
-- Source: sql\20260523_academy_major_seed.sql
-- 学院/专业初始化脚本
-- 用途：
-- 1. 确保存在“教学组织”根节点
-- 2. 清空“教学组织”下现有学院/专业
-- 3. 按当前院系结构重建学院 -> 专业两级树
--
-- 说明：
-- 1. 注册页会直接读取本树的前两级数据作为“学院/专业”选项
-- 2. 本脚本会删除“教学组织”下的现有子节点，请在执行前确认不再需要旧示例数据

-- 0. 确保存在“教学组织”根节点（挂在若依科技/100 下）
insert into sys_dept (
  dept_id, parent_id, ancestors, dept_name, order_num, leader, phone, email,
  status, del_flag, create_by, create_time, update_by, update_time
)
values (
  120, 100, '0,100', '教学组织', 6, '教务处', '15800000120', 'academic@school.edu.cn',
  '0', '0', 'admin', sysdate(), '', null
)
on duplicate key update
  parent_id = values(parent_id),
  ancestors = values(ancestors),
  dept_name = values(dept_name),
  order_num = values(order_num),
  leader = values(leader),
  phone = values(phone),
  email = values(email),
  status = values(status),
  del_flag = values(del_flag),
  update_by = 'admin',
  update_time = sysdate();

-- 1. 清空“教学组织”下已有学院/专业
delete from sys_dept where find_in_set('120', ancestors);

