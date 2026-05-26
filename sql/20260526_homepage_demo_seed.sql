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
delete from edu_course_category where category_id between 3001 and 3301;

-- ----------------------------
-- 1. 课程分类
-- ----------------------------
insert into edu_course_category
(category_id, parent_id, ancestors, category_name, order_num, icon, status, del_flag, create_by, create_time, update_by, update_time, remark)
values
(3001, 0, '0', '编程开发', 1, 'monitor', '0', '0', 'admin', '2026-05-20 09:00:00', 'admin', '2026-05-20 09:00:00', '首页演示一级分类'),
(3002, 0, '0', '数据与分析', 2, 'chart', '0', '0', 'admin', '2026-05-20 09:00:00', 'admin', '2026-05-20 09:00:00', '首页演示一级分类'),
(3003, 0, '0', '设计创作', 3, 'edit', '0', '0', 'admin', '2026-05-20 09:00:00', 'admin', '2026-05-20 09:00:00', '首页演示一级分类'),
(3101, 3001, '0,3001', 'Java 开发', 1, 'tree', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3102, 3001, '0,3001', '前端开发', 2, 'build', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3201, 3002, '0,3002', '数据分析', 1, 'money', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3301, 3003, '0,3003', '视觉设计', 1, 'peoples', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类');

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
where category_id between 3001 and 3301
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
