package com.ruoyi.system.service.impl;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.model.ForgotPasswordBody;
import com.ruoyi.common.core.domain.model.RegisterBody;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.SysConfig;
import com.ruoyi.system.mapper.StudentAccountMapper;
import com.ruoyi.system.service.ISysConfigService;
import com.ruoyi.system.service.ISysDeptService;
import com.ruoyi.system.service.ISysRoleService;
import com.ruoyi.system.service.ISysUserService;

@ExtendWith(MockitoExtension.class)
class StudentAccountServiceImplTest
{
    @Mock
    private ISysConfigService configService;

    @Mock
    private ISysUserService userService;

    @Mock
    private ISysRoleService roleService;

    @Mock
    private StudentAccountMapper accountMapper;

    @Mock
    private ISysDeptService deptService;

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

    @Test
    void importStudentUsersRejectsExistingNonStudentAccount()
    {
        SysUser row = new SysUser();
        row.setUserName("teacher01");
        row.setStudentNo("20240002");
        row.setNickName("teacher");
        row.setDeptId(100L);

        SysRole studentRole = new SysRole();
        studentRole.setRoleId(3L);
        studentRole.setRoleKey("student");

        SysRole teacherRole = new SysRole();
        teacherRole.setRoleKey("teacher");

        SysUser existing = new SysUser();
        existing.setUserId(10L);
        existing.setUserName("teacher01");
        existing.setRoles(List.of(teacherRole));

        when(roleService.selectRoleAll()).thenReturn(List.of(studentRole));
        when(userService.selectUserByUserName("teacher01")).thenReturn(existing);
        when(accountMapper.selectStudentList(any(SysUser.class))).thenReturn(List.of());

        ServiceException exception = assertThrows(ServiceException.class,
                () -> service.importStudentUsers(List.of(row), true, false, "tester"));
        assertTrue(exception.getMessage().contains("不是学生账号"));
    }

    @Test
    void registerUsesStudentNoWhenUsernameIsBlank()
    {
        RegisterBody body = new RegisterBody();
        body.setStudentNo("20240003");
        body.setPassword("student123");
        body.setNickName("student");
        body.setPhonenumber("13800000000");
        body.setGrade("2024级");
        body.setAcademyId(1L);
        body.setMajorId(2L);

        SysDept academy = new SysDept();
        academy.setDeptId(1L);
        academy.setStatus(UserConstants.DEPT_NORMAL);
        SysDept major = new SysDept();
        major.setDeptId(2L);
        major.setParentId(1L);
        major.setStatus(UserConstants.DEPT_NORMAL);

        SysRole studentRole = new SysRole();
        studentRole.setRoleId(3L);
        studentRole.setRoleKey("student");

        when(configService.selectConfigList(any(SysConfig.class))).thenReturn(List.of());
        when(deptService.selectDeptById(1L)).thenReturn(academy);
        when(deptService.selectDeptById(2L)).thenReturn(major);
        when(userService.checkUserNameUnique(any(SysUser.class))).thenReturn(true);
        when(userService.checkStudentNoUnique(any(SysUser.class))).thenReturn(true);
        when(userService.checkPhoneUnique(any(SysUser.class))).thenReturn(true);
        when(roleService.selectRoleAll()).thenReturn(List.of(studentRole));
        when(userService.insertUser(any(SysUser.class))).thenAnswer(invocation -> {
            SysUser user = invocation.getArgument(0);
            user.setUserId(20L);
            return 1;
        });

        assertEquals("", service.register(body));
        ArgumentCaptor<SysUser> userCaptor = ArgumentCaptor.forClass(SysUser.class);
        verify(userService).insertUser(userCaptor.capture());
        assertEquals("20240003", userCaptor.getValue().getUserName());
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
