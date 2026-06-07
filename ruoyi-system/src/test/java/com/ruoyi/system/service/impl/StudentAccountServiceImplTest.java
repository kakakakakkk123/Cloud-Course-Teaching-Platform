package com.ruoyi.system.service.impl;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;
import java.util.Map;

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
import com.ruoyi.common.core.domain.model.AccountSecuritySettings;
import com.ruoyi.common.core.domain.model.ForgotPasswordBody;
import com.ruoyi.common.core.domain.model.RegisterBody;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.StudentProfile;
import com.ruoyi.system.domain.SysConfig;
import com.ruoyi.system.mapper.StudentAccountMapper;
import com.ruoyi.system.service.ISysConfigService;
import com.ruoyi.system.service.ISysDeptService;
import com.ruoyi.system.service.ISysRoleService;
import com.ruoyi.system.service.ISysUserService;

@ExtendWith(MockitoExtension.class)
class StudentAccountServiceImplTest
{
    private static final String REGISTER_KEY = "sys.account.registerUser";
    private static final String BLACK_IP_KEY = "sys.login.blackIPList";
    private static final String BLOCKED_UA_KEY = "sys.login.blockedUserAgentKeywords";
    private static final String FORGOT_EMAIL_KEY = "sys.account.forgotPasswordEmailRequired";
    private static final String INIT_PASSWORD_KEY = "sys.user.initPassword";

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
    void studentRegisterEnabledDefaultsToTrue()
    {
        whenConfigValues(Map.of());

        assertTrue(service.studentRegisterEnabled());
    }

    @Test
    void studentRegisterEnabledReadsFalseConfig()
    {
        whenConfigValues(Map.of(REGISTER_KEY, "false"));

        assertFalse(service.studentRegisterEnabled());
    }

    @Test
    void forgotPasswordEmailRequiredDefaultsToFalse()
    {
        whenConfigValues(Map.of());

        assertFalse(service.forgotPasswordEmailRequired());
    }

    @Test
    void forgotPasswordEmailRequiredReadsTrueConfig()
    {
        whenConfigValues(Map.of(FORGOT_EMAIL_KEY, "true"));

        assertTrue(service.forgotPasswordEmailRequired());
    }

    @Test
    void registerRejectsWhenStudentSelfRegisterIsClosed()
    {
        whenConfigValues(Map.of(REGISTER_KEY, "false"));

        String result = service.register(validRegisterBody());

        assertNotEquals("", result);
        verify(userService, never()).insertUser(any(SysUser.class));
    }

    @Test
    void registerUsesStudentNoWhenUsernameIsBlankAndCreatesProfile()
    {
        RegisterBody body = validRegisterBody();
        body.setUsername(null);
        whenConfigValues(Map.of());
        when(deptService.selectDeptById(1L)).thenReturn(normalDept(1L, 0L));
        when(deptService.selectDeptById(2L)).thenReturn(normalDept(2L, 1L));
        when(userService.checkUserNameUnique(any(SysUser.class))).thenReturn(true);
        when(userService.checkStudentNoUnique(any(SysUser.class))).thenReturn(true);
        when(userService.checkPhoneUnique(any(SysUser.class))).thenReturn(true);
        when(userService.checkEmailUnique(any(SysUser.class))).thenReturn(true);
        when(roleService.selectRoleAll()).thenReturn(List.of(studentRole()));
        when(userService.insertUser(any(SysUser.class))).thenAnswer(invocation -> {
            SysUser user = invocation.getArgument(0);
            user.setUserId(20L);
            return 1;
        });

        assertEquals("", service.register(body));

        ArgumentCaptor<SysUser> userCaptor = ArgumentCaptor.forClass(SysUser.class);
        ArgumentCaptor<StudentProfile> profileCaptor = ArgumentCaptor.forClass(StudentProfile.class);
        verify(userService).insertUser(userCaptor.capture());
        verify(accountMapper).insertStudentProfile(profileCaptor.capture());
        SysUser savedUser = userCaptor.getValue();
        assertEquals("20240003", savedUser.getUserName());
        assertEquals("20240003", savedUser.getStudentNo());
        assertEquals(2L, savedUser.getDeptId());
        assertArrayEquals(new Long[] { 4L }, savedUser.getRoleIds());
        assertEquals(UserConstants.NORMAL, savedUser.getStatus());
        assertTrue(SecurityUtils.matchesPassword("student123", savedUser.getPassword()));
        assertNotNull(savedUser.getPwdUpdateDate());
        assertEquals(20L, profileCaptor.getValue().getUserId());
        assertEquals("2024", profileCaptor.getValue().getGrade());
    }

