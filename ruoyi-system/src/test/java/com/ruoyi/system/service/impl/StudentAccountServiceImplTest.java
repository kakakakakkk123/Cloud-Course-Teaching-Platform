package com.ruoyi.system.service.impl;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.when;
import static org.mockito.ArgumentMatchers.any;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.model.ForgotPasswordBody;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.SysConfig;
import com.ruoyi.system.service.ISysConfigService;
import com.ruoyi.system.service.ISysUserService;

@ExtendWith(MockitoExtension.class)
class StudentAccountServiceImplTest
{
    @Mock
    private ISysConfigService configService;

    @Mock
    private ISysUserService userService;

    @InjectMocks
    private StudentAccountServiceImpl service;

    @Test
    void forgotPasswordEmailRequiredDefaultsToFalse()
    {
        when(configService.selectConfigList(any(SysConfig.class))).thenReturn(List.of());

        assertFalse(service.forgotPasswordEmailRequired());
    }

    @Test
    void forgotPasswordEmailRequiredReadsTrueConfig()
    {
        SysConfig value = new SysConfig();
        value.setConfigValue("true");
        when(configService.selectConfigList(any(SysConfig.class))).thenReturn(List.of(value));

        assertTrue(service.forgotPasswordEmailRequired());
    }

    @Test
    void validateForgotPasswordEmailReturnsBoundStudentEmail()
    {
        ForgotPasswordBody body = forgotPasswordBody("student@example.com");
        SysUser user = studentUser();
        when(userService.selectUserByUserName("student01")).thenReturn(user);

        assertEquals("student@example.com", service.validateForgotPasswordEmail(body));
    }

    @Test
    void validateForgotPasswordEmailRejectsMismatchedEmail()
    {
        ForgotPasswordBody body = forgotPasswordBody("other@example.com");
        when(userService.selectUserByUserName("student01")).thenReturn(studentUser());

        assertThrows(ServiceException.class, () -> service.validateForgotPasswordEmail(body));
    }

    private ForgotPasswordBody forgotPasswordBody(String email)
    {
        ForgotPasswordBody body = new ForgotPasswordBody();
        body.setUsername("student01");
        body.setStudentNo("20240001");
        body.setEmail(email);
        return body;
    }

    private SysUser studentUser()
    {
        SysRole role = new SysRole();
        role.setRoleKey("student");

        SysUser user = new SysUser();
        user.setUserId(2L);
        user.setUserName("student01");
        user.setStudentNo("20240001");
        user.setEmail("student@example.com");
        user.setRoles(List.of(role));
        return user;
    }
}
