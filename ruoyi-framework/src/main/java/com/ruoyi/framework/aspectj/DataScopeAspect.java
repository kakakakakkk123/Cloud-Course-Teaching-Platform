package com.ruoyi.framework.aspectj;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;
import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.framework.security.context.PermissionContextHolder;

/**
 * 数据过滤处理
 *
 * @author ruoyi
 */
@Aspect
@Component
public class DataScopeAspect
{
    /**
     * 数据权限过滤关键字
     */
    public static final String DATA_SCOPE = "dataScope";

    private static final Pattern SQL_IDENTIFIER = Pattern.compile("[A-Za-z_][A-Za-z0-9_]*");

    @Before("@annotation(controllerDataScope)")
    public void doBefore(JoinPoint point, DataScope controllerDataScope) throws Throwable
    {
        clearDataScope(point);
        handleDataScope(point, controllerDataScope);
    }

    protected void handleDataScope(final JoinPoint joinPoint, DataScope controllerDataScope)
    {
        // 获取当前的用户
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (StringUtils.isNotNull(loginUser))
        {
            SysUser currentUser = loginUser.getUser();
            // 如果是超级管理员，则不过滤数据
            if (StringUtils.isNotNull(currentUser) && !currentUser.isAdmin() && !hasTeacherRole(currentUser))
            {
                String permission = StringUtils.defaultIfEmpty(controllerDataScope.permission(), PermissionContextHolder.getContext());
                dataScopeFilter(joinPoint, currentUser, controllerDataScope.userAlias(), controllerDataScope.deptAlias(), controllerDataScope.userField(), controllerDataScope.deptField(), permission);
            }
        }
    }

    /**
     * 数据范围过滤
     *
     * @param joinPoint 切点
     * @param user 用户
     * @param deptAlias 部门别名
     * @param userAlias 用户别名
     * @param permission 权限字符
     */
    public static void dataScopeFilter(JoinPoint joinPoint, SysUser user, String userAlias, String deptAlias, String userField, String deptField, String permission)
    {
        userAlias = safeSqlIdentifier(userAlias, "userAlias", true);
        deptAlias = safeSqlIdentifier(deptAlias, "deptAlias", false);
        userField = safeSqlIdentifier(userField, "userField", false);
        deptField = safeSqlIdentifier(deptField, "deptField", false);
        String sqlString = buildDataScopeSql(user, userAlias, deptAlias, userField, deptField, permission);
        putDataScope(joinPoint, sqlString);
    }

    private static String buildDataScopeSql(SysUser user, String userAlias, String deptAlias, String userField, String deptField, String permission)
    {
        StringBuilder sqlString = new StringBuilder();
        List<String> conditions = new ArrayList<String>();
        List<SysRole> roles = StringUtils.isNull(user) || StringUtils.isEmpty(user.getRoles()) ? List.of() : user.getRoles();
        List<String> scopeCustomIds = selectCustomScopeRoleIds(roles, permission);

        for (SysRole role : roles)
        {
            String dataScope = role.getDataScope();
            if (shouldSkipDataScope(conditions, role, permission))
            {
                continue;
            }
            if (Constants.Dept.DATA_SCOPE_ALL.equals(dataScope))
            {
                return StringUtils.EMPTY;
            }
            appendDataScopeCondition(sqlString, role, user, userAlias, deptAlias, userField, deptField, scopeCustomIds);
            conditions.add(dataScope);
        }

        // 角色都不包含传递过来的权限字符，这个时候sqlString也会为空，所以要限制一下,不查询任何数据
        if (StringUtils.isEmpty(conditions))
        {
            sqlString.append(StringUtils.format(" OR {}.{} = 0 ", deptAlias, deptField));
        }
        return sqlString.toString();
    }

    private static List<String> selectCustomScopeRoleIds(List<SysRole> roles, String permission)
    {
        List<String> scopeCustomIds = new ArrayList<String>();
        roles.forEach(role -> {
            if (Constants.Dept.DATA_SCOPE_CUSTOM.equals(role.getDataScope()) && StringUtils.equals(role.getStatus(), UserConstants.ROLE_NORMAL) && hasPermission(role, permission))
            {
                scopeCustomIds.add(Convert.toStr(role.getRoleId()));
            }
        });
        return scopeCustomIds;
    }

    private static boolean shouldSkipDataScope(List<String> conditions, SysRole role, String permission)
    {
        String dataScope = role.getDataScope();
        return conditions.contains(dataScope)
                || StringUtils.equals(role.getStatus(), UserConstants.ROLE_DISABLE)
                || !hasPermission(role, permission);
    }