    @Test
    void registerRejectsMismatchedAcademyAndMajor()
    {
        whenConfigValues(Map.of());
        when(deptService.selectDeptById(1L)).thenReturn(normalDept(1L, 0L));
        when(deptService.selectDeptById(2L)).thenReturn(normalDept(2L, 99L));

        String result = service.register(validRegisterBody());

        assertNotEquals("", result);
        verify(userService, never()).insertUser(any(SysUser.class));
    }

    @Test
    void registerRejectsDuplicateStudentNo()
    {
        whenConfigValues(Map.of());
        when(deptService.selectDeptById(1L)).thenReturn(normalDept(1L, 0L));
        when(deptService.selectDeptById(2L)).thenReturn(normalDept(2L, 1L));
        when(userService.checkUserNameUnique(any(SysUser.class))).thenReturn(true);
        when(userService.checkStudentNoUnique(any(SysUser.class))).thenReturn(false);

        String result = service.register(validRegisterBody());

        assertNotEquals("", result);
        verify(userService, never()).insertUser(any(SysUser.class));
    }

    @Test
    void registerThrowsWhenStudentRoleIsMissing()
    {
        whenConfigValues(Map.of());
        when(deptService.selectDeptById(1L)).thenReturn(normalDept(1L, 0L));
        when(deptService.selectDeptById(2L)).thenReturn(normalDept(2L, 1L));
        when(userService.checkUserNameUnique(any(SysUser.class))).thenReturn(true);
        when(userService.checkStudentNoUnique(any(SysUser.class))).thenReturn(true);
        when(userService.checkPhoneUnique(any(SysUser.class))).thenReturn(true);
        when(userService.checkEmailUnique(any(SysUser.class))).thenReturn(true);
        when(roleService.selectRoleAll()).thenReturn(List.of(role("teacher", 3L)));

        assertThrows(ServiceException.class, () -> service.register(validRegisterBody()));
    }

    @Test
    void validateForgotPasswordEmailReturnsBoundStudentEmail()
    {
        ForgotPasswordBody body = forgotPasswordBody("student@example.com");
        when(userService.selectUserByUserName("student01")).thenReturn(studentUser(2L, "student01"));

        assertEquals("student@example.com", service.validateForgotPasswordEmail(body));
    }

    @Test
    void validateForgotPasswordEmailRejectsMismatchedEmail()
    {
        ForgotPasswordBody body = forgotPasswordBody("other@example.com");
        when(userService.selectUserByUserName("student01")).thenReturn(studentUser(2L, "student01"));

        assertThrows(ServiceException.class, () -> service.validateForgotPasswordEmail(body));
    }

    @Test
    void forgotPasswordResetsEncryptedPasswordForStudent()
    {
        ForgotPasswordBody body = forgotPasswordBody("student@example.com");
        body.setNewPassword("newPass123");
        when(userService.selectUserByUserName("student01")).thenReturn(studentUser(2L, "student01"));
        when(userService.resetUserPwd(eq(2L), anyString())).thenReturn(1);

        assertEquals("", service.forgotPassword(body));

        ArgumentCaptor<String> passwordCaptor = ArgumentCaptor.forClass(String.class);
        verify(userService).resetUserPwd(eq(2L), passwordCaptor.capture());
        assertNotEquals("newPass123", passwordCaptor.getValue());
        assertTrue(SecurityUtils.matchesPassword("newPass123", passwordCaptor.getValue()));
    }

    @Test
    void forgotPasswordRejectsNonStudentAccount()
    {
        ForgotPasswordBody body = forgotPasswordBody(null);
        body.setNewPassword("newPass123");
        SysUser teacher = studentUser(3L, "student01");
        teacher.setRoles(List.of(role("teacher", 3L)));
        when(userService.selectUserByUserName("student01")).thenReturn(teacher);

        assertNotEquals("", service.forgotPassword(body));
        verify(userService, never()).resetUserPwd(any(), anyString());
    }

