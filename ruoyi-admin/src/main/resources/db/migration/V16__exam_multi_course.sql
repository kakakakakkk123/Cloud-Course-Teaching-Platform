-- V16: 考试支持多课程绑定
-- 需求：一份试卷可以发给多个课程，考试发布时选择课程而非创建试卷时绑定单个

-- 1. 考试关联课程表
create table if not exists edu_exam_course (
    id                    bigint(20)      not null auto_increment comment '主键',
    exam_id               bigint(20)      not null comment '考试ID',
    course_id             bigint(20)      not null comment '课程ID',
    create_time           datetime        default current_timestamp comment '创建时间',
    primary key (id),
    unique key uk_exam_course (exam_id, course_id),
    key idx_exam_id (exam_id),
    key idx_course_id (course_id)
) engine=innodb auto_increment=10000 comment='考试关联课程表';

-- 2. 迁移现有单课程数据到多课程表
insert ignore into edu_exam_course (exam_id, course_id, create_time)
select exam_id, course_id, create_time
from edu_exam
where course_id is not null
  and del_flag = '0';
