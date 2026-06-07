package com.ruoyi.system.service.impl;

import java.util.List;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.model.AccountSecuritySettings;
import com.ruoyi.common.core.domain.model.ForgotPasswordBody;
import com.ruoyi.common.core.domain.model.RegisterBody;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.PasswordPolicyUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.StudentProfile;
import com.ruoyi.system.domain.SysConfig;
import com.ruoyi.system.mapper.StudentAccountMapper;
import com.ruoyi.system.service.ISysConfigService;
import com.ruoyi.system.service.ISysRoleService;
import com.ruoyi.system.service.ISysUserService;
import com.ruoyi.system.service.IStudentAccountService;
import com.ruoyi.system.service.ISysDeptService;

/**
 * Account module service implementation
 *
 * @author ruoyi
 */
@Service
public class StudentAccountServiceImpl implements IStudentAccountService
{
    private static final Logger log = LoggerFactory.getLogger(StudentAccountServiceImpl.class);
    private static final String STUDENT_ROLE_KEY = "student";
    private static final String REGISTER_CONFIG_KEY = "sys.account.registerUser";
    private static final String LOGIN_BLACK_IP_KEY = "sys.login.blackIPList";
    private static final String LOGIN_BLOCKED_UA_KEY = "sys.login.blockedUserAgentKeywords";
    private static final String FORGOT_PASSWORD_EMAIL_REQUIRED_KEY = "sys.account.forgotPasswordEmailRequired";
    private static final String INIT_PASSWORD_KEY = "sys.user.initPassword";
    private static final String STUDENT_DEFAULT_STATUS_KEY = "sys.account.studentDefaultStatus";
    private static final String MISSING_STUDENT_POLICY_KEY = "sys.account.missingStudentPolicy";
    @Autowired
    private ISysUserService userService;

    @Autowired
    private ISysRoleService roleService;

    @Autowired
    private ISysConfigService configService;

    @Autowired
    private StudentAccountMapper accountMapper;

    @Autowired
    private ISysDeptService deptService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String register(RegisterBody registerBody)
    {
        if (registerBody == null)
        {
            return "注册信息不能为空。";
        }
        String username = StringUtils.trim(registerBody.getUsername());
        String password = StringUtils.trim(registerBody.getPassword());
        String studentNo = StringUtils.trim(registerBody.getStudentNo());
        String nickName = StringUtils.trim(registerBody.getNickName());
        String grade = StringUtils.trim(registerBody.getGrade());
        String phonenumber = StringUtils.trim(registerBody.getPhonenumber());
        String email = StringUtils.trim(registerBody.getEmail());
        Long academyId = registerBody.getAcademyId();
        Long majorId = registerBody.getMajorId();

        if (!studentRegisterEnabled())
        {
            return "当前未开放学生自主注册。";
        }
        if (StringUtils.isEmpty(studentNo))
        {
            return "学号不能为空。";
        }
        if (StringUtils.isEmpty(username))
        {
            username = studentNo;
        }
        if (StringUtils.isEmpty(password))
        {
            return "密码不能为空。";
        }
        if (StringUtils.isEmpty(nickName))
        {
            return "昵称不能为空。";
        }
        if (StringUtils.isEmpty(phonenumber))
        {
            return "手机号码不能为空。";
        }

        if (StringUtils.isEmpty(grade))
        {
            return "年级不能为空。";
        }

        if (academyId == null)
        {
            return "请选择学院。";
        }
        if (majorId == null)
        {
            return "请选择专业。";
        }

        SysDept academy = deptService.selectDeptById(academyId);
        if (StringUtils.isNull(academy) || !UserConstants.DEPT_NORMAL.equals(academy.getStatus()))
        {
            return "所选学院不存在或已停用。";
        }
        SysDept major = deptService.selectDeptById(majorId);
        if (StringUtils.isNull(major) || !UserConstants.DEPT_NORMAL.equals(major.getStatus()))
        {
            return "所选专业不存在或已停用。";
        }
        if (!academyId.equals(major.getParentId()))
        {
            return "所选专业与学院不匹配。";
        }

        SysUser user = new SysUser();
        user.setUserName(username);
        user.setDeptId(majorId);
        user.setStudentNo(studentNo);
        user.setNickName(nickName);
        user.setPhonenumber(phonenumber);
        user.setEmail(email);

        if (!userService.checkUserNameUnique(user))
        {
            return "登录账号已存在。";
        }
        if (!userService.checkStudentNoUnique(user))
        {
            return "该学号已被注册。";
        }
        if (!userService.checkPhoneUnique(user))
        {
            return "手机号码已存在。";
        }
        if (StringUtils.isNotEmpty(user.getEmail()) && !userService.checkEmailUnique(user))
        {
            return "邮箱已被注册。";
        }

        SysRole studentRole = selectStudentRole();
        if (StringUtils.isNull(studentRole))
        {
            throw new ServiceException("系统缺少学生角色（role_key=student）。");
        }

        ensurePasswordValid(password, "密码");
        user.setRoleIds(new Long[] { studentRole.getRoleId() });
        user.setPassword(SecurityUtils.encryptPassword(password));
        user.setStatus(studentDefaultStatus());
        user.setPwdUpdateDate(DateUtils.getNowDate());
        user.setCreateBy("public");
        if (userService.insertUser(user) <= 0)
        {
            return "注册失败，请稍后重试或联系管理员。";
        }

        StudentProfile profile = new StudentProfile();
        profile.setUserId(user.getUserId());
        profile.setGrade(grade);
        profile.setCreateBy(username);
        accountMapper.insertStudentProfile(profile);
        return StringUtils.EMPTY;
    }

