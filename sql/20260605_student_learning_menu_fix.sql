-- 学生学习中心菜单与学生考试记录表兜底脚本
-- 用途：
-- 1. 修复学生端进入“我的课程”出现 404 的常见原因：学生角色未绑定学习中心菜单。
-- 2. 确保学生考试最小闭环依赖的 edu_exam_record 表存在。
-- 说明：
-- 1. 如果已执行 sql/20260529_exam_module_schema.sql，edu_exam_record 通常已经存在，本脚本不会重复创建。
-- 2. 如果学生角色 role_id 不是 4，请先把下面 sys_role_menu 中的 4 改成实际学生角色 ID。

-- 1. 确保学生角色存在
insert into sys_role
(role_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly,
 status, del_flag, create_by, create_time, update_by, update_time, remark)
select 4, '学生', 'student', 4, '2', 1, 1, '0', '0', 'admin', sysdate(), '', null, '学生角色'
where not exists (select 1 from sys_role where role_id = 4);

update sys_role
set role_name = '学生',
    role_key = 'student',
    status = '0',
    del_flag = '0'
where role_id = 4;

-- 2. 确保学习中心菜单存在
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache,
 menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2200, '学习中心', 0, 6, 'learning', null, '', '', 0, 0,
       'M', '0', '0', '', 'guide', 'admin', sysdate(), '', null, '学生学习中心目录'
where not exists (select 1 from sys_menu where menu_id = 2200);

update sys_menu
set menu_name = '学习中心',
    parent_id = 0,
    path = 'learning',
    component = null,
    menu_type = 'M',
    visible = '0',
    status = '0',
    icon = 'guide'
where menu_id = 2200;

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache,
 menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2201, '我的课程', 2200, 1, 'my-course', 'learning/my-course/index', '', '', 0, 0,
       'C', '0', '0', 'learning:course:list', 'dashboard', 'admin', sysdate(), '', null, '我的课程菜单'
where not exists (select 1 from sys_menu where menu_id = 2201);

update sys_menu
set menu_name = '我的课程',
    parent_id = 2200,
    path = 'my-course',
    component = 'learning/my-course/index',
    menu_type = 'C',
    visible = '0',
    status = '0',
    perms = 'learning:course:list',
    icon = 'dashboard'
where menu_id = 2201;

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache,
 menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2202, '在线学习', 2200, 2, 'online', 'learning/online/index', '', '', 0, 0,
       'C', '0', '0', 'learning:online:list', 'build', 'admin', sysdate(), '', null, '在线学习菜单'
where not exists (select 1 from sys_menu where menu_id = 2202);

update sys_menu
set menu_name = '在线学习',
    parent_id = 2200,
    path = 'online',
    component = 'learning/online/index',
    menu_type = 'C',
    visible = '0',
    status = '0',
    perms = 'learning:online:list',
    icon = 'build'
where menu_id = 2202;

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache,
 menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2203, '我的考试', 2200, 3, 'exam', 'learning/exam/index', '', '', 0, 0,
       'C', '0', '0', 'learning:exam:list', 'documentation', 'admin', sysdate(), '', null, '我的考试菜单'
where not exists (select 1 from sys_menu where menu_id = 2203);

update sys_menu
set menu_name = '我的考试',
    parent_id = 2200,
    path = 'exam',
    component = 'learning/exam/index',
    menu_type = 'C',
    visible = '0',
    status = '0',
    perms = 'learning:exam:list',
    icon = 'documentation'
where menu_id = 2203;

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache,
 menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2204, '我的错题', 2200, 4, 'wrong', 'learning/wrong/index', '', '', 0, 0,
       'C', '0', '0', 'learning:wrong:list', 'bug', 'admin', sysdate(), '', null, '我的错题菜单'
where not exists (select 1 from sys_menu where menu_id = 2204);

update sys_menu
set menu_name = '我的错题',
    parent_id = 2200,
    path = 'wrong',
    component = 'learning/wrong/index',
    menu_type = 'C',
    visible = '0',
    status = '0',
    perms = 'learning:wrong:list',
    icon = 'bug'
