package com.ruoyi.framework.web.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.lenient;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.ruoyi.common.constant.CacheConstants;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.common.exception.user.UserPasswordNotMatchException;
import com.ruoyi.common.exception.user.UserPasswordRetryLimitExceedException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.framework.security.context.AuthenticationContextHolder;
import com.ruoyi.system.service.ISysConfigService;

@ExtendWith(MockitoExtension.class)
class SysPasswordServiceTest
{
    @Mock
    private RedisCache redisCache;

    @Mock
    private ISysConfigService configService;

    @InjectMocks
    private SysPasswordService service;

    private final Map<String, Integer> retryCounts = new HashMap<>();

    @BeforeEach
    void setUp()
    {
        ReflectionTestUtils.setField(service, "maxRetryCount", 5);
        ReflectionTestUtils.setField(service, "lockTime", 10);
        when(configService.selectConfigByKey(anyString())).thenReturn("");
        when(redisCache.getCacheObject(anyString())).thenAnswer(invocation -> retryCounts.get(invocation.getArgument(0)));
        lenient().when(redisCache.hasKey(anyString())).thenAnswer(invocation -> retryCounts.containsKey(invocation.getArgument(0)));
        lenient().doAnswer(invocation -> {
            retryCounts.put(invocation.getArgument(0), invocation.getArgument(1));
            return null;
        }).when(redisCache).setCacheObject(anyString(), any(Integer.class), eq(10), eq(TimeUnit.MINUTES));

        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setRemoteAddr("10.0.0.8");
        request.addHeader("User-Agent", "JUnit Browser");
        request.addHeader("X-Device-Id", "device-a");
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));
    }

    @AfterEach
    void tearDown()
    {
        AuthenticationContextHolder.clearContext();
        RequestContextHolder.resetRequestAttributes();
    }

    @Test
    void validateLocksAfterFifthWrongPasswordAndRecordsAllDimensions()
    {
        SysUser user = user("student01", "right123");
        AuthenticationContextHolder.setContext(new UsernamePasswordAuthenticationToken("student01", "wrong123"));

        for (int i = 1; i < 5; i++)
        {
            assertThrows(UserPasswordNotMatchException.class, () -> service.validate(user));
        }

        assertThrows(UserPasswordRetryLimitExceedException.class, () -> service.validate(user));

        assertEquals(5, retryCounts.get(CacheConstants.PWD_ERR_CNT_KEY + "student01"));
        assertEquals(5, retryCounts.get(CacheConstants.PWD_ERR_IP_CNT_KEY + "10.0.0.8"));
        assertEquals(5, retryCounts.get(CacheConstants.PWD_ERR_DEVICE_CNT_KEY + "device-a"));
        verify(redisCache).setCacheObject(CacheConstants.PWD_ERR_CNT_KEY + "student01", 5, 10, TimeUnit.MINUTES);
        verify(redisCache).setCacheObject(CacheConstants.PWD_ERR_IP_CNT_KEY + "10.0.0.8", 5, 10, TimeUnit.MINUTES);
        verify(redisCache).setCacheObject(CacheConstants.PWD_ERR_DEVICE_CNT_KEY + "device-a", 5, 10, TimeUnit.MINUTES);
    }

    @Test
    void validateRejectsImmediatelyWhenUserIsAlreadyLocked()
    {
        retryCounts.put(CacheConstants.PWD_ERR_CNT_KEY + "student01", 5);
        SysUser user = user("student01", "right123");
        AuthenticationContextHolder.setContext(new UsernamePasswordAuthenticationToken("student01", "wrong123"));

        assertThrows(UserPasswordRetryLimitExceedException.class, () -> service.validate(user));
    }

    @Test
    void recordLoginFailureUsesSameLockThreshold()
    {
        for (int i = 1; i < 5; i++)
        {
            service.recordLoginFailure("student01");
        }

        assertThrows(UserPasswordRetryLimitExceedException.class, () -> service.recordLoginFailure("student01"));

        assertEquals(5, retryCounts.get(CacheConstants.PWD_ERR_CNT_KEY + "student01"));
        assertEquals(5, retryCounts.get(CacheConstants.PWD_ERR_IP_CNT_KEY + "10.0.0.8"));
        assertEquals(5, retryCounts.get(CacheConstants.PWD_ERR_DEVICE_CNT_KEY + "device-a"));
    }

    private SysUser user(String username, String password)
    {
        SysUser user = new SysUser();
        user.setUserName(username);
        user.setPassword(SecurityUtils.encryptPassword(password));
        return user;
    }
}
