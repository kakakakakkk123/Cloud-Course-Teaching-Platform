-- 1. Retire old student-account menus that still point to account/student/index.
update sys_menu
set visible = '1', status = '1'
where menu_id in (2001, 2002, 2003, 2004, 2005, 2102)
   or component = 'account/student/index';

delete from sys_role_menu
where menu_id in (2001, 2002, 2003, 2004, 2005, 2102);

-- 2. Ensure account governance menus are visible and granted to the administrator role.
update sys_menu
set visible = '0', status = '0'
where menu_id in (2301, 2302, 2303, 2304, 2306, 2400, 2401, 2500, 2501, 2502);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2502, '操作审计', 2500, 2, 'operation-audit', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', sysdate(), '', null, '后台操作审计'
where not exists (select 1 from sys_menu where menu_id = 2502);

insert ignore into sys_role_menu(role_id, menu_id)
select 1, m.menu_id
from sys_menu m
where m.menu_id in (2301, 2302, 2303, 2304, 2306, 2400, 2401, 2500, 2501, 2502);

-- 3. Replace demo company departments with school-style organization data.
update sys_dept set dept_name = '明德大学', leader = '校长办公室', phone = '010-62000000', email = 'office@mingde.edu.cn'
where dept_id = 100;
update sys_dept set dept_name = '校本部', leader = '党政办公室', phone = '010-62000001', email = 'admin@mingde.edu.cn'
where dept_id = 101;
update sys_dept set dept_name = '继续教育学院', leader = '继续教育学院', phone = '010-62000002', email = 'jxjy@mingde.edu.cn'
where dept_id = 102;
update sys_dept set dept_name = '信息化办公室', leader = '信息化办公室', phone = '010-62000103', email = 'it@mingde.edu.cn'
where dept_id = 103;
update sys_dept set dept_name = '教务处', leader = '教务处', phone = '010-62000104', email = 'jwc@mingde.edu.cn'
where dept_id = 104;
update sys_dept set dept_name = '质量评估中心', leader = '质量评估中心', phone = '010-62000105', email = 'quality@mingde.edu.cn'
where dept_id = 105;
update sys_dept set dept_name = '财务处', leader = '财务处', phone = '010-62000106', email = 'finance@mingde.edu.cn'
where dept_id = 106;
update sys_dept set dept_name = '后勤保障处', leader = '后勤保障处', phone = '010-62000107', email = 'logistics@mingde.edu.cn'
where dept_id = 107;
update sys_dept set dept_name = '招生就业处', leader = '招生就业处', phone = '010-62000108', email = 'career@mingde.edu.cn'
where dept_id = 108;
update sys_dept set dept_name = '学生工作处', leader = '学生工作处', phone = '010-62000109', email = 'xgc@mingde.edu.cn'
where dept_id = 109;

update sys_user set nick_name = '系统管理员', email = 'admin@mingde.edu.cn', phonenumber = '01062000000'
where user_id = 1 and user_name = 'admin';
update sys_user set nick_name = '平台测试员', email = 'tester@mingde.edu.cn'
where user_id = 2 and user_name = 'ry';

-- 4. Rebuild the academic organization tree as college -> major -> class.
update sys_dept
set dept_name = '院系分类', parent_id = 100, ancestors = '0,100', order_num = 10,
    leader = '教务处', phone = '010-62001000', email = 'schools@mingde.edu.cn', status = '0', del_flag = '0'
where dept_id = 120;

update sys_dept
set del_flag = '2'
where dept_id <> 120
  and (parent_id = 120 or find_in_set(120, ancestors));

