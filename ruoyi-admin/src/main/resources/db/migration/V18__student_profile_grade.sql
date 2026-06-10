-- V18: edu_student_profile 添加 grade 列（幂等：列已存在时跳过）
-- SysUserMapper.xml 和 StudentProfile 实体已引用此字段，但数据库表缺少该列
-- 用于账号管理页面展示学生年级信息

set @stmt = (
    select if(
        count(*) = 0,
        'alter table edu_student_profile add column grade varchar(20) default '''' comment ''年级'' after user_id',
        'select 1'
    )
    from information_schema.columns
    where table_schema = database()
      and table_name = 'edu_student_profile'
      and column_name = 'grade'
);

prepare stmt from @stmt;
execute stmt;
deallocate prepare stmt;