    @Test
    void selectStudentProfileReturnsEmptyProfileWhenMissing()
    {
        when(accountMapper.selectStudentProfileByUserId(8L)).thenReturn(null);

        StudentProfile profile = service.selectStudentProfileByUserId(8L);

        assertEquals(8L, profile.getUserId());
    }

    @Test
    void resetStudentPasswordRequiresStudentAndStoresEncryptedPassword()
    {
        when(userService.selectUserById(2L)).thenReturn(studentUser(2L, "student01"));
        when(userService.resetUserPwd(eq(2L), anyString())).thenReturn(1);

        assertEquals(1, service.resetStudentPassword(2L, "reset123"));

        ArgumentCaptor<String> passwordCaptor = ArgumentCaptor.forClass(String.class);
        verify(userService).resetUserPwd(eq(2L), passwordCaptor.capture());
        assertTrue(SecurityUtils.matchesPassword("reset123", passwordCaptor.getValue()));
    }

    @Test
    void resetStudentPasswordRejectsTeacherAccount()
    {
        SysUser teacher = studentUser(3L, "teacher01");
        teacher.setRoles(List.of(role("teacher", 3L)));
        when(userService.selectUserById(3L)).thenReturn(teacher);

        assertThrows(ServiceException.class, () -> service.resetStudentPassword(3L, "reset123"));
    }

    @Test
    void changeStudentStatusValidatesStatusAndUpdatesUser()
    {
        when(userService.selectUserById(2L)).thenReturn(studentUser(2L, "student01"));
        when(userService.updateUserStatus(any(SysUser.class))).thenReturn(1);

        assertEquals(1, service.changeStudentStatus(2L, UserConstants.USER_DISABLE));

        ArgumentCaptor<SysUser> userCaptor = ArgumentCaptor.forClass(SysUser.class);
        verify(userService).updateUserStatus(userCaptor.capture());
        assertEquals(2L, userCaptor.getValue().getUserId());
        assertEquals(UserConstants.USER_DISABLE, userCaptor.getValue().getStatus());
    }

    @Test
    void changeStudentStatusRejectsUnknownStatus()
    {
        when(userService.selectUserById(2L)).thenReturn(studentUser(2L, "student01"));

        assertThrows(ServiceException.class, () -> service.changeStudentStatus(2L, "9"));
    }

    @Test
    void deleteStudentUsersValidatesAllTargetsBeforeDeleting()
    {
        when(userService.selectUserById(2L)).thenReturn(studentUser(2L, "student01"));
        when(userService.selectUserById(4L)).thenReturn(studentUser(4L, "student02"));
        when(userService.deleteUserByIds(any(Long[].class))).thenReturn(2);

        assertEquals(2, service.deleteStudentUsers(new Long[] { 2L, 4L }));

        verify(userService).deleteUserByIds(new Long[] { 2L, 4L });
    }

    @Test
    void updateStudentRegisterEnabledUpdatesExistingConfig()
    {
        SysConfig existing = config(REGISTER_KEY, "false");
        when(configService.selectConfigList(any(SysConfig.class))).thenReturn(List.of(existing));
        when(configService.updateConfig(existing)).thenReturn(1);

        assertTrue(service.updateStudentRegisterEnabled(true, "teacher"));

        assertEquals("true", existing.getConfigValue());
        assertEquals("teacher", existing.getUpdateBy());
    }

    @Test
    void updateStudentRegisterEnabledThrowsWhenConfigMissing()
    {
        when(configService.selectConfigList(any(SysConfig.class))).thenReturn(List.of());

        assertThrows(ServiceException.class, () -> service.updateStudentRegisterEnabled(false, "teacher"));
    }

    @Test
    void selectAccountSecuritySettingsReadsAllConfigValues()
    {
        whenConfigValues(Map.of(
                BLACK_IP_KEY, "127.0.0.1",
                BLOCKED_UA_KEY, "blocked-device",
                FORGOT_EMAIL_KEY, "true"));

        AccountSecuritySettings settings = service.selectAccountSecuritySettings();

        assertEquals("127.0.0.1", settings.getBlackIpList());
        assertEquals("blocked-device", settings.getBlockedUserAgentKeywords());
        assertTrue(settings.getForgotPasswordEmailRequired());
    }

