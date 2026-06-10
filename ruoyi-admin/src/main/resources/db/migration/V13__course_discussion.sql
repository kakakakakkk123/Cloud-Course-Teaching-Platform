create table if not exists edu_course_discussion
(
  discussion_id bigint(20) not null auto_increment comment '讨论ID',
  course_id     bigint(20) not null comment '课程ID',
  student_id    bigint(20) not null comment '学生用户ID',
  content       varchar(1000) not null comment '讨论内容',
  status        char(1) default '0' comment '状态（0正常 1隐藏）',
  create_by     varchar(64) default '' comment '创建者',
  create_time   datetime comment '创建时间',
  update_by     varchar(64) default '' comment '更新者',
  update_time   datetime comment '更新时间',
  remark        varchar(500) default null comment '备注',
  primary key (discussion_id),
  key idx_course_discussion_course (course_id),
  key idx_course_discussion_student (student_id)
) engine=innodb auto_increment=10000 comment='课程讨论表';
