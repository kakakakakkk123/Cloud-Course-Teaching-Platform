-- 注意：项目已接入 Flyway，正常启动会自动执行 ruoyi-admin/src/main/resources/db/migration 下的迁移。
-- 本脚本仅作为历史初始化顺序参考，一般不再手动执行。

-- 在线课程教学平台完整初始化入口脚本
--
-- MySQL 命令行执行方式：
--   source sql/20260605_full_database_init.sql;
--
-- Navicat / DataGrip 等图形工具不一定支持 source：
--   请按本文件中的顺序逐个打开并执行对应 SQL 文件。

create database if not exists ruoyi
  default character set utf8mb4
  collate utf8mb4_general_ci;

use ruoyi;

-- 1. 若依基础表、基础菜单、基础账号
source sql/ry_20260417.sql;

-- 2. 定时任务 Quartz 表
source sql/quartz.sql;

-- 3. 学院/专业组织数据，供注册页学院和专业下拉使用
source sql/20260523_academy_major_seed.sql;

-- 4. 教师/学生/访客角色、示例教师和学生账号、学习中心基础菜单
source sql/edu_role_menu_update.sql;

-- 5. 开放学生自主注册
source sql/open_student_register.sql;

-- 6. 课程、课程内容、报名、点赞、轮播等课程模块表
source sql/20260605_course_module_schema.sql;

-- 7. 教师端课程管理菜单与课程接口权限
source sql/20260528_teacher_course_menu_fix.sql;

-- 8. 课程分类下拉数据和权限兜底
source sql/20260606_course_category_options_fix.sql;

-- 9. 首页、课程广场、我的课程、在线学习演示数据
source sql/20260526_homepage_demo_seed.sql;

-- 10. 考试模块表
source sql/20260529_exam_module_schema.sql;

-- 11. 考试模块菜单与权限
source sql/20260529_exam_menu_fix.sql;

-- 12. 学生学习中心菜单与学生考试记录表兜底
source sql/20260605_student_learning_menu_fix.sql;

-- 13. 学生端错题、收藏、笔记列表演示数据
source sql/20260606_learning_collection_examples.sql;

-- 14. 管理员端菜单清理，避免管理员侧显示学生学习中心
source sql/20260605_admin_menu_cleanup.sql;

select 'ruoyi database init done' as message;