    @Test
    void updateAccountSecuritySettingsUpdatesExistingAndInsertsMissingConfig()
    {
        SysConfig blackIp = config(BLACK_IP_KEY, "");
        when(configService.selectConfigList(any(SysConfig.class))).thenAnswer(invocation -> {
            SysConfig query = invocation.getArgument(0);
            return BLACK_IP_KEY.equals(query.getConfigKey()) ? List.of(blackIp) : List.of();
        });
        when(configService.updateConfig(any(SysConfig.class))).thenReturn(1);
        when(configService.insertConfig(any(SysConfig.class))).thenReturn(1);
        AccountSecuritySettings settings = new AccountSecuritySettings();
        settings.setBlackIpList(" 10.0.0.1 ");
        settings.setBlockedUserAgentKeywords(" kiosk ");
        settings.setForgotPasswordEmailRequired(Boolean.TRUE);

        assertTrue(service.updateAccountSecuritySettings(settings, "admin"));

        assertEquals("10.0.0.1", blackIp.getConfigValue());
        verify(configService).updateConfig(blackIp);
        verify(configService, times(2)).insertConfig(any(SysConfig.class));
    }

    @Test
    void importStudentUsersRejectsEmptyList()
    {
        assertThrows(ServiceException.class, () -> service.importStudentUsers(List.of(), true, false, "teacher"));
    }

    @Test
    void importStudentUsersCreatesMissingStudentWithDefaultPasswordAndProfile()
    {
        SysUser row = importRow("new01", "20240011", "New Student");
        when(roleService.selectRoleAll()).thenReturn(List.of(studentRole()));
        when(userService.selectUserByUserName("new01")).thenReturn(null);
        when(userService.checkStudentNoUnique(row)).thenReturn(true);
        when(userService.checkEmailUnique(row)).thenReturn(true);
        when(configService.selectConfigByKey(INIT_PASSWORD_KEY)).thenReturn("init123");
        when(userService.insertUser(row)).thenAnswer(invocation -> {
            row.setUserId(30L);
            return 1;
        });
        when(accountMapper.selectStudentProfileByUserId(30L)).thenReturn(null);
        when(accountMapper.selectStudentList(any(SysUser.class))).thenReturn(List.of());

        String message = service.importStudentUsers(List.of(row), false, false, "teacher");

        assertTrue(message.contains("new01"));
        assertArrayEquals(new Long[] { 4L }, row.getRoleIds());
        assertEquals(UserConstants.NORMAL, row.getStatus());
        assertEquals("teacher", row.getCreateBy());
        assertTrue(SecurityUtils.matchesPassword("init123", row.getPassword()));
        verify(accountMapper).insertStudentProfile(any(StudentProfile.class));
    }

    @Test
    void importStudentUsersRejectsExistingNonStudentAccount()
    {
        SysUser row = importRow("teacher01", "20240002", "Teacher");
        SysUser existing = studentUser(10L, "teacher01");
        existing.setRoles(List.of(role("teacher", 3L)));
        when(roleService.selectRoleAll()).thenReturn(List.of(studentRole()));
        when(userService.selectUserByUserName("teacher01")).thenReturn(existing);
        when(accountMapper.selectStudentList(any(SysUser.class))).thenReturn(List.of());

        ServiceException exception = assertThrows(ServiceException.class,
                () -> service.importStudentUsers(List.of(row), true, false, "tester"));
        assertTrue(exception.getMessage().contains("teacher01"));
    }

    @Test
    void importStudentUsersUpdatesExistingStudentWhenSupported()
    {
        SysUser row = importRow("student01", "20240001", "Updated Student");
        SysUser existing = studentUser(10L, "student01");
        existing.setDeptId(200L);
        existing.setStatus(UserConstants.NORMAL);
        row.setEmail(existing.getEmail());
        when(roleService.selectRoleAll()).thenReturn(List.of(studentRole()));
        when(userService.selectUserByUserName("student01")).thenReturn(existing);
        when(accountMapper.selectStudentProfileByUserId(10L)).thenReturn(new StudentProfile());
        when(accountMapper.selectStudentList(any(SysUser.class))).thenReturn(List.of());

        String message = service.importStudentUsers(List.of(row), true, false, "tester");

        assertTrue(message.contains("student01"));
        assertEquals(10L, row.getUserId());
        assertEquals(200L, row.getDeptId());
        assertEquals(UserConstants.NORMAL, row.getStatus());
        verify(userService).checkUserAllowed(existing);
        verify(userService).checkUserDataScope(10L);
        verify(userService).updateUser(row);
    }

