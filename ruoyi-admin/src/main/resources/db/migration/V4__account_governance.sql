-- Account governance, organization cleanup and audit extensions.

-- 1. Login audit device columns.
alter table sys_logininfor
  add column device_id varchar(128) default '' comment '设备号' after os,
  add column mac_address varchar(64) default '' comment 'MAC地址' after device_id,
  add column user_agent varchar(500) default '' comment 'User-Agent' after mac_address;

-- 2. Account menu order and visibility.
update sys_menu
set order_num = 1, menu_name = '全部账号', path = 'all', component = 'system/user/index',
    `query` = '{"roleId":0}', icon = 'user', visible = '0', status = '0'
where menu_id = 2301;

update sys_menu
set order_num = 2, menu_name = '管理员账号', path = 'admin', component = 'system/user/index',
    `query` = '{"roleId":1}', icon = 'admin', visible = '0', status = '0'
where menu_id = 2304;

update sys_menu
set order_num = 3, menu_name = '教师账号', path = 'teacher', component = 'system/user/index',
    `query` = '{"roleId":3}', icon = 'post', visible = '0', status = '0'
where menu_id = 2303;

update sys_menu
set order_num = 4, menu_name = '学生账号', path = 'student', component = 'system/user/index',
    `query` = '{"roleId":4}', icon = 'peoples', visible = '0', status = '0'
where menu_id = 2302;

update sys_menu
set visible = '1', status = '1'
where menu_id = 2305;

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2306, '院系管理', 2300, 5, 'org', 'system/org/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', sysdate(), '', null, '学院、专业、班级管理'
where not exists (select 1 from sys_menu where menu_id = 2306);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2400, '系统设置', 0, 8, 'settings', null, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', sysdate(), '', null, '系统设置目录'
where not exists (select 1 from sys_menu where menu_id = 2400);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2401, '账号与安全', 2400, 1, 'account-security', 'system/settings/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'setting', 'admin', sysdate(), '', null, '注册、密码、安全和审计策略设置'
where not exists (select 1 from sys_menu where menu_id = 2401);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2500, '日志审计', 0, 9, 'audit', null, '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', sysdate(), '', null, '日志审计目录'
where not exists (select 1 from sys_menu where menu_id = 2500);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2501, '登录审计', 2500, 1, 'login-audit', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', sysdate(), '', null, '登录成功、失败、IP和设备审计'
where not exists (select 1 from sys_menu where menu_id = 2501);

insert into sys_role_menu(role_id, menu_id)
select 1, m.menu_id from sys_menu m
where m.menu_id in (2306, 2400, 2401, 2500, 2501)
  and not exists (select 1 from sys_role_menu rm where rm.role_id = 1 and rm.menu_id = m.menu_id);

-- 3. Extended system settings.
insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select '学生默认账号状态', 'sys.account.studentDefaultStatus', '0', 'N', 'admin', sysdate(), '0正常 1停用'
where not exists (select 1 from sys_config where config_key = 'sys.account.studentDefaultStatus');

insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select '学生名单外账号策略', 'sys.account.missingStudentPolicy', 'ignore', 'N', 'admin', sysdate(), 'ignore仅提示 disable自动停用'
where not exists (select 1 from sys_config where config_key = 'sys.account.missingStudentPolicy');

insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select '登录失败锁定次数', 'sys.login.maxRetryCount', '5', 'N', 'admin', sysdate(), '登录失败保护策略'
where not exists (select 1 from sys_config where config_key = 'sys.login.maxRetryCount');

insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select '登录失败锁定分钟', 'sys.login.lockTime', '10', 'N', 'admin', sysdate(), '登录失败保护策略'
where not exists (select 1 from sys_config where config_key = 'sys.login.lockTime');

insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select '记录登录设备信息', 'sys.login.recordDeviceInfo', 'true', 'N', 'admin', sysdate(), '记录X-Device-Id和X-Mac-Address'
where not exists (select 1 from sys_config where config_key = 'sys.login.recordDeviceInfo');

insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select '登录审计保留天数', 'sys.audit.loginLogRetentionDays', '180', 'N', 'admin', sysdate(), '登录审计清理策略'
where not exists (select 1 from sys_config where config_key = 'sys.audit.loginLogRetentionDays');

insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select '操作审计保留天数', 'sys.audit.operLogRetentionDays', '180', 'N', 'admin', sysdate(), '操作审计清理策略'
where not exists (select 1 from sys_config where config_key = 'sys.audit.operLogRetentionDays');

-- 4. Clean teaching organization tree.
update sys_user
set dept_id = 12010101
where user_name = 'teacher' and exists (select 1 from sys_dept where dept_id = sys_user.dept_id and find_in_set(120, ancestors));

update sys_user
set dept_id = 12010101
where user_name = 'student01' and exists (select 1 from sys_dept where dept_id = sys_user.dept_id and find_in_set(120, ancestors));

update sys_dept
set del_flag = '2'
where dept_id <> 120
  and (parent_id = 120 or find_in_set(120, ancestors));

insert ignore into sys_dept(dept_id, parent_id, ancestors, dept_name, order_num, leader, phone, email, status, del_flag, create_by, create_time)
values
(1201, 120, '0,100,120', '计算机学院', 1, '计算机学院', '15800001201', 'cs@school.edu.cn', '0', '0', 'admin', sysdate()),
(120101, 1201, '0,100,120,1201', '软件工程', 1, '软件工程', '15800012101', 'se@school.edu.cn', '0', '0', 'admin', sysdate()),
(12010101, 120101, '0,100,120,1201,120101', '软件工程1班', 1, '软件工程1班', '15801210101', 'se1@school.edu.cn', '0', '0', 'admin', sysdate()),
(12010102, 120101, '0,100,120,1201,120101', '软件工程2班', 2, '软件工程2班', '15801210102', 'se2@school.edu.cn', '0', '0', 'admin', sysdate()),
(120102, 1201, '0,100,120,1201', '数据科学与大数据技术', 2, '大数据', '15800012102', 'bigdata@school.edu.cn', '0', '0', 'admin', sysdate()),
(12010201, 120102, '0,100,120,1201,120102', '数据科学与大数据技术1班', 1, '大数据1班', '15801210201', 'bigdata1@school.edu.cn', '0', '0', 'admin', sysdate()),
(1202, 120, '0,100,120', '工商管理学院', 2, '工商管理学院', '15800001202', 'business@school.edu.cn', '0', '0', 'admin', sysdate()),
(120201, 1202, '0,100,120,1202', '工商管理', 1, '工商管理', '15800012201', 'business-major@school.edu.cn', '0', '0', 'admin', sysdate()),
(12020101, 120201, '0,100,120,1202,120201', '工商管理1班', 1, '工商管理1班', '15801220101', 'business1@school.edu.cn', '0', '0', 'admin', sysdate()),
(120202, 1202, '0,100,120,1202', '市场营销', 2, '市场营销', '15800012202', 'marketing@school.edu.cn', '0', '0', 'admin', sysdate()),
(12020201, 120202, '0,100,120,1202,120202', '市场营销1班', 1, '市场营销1班', '15801220201', 'marketing1@school.edu.cn', '0', '0', 'admin', sysdate()),
(1203, 120, '0,100,120', '外国语学院', 3, '外国语学院', '15800001203', 'language@school.edu.cn', '0', '0', 'admin', sysdate()),
(120301, 1203, '0,100,120,1203', '英语', 1, '英语', '15800012301', 'english@school.edu.cn', '0', '0', 'admin', sysdate()),
(12030101, 120301, '0,100,120,1203,120301', '英语1班', 1, '英语1班', '15801230101', 'english1@school.edu.cn', '0', '0', 'admin', sysdate()),
(120302, 1203, '0,100,120,1203', '商务英语', 2, '商务英语', '15800012302', 'business-english@school.edu.cn', '0', '0', 'admin', sysdate()),
(12030201, 120302, '0,100,120,1203,120302', '商务英语1班', 1, '商务英语1班', '15801230201', 'business-english1@school.edu.cn', '0', '0', 'admin', sysdate());

update sys_user
set dept_id = 12010101
where dept_id in (select dept_id from sys_dept where del_flag = '2' and (parent_id = 120 or find_in_set(120, ancestors)));
