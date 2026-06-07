-- 将学生个人学习档案统一放到侧边栏“学习中心”下。

update sys_menu
set order_num = 1,
    update_by = 'admin',
    update_time = sysdate()
where menu_id = 2201;

update sys_menu
set order_num = 2,
    update_by = 'admin',
    update_time = sysdate()
where menu_id = 2202;

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache,
 menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2207, '学习待办', 2200, 3, 'todo', 'learning/todo/index', '', '', 0, 0,
       'C', '0', '0', 'learning:todo:list', 'list', 'admin', sysdate(), '', null, '学习待办菜单'
where not exists (select 1 from sys_menu where menu_id = 2207);

update sys_menu
set menu_name = '学习待办',
    parent_id = 2200,
    order_num = 3,
    path = 'todo',
    component = 'learning/todo/index',
    menu_type = 'C',
    visible = '0',
    status = '0',
    perms = 'learning:todo:list',
    icon = 'list',
    update_by = 'admin',
    update_time = sysdate()
where menu_id = 2207;

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache,
 menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2208, '学习历史', 2200, 4, 'history', 'learning/history/index', '', '', 0, 0,
       'C', '0', '0', 'learning:history:list', 'time', 'admin', sysdate(), '', null, '学习历史菜单'
where not exists (select 1 from sys_menu where menu_id = 2208);

update sys_menu
set menu_name = '学习历史',
    parent_id = 2200,
    order_num = 4,
    path = 'history',
    component = 'learning/history/index',
    menu_type = 'C',
    visible = '0',
    status = '0',
    perms = 'learning:history:list',
    icon = 'time',
    update_by = 'admin',
    update_time = sysdate()
where menu_id = 2208;

update sys_menu
set menu_name = '学习笔记',
    parent_id = 2200,
    order_num = 5,
    path = 'note',
    component = 'learning/note/index',
    menu_type = 'C',
    visible = '0',
    status = '0',
    perms = 'learning:note:list',
    icon = 'edit',
    update_by = 'admin',
    update_time = sysdate()
where menu_id = 2206;

update sys_menu
set menu_name = '我的收藏',
    parent_id = 2200,
    order_num = 6,
    path = 'favorite',
    component = 'learning/favorite/index',
    menu_type = 'C',
    visible = '0',
    status = '0',
    perms = 'learning:favorite:list',
    icon = 'star',
    update_by = 'admin',
    update_time = sysdate()
where menu_id = 2205;

update sys_menu
set order_num = 7,
    update_by = 'admin',
    update_time = sysdate()
where menu_id = 2204;

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache,
 menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2209, '我的讨论', 2200, 8, 'discussion', 'learning/discussion/index', '', '', 0, 0,
       'C', '0', '0', 'learning:discussion:list', 'message', 'admin', sysdate(), '', null, '我的讨论菜单'
where not exists (select 1 from sys_menu where menu_id = 2209);

update sys_menu
set menu_name = '我的讨论',
    parent_id = 2200,
    order_num = 8,
    path = 'discussion',
    component = 'learning/discussion/index',
    menu_type = 'C',
    visible = '0',
    status = '0',
    perms = 'learning:discussion:list',
    icon = 'message',
    update_by = 'admin',
    update_time = sysdate()
where menu_id = 2209;

update sys_menu
set order_num = 9,
    update_by = 'admin',
    update_time = sysdate()
where menu_id = 2203;

insert into sys_role_menu (role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
join sys_menu m on m.menu_id in (2207, 2208, 2209)
where r.role_key = 'student'
  and not exists (
    select 1
    from sys_role_menu rm
    where rm.role_id = r.role_id
      and rm.menu_id = m.menu_id
  );

delete rm
from sys_role_menu rm
join sys_role r on r.role_id = rm.role_id
where r.role_key in ('admin', 'teacher')
  and rm.menu_id between 2200 and 2209;