    @Test
    void importStudentUsersCanDisableStudentsMissingFromImportedList()
    {
        SysUser row = importRow("new01", "20240011", "New Student");
        SysUser missing = studentUser(40L, "missing01");
        when(roleService.selectRoleAll()).thenReturn(List.of(studentRole()));
        when(userService.selectUserByUserName(anyString())).thenAnswer(invocation -> {
            String username = invocation.getArgument(0);
            return "missing01".equals(username) ? missing : null;
        });
        when(userService.checkStudentNoUnique(row)).thenReturn(true);
        when(userService.checkEmailUnique(row)).thenReturn(true);
        when(configService.selectConfigByKey(INIT_PASSWORD_KEY)).thenReturn("init123");
        when(userService.insertUser(row)).thenAnswer(invocation -> {
            row.setUserId(30L);
            return 1;
        });
        when(accountMapper.selectStudentProfileByUserId(30L)).thenReturn(null);
        when(accountMapper.selectStudentList(any(SysUser.class))).thenReturn(List.of(missing));

        String message = service.importStudentUsers(List.of(row), false, true, "teacher");

        assertTrue(message.contains("missing01"));
        ArgumentCaptor<SysUser> statusCaptor = ArgumentCaptor.forClass(SysUser.class);
        verify(userService).updateUserStatus(statusCaptor.capture());
        assertEquals(40L, statusCaptor.getValue().getUserId());
        assertEquals(UserConstants.USER_DISABLE, statusCaptor.getValue().getStatus());
    }

    private void whenConfigValues(Map<String, String> values)
    {
        when(configService.selectConfigList(any(SysConfig.class))).thenAnswer(invocation -> {
            SysConfig query = invocation.getArgument(0);
            String value = values.get(query.getConfigKey());
            return value == null ? List.of() : List.of(config(query.getConfigKey(), value));
        });
    }

    private SysConfig config(String key, String value)
    {
        SysConfig config = new SysConfig();
        config.setConfigKey(key);
        config.setConfigValue(value);
        return config;
    }

    private RegisterBody validRegisterBody()
    {
        RegisterBody body = new RegisterBody();
        body.setUsername("student01");
        body.setStudentNo("20240003");
        body.setPassword("student123");
        body.setNickName("Student");
        body.setPhonenumber("13800000000");
        body.setEmail("student@example.com");
        body.setGrade("2024");
        body.setAcademyId(1L);
        body.setMajorId(2L);
        return body;
    }

    private ForgotPasswordBody forgotPasswordBody(String email)
    {
        ForgotPasswordBody body = new ForgotPasswordBody();
        body.setUsername("student01");
        body.setStudentNo("20240001");
        body.setEmail(email);
        return body;
    }

    private SysDept normalDept(Long id, Long parentId)
    {
        SysDept dept = new SysDept();
        dept.setDeptId(id);
        dept.setParentId(parentId);
        dept.setStatus(UserConstants.DEPT_NORMAL);
        return dept;
    }

    private SysRole studentRole()
    {
        return role("student", 4L);
    }

    private SysRole role(String roleKey, Long roleId)
    {
        SysRole role = new SysRole();
        role.setRoleId(roleId);
        role.setRoleKey(roleKey);
        return role;
    }

    private SysUser studentUser(Long userId, String username)
    {
        SysUser user = new SysUser();
        user.setUserId(userId);
        user.setUserName(username);
        user.setStudentNo("20240001");
        user.setEmail("student@example.com");
        user.setRoles(List.of(studentRole()));
        return user;
    }

    private SysUser importRow(String username, String studentNo, String nickName)
    {
        SysUser row = new SysUser();
        row.setUserName(username);
        row.setStudentNo(studentNo);
        row.setNickName(nickName);
        row.setDeptId(100L);
        row.setEmail(username + "@example.com");
        return row;
    }
}
