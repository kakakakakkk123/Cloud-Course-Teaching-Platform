-- 管理员侧菜单清理脚本
-- 解决：
-- 1. 左侧栏“账号管理”重复。
-- 2. 全部账号/教师账号/管理员账号 404。
-- 3. 移除游客账号菜单。
-- 4. 管理员端不显示学习中心。

-- 1. 隐藏旧版账户管理菜单（2000/2001 这一组），保留新版账号管理（2300 这一组）
update sys_menu
set visible = '1',
    status = '1',
    update_by = 'admin',
    update_time = sysdate()
where menu_id in (2000, 2001, 2002, 2003, 2004, 2005);

delete from sys_role_menu
where menu_id in (2000, 2001, 2002, 2003, 2004, 2005);

-- 2. 确保新版账号管理菜单存在且组件路径可用
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache,
 menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2300, '账号管理', 0, 4, 'account', null, '', '', 0, 0,
       'M', '0', '0', '', 'user', 'admin', sysdate(), '', null, '账号管理目录'
where not exists (select 1 from sys_menu where menu_id = 2300);

update sys_menu
set menu_name = '账号管理',
    parent_id = 0,
    order_num = 4,
    path = 'account',
    component = null,
    menu_type = 'M',
    visible = '0',
    status = '0',
    icon = 'user',
    update_by = 'admin',
    update_time = sysdate()
where menu_id = 2300;

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache,
 menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2301, '全部账号', 2300, 1, 'all', 'system/user/index', '{"roleId":0}', '', 0, 0,
       'C', '0', '0', 'system:user:list', 'user', 'admin', sysdate(), '', null, '全部账号菜单'
where not exists (select 1 from sys_menu where menu_id = 2301);

update sys_menu
set menu_name = '全部账号',
    parent_id = 2300,
    order_num = 1,
    path = 'all',
    component = 'system/user/index',
    `query` = '{"roleId":0}',
    menu_type = 'C',
    visible = '0',
    status = '0',
    perms = 'system:user:list',
    icon = 'user',
    update_by = 'admin',
    update_time = sysdate()
where menu_id = 2301;

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache,
 menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2302, '学生账号', 2300, 2, 'student', 'system/user/index', '{"roleId":4}', '', 0, 0,
       'C', '0', '0', 'system:user:list', 'peoples', 'admin', sysdate(), '', null, '学生账号菜单'
where not exists (select 1 from sys_menu where menu_id = 2302);

update sys_menu
set menu_name = '学生账号',
    parent_id = 2300,
    order_num = 2,
    path = 'student',
    component = 'system/user/index',
    `query` = '{"roleId":4}',
    menu_type = 'C',
    visible = '0',
    status = '0',
    perms = 'system:user:list',
    icon = 'peoples',
    update_by = 'admin',
    update_time = sysdate()
where menu_id = 2302;

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache,
 menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2303, '教师账号', 2300, 3, 'teacher', 'system/user/index', '{"roleId":3}', '', 0, 0,
       'C', '0', '0', 'system:user:list', 'post', 'admin', sysdate(), '', null, '教师账号菜单'
where not exists (select 1 from sys_menu where menu_id = 2303);

update sys_menu
set menu_name = '教师账号',
    parent_id = 2300,
    order_num = 3,
    path = 'teacher',
    component = 'system/user/index',
    `query` = '{"roleId":3}',
    menu_type = 'C',
    visible = '0',
    status = '0',
    perms = 'system:user:list',
    icon = 'post',
    update_by = 'admin',
    update_time = sysdate()
where menu_id = 2303;

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache,
 menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2304, '管理员账号', 2300, 4, 'admin', 'system/user/index', '{"roleId":1}', '', 0, 0,
       'C', '0', '0', 'system:user:list', 'admin', 'admin', sysdate(), '', null, '管理员账号菜单'
where not exists (select 1 from sys_menu where menu_id = 2304);

update sys_menu
set menu_name = '管理员账号',
    parent_id = 2300,
    order_num = 4,
    path = 'admin',
    component = 'system/user/index',
    `query` = '{"roleId":1}',
    menu_type = 'C',
    visible = '0',
    status = '0',
    perms = 'system:user:list',
    icon = 'admin',
    update_by = 'admin',
    update_time = sysdate()
where menu_id = 2304;

-- 3. 移除游客账号菜单
update sys_menu
set visible = '1',
    status = '1',
    update_by = 'admin',
    update_time = sysdate()
where menu_id = 2305;

delete from sys_role_menu where menu_id = 2305;

-- 4. 管理员端不需要学习中心：移除管理员角色与学习中心菜单的授权
delete from sys_role_menu
where role_id = 1
  and menu_id in (2200, 2201, 2202, 2203, 2204, 2205, 2206);

-- 5. 授权管理员访问新版账号管理菜单
insert into sys_role_menu (role_id, menu_id)
select 1, 2300
where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2300);

insert into sys_role_menu (role_id, menu_id)
select 1, 2301
where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2301);

insert into sys_role_menu (role_id, menu_id)
select 1, 2302
where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2302);

insert into sys_role_menu (role_id, menu_id)
select 1, 2303
where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2303);

insert into sys_role_menu (role_id, menu_id)
select 1, 2304
where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2304);

-- 6. 检查结果
select m.menu_id, m.menu_name, m.parent_id, m.path, m.component, m.visible, m.status, rm.role_id
from sys_menu m
left join sys_role_menu rm on m.menu_id = rm.menu_id and rm.role_id = 1
where m.menu_id in (2000, 2001, 2300, 2301, 2302, 2303, 2304, 2305, 2200, 2201, 2202, 2203, 2204, 2205, 2206)
order by m.menu_id;