    @Override
    public String forgotPassword(ForgotPasswordBody body)
    {
        if (body == null)
        {
            return "找回密码请求不能为空。";
        }
        String newPassword = StringUtils.trim(body.getNewPassword());

        if (StringUtils.isEmpty(newPassword))
        {
            return "新密码不能为空。";
        }

        ensurePasswordValid(newPassword, "新密码");
        SysUser user;
        try
        {
            user = validateForgotPasswordUser(body);
            ensureForgotPasswordEmailMatches(user, body);
        }
        catch (ServiceException e)
        {
            return e.getMessage();
        }

        String encoded = SecurityUtils.encryptPassword(newPassword);
        userService.resetUserPwd(user.getUserId(), encoded);
        return StringUtils.EMPTY;
    }

    @Override
    public String validateForgotPasswordEmail(ForgotPasswordBody body)
    {
        SysUser user = validateForgotPasswordUser(body);
        ensureForgotPasswordEmailMatches(user, body);
        String email = StringUtils.trim(user.getEmail());
        if (StringUtils.isEmpty(email))
        {
            throw new ServiceException("该学生账号未绑定邮箱，无法发送邮箱验证码。");
        }
        return email;
    }

    @Override
    public StudentProfile selectStudentProfileByUserId(Long userId)
    {
        StudentProfile profile = accountMapper.selectStudentProfileByUserId(userId);
        if (StringUtils.isNull(profile))
        {
            profile = new StudentProfile();
            profile.setUserId(userId);
        }
        return profile;
    }

    @Override
    @Transactional
    public int updateStudentProfile(SysUser user, StudentProfile profile)
    {
        SysUser current = userService.selectUserById(user.getUserId());
        if (StringUtils.isNull(current))
        {
            throw new ServiceException("未找到该用户。");
        }
        current.setNickName(user.getNickName());
        current.setEmail(user.getEmail());
        current.setPhonenumber(user.getPhonenumber());
        current.setSex(user.getSex());
        current.setAvatar(user.getAvatar());
        current.setRemark(user.getRemark());
        if (StringUtils.isNotEmpty(user.getPhonenumber()) && !userService.checkPhoneUnique(current))
        {
            throw new ServiceException("手机号已存在。");
        }
        if (StringUtils.isNotEmpty(user.getEmail()) && !userService.checkEmailUnique(current))
        {
            throw new ServiceException("邮箱已存在。");
        }
        int rows = userService.updateUserProfile(current);
        StudentProfile existing = accountMapper.selectStudentProfileByUserId(user.getUserId());
        profile.setUserId(user.getUserId());
        if (StringUtils.isNull(existing))
        {
            profile.setCreateBy(SecurityUtils.getUsername());
            accountMapper.insertStudentProfile(profile);
        }
        else
        {
            profile.setUpdateBy(SecurityUtils.getUsername());
            accountMapper.updateStudentProfile(profile);
        }
        return rows;
    }

