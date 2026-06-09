create table if not exists edu_course_favorite (
  favorite_id bigint(20) not null auto_increment comment '收藏ID',
  course_id   bigint(20) not null comment '课程ID',
  user_id     bigint(20) not null comment '用户ID',
  create_time datetime   default null comment '创建时间',
  primary key (favorite_id),
  unique key uk_course_user_favorite (course_id, user_id),
  key idx_favorite_user (user_id),
  key idx_favorite_course (course_id)
) engine=innodb auto_increment=12000 comment='课程收藏表';
