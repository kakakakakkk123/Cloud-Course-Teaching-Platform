package com.ruoyi.framework.aspectj;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import java.util.List;
import org.aspectj.lang.JoinPoint;
import org.junit.jupiter.api.Test;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;

class DataScopeAspectTest
{
    @Test
    void dataScopeFilterRejectsUnsafeIdentifiers()
    {
        assertThrows(IllegalArgumentException.class, () ->
                DataScopeAspect.dataScopeFilter(null, null, "u;drop", "d", "user_id", "dept_id", ""));
    }

    @Test
    void dataScopeFilterAcceptsSafeIdentifiersWhenJoinPointHasNoArgs()
    {
        JoinPoint joinPoint = mock(JoinPoint.class);
        when(joinPoint.getArgs()).thenReturn(new Object[0]);

        SysRole role = new SysRole();
        role.setStatus(UserConstants.ROLE_NORMAL);
        role.setDataScope(Constants.Dept.DATA_SCOPE_DEPT);

        SysUser user = new SysUser();
        user.setDeptId(100L);
        user.setRoles(List.of(role));

        assertDoesNotThrow(() ->
                DataScopeAspect.dataScopeFilter(joinPoint, user, "u", "d", "user_id", "dept_id", ""));
    }

    @Test
    void dataScopeFilterWritesDeptConditionToBaseEntity()
    {
        SysUser query = new SysUser();
        JoinPoint joinPoint = mock(JoinPoint.class);
        when(joinPoint.getArgs()).thenReturn(new Object[] { query });

        SysRole role = new SysRole();
        role.setStatus(UserConstants.ROLE_NORMAL);
        role.setDataScope(Constants.Dept.DATA_SCOPE_DEPT);

        SysUser user = new SysUser();
        user.setDeptId(100L);
        user.setRoles(List.of(role));

        DataScopeAspect.dataScopeFilter(joinPoint, user, "u", "d", "user_id", "dept_id", "");

        assertEquals(" AND (d.dept_id = 100 )", query.getParams().get(DataScopeAspect.DATA_SCOPE));
    }
}