    @Override
    public List<SysUser> selectStudentList(SysUser user)
    {
        return accountMapper.selectStudentList(user);
    }

    @Override
    public SysUser selectStudentByUserId(Long userId)
    {
        return accountMapper.selectStudentByUserId(userId);
    }

    @Override
    public int resetStudentPassword(Long userId, String password)
    {
        ensureStudentUser(userId);
        ensurePasswordValid(password, "新密码");
        return userService.resetUserPwd(userId, SecurityUtils.encryptPassword(password));
    }

    @Override
    @Transactional
    public int resetStudentPasswords(Long[] userIds, String password)
    {
        ensureStudentIds(userIds);
        int count = 0;
        for (Long userId : userIds)
        {
            count += resetStudentPassword(userId, password);
        }
        return count;
    }

    @Override
    public int changeStudentStatus(Long userId, String status)
    {
        ensureStudentUser(userId);
        ensureUserStatus(status);
        SysUser user = new SysUser();
        user.setUserId(userId);
        user.setStatus(status);
        return userService.updateUserStatus(user);
    }

    @Override
    @Transactional
    public int changeStudentStatuses(Long[] userIds, String status)
    {
        ensureStudentIds(userIds);
        int count = 0;
        for (Long userId : userIds)
        {
            count += changeStudentStatus(userId, status);
        }
        return count;
    }

    @Override
    public int deleteStudentUsers(Long[] userIds)
    {
        ensureStudentIds(userIds);
        for (Long userId : userIds)
        {
            ensureStudentUser(userId);
        }
        return userService.deleteUserByIds(userIds);
    }

    @Override
    public boolean studentRegisterEnabled()
    {
        String value = configValue(REGISTER_CONFIG_KEY);
        return StringUtils.isEmpty(value) || StringUtils.equals("true", value);
    }

    @Override
    public boolean forgotPasswordEmailRequired()
    {
        return "true".equalsIgnoreCase(configValue(FORGOT_PASSWORD_EMAIL_REQUIRED_KEY));
    }

    @Override
    public boolean updateStudentRegisterEnabled(boolean enabled, String operName)
    {
        SysConfig config = new SysConfig();
        config.setConfigKey(REGISTER_CONFIG_KEY);
        List<SysConfig> list = configService.selectConfigList(config);
        if (list.isEmpty())
        {
            throw new ServiceException("注册开关配置不存在。");
        }
        SysConfig target = list.get(0);
        target.setConfigValue(Boolean.toString(enabled));
        target.setUpdateBy(operName);
        return configService.updateConfig(target) > 0;
    }

    @Override
    public AccountSecuritySettings selectAccountSecuritySettings()
    {
        AccountSecuritySettings settings = new AccountSecuritySettings();
        settings.setBlackIpList(configValue(LOGIN_BLACK_IP_KEY));
        settings.setBlockedUserAgentKeywords(configValue(LOGIN_BLOCKED_UA_KEY));
        settings.setForgotPasswordEmailRequired(forgotPasswordEmailRequired());
        return settings;
    }

