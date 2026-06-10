-- V17: 试卷管理和考试管理独立菜单
-- 让试卷管理和考试管理作为教学管理的直接子菜单，减少导航层级
-- 用户可以从侧边栏直接进入，无需通过题库管理三层跳转
--
-- 权限说明：
--   试卷管理 → edu:paper:list（与 EduPaperController / EduQuestionBankController 对齐）
--   考试管理 → edu:score:list（与 EduExamManageController / EduExamStatController 对齐）
--   教师角色已通过 2103/2104 拥有上述权限，此处仅新增菜单入口并绑定角色

-- 1. 试卷管理菜单 (menu_id = 2105)
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2105', '试卷管理', '2100', '5', 'paper-manage', 'teaching/paper/manage', '', '', 1, 0, 'C', '0', '0', 'edu:paper:list', 'documentation', 'admin', sysdate(), '', null, '试卷管理菜单'
where not exists (select 1 from sys_menu where menu_id = '2105');

-- 2. 考试管理菜单 (menu_id = 2106)
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2106', '考试管理', '2100', '6', 'exam', 'teaching/exam/index', '', '', 1, 0, 'C', '0', '0', 'edu:score:list', 'example', 'admin', sysdate(), '', null, '考试管理菜单'
where not exists (select 1 from sys_menu where menu_id = '2106');

-- 3. 绑定教师角色 (role_id = 3)
--    教师已有 edu:paper:* 和 edu:score:* 权限（通过 2103/2104），此处仅让菜单在侧边栏可见
insert into sys_role_menu (role_id, menu_id)
select 3, 2105 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 2105);

insert into sys_role_menu (role_id, menu_id)
select 3, 2106 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 2106);
