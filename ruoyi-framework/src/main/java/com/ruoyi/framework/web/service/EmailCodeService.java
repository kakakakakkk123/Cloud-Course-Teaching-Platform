package com.ruoyi.framework.web.service;

import java.util.Locale;
import java.util.Random;
import java.util.concurrent.TimeUnit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import com.ruoyi.common.constant.CacheConstants;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;

/**
 * 邮箱验证码服务
 */
@Service
public class EmailCodeService
{
    private static final int EXPIRE_MINUTES = 10;

    @Autowired(required = false)
    private JavaMailSender mailSender;

    @Autowired
    private RedisCache redisCache;

    @Value("${spring.mail.username:}")
    private String fromAddress;

    public String sendRegisterCode(String email)
    {
        return sendCode(email, CacheConstants.EMAIL_REGISTER_CODE_KEY, "学生账号注册验证码");
    }

    public String sendForgotPasswordCode(String email)
    {
        return sendCode(email, CacheConstants.EMAIL_FORGOT_PASSWORD_CODE_KEY, "找回密码验证码");
    }

    public void validateRegisterCode(String email, String code)
    {
        String targetEmail = normalizeEmail(email);
        if (StringUtils.isEmpty(targetEmail))
        {
            return;
        }
        validateCode(targetEmail, code, CacheConstants.EMAIL_REGISTER_CODE_KEY, "邮箱验证码");
    }

    public void validateForgotPasswordCode(String email, String code)
    {
        validateCode(email, code, CacheConstants.EMAIL_FORGOT_PASSWORD_CODE_KEY, "邮箱验证码");
    }

    private String sendCode(String email, String keyPrefix, String subject)
    {
        String targetEmail = normalizeEmail(email);
        if (StringUtils.isEmpty(targetEmail))
        {
            throw new ServiceException("邮箱不能为空");
        }
        if (mailSender == null || StringUtils.isEmpty(fromAddress))
        {
            throw new ServiceException("邮件服务未配置，请先补充 spring.mail 配置");
        }

        String code = generateCode();
        redisCache.setCacheObject(codeKey(keyPrefix, targetEmail), code, EXPIRE_MINUTES, TimeUnit.MINUTES);

        try
        {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromAddress);
            message.setTo(targetEmail);
            message.setSubject(subject);
            message.setText("你的验证码是：" + code + "，有效期 " + EXPIRE_MINUTES + " 分钟。");
            mailSender.send(message);
        }
        catch (MailException ex)
        {
            throw new ServiceException("验证码发送失败：" + ex.getMessage());
        }
        return code;
    }

    private void validateCode(String email, String code, String keyPrefix, String label)
    {
        String targetEmail = normalizeEmail(email);
        String targetCode = StringUtils.trim(code);
        if (StringUtils.isEmpty(targetEmail))
        {
            throw new ServiceException("邮箱不能为空");
        }
        if (StringUtils.isEmpty(targetCode))
        {
            throw new ServiceException("请输入" + label);
        }

        String key = codeKey(keyPrefix, targetEmail);
        String cacheCode = redisCache.getCacheObject(key);
        if (StringUtils.isEmpty(cacheCode))
        {
            throw new ServiceException(label + "已过期，请重新获取");
        }
        if (!cacheCode.equalsIgnoreCase(targetCode))
        {
            throw new ServiceException(label + "错误");
        }
        redisCache.deleteObject(key);
    }

    private String codeKey(String keyPrefix, String email)
    {
        return keyPrefix + normalizeEmail(email);
    }

    private String normalizeEmail(String email)
    {
        return StringUtils.trim(email).toLowerCase(Locale.ROOT);
    }

    private String generateCode()
    {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000);
        return Integer.toString(code);
    }
}