-- 2. 重建学院节点
insert into sys_dept values
(121, 120, '0,100,120', '金融与经贸学院', 1, '金融与经贸学院', '15800000121', 'academy121@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(122, 120, '0,100,120', '财税学院', 2, '财税学院', '15800000122', 'academy122@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(123, 120, '0,100,120', '工商管理学院', 3, '工商管理学院', '15800000123', 'academy123@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(124, 120, '0,100,120', '会计学院', 4, '会计学院', '15800000124', 'academy124@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(125, 120, '0,100,120', '信息与人工智能学院', 5, '信息与人工智能学院', '15800000125', 'academy125@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(126, 120, '0,100,120', '法律与社会工作学院', 6, '法律与社会工作学院', '15800000126', 'academy126@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(127, 120, '0,100,120', '文化传播与设计学院', 7, '文化传播与设计学院', '15800000127', 'academy127@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(128, 120, '0,100,120', '外国语学院', 8, '外国语学院', '15800000128', 'academy128@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);

-- 3. 重建专业节点
insert into sys_dept values
(129, 121, '0,100,120,121', '金融学', 1, '金融学', '15800000129', 'major129@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(130, 121, '0,100,120,121', '经济学', 2, '经济学', '15800000130', 'major130@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(131, 121, '0,100,120,121', '国际经济与贸易', 3, '国际经济与贸易', '15800000131', 'major131@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(132, 121, '0,100,120,121', '跨境电子商务', 4, '跨境电子商务', '15800000132', 'major132@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(133, 121, '0,100,120,121', '保险学', 5, '保险学', '15800000133', 'major133@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),

(134, 122, '0,100,120,122', '财政学', 1, '财政学', '15800000134', 'major134@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(135, 122, '0,100,120,122', '税收学', 2, '税收学', '15800000135', 'major135@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(136, 122, '0,100,120,122', '劳动与社会保障', 3, '劳动与社会保障', '15800000136', 'major136@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),

(137, 123, '0,100,120,123', '工商管理', 1, '工商管理', '15800000137', 'major137@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(138, 123, '0,100,120,123', '市场营销', 2, '市场营销', '15800000138', 'major138@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(139, 123, '0,100,120,123', '工程管理', 3, '工程管理', '15800000139', 'major139@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(140, 123, '0,100,120,123', '人力资源管理', 4, '人力资源管理', '15800000140', 'major140@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(141, 123, '0,100,120,123', '物流管理', 5, '物流管理', '15800000141', 'major141@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),

(142, 124, '0,100,120,124', '会计学', 1, '会计学', '15800000142', 'major142@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(143, 124, '0,100,120,124', '财务管理', 2, '财务管理', '15800000143', 'major143@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(144, 124, '0,100,120,124', '审计学', 3, '审计学', '15800000144', 'major144@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(145, 124, '0,100,120,124', '资产评估', 4, '资产评估', '15800000145', 'major145@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),

(146, 125, '0,100,120,125', '信息管理与信息系统', 1, '信息管理与信息系统', '15800000146', 'major146@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(147, 125, '0,100,120,125', '计算机科学与技术', 2, '计算机科学与技术', '15800000147', 'major147@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(148, 125, '0,100,120,125', '电子商务', 3, '电子商务', '15800000148', 'major148@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(149, 125, '0,100,120,125', '应用统计学', 4, '应用统计学', '15800000149', 'major149@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(150, 125, '0,100,120,125', '人工智能', 5, '人工智能', '15800000150', 'major150@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(151, 125, '0,100,120,125', '数据科学与大数据技术', 6, '数据科学与大数据技术', '15800000151', 'major151@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),

(152, 126, '0,100,120,126', '法学', 1, '法学', '15800000152', 'major152@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(153, 126, '0,100,120,126', '社会工作', 2, '社会工作', '15800000153', 'major153@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),

(154, 127, '0,100,120,127', '汉语言文学', 1, '汉语言文学', '15800000154', 'major154@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(155, 127, '0,100,120,127', '广告学', 2, '广告学', '15800000155', 'major155@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(156, 127, '0,100,120,127', '视觉传达设计', 3, '视觉传达设计', '15800000156', 'major156@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(157, 127, '0,100,120,127', '环境设计', 4, '环境设计', '15800000157', 'major157@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(158, 127, '0,100,120,127', '工业设计', 5, '工业设计', '15800000158', 'major158@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(159, 127, '0,100,120,127', '服装与服饰设计', 6, '服装与服饰设计', '15800000159', 'major159@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),

(160, 128, '0,100,120,128', '英语', 1, '英语', '15800000160', 'major160@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(161, 128, '0,100,120,128', '日语', 2, '日语', '15800000161', 'major161@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);

-- 4. 可选检查
select dept_id, parent_id, dept_name, order_num
from sys_dept
where dept_id = 120 or find_in_set('120', ancestors)
order by ancestors, order_num, dept_id;


-- Source: sql\edu_role_menu_update.sql
-- 云课教学平台角色与菜单补丁
-- 已有数据库可直接执行本文件

update sys_role set role_name = '教师', role_key = 'teacher', role_sort = 3, status = '0', del_flag = '0' where role_id = 3;
update sys_role set role_name = '学生', role_key = 'student', role_sort = 4, status = '0', del_flag = '0' where role_id = 4;

insert into sys_role (role_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, update_by, update_time, remark)
select 3, '教师', 'teacher', 3, 1, 1, 1, '0', '0', 'admin', sysdate(), '', null, '教师角色'
where not exists (select 1 from sys_role where role_id = 3);

insert into sys_role (role_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, update_by, update_time, remark)
select 4, '学生', 'student', 4, 2, 1, 1, '0', '0', 'admin', sysdate(), '', null, '学生角色'
where not exists (select 1 from sys_role where role_id = 4);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2100', '教学管理', '0', '5', 'teaching', '', '', '', 1, 0, 'M', '0', '0', '', 'education', 'admin', sysdate(), '', null, '教师教学管理目录'
where not exists (select 1 from sys_menu where menu_id = '2100');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2101', '课程管理', '2100', '1', 'course', 'teaching/course/index', '', '', 1, 0, 'C', '0', '0', 'teaching:course:list', 'form', 'admin', sysdate(), '', null, '课程管理菜单'
where not exists (select 1 from sys_menu where menu_id = '2101');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2102', '学生管理', '2100', '2', 'student', 'account/student/index', '', '', 1, 0, 'C', '0', '0', 'account:student:list', 'peoples', 'admin', sysdate(), '', null, '学生管理菜单'
where not exists (select 1 from sys_menu where menu_id = '2102');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2103', '试卷管理', '2100', '3', 'paper', 'teaching/paper/index', '', '', 1, 0, 'C', '0', '0', 'teaching:paper:list', 'documentation', 'admin', sysdate(), '', null, '试卷管理菜单'
where not exists (select 1 from sys_menu where menu_id = '2103');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2104', '成绩统计', '2100', '4', 'score', 'teaching/score/index', '', '', 1, 0, 'C', '0', '0', 'teaching:score:list', 'chart', 'admin', sysdate(), '', null, '成绩统计菜单'
where not exists (select 1 from sys_menu where menu_id = '2104');

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2200', '学习中心', '0', '6', 'learning', '', '', '', 1, 0, 'M', '0', '0', '', 'guide', 'admin', sysdate(), '', null, '学生学习中心目录'
where not exists (select 1 from sys_menu where menu_id = '2200');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2201', '我的课程', '2200', '1', 'my-course', 'learning/my-course/index', '', '', 1, 0, 'C', '0', '0', 'learning:course:list', 'dashboard', 'admin', sysdate(), '', null, '我的课程菜单'
where not exists (select 1 from sys_menu where menu_id = '2201');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2202', '在线学习', '2200', '2', 'online', 'learning/online/index', '', '', 1, 0, 'C', '0', '0', 'learning:online:list', 'build', 'admin', sysdate(), '', null, '在线学习菜单'
where not exists (select 1 from sys_menu where menu_id = '2202');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2203', '我的考试', '2200', '3', 'exam', 'learning/exam/index', '', '', 1, 0, 'C', '0', '0', 'learning:exam:list', 'documentation', 'admin', sysdate(), '', null, '我的考试菜单'
where not exists (select 1 from sys_menu where menu_id = '2203');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2204', '我的错题', '2200', '4', 'wrong', 'learning/wrong/index', '', '', 1, 0, 'C', '0', '0', 'learning:wrong:list', 'bug', 'admin', sysdate(), '', null, '我的错题菜单'
where not exists (select 1 from sys_menu where menu_id = '2204');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2205', '收藏', '2200', '5', 'favorite', 'learning/favorite/index', '', '', 1, 0, 'C', '0', '0', 'learning:favorite:list', 'star', 'admin', sysdate(), '', null, '收藏菜单'
where not exists (select 1 from sys_menu where menu_id = '2205');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2206', '笔记', '2200', '6', 'note', 'learning/note/index', '', '', 1, 0, 'C', '0', '0', 'learning:note:list', 'edit', 'admin', sysdate(), '', null, '笔记菜单'
where not exists (select 1 from sys_menu where menu_id = '2206');

delete from sys_role_menu where role_id in (3, 4) and menu_id in (2000,2001,2002,2003,2004,2005,2100,2101,2102,2103,2104,2200,2201,2202,2203,2204,2205,2206);

insert into sys_role_menu (role_id, menu_id) select '3', '2100' where not exists (select 1 from sys_role_menu where role_id = '3' and menu_id = '2100');
insert into sys_role_menu (role_id, menu_id) select '3', '2101' where not exists (select 1 from sys_role_menu where role_id = '3' and menu_id = '2101');
insert into sys_role_menu (role_id, menu_id) select '3', '2102' where not exists (select 1 from sys_role_menu where role_id = '3' and menu_id = '2102');
insert into sys_role_menu (role_id, menu_id) select '3', '2103' where not exists (select 1 from sys_role_menu where role_id = '3' and menu_id = '2103');
insert into sys_role_menu (role_id, menu_id) select '3', '2104' where not exists (select 1 from sys_role_menu where role_id = '3' and menu_id = '2104');
insert into sys_role_menu (role_id, menu_id) select '4', '2200' where not exists (select 1 from sys_role_menu where role_id = '4' and menu_id = '2200');
insert into sys_role_menu (role_id, menu_id) select '4', '2201' where not exists (select 1 from sys_role_menu where role_id = '4' and menu_id = '2201');
insert into sys_role_menu (role_id, menu_id) select '4', '2202' where not exists (select 1 from sys_role_menu where role_id = '4' and menu_id = '2202');
insert into sys_role_menu (role_id, menu_id) select '4', '2203' where not exists (select 1 from sys_role_menu where role_id = '4' and menu_id = '2203');
insert into sys_role_menu (role_id, menu_id) select '4', '2204' where not exists (select 1 from sys_role_menu where role_id = '4' and menu_id = '2204');
insert into sys_role_menu (role_id, menu_id) select '4', '2205' where not exists (select 1 from sys_role_menu where role_id = '4' and menu_id = '2205');
insert into sys_role_menu (role_id, menu_id) select '4', '2206' where not exists (select 1 from sys_role_menu where role_id = '4' and menu_id = '2206');

insert into sys_user (user_id, dept_id, user_name, nick_name, student_no, email, phonenumber, sex, avatar, password, status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, update_by, update_time, remark)
select 3, 103, 'teacher', '教师', 'TS001', 'teacher@school.edu.cn', '13800000000', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '教师账号'
where not exists (select 1 from sys_user where user_id = 3);

insert into sys_user_role (user_id, role_id)
select 3, 3 where not exists (select 1 from sys_user_role where user_id = 3 and role_id = 3);

insert into sys_user (user_id, dept_id, user_name, nick_name, student_no, email, phonenumber, sex, avatar, password, status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, update_by, update_time, remark)
select 4, 103, 'student01', '学生一号', 'ST001', 'student01@school.edu.cn', '13900000001', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '示例学生账号'
where not exists (select 1 from sys_user where user_id = 4);

insert into sys_user_role (user_id, role_id)
select 4, 4 where not exists (select 1 from sys_user_role where user_id = 4 and role_id = 4);

insert into edu_student_profile (user_id, signature, todo_items, learning_history, learning_notes, favorites, wrong_questions, discussions, create_by, create_time)
select 4, '认真学习，持续进步', '完成 Java Web 课程实验和数据库作业', '已完成 Java Web 第 1~6 章学习', '本周重点复习过滤器和拦截器', '收藏：Spring Security 登录流程图', '错题：数据库范式综合题', '讨论：期末项目模块分工', 'admin', sysdate()
where not exists (select 1 from edu_student_profile where user_id = 4);

insert into sys_role (role_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, update_by, update_time, remark)
select 5, '游客', 'visitor', 5, 2, 1, 1, '0', '0', 'admin', sysdate(), '', null, '游客角色'
where not exists (select 1 from sys_role where role_id = 5);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2300', '账号管理', '0', '4', 'account', '', '', '', 1, 0, 'M', '0', '0', '', 'user', 'admin', sysdate(), '', null, '账号管理目录'
where not exists (select 1 from sys_menu where menu_id = '2300');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2301', '全部账号', '2300', '1', 'all', 'system/user/index', '{"roleId":0}', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', sysdate(), '', null, '全部账号菜单'
where not exists (select 1 from sys_menu where menu_id = '2301');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2302', '学生账号', '2300', '2', 'student', 'system/user/index', '{"roleId":4}', '', 1, 0, 'C', '0', '0', 'system:user:list', 'peoples', 'admin', sysdate(), '', null, '学生账号菜单'
where not exists (select 1 from sys_menu where menu_id = '2302');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2303', '教师账号', '2300', '3', 'teacher', 'system/user/index', '{"roleId":3}', '', 1, 0, 'C', '0', '0', 'system:user:list', 'post', 'admin', sysdate(), '', null, '教师账号菜单'
where not exists (select 1 from sys_menu where menu_id = '2303');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2304', '管理员账号', '2300', '4', 'admin', 'system/user/index', '{"roleId":1}', '', 1, 0, 'C', '0', '0', 'system:user:list', 'admin', 'admin', sysdate(), '', null, '管理员账号菜单'
where not exists (select 1 from sys_menu where menu_id = '2304');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2305', '游客账号', '2300', '5', 'visitor', 'system/user/index', '{"roleId":5}', '', 1, 0, 'C', '0', '0', 'system:user:list', 'message', 'admin', sysdate(), '', null, '游客账号菜单'
where not exists (select 1 from sys_menu where menu_id = '2305');


-- Source: sql\open_student_register.sql
update sys_config
set config_value = 'true'
where config_key = 'sys.account.registerUser';


-- Source: sql\20260528_teacher_course_menu_fix.sql
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

-- 5. 课程分类下拉权限
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21026, '课程分类列表', 2101, 11, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:category:list', '#', 'admin', sysdate(), '', null, '课程分类下拉查询权限'
where not exists (select 1 from sys_menu where menu_id = 21026);

-- 6. 绑定教师角色菜单与权限
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

insert into sys_role_menu (role_id, menu_id)
select 3, 21026 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21026);

-- 7. 执行后可用下面 SQL 验证
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
--   and m.menu_id between 2100 and 21026
-- order by m.menu_id;


-- Source: sql\20260606_course_category_options_fix.sql
-- 教师端新增课程分类下拉修复脚本
-- 作用：
-- 1. 非破坏式补齐课程分类数据
-- 2. 给教师角色补齐课程分类下拉所需的 edu:category:list 权限
-- 执行后请退出教师账号并重新登录。

insert into edu_course_category
(category_id, parent_id, ancestors, category_name, order_num, icon, status, del_flag, create_by, create_time, update_by, update_time, remark)
values
(3001, 0, '0', '编程开发', 1, 'monitor', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁一级分类'),
(3002, 0, '0', '数据与分析', 2, 'chart', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁一级分类'),
(3003, 0, '0', '设计创作', 3, 'edit', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁一级分类'),
(3004, 0, '0', '人工智能', 4, 'skill', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁一级分类'),
(3005, 0, '0', '云计算与运维', 5, 'server', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁一级分类'),
(3006, 0, '0', '产品与运营', 6, 'guide', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁一级分类'),
(3007, 0, '0', '学科基础', 7, 'education', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁一级分类'),
(3101, 3001, '0,3001', 'Java 开发', 1, 'tree', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3102, 3001, '0,3001', '前端开发', 2, 'build', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3103, 3001, '0,3001', 'Python 开发', 3, 'code', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3104, 3001, '0,3001', '移动开发', 4, 'phone', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3105, 3001, '0,3001', '后端架构', 5, 'nested', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3201, 3002, '0,3002', '数据分析', 1, 'money', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3202, 3002, '0,3002', '数据库技术', 2, 'table', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3203, 3002, '0,3002', '大数据开发', 3, 'redis', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3204, 3002, '0,3002', '商业智能', 4, 'excel', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3301, 3003, '0,3003', '视觉设计', 1, 'peoples', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3302, 3003, '0,3003', 'UI/UX 设计', 2, 'component', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3303, 3003, '0,3003', '数字媒体', 3, 'color', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3401, 3004, '0,3004', '机器学习', 1, 'skill', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3402, 3004, '0,3004', '深度学习', 2, 'rate', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3403, 3004, '0,3004', 'AIGC 应用', 3, 'international', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3501, 3005, '0,3005', 'Linux 运维', 1, 'server', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3502, 3005, '0,3005', '云原生与容器', 2, 'redis-list', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3503, 3005, '0,3005', '网络安全', 3, 'lock', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3601, 3006, '0,3006', '产品经理', 1, 'guide', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3602, 3006, '0,3006', '新媒体运营', 2, 'message', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3603, 3006, '0,3006', '项目管理', 3, 'documentation', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3701, 3007, '0,3007', '高等数学', 1, 'number', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3702, 3007, '0,3007', '计算机基础', 2, 'education', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3703, 3007, '0,3007', '英语通识', 3, 'language', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类')
on duplicate key update
  category_name = values(category_name),
  parent_id = values(parent_id),
  ancestors = values(ancestors),
  order_num = values(order_num),
  icon = values(icon),
  status = '0',
  del_flag = '0',
  update_by = 'admin',
  update_time = sysdate();

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21026, '课程分类列表', 2101, 11, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:category:list', '#', 'admin', sysdate(), '', null, '课程分类下拉查询权限'
where not exists (select 1 from sys_menu where menu_id = 21026);

insert into sys_role_menu (role_id, menu_id)
select 3, 21026
where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21026);

select category_id, category_name, parent_id, order_num
from edu_course_category
where category_id between 3001 and 3703
order by parent_id, order_num, category_id;


-- Source: sql\20260526_homepage_demo_seed.sql
-- 首页模块测试数据
-- 说明：
-- 1. 请先执行首页模块对应的建表脚本，确保以下表已存在：
--    edu_course_category / edu_course / edu_course_content / edu_course_enroll / edu_course_banner / edu_course_like
-- 2. 本脚本默认系统中已存在基础账号：
--    教师：user_id = 3（teacher）
--    学生：user_id = 4（student01）
--    以上账号来自 ry_20260417.sql
-- 3. 本脚本只清理本次演示数据使用的固定 ID，不影响你已有的其它数据

-- ----------------------------
-- 0. 清理旧演示数据
-- ----------------------------
delete from edu_course_like where like_id between 11001 and 11008;
delete from edu_course_enroll where enroll_id between 10001 and 10006;
delete from edu_course_banner where banner_id between 9001 and 9003;
delete from edu_course_content where content_id between 7001 and 7016;
delete from edu_course where course_id between 5001 and 5006;
delete from edu_course_category where category_id between 3001 and 3703;

-- ----------------------------
-- 1. 课程分类
-- ----------------------------
insert into edu_course_category
(category_id, parent_id, ancestors, category_name, order_num, icon, status, del_flag, create_by, create_time, update_by, update_time, remark)
values
(3001, 0, '0', '编程开发', 1, 'monitor', '0', '0', 'admin', '2026-05-20 09:00:00', 'admin', '2026-05-20 09:00:00', '首页演示一级分类'),
(3002, 0, '0', '数据与分析', 2, 'chart', '0', '0', 'admin', '2026-05-20 09:00:00', 'admin', '2026-05-20 09:00:00', '首页演示一级分类'),
(3003, 0, '0', '设计创作', 3, 'edit', '0', '0', 'admin', '2026-05-20 09:00:00', 'admin', '2026-05-20 09:00:00', '首页演示一级分类'),
(3004, 0, '0', '人工智能', 4, 'skill', '0', '0', 'admin', '2026-05-20 09:00:00', 'admin', '2026-05-20 09:00:00', '首页演示一级分类'),
(3005, 0, '0', '云计算与运维', 5, 'server', '0', '0', 'admin', '2026-05-20 09:00:00', 'admin', '2026-05-20 09:00:00', '首页演示一级分类'),
(3006, 0, '0', '产品与运营', 6, 'guide', '0', '0', 'admin', '2026-05-20 09:00:00', 'admin', '2026-05-20 09:00:00', '首页演示一级分类'),
(3007, 0, '0', '学科基础', 7, 'education', '0', '0', 'admin', '2026-05-20 09:00:00', 'admin', '2026-05-20 09:00:00', '首页演示一级分类'),
(3101, 3001, '0,3001', 'Java 开发', 1, 'tree', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3102, 3001, '0,3001', '前端开发', 2, 'build', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3103, 3001, '0,3001', 'Python 开发', 3, 'code', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3104, 3001, '0,3001', '移动开发', 4, 'phone', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3105, 3001, '0,3001', '后端架构', 5, 'nested', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3201, 3002, '0,3002', '数据分析', 1, 'money', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3202, 3002, '0,3002', '数据库技术', 2, 'table', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3203, 3002, '0,3002', '大数据开发', 3, 'redis', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3204, 3002, '0,3002', '商业智能', 4, 'excel', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3301, 3003, '0,3003', '视觉设计', 1, 'peoples', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3302, 3003, '0,3003', 'UI/UX 设计', 2, 'component', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3303, 3003, '0,3003', '数字媒体', 3, 'color', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3401, 3004, '0,3004', '机器学习', 1, 'skill', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3402, 3004, '0,3004', '深度学习', 2, 'rate', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3403, 3004, '0,3004', 'AIGC 应用', 3, 'international', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3501, 3005, '0,3005', 'Linux 运维', 1, 'server', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3502, 3005, '0,3005', '云原生与容器', 2, 'redis-list', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3503, 3005, '0,3005', '网络安全', 3, 'lock', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3601, 3006, '0,3006', '产品经理', 1, 'guide', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3602, 3006, '0,3006', '新媒体运营', 2, 'message', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3603, 3006, '0,3006', '项目管理', 3, 'documentation', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3701, 3007, '0,3007', '高等数学', 1, 'number', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3702, 3007, '0,3007', '计算机基础', 2, 'education', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3703, 3007, '0,3007', '英语通识', 3, 'language', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类');

-- ----------------------------
-- 2. 课程主数据
-- ----------------------------
insert into edu_course
(course_id, category_id, teacher_id, course_name, course_subtitle, cover_image, intro, detail_html, tags,
 difficulty_level, publish_status, recommend_flag, hot_flag, banner_flag, allow_register, sort_order,
 view_count, like_count, enroll_count, content_count, exam_count, last_content_time, publish_time,
 status, del_flag, create_by, create_time, update_by, update_time, remark)
values
(5001, 3101, 3, 'Java Web 企业开发实战', '从 Servlet 到课程平台实战开发', 'https://dummyimage.com/720x420/2563eb/ffffff&text=Java+Web',
 '面向在线教育平台的 Java Web 实战课程，覆盖接口设计、权限控制、分页查询与前后端联调。',
 '<p>课程围绕在线教育平台常见业务展开，适合完成首页、课程与考试模块实训。</p>',
 'Java,SpringBoot,MySQL,若依', '2', '1', '1', '1', '1', '1', 90,
 286, 3, 18, 3, 1, '2026-05-25 18:20:00', '2026-05-18 09:00:00',
 '0', '0', 'admin', '2026-05-18 09:00:00', 'admin', '2026-05-25 18:20:00', '推荐热门课程'),

(5002, 3102, 3, 'Vue2 教育平台前端实战', '聚焦课程门户首页、课程广场与详情页实现', 'https://dummyimage.com/720x420/0ea5e9/ffffff&text=Vue2+Portal',
 '以 Vue2 + Element UI 为基础，完成在线课程平台的首页、搜索、课程卡片与详情页展示。',
 '<p>课程强调组件复用、页面层级设计和课程门户风格构建。</p>',
 'Vue2,ElementUI,课程门户,前端', '1', '1', '1', '0', '1', '1', 88,
 198, 2, 14, 3, 0, '2026-05-24 21:00:00', '2026-05-19 10:00:00',
 '0', '0', 'admin', '2026-05-19 10:00:00', 'admin', '2026-05-24 21:00:00', '推荐课程'),

(5003, 3101, 3, 'Spring Boot 课程管理项目实训', '课程管理、章节发布与内容统计一体化实践', 'https://dummyimage.com/720x420/1d4ed8/ffffff&text=Spring+Boot',
 '通过课程管理、内容管理和统计字段回写，掌握在线课程平台的后端业务落地方式。',
 '<p>课程适合与首页模块、考试模块联动开发。</p>',
 'SpringBoot,课程管理,MyBatis', '2', '1', '0', '1', '0', '1', 82,
 164, 2, 12, 3, 1, '2026-05-26 09:30:00', '2026-05-21 08:30:00',
 '0', '0', 'admin', '2026-05-21 08:30:00', 'admin', '2026-05-26 09:30:00', '最新课程'),

(5004, 3201, 3, 'Python 数据分析入门', '从数据清洗到可视化的基础训练', 'https://dummyimage.com/720x420/14b8a6/ffffff&text=Python+Data',
 '适合初学者快速掌握数据处理、图表分析和结果汇报等基础能力。',
 '<p>课程内容覆盖数据读取、清洗、分析与图表呈现。</p>',
 'Python,数据分析,可视化', '1', '1', '0', '0', '0', '1', 78,
 123, 1, 9, 2, 0, '2026-05-25 15:40:00', '2026-05-20 14:00:00',
 '0', '0', 'admin', '2026-05-20 14:00:00', 'admin', '2026-05-25 15:40:00', '数据分析课程'),

(5005, 3201, 3, 'SQL 数据库建模与优化', '面向业务系统的数据设计与性能优化', 'https://dummyimage.com/720x420/f59e0b/ffffff&text=SQL+Modeling',
 '围绕课程平台中的用户、课程、考试等业务，学习数据库建模、索引设计与查询优化。',
 '<p>课程强调建模规范、统计字段设计和导入测试数据实践。</p>',
 'MySQL,SQL,建模,优化', '2', '1', '0', '0', '0', '1', 70,
 108, 1, 7, 2, 0, '2026-05-23 16:00:00', '2026-05-17 11:20:00',
 '0', '0', 'admin', '2026-05-17 11:20:00', 'admin', '2026-05-23 16:00:00', '数据库课程'),

(5006, 3301, 3, 'UI 界面设计与交互基础', '教育平台页面视觉层级与组件规范', 'https://dummyimage.com/720x420/a855f7/ffffff&text=UI+Design',
 '围绕在线教育平台首页、课程卡片与信息层级设计，训练基础视觉与交互表达。',
 '<p>课程适合首页优化、卡片风格统一和移动端适配练习。</p>',
 'UI,交互设计,教育平台', '1', '1', '1', '0', '0', '1', 76,
 96, 1, 6, 3, 0, '2026-05-22 19:30:00', '2026-05-16 13:30:00',
 '0', '0', 'admin', '2026-05-16 13:30:00', 'admin', '2026-05-22 19:30:00', '设计课程');

-- ----------------------------
-- 3. 课程内容
-- ----------------------------
insert into edu_course_content
(content_id, course_id, parent_id, content_title, content_type, source_type, file_name, file_url, cover_image,
 link_url, summary, content_body, duration_seconds, exam_id, is_preview, sort_order, publish_status,
 view_count, create_by, create_time, update_by, update_time, remark)
values
(7001, 5001, 0, '第1讲：课程平台整体架构', '1', '1', '架构说明.pdf', 'https://example.com/files/java-web-01.pdf', '', '',
 '理解课程平台从首页到课程详情页的整体数据流。', '介绍课程平台基础架构、模块关系与开发顺序。', 0, null, '1', 1, '1',
 28, 'teacher', '2026-05-18 09:20:00', 'teacher', '2026-05-18 09:20:00', 'Java Web 文档课件'),
(7002, 5001, 0, '第2讲：登录与课程接口联调', '2', '2', '', '', '',
 'https://example.com/video/java-web-02', '完成登录态下课程查询与注册流程联调。', '通过视频演示课程查询、点赞与注册的完整交互。', 1860, null, '0', 2, '1',
 35, 'teacher', '2026-05-25 18:20:00', 'teacher', '2026-05-25 18:20:00', 'Java Web 视频课件'),

(7003, 5002, 0, '第1讲：课程门户首页布局', '1', '1', 'portal-home.pdf', 'https://example.com/files/vue-portal-01.pdf', '', '',
 '搭建课程首页的 Hero、搜索区和课程分区。', '完成在线教育首页的布局设计和组件拆分。', 0, null, '1', 1, '1',
 31, 'teacher', '2026-05-19 10:30:00', 'teacher', '2026-05-19 10:30:00', '前端首页文档'),
(7004, 5002, 0, '第2讲：课程卡片与详情页', '2', '2', '', '', '',
 'https://example.com/video/vue-portal-02', '统一课程卡片风格并实现详情页交互。', '演示课程详情页、点赞注册和信息卡片呈现。', 1540, null, '0', 2, '1',
 24, 'teacher', '2026-05-24 21:00:00', 'teacher', '2026-05-24 21:00:00', '前端详情视频'),

(7005, 5003, 0, '第1讲：课程后台管理设计', '1', '1', 'course-manage.pdf', 'https://example.com/files/spring-course-01.pdf', '', '',
 '掌握课程分类、课程、内容三张主表的关系。', '介绍课程后台的菜单设计、接口分层和 Mapper 编写。', 0, null, '1', 1, '1',
 20, 'teacher', '2026-05-21 08:50:00', 'teacher', '2026-05-21 08:50:00', '后台管理文档'),
(7006, 5003, 0, '第2讲：统计字段刷新策略', '1', '1', 'course-stat.pdf', 'https://example.com/files/spring-course-02.pdf', '', '',
 '理解 enroll_count、like_count、content_count 的维护方式。', '讲解课程热度、最新课程与课程统计字段的刷新逻辑。', 0, null, '0', 2, '1',
 18, 'teacher', '2026-05-26 09:30:00', 'teacher', '2026-05-26 09:30:00', '统计字段文档'),

(7007, 5004, 0, '第1讲：数据清洗基础', '1', '1', 'python-data-01.pdf', 'https://example.com/files/python-data-01.pdf', '', '',
 '掌握常见数据清洗步骤和分析准备工作。', '从原始数据导入、字段清洗到结果检查。', 0, null, '1', 1, '1',
 16, 'teacher', '2026-05-20 14:20:00', 'teacher', '2026-05-20 14:20:00', '数据分析文档'),
(7008, 5004, 0, '第2讲：图表可视化实践', '2', '2', '', '', '',
 'https://example.com/video/python-data-02', '用图表展示分析结果，适合课程总结演示。', '演示常见图表与分析报告页面设计。', 1320, null, '0', 2, '1',
 22, 'teacher', '2026-05-25 15:40:00', 'teacher', '2026-05-25 15:40:00', '数据分析视频'),

(7009, 5005, 0, '第1讲：用户与课程关系建模', '1', '1', 'sql-model-01.pdf', 'https://example.com/files/sql-model-01.pdf', '', '',
 '围绕用户、课程和考试的关系设计数据库结构。', '分析课程平台注册、点赞、考试等场景的数据建模。', 0, null, '1', 1, '1',
 12, 'teacher', '2026-05-17 11:40:00', 'teacher', '2026-05-17 11:40:00', 'SQL 建模文档'),
(7010, 5005, 0, '第2讲：索引与排序优化', '1', '1', 'sql-model-02.pdf', 'https://example.com/files/sql-model-02.pdf', '', '',
 '优化课程列表查询和首页排序效率。', '讲解课程名称搜索、分类过滤与排序字段索引设计。', 0, null, '0', 2, '1',
 10, 'teacher', '2026-05-23 16:00:00', 'teacher', '2026-05-23 16:00:00', 'SQL 优化文档'),

(7011, 5006, 0, '第1讲：教育平台信息层级', '1', '1', 'ui-design-01.pdf', 'https://example.com/files/ui-design-01.pdf', '', '',
 '建立首页、课程广场和详情页的一致视觉层级。', '讲解教育类页面的标题、摘要、按钮和卡片布局。', 0, null, '1', 1, '1',
 14, 'teacher', '2026-05-16 13:50:00', 'teacher', '2026-05-16 13:50:00', 'UI 设计文档'),
(7012, 5006, 0, '第2讲：卡片交互与移动端适配', '2', '2', '', '', '',
 'https://example.com/video/ui-design-02', '通过 hover、阴影和间距统一提升页面体验。', '演示卡片上浮、按钮交互和小屏适配技巧。', 1240, null, '0', 2, '1',
 17, 'teacher', '2026-05-22 19:30:00', 'teacher', '2026-05-22 19:30:00', 'UI 视频课程');

-- ----------------------------
-- 4. 学生注册课程
-- 说明：保证 student01 登录后“我的课程”有内容可看
-- ----------------------------
insert into edu_course_enroll
(enroll_id, course_id, student_id, enroll_source, enroll_status, progress_percent, last_study_time, finish_time,
 create_by, create_time, update_by, update_time, remark)
values
(10001, 5001, 4, '1', '1', 68.50, '2026-05-25 20:10:00', null, 'student01', '2026-05-19 20:00:00', 'student01', '2026-05-25 20:10:00', '首页演示：已注册课程'),
(10002, 5002, 4, '1', '1', 42.00, '2026-05-24 22:15:00', null, 'student01', '2026-05-20 18:30:00', 'student01', '2026-05-24 22:15:00', '首页演示：已注册课程'),
(10003, 5004, 4, '1', '1', 15.00, '2026-05-25 15:50:00', null, 'student01', '2026-05-23 16:40:00', 'student01', '2026-05-25 15:50:00', '首页演示：已注册课程');

-- ----------------------------
-- 5. 点赞数据
-- 说明：这里使用已有用户进行点赞，便于演示课程热度
-- ----------------------------
insert into edu_course_like
(like_id, course_id, user_id, create_time)
values
(11001, 5001, 1, '2026-05-24 09:00:00'),
(11002, 5001, 2, '2026-05-24 09:10:00'),
(11003, 5001, 4, '2026-05-24 09:20:00'),
(11004, 5002, 1, '2026-05-24 10:00:00'),
(11005, 5002, 4, '2026-05-24 10:20:00'),
(11006, 5003, 2, '2026-05-25 08:00:00'),
(11007, 5004, 4, '2026-05-25 08:20:00'),
(11008, 5006, 1, '2026-05-25 08:40:00');

-- ----------------------------
-- 6. 首页轮播图
-- ----------------------------
insert into edu_course_banner
(banner_id, banner_title, banner_image, course_id, jump_url, sort_order, status, start_time, end_time,
 create_by, create_time, update_by, update_time, remark)
values
(9001, '首页推荐：Java Web 企业开发实战', 'https://dummyimage.com/1440x420/2563eb/ffffff&text=Java+Web+Course', 5001, '', 1, '0',
 '2026-05-01 00:00:00', '2026-12-31 23:59:59', 'admin', '2026-05-20 10:00:00', 'admin', '2026-05-20 10:00:00', '首页主轮播'),
(9002, '前端专题：Vue2 教育平台前端实战', 'https://dummyimage.com/1440x420/0ea5e9/ffffff&text=Vue2+Portal+Course', 5002, '', 2, '0',
 '2026-05-01 00:00:00', '2026-12-31 23:59:59', 'admin', '2026-05-20 10:10:00', 'admin', '2026-05-20 10:10:00', '首页主轮播'),
(9003, '项目实训：Spring Boot 课程管理项目实训', 'https://dummyimage.com/1440x420/1d4ed8/ffffff&text=Spring+Boot+Training', 5003, '', 3, '0',
 '2026-05-01 00:00:00', '2026-12-31 23:59:59', 'admin', '2026-05-20 10:20:00', 'admin', '2026-05-20 10:20:00', '首页主轮播');

-- ----------------------------
-- 7. 导入后快速检查
-- ----------------------------
select category_id, category_name, parent_id, order_num
from edu_course_category
where category_id between 3001 and 3703
order by parent_id, order_num, category_id;

select course_id, course_name, teacher_id, category_id, recommend_flag, hot_flag, enroll_count, like_count, content_count
from edu_course
where course_id between 5001 and 5006
order by sort_order desc, course_id asc;

select enroll_id, course_id, student_id, progress_percent
from edu_course_enroll
where enroll_id between 10001 and 10003
order by enroll_id asc;

select banner_id, banner_title, course_id, sort_order, status
from edu_course_banner
where banner_id between 9001 and 9003
order by sort_order asc;


-- Source: sql\20260529_exam_menu_fix.sql
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


-- Source: sql\20260605_student_learning_menu_fix.sql
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


-- Source: sql\20260606_learning_collection_examples.sql
-- 学生端“我的错题 / 收藏 / 笔记”演示数据
-- 说明：为示例学生 student01（user_id = 4）写入课程内收集的列表数据。

insert into edu_student_profile (
  user_id, signature, todo_items, learning_history, learning_notes, favorites,
  wrong_questions, discussions, create_by, create_time
)
select 4, '认真学习，持续进步', '完成 Java Web 课程实验和数据库作业', '已完成 Java Web 第 1~6 章学习',
       '[]', '[]', '[]', '讨论：期末项目模块分工', 'admin', sysdate()
where not exists (select 1 from edu_student_profile where user_id = 4);

update edu_student_profile
set
  learning_notes = '[
    {
      "id": "note-5001-01",
      "courseId": 5001,
      "courseName": "Java Web 开发实战",
      "chapterTitle": "第 3 章 认证与会话",
      "contentId": 7001,
      "contentTitle": "登录态与拦截器",
      "title": "拦截器处理登录态的执行顺序",
      "summary": "先排除登录、注册和静态资源，再从 Session 或 Token 中读取用户身份。",
      "note": "拦截器适合做统一登录校验，Controller 只处理业务。遇到未登录请求时返回统一错误码，前端根据错误码跳转登录页。",
      "collectedAt": "2026-06-06 09:20",
      "tags": ["登录态", "拦截器"]
    },
    {
      "id": "note-5002-01",
      "courseId": 5002,
      "courseName": "Vue 前端项目实践",
      "chapterTitle": "第 2 章 组件通信",
      "contentId": 7102,
      "contentTitle": "表单组件封装",
      "title": "v-model 封装要点",
      "summary": "子组件通过 value 接收值，通过 input 事件回传新值。",
      "note": "封装上传、选择器、富文本这类组件时，要保持 value/input 约定，避免父页面额外写同步逻辑。",
      "collectedAt": "2026-06-06 10:35",
      "tags": ["Vue", "组件封装"]
    }
  ]',
  favorites = '[
    {
      "id": "fav-5001-01",
      "courseId": 5001,
      "courseName": "Java Web 开发实战",
      "chapterTitle": "第 4 章 权限控制",
      "contentId": 7006,
      "contentTitle": "Spring Security 登录流程图",
      "title": "Spring Security 登录流程图",
      "summary": "用于复习认证过滤器、UserDetailsService 和权限上下文的关系。",
      "detail": "这份资料把登录请求进入过滤器链、认证管理器校验、保存 SecurityContext 的过程串起来，适合考前快速回看。",
      "resourceUrl": "https://example.com/resource/security-flow",
      "collectedAt": "2026-06-06 11:05",
      "tags": ["权限", "流程图"]
    },
    {
      "id": "fav-5004-01",
      "courseId": 5004,
      "courseName": "UI 设计与交互规范",
      "chapterTitle": "第 1 章 信息层级",
      "contentId": 7301,
      "contentTitle": "后台表格页面规范",
      "title": "后台列表页信息层级清单",
      "summary": "收藏用于检查表格筛选区、操作区、状态标签和分页布局。",
      "detail": "重点关注高频操作入口、批量操作禁用态、表格列宽和移动端换行。",
      "resourceUrl": "https://example.com/resource/admin-list-guideline",
      "collectedAt": "2026-06-06 14:10",
      "tags": ["UI", "后台页面"]
    }
  ]',
  wrong_questions = '[
    {
      "id": "wrong-5001-01",
      "courseId": 5001,
      "courseName": "Java Web 开发实战",
      "examId": 9001,
      "examName": "Java Web 阶段测验",
      "questionId": 8101,
      "title": "过滤器与拦截器的执行时机",
      "questionStem": "下列关于 Filter 与 HandlerInterceptor 执行顺序的说法，哪一项正确？",
      "myAnswer": "Controller 方法执行后才进入 Filter",
      "correctAnswer": "Filter 先于 DispatcherServlet，HandlerInterceptor 在 HandlerMapping 之后执行",
      "analysis": "Filter 属于 Servlet 容器层，Interceptor 属于 Spring MVC 层。请求先经过 Filter，再进入 DispatcherServlet 和拦截器链。",
      "summary": "混淆了 Servlet 容器层和 Spring MVC 层的边界。",
      "collectedAt": "2026-06-06 15:25",
      "tags": ["Filter", "Interceptor"]
    },
    {
      "id": "wrong-5002-01",
      "courseId": 5002,
      "courseName": "Vue 前端项目实践",
      "examId": 9002,
      "examName": "Vue 组件基础测验",
      "questionId": 8203,
      "title": "父子组件双向绑定",
      "questionStem": "自定义组件要支持 v-model，默认需要接收哪个 prop 并触发哪个事件？",
      "myAnswer": "接收 modelValue，触发 update:modelValue",
      "correctAnswer": "Vue 2 默认接收 value，触发 input",
      "analysis": "当前项目使用 Vue 2，默认 v-model 协议是 value/input；modelValue/update:modelValue 是 Vue 3 的默认协议。",
      "summary": "把 Vue 2 与 Vue 3 的 v-model 协议混用了。",
      "collectedAt": "2026-06-06 16:00",
      "tags": ["Vue 2", "v-model"]
    }
  ]',
  update_by = 'admin',
  update_time = sysdate()
where user_id = 4;


-- Source: sql\20260605_admin_menu_cleanup.sql
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
select 2300, '账号管理', 0, 4, 'account', null, '', '', 1, 0,
       'M', '0', '0', '', 'user', 'admin', sysdate(), '', null, '账号管理目录'
where not exists (select 1 from sys_menu where menu_id = 2300);

update sys_menu
set menu_name = '账号管理',
    parent_id = 0,
    order_num = 4,
    path = 'account',
    component = null,
    is_frame = '1',
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
select 2301, '全部账号', 2300, 1, 'all', 'system/user/index', '{"roleId":0}', '', 1, 0,
       'C', '0', '0', 'system:user:list', 'user', 'admin', sysdate(), '', null, '全部账号菜单'
where not exists (select 1 from sys_menu where menu_id = 2301);

update sys_menu
set menu_name = '全部账号',
    parent_id = 2300,
    order_num = 1,
    path = 'all',
    component = 'system/user/index',
    `query` = '{"roleId":0}',
    is_frame = '1',
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
select 2302, '学生账号', 2300, 2, 'student', 'system/user/index', '{"roleId":4}', '', 1, 0,
       'C', '0', '0', 'system:user:list', 'peoples', 'admin', sysdate(), '', null, '学生账号菜单'
where not exists (select 1 from sys_menu where menu_id = 2302);

update sys_menu
set menu_name = '学生账号',
    parent_id = 2300,
    order_num = 2,
    path = 'student',
    component = 'system/user/index',
    `query` = '{"roleId":4}',
    is_frame = '1',
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
select 2303, '教师账号', 2300, 3, 'teacher', 'system/user/index', '{"roleId":3}', '', 1, 0,
       'C', '0', '0', 'system:user:list', 'post', 'admin', sysdate(), '', null, '教师账号菜单'
where not exists (select 1 from sys_menu where menu_id = 2303);

update sys_menu
set menu_name = '教师账号',
    parent_id = 2300,
    order_num = 3,
    path = 'teacher',
    component = 'system/user/index',
    `query` = '{"roleId":3}',
    is_frame = '1',
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
select 2304, '管理员账号', 2300, 4, 'admin', 'system/user/index', '{"roleId":1}', '', 1, 0,
       'C', '0', '0', 'system:user:list', 'admin', 'admin', sysdate(), '', null, '管理员账号菜单'
where not exists (select 1 from sys_menu where menu_id = 2304);

update sys_menu
set menu_name = '管理员账号',
    parent_id = 2300,
    order_num = 4,
    path = 'admin',
    component = 'system/user/index',
    `query` = '{"roleId":1}',
    is_frame = '1',
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
