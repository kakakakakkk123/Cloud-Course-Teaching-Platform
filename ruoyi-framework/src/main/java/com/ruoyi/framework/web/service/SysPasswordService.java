package com.ruoyi.framework.web.service;

import jakarta.servlet.http.HttpServletRequest;
import java.util.concurrent.TimeUnit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;
import com.ruoyi.common.constant.CacheConstants;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.common.exception.user.UserPasswordNotMatchException;
import com.ruoyi.common.exception.user.UserPasswordRetryLimitExceedException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.ServletUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.ip.IpUtils;
import com.ruoyi.framework.security.context.AuthenticationContextHolder;
import com.ruoyi.system.service.ISysConfigService;

/**
 * 登录密码方法
 * 
 * @author ruoyi
 */
@Component
public class SysPasswordService
{
    private static final String DEVICE_ID_HEADER = "X-Device-Id";

    @Autowired
    private RedisCache redisCache;

    @Autowired
    private ISysConfigService configService;

    @Value(value = "${user.password.maxRetryCount}")
    private int maxRetryCount;

    @Value(value = "${user.password.lockTime}")
    private int lockTime;

    /**
     * 登录账户密码错误次数缓存键名
     * 
     * @param username 用户名
     * @return 缓存键key
     */
    private String getCacheKey(String username)
    {
        return CacheConstants.PWD_ERR_CNT_KEY + username;
    }

    private String getIpCacheKey(String ip)
    {
        return CacheConstants.PWD_ERR_IP_CNT_KEY + ip;
    }

    private String getDeviceCacheKey(String deviceId)
    {
        return CacheConstants.PWD_ERR_DEVICE_CNT_KEY + deviceId;
    }

    private String getDeviceId()
    {
        HttpServletRequest request = ServletUtils.getRequest();
        String deviceId = request == null ? null : request.getHeader(DEVICE_ID_HEADER);
        if (StringUtils.isNotEmpty(deviceId))
        {
            return deviceId;
        }
        String userAgent = request == null ? null : request.getHeader("User-Agent");
        return StringUtils.defaultIfEmpty(userAgent, "unknown-device");
    }

    private boolean isLocked(String key)
    {
        Integer retryCount = redisCache.getCacheObject(key);
        return retryCount != null && retryCount >= currentMaxRetryCount();
    }

    private void checkLocked(String username, String ip, String deviceId)
    {
        if (isLocked(getCacheKey(username))
                || isLocked(getIpCacheKey(ip))
                || isLocked(getDeviceCacheKey(deviceId)))
        {
            throw new UserPasswordRetryLimitExceedException(currentMaxRetryCount(), currentLockTime());
        }
    }

    private void increaseRetryCount(String key)
    {
        Integer retryCount = redisCache.getCacheObject(key);
        retryCount = retryCount == null ? 1 : retryCount + 1;
        redisCache.setCacheObject(key, retryCount, currentLockTime(), TimeUnit.MINUTES);
        if (retryCount >= currentMaxRetryCount())
        {
            throw new UserPasswordRetryLimitExceedException(currentMaxRetryCount(), currentLockTime());
        }
    }

    public void validate(SysUser user)
    {
        Authentication usernamePasswordAuthenticationToken = AuthenticationContextHolder.getContext();
        String username = usernamePasswordAuthenticationToken.getName();
        String password = usernamePasswordAuthenticationToken.getCredentials().toString();
        String ip = IpUtils.getIpAddr();
        String deviceId = getDeviceId();

        checkLocked(username, ip, deviceId);

        if (!matches(user, password))
        {
            increaseRetryCount(getCacheKey(username));
            increaseRetryCount(getIpCacheKey(ip));
            increaseRetryCount(getDeviceCacheKey(deviceId));
            throw new UserPasswordNotMatchException();
        }
        else
        {
            clearLoginRecordCache(username);
            clearLoginRecordCacheByKey(getIpCacheKey(ip));
            clearLoginRecordCacheByKey(getDeviceCacheKey(deviceId));
        }
    }

    public boolean matches(SysUser user, String rawPassword)
    {
        return SecurityUtils.matchesPassword(rawPassword, user.getPassword());
    }

    public void clearLoginRecordCache(String loginName)
    {
        if (redisCache.hasKey(getCacheKey(loginName)))
        {
            redisCache.deleteObject(getCacheKey(loginName));
        }
    }

    private void clearLoginRecordCacheByKey(String key)
    {
        if (redisCache.hasKey(key))
        {
            redisCache.deleteObject(key);
        }
    }

    private int currentMaxRetryCount()
    {
        return configInt("sys.login.maxRetryCount", maxRetryCount);
    }

    private int currentLockTime()
    {
        return configInt("sys.login.lockTime", lockTime);
    }

    private int configInt(String key, int fallback)
    {
        try
        {
            String value = configService.selectConfigByKey(key);
            if (StringUtils.isNotEmpty(value))
            {
                return Integer.parseInt(value);
            }
        }
        catch (Exception ignored)
        {
        }
        return fallback;
    }
}