    @Override
    public boolean updateAccountSecuritySettings(AccountSecuritySettings settings, String operName)
    {
        if (settings == null)
        {
            throw new ServiceException("安全策略不能为空。");
        }
        boolean updated = upsertConfig(LOGIN_BLACK_IP_KEY, "登录 IP 黑名单", StringUtils.trim(settings.getBlackIpList()), operName);
        boolean uaUpdated = upsertConfig(LOGIN_BLOCKED_UA_KEY, "登录终端关键字黑名单", StringUtils.trim(settings.getBlockedUserAgentKeywords()), operName);
        boolean emailUpdated = upsertConfig(FORGOT_PASSWORD_EMAIL_REQUIRED_KEY, "找回密码强制邮箱验证",
                Boolean.toString(Boolean.TRUE.equals(settings.getForgotPasswordEmailRequired())), operName);
        return updated || uaUpdated || emailUpdated;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String importStudentUsers(List<SysUser> userList, Boolean isUpdateSupport, Boolean disableMissing, String operName)
    {
        if (StringUtils.isNull(userList) || userList.size() == 0)
        {
            throw new ServiceException("导入学生数据不能为空");
        }

        SysRole studentRole = selectStudentRole();
        if (StringUtils.isNull(studentRole))
        {
            throw new ServiceException("系统缺少学生角色（role_key=student）");
        }

        Set<String> importedUserNames = new HashSet<>();
        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();

        for (SysUser user : userList)
        {
            try
            {
                if (StringUtils.isNull(user.getDeptId()) || user.getDeptId() == 0)
                {
                    throw new ServiceException("所属部门不能为空");
                }
                if (StringUtils.isEmpty(user.getUserName()) || StringUtils.isEmpty(user.getStudentNo()) || StringUtils.isEmpty(user.getNickName()))
                {
                    throw new ServiceException("账号、学号、昵称不能为空");
                }
                importedUserNames.add(user.getUserName());

                SysUser exist = userService.selectUserByUserName(user.getUserName());
                if (StringUtils.isNull(exist))
                {
                    if (!userService.checkStudentNoUnique(user))
                    {
                        throw new ServiceException("学号已存在");
                    }
                    if (StringUtils.isNotEmpty(user.getEmail()) && !userService.checkEmailUnique(user))
                    {
                        throw new ServiceException("邮箱已存在");
                    }
                    user.setRoleIds(new Long[] { studentRole.getRoleId() });
                    user.setPassword(SecurityUtils.encryptPassword(configService.selectConfigByKey(INIT_PASSWORD_KEY)));
                    user.setStatus(studentDefaultStatus());
                    user.setCreateBy(operName);
                    user.setCreateTime(DateUtils.getNowDate());
                    user.setPwdUpdateDate(DateUtils.getNowDate());
                    userService.insertUser(user);
                    ensureStudentProfile(user.getUserId(), operName);
                    successNum++;
                    successMsg.append("<br/>").append(successNum).append("、账号").append(user.getUserName()).append(" 导入成功");
                }
                else if (isUpdateSupport)
                {
                    ensureExistingImportTargetIsStudent(exist);
                    user.setUserId(exist.getUserId());
                    user.setDeptId(exist.getDeptId());
                    user.setStatus(exist.getStatus());
                    user.setUpdateBy(operName);
                    user.setRoleIds(new Long[] { studentRole.getRoleId() });
                    userService.checkUserAllowed(exist);
                    userService.checkUserDataScope(exist.getUserId());
                    if (!StringUtils.equals(exist.getStudentNo(), user.getStudentNo()) && !userService.checkStudentNoUnique(user))
                    {
                        throw new ServiceException("学号已存在");
                    }
                    if (StringUtils.isNotEmpty(user.getEmail()) && !StringUtils.equals(exist.getEmail(), user.getEmail()) && !userService.checkEmailUnique(user))
                    {
                        throw new ServiceException("邮箱已存在");
                    }
                    userService.updateUser(user);
                    ensureStudentProfile(user.getUserId(), operName);
                    successNum++;
                    successMsg.append("<br/>").append(successNum).append("、账号").append(user.getUserName()).append(" 更新成功");
                }
                else
                {
                    failureNum++;
                    failureMsg.append("<br/>").append(failureNum).append("、账号").append(user.getUserName()).append(" 已存在");
                }
            }
            catch (Exception e)
            {
                failureNum++;
                String msg = "<br/>" + failureNum + "、账号" + user.getUserName() + " 导入失败：";
                failureMsg.append(msg).append(e.getMessage());
                log.error(msg, e);
            }
        }

        List<SysUser> allStudents = accountMapper.selectStudentList(new SysUser());
        List<String> missingStudents = allStudents.stream()
                .map(SysUser::getUserName)
                .filter(name -> !importedUserNames.contains(name))
                .collect(Collectors.toList());
        if ((Boolean.TRUE.equals(disableMissing) || "disable".equalsIgnoreCase(configValue(MISSING_STUDENT_POLICY_KEY)))
                && !CollectionUtils.isEmpty(missingStudents))
        {
            for (String userName : missingStudents)
            {
                SysUser user = userService.selectUserByUserName(userName);
                if (StringUtils.isNotNull(user))
                {
                    SysUser statusUser = new SysUser();
                    statusUser.setUserId(user.getUserId());
                    statusUser.setStatus(UserConstants.USER_DISABLE);
                    userService.updateUserStatus(statusUser);
                }
            }
        }

        String missingText = CollectionUtils.isEmpty(missingStudents) ? "" : ("；名单外账号：" + String.join("、", missingStudents));
        if (failureNum > 0)
        {
            failureMsg.insert(0, "很抱歉，导入失败！共 " + failureNum + " 条数据格式不正确，错误如下：");
            throw new ServiceException(failureMsg.toString() + missingText);
        }

        successMsg.insert(0, "恭喜您，数据已全部导入成功！共" + successNum + " 条，数据如下：");
        if (!StringUtils.isEmpty(missingText))
        {
            successMsg.append("<br/>").append("提示：").append(missingText);
            if (Boolean.TRUE.equals(disableMissing) || "disable".equalsIgnoreCase(configValue(MISSING_STUDENT_POLICY_KEY)))
            {
                successMsg.append("，已自动停用名单外账号");
            }
        }
        return successMsg.toString();
    }

    private void ensureExistingImportTargetIsStudent(SysUser user)
    {
        if (StringUtils.isNull(user))
        {
            throw new ServiceException("账号不存在");
        }
        if (user.isAdmin() || !selectStudentRoleNames(user).contains(STUDENT_ROLE_KEY))
        {
            throw new ServiceException("账号已存在且不是学生账号，不能通过学生名单导入更新");
        }
    }

    private StudentProfile buildEmptyProfile(Long userId, String operName)
    {
        StudentProfile profile = new StudentProfile();
        profile.setUserId(userId);
        profile.setCreateBy(operName);
        return profile;
    }

    private void ensureStudentProfile(Long userId, String operName)
    {
        if (StringUtils.isNull(accountMapper.selectStudentProfileByUserId(userId)))
        {
            accountMapper.insertStudentProfile(buildEmptyProfile(userId, operName));
        }
    }

    private SysUser validateForgotPasswordUser(ForgotPasswordBody body)
    {
        if (body == null)
        {
            throw new ServiceException("找回密码请求不能为空。");
        }
        String username = StringUtils.trim(body.getUsername());
        String studentNo = StringUtils.trim(body.getStudentNo());
        if (StringUtils.isEmpty(username) || StringUtils.isEmpty(studentNo))
        {
            throw new ServiceException("账号和学号不能为空。");
        }

        SysUser user = userService.selectUserByUserName(username);
        if (StringUtils.isNull(user))
        {
            throw new ServiceException("未找到该账号。");
        }
        if (!StringUtils.equals(studentNo, user.getStudentNo()))
        {
            throw new ServiceException("学号校验失败。");
        }
        if (user.isAdmin() || !selectStudentRoleNames(user).contains(STUDENT_ROLE_KEY))
        {
            throw new ServiceException("只有学生账号支持自助重置密码。");
        }
        return user;
    }

    private void ensureForgotPasswordEmailMatches(SysUser user, ForgotPasswordBody body)
    {
        String requestEmail = StringUtils.trim(body == null ? null : body.getEmail());
        if (StringUtils.isEmpty(requestEmail))
        {
            return;
        }
        String userEmail = StringUtils.trim(user == null ? null : user.getEmail());
        if (StringUtils.isEmpty(userEmail) || !userEmail.equalsIgnoreCase(requestEmail))
        {
            throw new ServiceException("邮箱与账号绑定邮箱不一致。");
        }
    }

    private void ensurePasswordValid(String password, String label)
    {
        String target = StringUtils.trim(password);
        String error = PasswordPolicyUtils.validate(target,
                Convert.toInt(configValue("sys.account.passwordMinLength"), UserConstants.PASSWORD_MIN_LENGTH),
                Convert.toInt(configValue("sys.account.passwordMaxLength"), UserConstants.PASSWORD_MAX_LENGTH),
                configValue("sys.account.chrtype"));
        if (StringUtils.isNotEmpty(error))
        {
            throw new ServiceException(error.replaceFirst("^密码", label));
        }
    }

    private String studentDefaultStatus()
    {
        String status = configValue(STUDENT_DEFAULT_STATUS_KEY);
        return UserConstants.USER_DISABLE.equals(status) ? UserConstants.USER_DISABLE : UserConstants.NORMAL;
    }

    private void ensureStudentIds(Long[] userIds)
    {
        if (userIds == null || userIds.length == 0)
        {
            throw new ServiceException("请选择学生账号。");
        }
        for (Long userId : userIds)
        {
            if (userId == null)
            {
                throw new ServiceException("学生账号 ID 不能为空。");
            }
        }
    }

    private void ensureUserStatus(String status)
    {
        if (!UserConstants.NORMAL.equals(status) && !UserConstants.USER_DISABLE.equals(status))
        {
            throw new ServiceException("用户状态不正确。");
        }
    }

    private SysRole selectStudentRole()
    {
        return roleService.selectRoleAll().stream()
                .filter(role -> StringUtils.equals(STUDENT_ROLE_KEY, role.getRoleKey()))
                .findFirst().orElse(null);
    }

    private void ensureStudentUser(Long userId)
    {
        SysUser user = userService.selectUserById(userId);
        if (StringUtils.isNull(user))
        {
            throw new ServiceException("未找到该用户。");
        }
        if (user.isAdmin())
        {
            throw new ServiceException("管理员账号不能执行此操作。");
        }
        if (!selectStudentRoleNames(user).contains(STUDENT_ROLE_KEY))
        {
            throw new ServiceException("仅支持学生账号。");
        }
    }

    private List<String> selectStudentRoleNames(SysUser user)
    {
        if (StringUtils.isNull(user) || StringUtils.isEmpty(user.getRoles()))
        {
            if (StringUtils.isNull(user))
            {
                return List.of();
            }
            SysUser full = userService.selectUserById(user.getUserId());
            user = full;
        }
        if (StringUtils.isNull(user) || StringUtils.isEmpty(user.getRoles()))
        {
            return List.of();
        }
        return user.getRoles().stream().map(SysRole::getRoleKey).filter(Objects::nonNull).collect(Collectors.toList());
    }

    private String configValue(String key)
    {
        SysConfig query = new SysConfig();
        query.setConfigKey(key);
        List<SysConfig> list = configService.selectConfigList(query);
        return list.isEmpty() ? "" : list.get(0).getConfigValue();
    }

    private boolean upsertConfig(String key, String name, String value, String operName)
    {
        SysConfig query = new SysConfig();
        query.setConfigKey(key);
        List<SysConfig> list = configService.selectConfigList(query);
        if (list.isEmpty())
        {
            SysConfig config = new SysConfig();
            config.setConfigName(name);
            config.setConfigKey(key);
            config.setConfigValue(value);
            config.setConfigType("N");
            config.setCreateBy(operName);
            return configService.insertConfig(config) > 0;
        }
        SysConfig target = list.get(0);
        target.setConfigValue(value);
        target.setUpdateBy(operName);
        return configService.updateConfig(target) > 0;
    }
}
