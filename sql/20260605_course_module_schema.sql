-- 课程与首页模块建表脚本
-- 说明：本脚本补齐首页、课程广场、课程详情、我的课程、在线学习依赖的课程表结构。

drop table if exists edu_course_like;
drop table if exists edu_course_enroll;
drop table if exists edu_course_banner;
drop table if exists edu_course_content;
drop table if exists edu_course;
drop table if exists edu_course_category;

create table edu_course_category (
  category_id   bigint(20)   not null auto_increment comment '分类ID',
  parent_id     bigint(20)   default 0 comment '父分类ID',
  ancestors     varchar(500) default '' comment '祖级列表',
  category_name varchar(120) not null comment '分类名称',
  order_num     int(4)       default 0 comment '显示顺序',
  icon          varchar(100) default '' comment '图标',
  status        char(1)      default '0' comment '状态（0正常 1停用）',
  del_flag      char(1)      default '0' comment '删除标志（0存在 2删除）',
  create_by     varchar(64)  default '' comment '创建者',
  create_time   datetime     comment '创建时间',
  update_by     varchar(64)  default '' comment '更新者',
  update_time   datetime     comment '更新时间',
  remark        varchar(500) default null comment '备注',
  primary key (category_id),
  key idx_course_category_parent (parent_id),
  key idx_course_category_status (status, del_flag)
) engine=innodb auto_increment=3000 comment='课程分类表';

create table edu_course (
  course_id          bigint(20)    not null auto_increment comment '课程ID',
  category_id        bigint(20)    not null comment '分类ID',
  teacher_id         bigint(20)    not null comment '教师用户ID',
  course_name        varchar(200)  not null comment '课程名称',
  course_subtitle    varchar(255)  default '' comment '课程副标题',
  cover_image        varchar(500)  default '' comment '课程封面',
  intro              varchar(1000) default '' comment '课程简介',
  detail_html        longtext      comment '课程详情',
  tags               varchar(500)  default '' comment '标签',
  difficulty_level   char(1)       default '1' comment '难度等级（1初级 2中级 3高级）',
  publish_status     char(1)       default '0' comment '发布状态（0草稿 1已发布）',
  recommend_flag     char(1)       default '0' comment '是否推荐（0否 1是）',
  hot_flag           char(1)       default '0' comment '是否热门（0否 1是）',
  banner_flag        char(1)       default '0' comment '是否轮播（0否 1是）',
  allow_register     char(1)       default '1' comment '是否允许注册（0否 1是）',
  sort_order         int(4)        default 0 comment '排序值',
  view_count         int(11)       default 0 comment '浏览次数',
  like_count         int(11)       default 0 comment '点赞次数',
  enroll_count       int(11)       default 0 comment '注册人数',
  content_count      int(11)       default 0 comment '内容数',
  exam_count         int(11)       default 0 comment '考试数',
  last_content_time  datetime      default null comment '最后内容更新时间',
  publish_time       datetime      default null comment '发布时间',
  status             char(1)       default '0' comment '状态（0正常 1停用）',
  del_flag           char(1)       default '0' comment '删除标志（0存在 2删除）',
  create_by          varchar(64)   default '' comment '创建者',
  create_time        datetime      comment '创建时间',
  update_by          varchar(64)   default '' comment '更新者',
  update_time        datetime      comment '更新时间',
  remark             varchar(500)  default null comment '备注',
  primary key (course_id),
  key idx_course_category (category_id),
  key idx_course_teacher (teacher_id),
  key idx_course_publish (publish_status, status, del_flag),
  key idx_course_sort (sort_order, publish_time)
) engine=innodb auto_increment=5000 comment='课程表';