    private static boolean hasPermission(SysRole role, String permission)
    {
        return StringUtils.isEmpty(permission) || StringUtils.containsAny(role.getPermissions(), Convert.toStrArray(permission));
    }

    private static void appendDataScopeCondition(StringBuilder sqlString, SysRole role, SysUser user, String userAlias, String deptAlias, String userField, String deptField, List<String> scopeCustomIds)
    {
        String dataScope = role.getDataScope();
        if (Constants.Dept.DATA_SCOPE_CUSTOM.equals(dataScope))
        {
            appendCustomScopeCondition(sqlString, role, deptAlias, deptField, scopeCustomIds);
        }
        else if (Constants.Dept.DATA_SCOPE_DEPT.equals(dataScope))
        {
            sqlString.append(StringUtils.format(" OR {}.{} = {} ", deptAlias, deptField, user.getDeptId()));
        }
        else if (Constants.Dept.DATA_SCOPE_DEPT_AND_CHILD.equals(dataScope))
        {
            sqlString.append(StringUtils.format(" OR {}.{} IN ( SELECT dept_id FROM sys_dept WHERE dept_id = {} or find_in_set( {} , ancestors ) )", deptAlias, deptField, user.getDeptId(), user.getDeptId()));
        }
        else if (Constants.Dept.DATA_SCOPE_SELF.equals(dataScope))
        {
            appendSelfScopeCondition(sqlString, user, userAlias, deptAlias, userField, deptField);
        }
    }

    private static void appendCustomScopeCondition(StringBuilder sqlString, SysRole role, String deptAlias, String deptField, List<String> scopeCustomIds)
    {
        if (scopeCustomIds.size() > 1)
        {
            // 多个自定数据权限使用in查询，避免多次拼接。
            sqlString.append(StringUtils.format(" OR {}.{} IN ( SELECT dept_id FROM sys_role_dept WHERE role_id in ({}) ) ", deptAlias, deptField, String.join(",", scopeCustomIds)));
        }
        else
        {
            sqlString.append(StringUtils.format(" OR {}.{} IN ( SELECT dept_id FROM sys_role_dept WHERE role_id = {} ) ", deptAlias, deptField, role.getRoleId()));
        }
    }

    private static void appendSelfScopeCondition(StringBuilder sqlString, SysUser user, String userAlias, String deptAlias, String userField, String deptField)
    {
        if (StringUtils.isNotBlank(userAlias))
        {
            sqlString.append(StringUtils.format(" OR {}.{} = {} ", userAlias, userField, user.getUserId()));
        }
        else
        {
            // 数据权限为仅本人且没有userAlias别名不查询任何数据
            sqlString.append(StringUtils.format(" OR {}.{} = 0 ", deptAlias, deptField));
        }
    }

    private static void putDataScope(JoinPoint joinPoint, String sqlString)
    {
        if (StringUtils.isNotBlank(sqlString))
        {
            Object[] args = joinPoint.getArgs();
            if (args.length == 0)
            {
                return;
            }
            Object params = args[0];
            if (StringUtils.isNotNull(params) && params instanceof BaseEntity)
            {
                BaseEntity baseEntity = (BaseEntity) params;
                baseEntity.getParams().put(DATA_SCOPE, " AND (" + sqlString.substring(4) + ")");
            }
        }
    }

    /**
     * 拼接权限sql前先清空params.dataScope参数防止注入
     */
    private void clearDataScope(final JoinPoint joinPoint)
    {
        Object[] args = joinPoint.getArgs();
        if (args.length == 0)
        {
            return;
        }
        Object params = args[0];
        if (StringUtils.isNotNull(params) && params instanceof BaseEntity)
        {
            BaseEntity baseEntity = (BaseEntity) params;
            baseEntity.getParams().put(DATA_SCOPE, "");
        }
    }

    private static String safeSqlIdentifier(String value, String label, boolean allowEmpty)
    {
        String identifier = StringUtils.trim(value);
        if (StringUtils.isEmpty(identifier))
        {
            if (allowEmpty)
            {
                return "";
            }
            throw new IllegalArgumentException("数据权限标识符不能为空：" + label);
        }
        if (!SQL_IDENTIFIER.matcher(identifier).matches())
        {
            throw new IllegalArgumentException("数据权限标识符不合法：" + label);
        }
        return identifier;
    }

    private boolean hasTeacherRole(SysUser user)
    {
        return StringUtils.isNotNull(user)
                && StringUtils.isNotEmpty(user.getRoles())
                && user.getRoles().stream().anyMatch(role -> StringUtils.equals(role.getRoleKey(), "teacher"));
    }
}
