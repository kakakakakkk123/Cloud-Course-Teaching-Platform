-- 考试模块菜单与权限修复脚本
-- 作用：
-- 1. 统一试卷管理、成绩统计菜单权限为当前后端使用的 edu:* 权限
-- 2. 补齐题库、试题、试卷、考试、统计接口所需功能权限
-- 3. 绑定教师角色（role_id = 3）
--
-- 使用说明：
-- 1. 在 ruoyi 数据库中执行本脚本
-- 2. 执行后退出并重新登录教师账号
-- 3. 课程管理、题库管理、试卷管理、考试发布、成绩统计接口将按新权限生效

-- 0. 修正已有菜单的路由属性与权限标识
update sys_menu
set menu_name = '题库管理',
    is_frame = '1',
    perms = 'edu:paper:list'
where menu_id = 2103;

update sys_menu
set is_frame = '1',
    perms = 'edu:score:list'
where menu_id = 2104;

-- 1. 题库与试卷接口权限
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21031, '题库试卷查询', 2103, 1, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:paper:query', '#', 'admin', sysdate(), '', null, '题库与试卷查询权限'
where not exists (select 1 from sys_menu where menu_id = 21031);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21032, '题库试卷新增', 2103, 2, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:paper:add', '#', 'admin', sysdate(), '', null, '题库与试卷新增权限'
where not exists (select 1 from sys_menu where menu_id = 21032);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21033, '题库试卷修改', 2103, 3, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:paper:edit', '#', 'admin', sysdate(), '', null, '题库与试卷修改权限'
where not exists (select 1 from sys_menu where menu_id = 21033);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21034, '题库试卷删除', 2103, 4, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:paper:remove', '#', 'admin', sysdate(), '', null, '题库与试卷删除权限'
where not exists (select 1 from sys_menu where menu_id = 21034);

-- 2. 试题接口权限
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21035, '试题列表', 2103, 5, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:question:list', '#', 'admin', sysdate(), '', null, '试题列表权限'
where not exists (select 1 from sys_menu where menu_id = 21035);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21036, '试题查询', 2103, 6, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:question:query', '#', 'admin', sysdate(), '', null, '试题查询权限'
where not exists (select 1 from sys_menu where menu_id = 21036);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21037, '试题新增', 2103, 7, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:question:add', '#', 'admin', sysdate(), '', null, '试题新增权限'
where not exists (select 1 from sys_menu where menu_id = 21037);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21038, '试题修改', 2103, 8, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:question:edit', '#', 'admin', sysdate(), '', null, '试题修改权限'
where not exists (select 1 from sys_menu where menu_id = 21038);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21039, '试题删除', 2103, 9, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:question:remove', '#', 'admin', sysdate(), '', null, '试题删除权限'
where not exists (select 1 from sys_menu where menu_id = 21039);

-- 3. 考试发布与统计权限
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21041, '考试查询', 2104, 1, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:score:query', '#', 'admin', sysdate(), '', null, '考试查询权限'
where not exists (select 1 from sys_menu where menu_id = 21041);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21042, '考试新增', 2104, 2, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:score:add', '#', 'admin', sysdate(), '', null, '考试新增权限'
where not exists (select 1 from sys_menu where menu_id = 21042);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21043, '考试修改', 2104, 3, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:score:edit', '#', 'admin', sysdate(), '', null, '考试修改权限'
where not exists (select 1 from sys_menu where menu_id = 21043);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21044, '考试删除', 2104, 4, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:score:remove', '#', 'admin', sysdate(), '', null, '考试删除权限'
where not exists (select 1 from sys_menu where menu_id = 21044);

-- 4. 绑定教师角色
insert into sys_role_menu (role_id, menu_id)
select 3, 2103 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 2103);

insert into sys_role_menu (role_id, menu_id)
select 3, 2104 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 2104);

insert into sys_role_menu (role_id, menu_id)
select 3, 21031 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21031);

insert into sys_role_menu (role_id, menu_id)
select 3, 21032 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21032);

insert into sys_role_menu (role_id, menu_id)
select 3, 21033 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21033);

insert into sys_role_menu (role_id, menu_id)
select 3, 21034 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21034);

insert into sys_role_menu (role_id, menu_id)
select 3, 21035 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21035);

insert into sys_role_menu (role_id, menu_id)
select 3, 21036 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21036);

insert into sys_role_menu (role_id, menu_id)
select 3, 21037 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21037);

insert into sys_role_menu (role_id, menu_id)
select 3, 21038 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21038);

insert into sys_role_menu (role_id, menu_id)
select 3, 21039 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21039);

insert into sys_role_menu (role_id, menu_id)
select 3, 21041 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21041);

insert into sys_role_menu (role_id, menu_id)
select 3, 21042 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21042);

insert into sys_role_menu (role_id, menu_id)
select 3, 21043 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21043);

insert into sys_role_menu (role_id, menu_id)
select 3, 21044 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21044);

-- 5. 执行后可用下列 SQL 自检
-- select m.menu_id, m.menu_name, m.perms
-- from sys_role_menu rm
-- join sys_menu m on rm.menu_id = m.menu_id
-- where rm.role_id = 3
--   and m.menu_id between 2103 and 21044
-- order by m.menu_id;
