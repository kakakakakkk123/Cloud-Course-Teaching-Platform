-- V18: edu_student_profile 添加 grade 列
-- SysUserMapper.xml 和 StudentProfile 实体已引用此字段，但数据库表缺少该列
-- 用于账号管理页面展示学生年级信息

alter table edu_student_profile
    add column grade varchar(20) default '' comment '年级' after user_id;
