-- 教师课程管理菜单与权限修复脚本
-- 作用：
-- 1. 补齐“教学管理 -> 课程管理”菜单
-- 2. 补齐课程与课程内容接口对应的功能权限
-- 3. 绑定教师角色（role_id = 3）
--
-- 使用说明：
-- 1. 在 ruoyi 数据库执行本脚本
-- 2. 执行后退出并重新登录教师账号
-- 3. 左侧应出现“教学管理 -> 课程管理”

-- 0. 修正已有菜单的路由属性
update sys_menu
set is_frame = '1'
where menu_id in (2100, 2101)
  and is_frame <> '1';

-- 1. 教学管理目录
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2100, '教学管理', 0, 5, 'teaching', '', '', '', 1, 0, 'M', '0', '0', '', 'education', 'admin', sysdate(), '', null, '教师教学管理目录'
where not exists (select 1 from sys_menu where menu_id = 2100);

-- 2. 课程管理菜单
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2101, '课程管理', 2100, 1, 'course', 'teaching/course/index', '', '', 1, 0, 'C', '0', '0', 'edu:course:list', 'form', 'admin', sysdate(), '', null, '教师课程管理菜单'
where not exists (select 1 from sys_menu where menu_id = 2101);

-- 3. 课程管理功能权限
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21011, '课程查询', 2101, 1, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:course:query', '#', 'admin', sysdate(), '', null, '课程查询权限'
where not exists (select 1 from sys_menu where menu_id = 21011);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21012, '课程新增', 2101, 2, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:course:add', '#', 'admin', sysdate(), '', null, '课程新增权限'
where not exists (select 1 from sys_menu where menu_id = 21012);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21013, '课程修改', 2101, 3, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:course:edit', '#', 'admin', sysdate(), '', null, '课程修改权限'
where not exists (select 1 from sys_menu where menu_id = 21013);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21014, '课程删除', 2101, 4, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:course:remove', '#', 'admin', sysdate(), '', null, '课程删除权限'
where not exists (select 1 from sys_menu where menu_id = 21014);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21015, '课程列表', 2101, 5, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:course:list', '#', 'admin', sysdate(), '', null, '课程列表权限'
where not exists (select 1 from sys_menu where menu_id = 21015);

-- 4. 课程内容功能权限
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21021, '内容列表', 2101, 6, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:content:list', '#', 'admin', sysdate(), '', null, '课程内容列表权限'
where not exists (select 1 from sys_menu where menu_id = 21021);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21022, '内容详情', 2101, 7, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:content:query', '#', 'admin', sysdate(), '', null, '课程内容详情权限'
where not exists (select 1 from sys_menu where menu_id = 21022);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21023, '内容新增', 2101, 8, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:content:add', '#', 'admin', sysdate(), '', null, '课程内容新增权限'
where not exists (select 1 from sys_menu where menu_id = 21023);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21024, '内容修改', 2101, 9, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:content:edit', '#', 'admin', sysdate(), '', null, '课程内容修改权限'
where not exists (select 1 from sys_menu where menu_id = 21024);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21025, '内容删除', 2101, 10, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:content:remove', '#', 'admin', sysdate(), '', null, '课程内容删除权限'
where not exists (select 1 from sys_menu where menu_id = 21025);

-- 5. 绑定教师角色菜单与权限
insert into sys_role_menu (role_id, menu_id)
select 3, 2100 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 2100);

insert into sys_role_menu (role_id, menu_id)
select 3, 2101 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 2101);

insert into sys_role_menu (role_id, menu_id)
select 3, 21011 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21011);

insert into sys_role_menu (role_id, menu_id)
select 3, 21012 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21012);

insert into sys_role_menu (role_id, menu_id)
select 3, 21013 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21013);

insert into sys_role_menu (role_id, menu_id)
select 3, 21014 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21014);

insert into sys_role_menu (role_id, menu_id)
select 3, 21015 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21015);

insert into sys_role_menu (role_id, menu_id)
select 3, 21021 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21021);

insert into sys_role_menu (role_id, menu_id)
select 3, 21022 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21022);

insert into sys_role_menu (role_id, menu_id)
select 3, 21023 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21023);

insert into sys_role_menu (role_id, menu_id)
select 3, 21024 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21024);

insert into sys_role_menu (role_id, menu_id)
select 3, 21025 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21025);

-- 6. 执行后可用下面 SQL 验证
-- select
--   r.role_key,
--   m.menu_id,
--   m.menu_name,
--   m.component,
--   m.perms
-- from sys_role r
-- join sys_role_menu rm on r.role_id = rm.role_id
-- join sys_menu m on rm.menu_id = m.menu_id
-- where r.role_key = 'teacher'
--   and m.menu_id between 2100 and 21025
-- order by m.menu_id;