where menu_id = 2204;

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache,
 menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2205, '收藏', 2200, 5, 'favorite', 'learning/favorite/index', '', '', 0, 0,
       'C', '0', '0', 'learning:favorite:list', 'star', 'admin', sysdate(), '', null, '收藏菜单'
where not exists (select 1 from sys_menu where menu_id = 2205);

update sys_menu
set menu_name = '收藏',
    parent_id = 2200,
    path = 'favorite',
    component = 'learning/favorite/index',
    menu_type = 'C',
    visible = '0',
    status = '0',
    perms = 'learning:favorite:list',
    icon = 'star'
where menu_id = 2205;

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache,
 menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2206, '笔记', 2200, 6, 'note', 'learning/note/index', '', '', 0, 0,
       'C', '0', '0', 'learning:note:list', 'edit', 'admin', sysdate(), '', null, '笔记菜单'
where not exists (select 1 from sys_menu where menu_id = 2206);

update sys_menu
set menu_name = '笔记',
    parent_id = 2200,
    path = 'note',
    component = 'learning/note/index',
    menu_type = 'C',
    visible = '0',
    status = '0',
    perms = 'learning:note:list',
    icon = 'edit'
where menu_id = 2206;

-- 3. 授权学生角色访问学习中心
insert into sys_role_menu (role_id, menu_id)
select 4, 2200
where not exists (select 1 from sys_role_menu where role_id = 4 and menu_id = 2200);

insert into sys_role_menu (role_id, menu_id)
select 4, 2201
where not exists (select 1 from sys_role_menu where role_id = 4 and menu_id = 2201);

insert into sys_role_menu (role_id, menu_id)
select 4, 2202
where not exists (select 1 from sys_role_menu where role_id = 4 and menu_id = 2202);

insert into sys_role_menu (role_id, menu_id)
select 4, 2203
where not exists (select 1 from sys_role_menu where role_id = 4 and menu_id = 2203);

insert into sys_role_menu (role_id, menu_id)
select 4, 2204
where not exists (select 1 from sys_role_menu where role_id = 4 and menu_id = 2204);

insert into sys_role_menu (role_id, menu_id)
select 4, 2205
where not exists (select 1 from sys_role_menu where role_id = 4 and menu_id = 2205);

insert into sys_role_menu (role_id, menu_id)
select 4, 2206
where not exists (select 1 from sys_role_menu where role_id = 4 and menu_id = 2206);

-- 4. 学生考试记录表兜底，已执行考试模块建表脚本时会跳过
create table if not exists edu_exam_record (
  record_id             bigint(20)      not null auto_increment comment '考试记录ID',
  exam_id               bigint(20)      not null comment '考试ID',
  paper_id              bigint(20)      not null comment '试卷ID',
  course_id             bigint(20)      default null comment '课程ID',
  student_id            bigint(20)      not null comment '学生ID',
  attempt_no            int(11)         default 1 comment '第几次考试',
  start_time            datetime        default null comment '开始时间',
  submit_time           datetime        default null comment '提交时间',
  duration_seconds      int(11)         default 0 comment '耗时（秒）',
  exam_status           char(1)         default '0' comment '考试状态（0待开始 1进行中 2已交卷 3已批改 4缺考）',
  objective_score       decimal(8,2)    default 0.00 comment '客观题得分',
  subjective_score      decimal(8,2)    default 0.00 comment '主观题得分',
  total_score           decimal(8,2)    default 0.00 comment '总分',
  pass_flag             char(1)         default '0' comment '是否及格（0否 1是）',
  checked_flag          char(1)         default '0' comment '是否完成阅卷（0否 1是）',
  primary key (record_id),
  unique key uk_exam_student_attempt (exam_id, student_id, attempt_no),
  key idx_record_exam (exam_id),
  key idx_record_student (student_id),
  key idx_record_course (course_id),
  key idx_record_status (exam_status, checked_flag)
) engine=innodb auto_increment=10000 comment='学生考试记录表';

-- 5. 检查菜单是否已返回给学生角色
select m.menu_id, m.menu_name, m.path, m.component, rm.role_id
from sys_menu m
left join sys_role_menu rm on m.menu_id = rm.menu_id and rm.role_id = 4
where m.menu_id in (2200, 2201, 2202, 2203, 2204, 2205, 2206)
order by m.menu_id;
