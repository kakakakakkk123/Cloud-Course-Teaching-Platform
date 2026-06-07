package com.ruoyi.framework.web.service;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.context.MessageSource;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.ruoyi.common.exception.user.BlackListException;
import com.ruoyi.common.exception.user.UserNotExistsException;
import com.ruoyi.common.exception.user.UserPasswordNotMatchException;
import com.ruoyi.common.utils.spring.SpringUtils;
import com.ruoyi.system.service.ISysConfigService;

import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;

@ExtendWith(MockitoExtension.class)
class SysLoginServiceTest
{
    private static final String BLACK_IP_KEY = "sys.login.blackIPList";
    private static final String BLOCKED_UA_KEY = "sys.login.blockedUserAgentKeywords";

    @Mock
    private ISysConfigService configService;

    @InjectMocks
    private SysLoginService service;

    @BeforeAll
    static void prepareAsyncManagerDependencies()
    {
        ConfigurableListableBeanFactory beanFactory = mock(ConfigurableListableBeanFactory.class);
        ScheduledExecutorService executorService = mock(ScheduledExecutorService.class);
        MessageSource messageSource = mock(MessageSource.class);
        when(beanFactory.getBean("scheduledExecutorService")).thenReturn(executorService);
        when(beanFactory.getBean(MessageSource.class)).thenReturn(messageSource);
        when(messageSource.getMessage(anyString(), any(Object[].class), any())).thenAnswer(invocation -> invocation.getArgument(0));
        when(executorService.schedule(any(Runnable.class), anyLong(), eq(TimeUnit.MILLISECONDS)))
                .thenReturn(mock(ScheduledFuture.class));
        ReflectionTestUtils.setField(SpringUtils.class, "beanFactory", beanFactory);
    }

    @AfterEach
    void clearRequestContext()
    {
        RequestContextHolder.resetRequestAttributes();
    }

    @BeforeEach
    void bindDefaultRequestContext()
    {
        bindRequest("10.0.0.5", "Mozilla/5.0");
    }

    @Test
    void loginPreCheckRejectsBlankUsernameOrPassword()
    {
        assertThrows(UserNotExistsException.class, () -> service.loginPreCheck("", "student123"));
        assertThrows(UserNotExistsException.class, () -> service.loginPreCheck("student01", ""));
    }

    @Test
    void loginPreCheckRejectsInvalidPasswordLength()
    {
        assertThrows(UserPasswordNotMatchException.class, () -> service.loginPreCheck("student01", "1234"));
        assertThrows(UserPasswordNotMatchException.class,
                () -> service.loginPreCheck("student01", "123456789012345678901"));
    }

    @Test
    void loginPreCheckRejectsInvalidUsernameLength()
    {
        assertThrows(UserPasswordNotMatchException.class, () -> service.loginPreCheck("s", "student123"));
        assertThrows(UserPasswordNotMatchException.class,
                () -> service.loginPreCheck("student0123456789012345", "student123"));
    }

    @Test
    void loginPreCheckAllowsValidCredentialsWhenNoBlacklistMatches()
    {
        bindRequest("10.0.0.5", "Mozilla/5.0");
        when(configService.selectConfigByKey(BLACK_IP_KEY)).thenReturn("");
        when(configService.selectConfigByKey(BLOCKED_UA_KEY)).thenReturn("");

        assertDoesNotThrow(() -> service.loginPreCheck("student01", "student123"));
    }

    @Test
    void loginPreCheckRejectsBlacklistedIp()
    {
        bindRequest("10.0.0.5", "Mozilla/5.0");
        when(configService.selectConfigByKey(BLACK_IP_KEY)).thenReturn("10.0.0.*");

        assertThrows(BlackListException.class, () -> service.loginPreCheck("student01", "student123"));
    }

    private void bindRequest(String remoteAddr, String userAgent)
    {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setRemoteAddr(remoteAddr);
        request.addHeader("User-Agent", userAgent);
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));
    }
}