insert into sys_dept(dept_id, parent_id, ancestors, dept_name, order_num, leader, phone, email, status, del_flag, create_by, create_time)
values
(1201, 120, '0,100,120', '信息工程学院', 1, '信息工程学院', '010-62001201', 'ise@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(120101, 1201, '0,100,120,1201', '软件工程', 1, '软件工程教研室', '010-62012101', 'se@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(12010101, 120101, '0,100,120,1201,120101', '软件工程2024级1班', 1, '软件工程2024级1班', '010-62110101', 'se202401@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(12010102, 120101, '0,100,120,1201,120101', '软件工程2023级1班', 2, '软件工程2023级1班', '010-62110102', 'se202301@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(120102, 1201, '0,100,120,1201', '数据科学与大数据技术', 2, '数据科学教研室', '010-62012102', 'data@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(12010201, 120102, '0,100,120,1201,120102', '数据科学与大数据技术2024级1班', 1, '数据科学与大数据技术2024级1班', '010-62110201', 'data202401@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(120103, 1201, '0,100,120,1201', '计算机科学与技术', 3, '计算机科学教研室', '010-62012103', 'cs@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(12010301, 120103, '0,100,120,1201,120103', '计算机科学与技术2024级1班', 1, '计算机科学与技术2024级1班', '010-62110301', 'cs202401@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(1202, 120, '0,100,120', '经济管理学院', 2, '经济管理学院', '010-62001202', 'sem@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(120201, 1202, '0,100,120,1202', '工商管理', 1, '工商管理教研室', '010-62012201', 'business@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(12020101, 120201, '0,100,120,1202,120201', '工商管理2024级1班', 1, '工商管理2024级1班', '010-62120101', 'business202401@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(120202, 1202, '0,100,120,1202', '市场营销', 2, '市场营销教研室', '010-62012202', 'marketing@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(12020201, 120202, '0,100,120,1202,120202', '市场营销2024级1班', 1, '市场营销2024级1班', '010-62120201', 'marketing202401@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(120203, 1202, '0,100,120,1202', '会计学', 3, '会计学教研室', '010-62012203', 'accounting@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(12020301, 120203, '0,100,120,1202,120203', '会计学2024级1班', 1, '会计学2024级1班', '010-62120301', 'accounting202401@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(120204, 1202, '0,100,120,1202', '金融学', 4, '金融学教研室', '010-62012204', 'finance@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(12020401, 120204, '0,100,120,1202,120204', '金融学2024级1班', 1, '金融学2024级1班', '010-62120401', 'finance202401@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(1203, 120, '0,100,120', '外国语学院', 3, '外国语学院', '010-62001203', 'foreign@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(120301, 1203, '0,100,120,1203', '英语', 1, '英语教研室', '010-62012301', 'english@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(12030101, 120301, '0,100,120,1203,120301', '英语2024级1班', 1, '英语2024级1班', '010-62130101', 'english202401@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(120302, 1203, '0,100,120,1203', '商务英语', 2, '商务英语教研室', '010-62012302', 'business-english@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(12030201, 120302, '0,100,120,1203,120302', '商务英语2024级1班', 1, '商务英语2024级1班', '010-62130201', 'business-english202401@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(120303, 1203, '0,100,120,1203', '日语', 3, '日语教研室', '010-62012303', 'japanese@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(12030301, 120303, '0,100,120,1203,120303', '日语2024级1班', 1, '日语2024级1班', '010-62130301', 'japanese202401@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(1204, 120, '0,100,120', '艺术与传媒学院', 4, '艺术与传媒学院', '010-62001204', 'artmedia@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(120401, 1204, '0,100,120,1204', '视觉传达设计', 1, '视觉传达设计教研室', '010-62012401', 'visual@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(12040101, 120401, '0,100,120,1204,120401', '视觉传达设计2024级1班', 1, '视觉传达设计2024级1班', '010-62140101', 'visual202401@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(120402, 1204, '0,100,120,1204', '数字媒体艺术', 2, '数字媒体艺术教研室', '010-62012402', 'digital-art@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(12040201, 120402, '0,100,120,1204,120402', '数字媒体艺术2024级1班', 1, '数字媒体艺术2024级1班', '010-62140201', 'digital-art202401@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(1205, 120, '0,100,120', '马克思主义学院', 5, '马克思主义学院', '010-62001205', 'marxism@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(120501, 1205, '0,100,120,1205', '思想政治教育', 1, '思想政治教育教研室', '010-62012501', 'ideology@mingde.edu.cn', '0', '0', 'admin', sysdate()),
(12050101, 120501, '0,100,120,1205,120501', '思想政治教育2024级1班', 1, '思想政治教育2024级1班', '010-62150101', 'ideology202401@mingde.edu.cn', '0', '0', 'admin', sysdate())
on duplicate key update
parent_id = values(parent_id), ancestors = values(ancestors), dept_name = values(dept_name),
order_num = values(order_num), leader = values(leader), phone = values(phone), email = values(email),
status = values(status), del_flag = values(del_flag), update_by = 'admin', update_time = sysdate();

update sys_user
set dept_id = 120101
where user_name in ('teacher', 'teacher01')
  and (dept_id is null or dept_id in (select dept_id from sys_dept where del_flag = '2' or dept_id = 12010101));

update sys_user
set dept_id = 12010101
where user_name in ('student', 'student01')
   or dept_id in (select dept_id from sys_dept where del_flag = '2' and (parent_id = 120 or find_in_set(120, ancestors)));

-- 5. Complete policy configuration defaults used by backend and frontend.
insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select '密码复杂度规则', 'sys.account.chrtype', '3', 'N', 'admin', sysdate(), '0任意 1数字 2字母 3字母数字 4字母数字特殊字符'
where not exists (select 1 from sys_config where config_key = 'sys.account.chrtype');

insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select '记录登录失败原因', 'sys.audit.recordFailureReason', 'true', 'N', 'admin', sysdate(), '登录失败审计是否记录具体失败原因'
where not exists (select 1 from sys_config where config_key = 'sys.audit.recordFailureReason');

insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select '允许导出审计', 'sys.audit.exportEnabled', 'true', 'N', 'admin', sysdate(), '是否允许导出登录和操作审计'
where not exists (select 1 from sys_config where config_key = 'sys.audit.exportEnabled');

-- 6. Seed teaching business dictionaries used by the management pages.
insert into sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
select '课程发布状态', 'edu_course_publish_status', '0', 'admin', sysdate(), '课程草稿、发布、下线状态'
where not exists (select 1 from sys_dict_type where dict_type = 'edu_course_publish_status');
insert into sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
select '课程难度等级', 'edu_course_difficulty', '0', 'admin', sysdate(), '课程难度等级'
where not exists (select 1 from sys_dict_type where dict_type = 'edu_course_difficulty');
insert into sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
select '课程内容类型', 'edu_content_type', '0', 'admin', sysdate(), '文档、视频、图片、外链、考试'
where not exists (select 1 from sys_dict_type where dict_type = 'edu_content_type');
insert into sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
select '课程内容来源', 'edu_content_source_type', '0', 'admin', sysdate(), '上传文件或外部链接'
where not exists (select 1 from sys_dict_type where dict_type = 'edu_content_source_type');
insert into sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
select '题目类型', 'edu_question_type', '0', 'admin', sysdate(), '题库题目类型'
where not exists (select 1 from sys_dict_type where dict_type = 'edu_question_type');
insert into sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
select '考试状态', 'edu_exam_status', '0', 'admin', sysdate(), '考试草稿、发布、结束状态'
where not exists (select 1 from sys_dict_type where dict_type = 'edu_exam_status');
insert into sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
select '试卷状态', 'edu_paper_status', '0', 'admin', sysdate(), '试卷草稿、启用、停用状态'
where not exists (select 1 from sys_dict_type where dict_type = 'edu_paper_status');
insert into sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
select '题库可见范围', 'edu_bank_visibility', '0', 'admin', sysdate(), '题库私有或公开'
where not exists (select 1 from sys_dict_type where dict_type = 'edu_bank_visibility');

insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 1, '草稿', '0', 'edu_course_publish_status', '', 'info', 'Y', '0', 'admin', sysdate(), '课程草稿'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_course_publish_status' and dict_value = '0');
insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 2, '已发布', '1', 'edu_course_publish_status', '', 'success', 'N', '0', 'admin', sysdate(), '课程已发布'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_course_publish_status' and dict_value = '1');
insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 3, '已下线', '2', 'edu_course_publish_status', '', 'warning', 'N', '0', 'admin', sysdate(), '课程已下线'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_course_publish_status' and dict_value = '2');

insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 1, '初级', '1', 'edu_course_difficulty', '', 'success', 'Y', '0', 'admin', sysdate(), '初级'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_course_difficulty' and dict_value = '1');
insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 2, '中级', '2', 'edu_course_difficulty', '', 'warning', 'N', '0', 'admin', sysdate(), '中级'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_course_difficulty' and dict_value = '2');
insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 3, '高级', '3', 'edu_course_difficulty', '', 'danger', 'N', '0', 'admin', sysdate(), '高级'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_course_difficulty' and dict_value = '3');

insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 1, '文档', '1', 'edu_content_type', '', 'primary', 'Y', '0', 'admin', sysdate(), '文档'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_content_type' and dict_value = '1');
insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 2, '视频', '2', 'edu_content_type', '', 'success', 'N', '0', 'admin', sysdate(), '视频'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_content_type' and dict_value = '2');
insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 3, '图片', '3', 'edu_content_type', '', 'warning', 'N', '0', 'admin', sysdate(), '图片'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_content_type' and dict_value = '3');
insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 4, '外链', '4', 'edu_content_type', '', 'info', 'N', '0', 'admin', sysdate(), '外链'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_content_type' and dict_value = '4');
insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 5, '考试', '5', 'edu_content_type', '', 'danger', 'N', '0', 'admin', sysdate(), '考试'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_content_type' and dict_value = '5');

insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 1, '上传文件', '1', 'edu_content_source_type', '', 'primary', 'Y', '0', 'admin', sysdate(), '上传文件'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_content_source_type' and dict_value = '1');
insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 2, '外部链接', '2', 'edu_content_source_type', '', 'info', 'N', '0', 'admin', sysdate(), '外部链接'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_content_source_type' and dict_value = '2');

insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 1, '单选题', '1', 'edu_question_type', '', 'default', 'Y', '0', 'admin', sysdate(), '单选题'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_question_type' and dict_value = '1');
insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 2, '多选题', '2', 'edu_question_type', '', 'warning', 'N', '0', 'admin', sysdate(), '多选题'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_question_type' and dict_value = '2');
insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 3, '判断题', '3', 'edu_question_type', '', 'success', 'N', '0', 'admin', sysdate(), '判断题'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_question_type' and dict_value = '3');
insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 4, '填空题', '4', 'edu_question_type', '', 'info', 'N', '0', 'admin', sysdate(), '填空题'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_question_type' and dict_value = '4');
insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 5, '简答题', '5', 'edu_question_type', '', 'danger', 'N', '0', 'admin', sysdate(), '简答题'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_question_type' and dict_value = '5');

insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 1, '草稿', '0', 'edu_exam_status', '', 'info', 'Y', '0', 'admin', sysdate(), '考试草稿'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_exam_status' and dict_value = '0');
insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 2, '已发布', '1', 'edu_exam_status', '', 'success', 'N', '0', 'admin', sysdate(), '考试已发布'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_exam_status' and dict_value = '1');
insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 3, '已结束', '2', 'edu_exam_status', '', 'warning', 'N', '0', 'admin', sysdate(), '考试已结束'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_exam_status' and dict_value = '2');

insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 1, '草稿', '0', 'edu_paper_status', '', 'info', 'Y', '0', 'admin', sysdate(), '试卷草稿'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_paper_status' and dict_value = '0');
insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 2, '启用', '1', 'edu_paper_status', '', 'success', 'N', '0', 'admin', sysdate(), '试卷启用'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_paper_status' and dict_value = '1');
insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 3, '停用', '2', 'edu_paper_status', '', 'warning', 'N', '0', 'admin', sysdate(), '试卷停用'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_paper_status' and dict_value = '2');

insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 1, '私有', '0', 'edu_bank_visibility', '', 'info', 'Y', '0', 'admin', sysdate(), '私有'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_bank_visibility' and dict_value = '0');
insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
select 2, '公开', '1', 'edu_bank_visibility', '', 'success', 'N', '0', 'admin', sysdate(), '公开'
where not exists (select 1 from sys_dict_data where dict_type = 'edu_bank_visibility' and dict_value = '1');

-- 7. Remove external placeholder image URLs from seed data.
update edu_course
set cover_image = ''
where cover_image like 'https://dummyimage.com/%';

update edu_course_banner
set banner_image = ''
where banner_image like 'https://dummyimage.com/%';