create table edu_course_content (
  content_id       bigint(20)    not null auto_increment comment '内容ID',
  course_id        bigint(20)    not null comment '课程ID',
  parent_id        bigint(20)    default 0 comment '父内容ID',
  content_title    varchar(200)  not null comment '内容标题',
  content_type     char(1)       default '1' comment '内容类型（1文档 2视频 3图片 4外链 5考试）',
  source_type      char(1)       default '1' comment '来源类型（1本地/上传 2外链）',
  file_name        varchar(255)  default '' comment '文件名',
  file_url         varchar(500)  default '' comment '文件地址',
  cover_image      varchar(500)  default '' comment '内容封面',
  link_url         varchar(500)  default '' comment '外链地址',
  summary          varchar(1000) default '' comment '摘要',
  content_body     longtext      comment '正文',
  duration_seconds int(11)       default 0 comment '时长（秒）',
  exam_id          bigint(20)    default null comment '关联考试ID',
  is_preview       char(1)       default '0' comment '是否可预览（0否 1是）',
  sort_order       int(4)        default 0 comment '排序值',
  publish_status   char(1)       default '0' comment '发布状态（0草稿 1已发布）',
  view_count       int(11)       default 0 comment '查看次数',
  create_by        varchar(64)   default '' comment '创建者',
  create_time      datetime      comment '创建时间',
  update_by        varchar(64)   default '' comment '更新者',
  update_time      datetime      comment '更新时间',
  remark           varchar(500)  default null comment '备注',
  primary key (content_id),
  key idx_content_course (course_id),
  key idx_content_exam (exam_id),
  key idx_content_publish (publish_status),
  key idx_content_sort (course_id, sort_order, content_id)
) engine=innodb auto_increment=7000 comment='课程内容表';

create table edu_course_enroll (
  enroll_id        bigint(20)   not null auto_increment comment '注册ID',
  course_id        bigint(20)   not null comment '课程ID',
  student_id       bigint(20)   not null comment '学生用户ID',
  enroll_source    char(1)      default '1' comment '注册来源（1学生自主 2教师导入）',
  enroll_status    char(1)      default '1' comment '注册状态（1正常 2退课 3完成）',
  progress_percent decimal(5,2) default 0.00 comment '学习进度',
  last_study_time  datetime     default null comment '最近学习时间',
  finish_time      datetime     default null comment '完成时间',
  create_by        varchar(64)  default '' comment '创建者',
  create_time      datetime     comment '创建时间',
  update_by        varchar(64)  default '' comment '更新者',
  update_time      datetime     comment '更新时间',
  remark           varchar(500) default null comment '备注',
  primary key (enroll_id),
  unique key uk_course_student (course_id, student_id),
  key idx_enroll_student (student_id),
  key idx_enroll_course_status (course_id, enroll_status)
) engine=innodb auto_increment=10000 comment='课程注册表';

create table edu_course_like (
  like_id     bigint(20) not null auto_increment comment '点赞ID',
  course_id   bigint(20) not null comment '课程ID',
  user_id     bigint(20) not null comment '用户ID',
  create_time datetime   comment '创建时间',
  primary key (like_id),
  unique key uk_course_user_like (course_id, user_id),
  key idx_like_user (user_id)
) engine=innodb auto_increment=11000 comment='课程点赞表';

create table edu_course_banner (
  banner_id    bigint(20)   not null auto_increment comment '轮播ID',
  banner_title varchar(200) not null comment '轮播标题',
  banner_image varchar(500) default '' comment '轮播图片',
  course_id    bigint(20)   default null comment '关联课程ID',
  jump_url     varchar(500) default '' comment '跳转地址',
  sort_order   int(4)       default 0 comment '排序值',
  status       char(1)      default '0' comment '状态（0正常 1停用）',
  start_time   datetime     default null comment '开始时间',
  end_time     datetime     default null comment '结束时间',
  create_by    varchar(64)  default '' comment '创建者',
  create_time  datetime     comment '创建时间',
  update_by    varchar(64)  default '' comment '更新者',
  update_time  datetime     comment '更新时间',
  remark       varchar(500) default null comment '备注',
  primary key (banner_id),
  key idx_banner_course (course_id),
  key idx_banner_status (status, sort_order)
) engine=innodb auto_increment=9000 comment='首页课程轮播表';
