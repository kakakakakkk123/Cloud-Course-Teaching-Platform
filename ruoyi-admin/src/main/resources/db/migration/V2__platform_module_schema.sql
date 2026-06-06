
-- Source: sql\quartz.sql
-- ----------------------------
-- 1、存储每一个已配置的 jobDetail 的详细信息
-- ----------------------------
create table if not exists QRTZ_JOB_DETAILS (
    sched_name           varchar(120)    not null            comment '调度名称',
    job_name             varchar(200)    not null            comment '任务名称',
    job_group            varchar(200)    not null            comment '任务组名',
    description          varchar(250)    null                comment '相关介绍',
    job_class_name       varchar(250)    not null            comment '执行任务类名称',
    is_durable           varchar(1)      not null            comment '是否持久化',
    is_nonconcurrent     varchar(1)      not null            comment '是否并发',
    is_update_data       varchar(1)      not null            comment '是否更新数据',
    requests_recovery    varchar(1)      not null            comment '是否接受恢复执行',
    job_data             blob            null                comment '存放持久化job对象',
    primary key (sched_name, job_name, job_group)
) engine=innodb comment = '任务详细信息表';

-- ----------------------------
-- 2、 存储已配置的 Trigger 的信息
-- ----------------------------
create table if not exists QRTZ_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment '触发器的名字',
    trigger_group        varchar(200)    not null            comment '触发器所属组的名字',
    job_name             varchar(200)    not null            comment 'qrtz_job_details表job_name的外键',
    job_group            varchar(200)    not null            comment 'qrtz_job_details表job_group的外键',
    description          varchar(250)    null                comment '相关介绍',
    next_fire_time       bigint(13)      null                comment '上一次触发时间（毫秒）',
    prev_fire_time       bigint(13)      null                comment '下一次触发时间（默认为-1表示不触发）',
    priority             integer         null                comment '优先级',
    trigger_state        varchar(16)     not null            comment '触发器状态',
    trigger_type         varchar(8)      not null            comment '触发器的类型',
    start_time           bigint(13)      not null            comment '开始时间',
    end_time             bigint(13)      null                comment '结束时间',
    calendar_name        varchar(200)    null                comment '日程表名称',
    misfire_instr        smallint(2)     null                comment '补偿执行的策略',
    job_data             blob            null                comment '存放持久化job对象',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, job_name, job_group) references QRTZ_JOB_DETAILS(sched_name, job_name, job_group)
) engine=innodb comment = '触发器详细信息表';

-- ----------------------------
-- 3、 存储简单的 Trigger，包括重复次数，间隔，以及已触发的次数
-- ----------------------------
create table if not exists QRTZ_SIMPLE_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    repeat_count         bigint(7)       not null            comment '重复的次数统计',
    repeat_interval      bigint(12)      not null            comment '重复的间隔时间',
    times_triggered      bigint(10)      not null            comment '已经触发的次数',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = '简单触发器的信息表';

-- ----------------------------
-- 4、 存储 Cron Trigger，包括 Cron 表达式和时区信息
-- ---------------------------- 
create table if not exists QRTZ_CRON_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    cron_expression      varchar(200)    not null            comment 'cron表达式',
    time_zone_id         varchar(80)                         comment '时区',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = 'Cron类型的触发器表';

-- ----------------------------
-- 5、 Trigger 作为 Blob 类型存储(用于 Quartz 用户用 JDBC 创建他们自己定制的 Trigger 类型，JobStore 并不知道如何存储实例的时候)
-- ---------------------------- 
create table if not exists QRTZ_BLOB_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    blob_data            blob            null                comment '存放持久化Trigger对象',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = 'Blob类型的触发器表';

-- ----------------------------
-- 6、 以 Blob 类型存储存放日历信息， quartz可配置一个日历来指定一个时间范围
-- ---------------------------- 
create table if not exists QRTZ_CALENDARS (
    sched_name           varchar(120)    not null            comment '调度名称',
    calendar_name        varchar(200)    not null            comment '日历名称',
    calendar             blob            not null            comment '存放持久化calendar对象',
    primary key (sched_name, calendar_name)
) engine=innodb comment = '日历信息表';

-- ----------------------------
-- 7、 存储已暂停的 Trigger 组的信息
-- ---------------------------- 
create table if not exists QRTZ_PAUSED_TRIGGER_GRPS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    primary key (sched_name, trigger_group)
) engine=innodb comment = '暂停的触发器表';

-- ----------------------------
-- 8、 存储与已触发的 Trigger 相关的状态信息，以及相联 Job 的执行信息
-- ---------------------------- 
create table if not exists QRTZ_FIRED_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    entry_id             varchar(95)     not null            comment '调度器实例id',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    instance_name        varchar(200)    not null            comment '调度器实例名',
    fired_time           bigint(13)      not null            comment '触发的时间',
    sched_time           bigint(13)      not null            comment '定时器制定的时间',
    priority             integer         not null            comment '优先级',
    state                varchar(16)     not null            comment '状态',
    job_name             varchar(200)    null                comment '任务名称',
    job_group            varchar(200)    null                comment '任务组名',
    is_nonconcurrent     varchar(1)      null                comment '是否并发',
    requests_recovery    varchar(1)      null                comment '是否接受恢复执行',
    primary key (sched_name, entry_id)
) engine=innodb comment = '已触发的触发器表';

-- ----------------------------
-- 9、 存储少量的有关 Scheduler 的状态信息，假如是用于集群中，可以看到其他的 Scheduler 实例
-- ---------------------------- 
create table if not exists QRTZ_SCHEDULER_STATE (
    sched_name           varchar(120)    not null            comment '调度名称',
    instance_name        varchar(200)    not null            comment '实例名称',
    last_checkin_time    bigint(13)      not null            comment '上次检查时间',
    checkin_interval     bigint(13)      not null            comment '检查间隔时间',
    primary key (sched_name, instance_name)
) engine=innodb comment = '调度器状态表';

-- ----------------------------
-- 10、 存储程序的悲观锁的信息(假如使用了悲观锁)
-- ---------------------------- 
create table if not exists QRTZ_LOCKS (
    sched_name           varchar(120)    not null            comment '调度名称',
    lock_name            varchar(40)     not null            comment '悲观锁名称',
    primary key (sched_name, lock_name)
) engine=innodb comment = '存储的悲观锁信息表';

-- ----------------------------
-- 11、 Quartz集群实现同步机制的行锁表
-- ---------------------------- 
create table if not exists QRTZ_SIMPROP_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    str_prop_1           varchar(512)    null                comment 'String类型的trigger的第一个参数',
    str_prop_2           varchar(512)    null                comment 'String类型的trigger的第二个参数',
    str_prop_3           varchar(512)    null                comment 'String类型的trigger的第三个参数',
    int_prop_1           int             null                comment 'int类型的trigger的第一个参数',
    int_prop_2           int             null                comment 'int类型的trigger的第二个参数',
    long_prop_1          bigint          null                comment 'long类型的trigger的第一个参数',
    long_prop_2          bigint          null                comment 'long类型的trigger的第二个参数',
    dec_prop_1           numeric(13,4)   null                comment 'decimal类型的trigger的第一个参数',
    dec_prop_2           numeric(13,4)   null                comment 'decimal类型的trigger的第二个参数',
    bool_prop_1          varchar(1)      null                comment 'Boolean类型的trigger的第一个参数',
    bool_prop_2          varchar(1)      null                comment 'Boolean类型的trigger的第二个参数',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = '同步机制的行锁表';

commit;


-- Source: sql\20260605_course_module_schema.sql
-- 课程与首页模块建表脚本
-- 说明：本脚本补齐首页、课程广场、课程详情、我的课程、在线学习依赖的课程表结构。
create table if not exists edu_course_category (
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
create table if not exists edu_course (
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
create table if not exists edu_course_content (
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
create table if not exists edu_course_enroll (
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
create table if not exists edu_course_like (
  like_id     bigint(20) not null auto_increment comment '点赞ID',
  course_id   bigint(20) not null comment '课程ID',
  user_id     bigint(20) not null comment '用户ID',
  create_time datetime   comment '创建时间',
  primary key (like_id),
  unique key uk_course_user_like (course_id, user_id),
  key idx_like_user (user_id)
) engine=innodb auto_increment=11000 comment='课程点赞表';
create table if not exists edu_course_banner (
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


-- Source: sql\20260529_exam_module_schema.sql
-- 考试模块建表脚本
-- 说明：
-- 1. 本脚本用于在线课程教学平台的考试模块第一阶段建设。
-- 2. 设计目标：围绕“题库 -> 试题 -> 试卷 -> 考试 -> 学生作答 -> 成绩统计”形成最小闭环。
-- 3. 本脚本与现有课程模块对齐：
--    - 考试通过 edu_exam.course_id 归属于课程
--    - 课程内容表 edu_course_content.exam_id 可直接挂接到 edu_exam.exam_id
-- 4. 本脚本不包含防作弊、AI 判题、监考等增强能力，后续可按需扩展。

-- ----------------------------
-- 1. 题库表
-- ----------------------------
create table if not exists edu_question_bank (
  bank_id               bigint(20)      not null auto_increment comment '题库ID',
  bank_name             varchar(120)    not null comment '题库名称',
  creator_id            bigint(20)      not null comment '创建教师ID',
  visibility            char(1)         default '0' comment '可见范围（0私有 1公开）',
  tags                  varchar(500)    default '' comment '题库标签，多个使用逗号分隔',
  question_count        int(11)         default 0 comment '题目数量',
  usage_count           int(11)         default 0 comment '试卷使用次数',
  answer_count          int(11)         default 0 comment '学生答题次数',
  correct_rate          decimal(5,2)    default 0.00 comment '题库平均正确率',
  status                char(1)         default '0' comment '状态（0正常 1停用）',
  del_flag              char(1)         default '0' comment '删除标志（0存在 2删除）',
  create_by             varchar(64)     default '' comment '创建者',
  create_time           datetime        comment '创建时间',
  update_by             varchar(64)     default '' comment '更新者',
  update_time           datetime        comment '更新时间',
  remark                varchar(500)    default null comment '备注',
  primary key (bank_id),
  key idx_bank_creator (creator_id),
  key idx_bank_status (status, del_flag)
) engine=innodb auto_increment=10000 comment='题库表';

-- ----------------------------
-- 2. 题库关联课程表
-- 说明：需求中题库可关联 0~多个课程，因此单独拆关系表
-- ----------------------------
create table if not exists edu_question_bank_course (
  id                    bigint(20)      not null auto_increment comment '主键ID',
  bank_id               bigint(20)      not null comment '题库ID',
  course_id             bigint(20)      not null comment '课程ID',
  create_time           datetime        comment '创建时间',
  primary key (id),
  unique key uk_bank_course (bank_id, course_id),
  key idx_bank_course_course (course_id)
) engine=innodb auto_increment=10000 comment='题库关联课程表';

-- ----------------------------
-- 3. 试题表
-- 题型：
-- 1 单选题
-- 2 多选题
-- 3 判断题
-- 4 填空题
-- 5 简答题
-- ----------------------------
create table if not exists edu_question (
  question_id           bigint(20)      not null auto_increment comment '试题ID',
  bank_id               bigint(20)      not null comment '所属题库ID',
  creator_id            bigint(20)      not null comment '创建教师ID',
  question_type         char(1)         not null comment '题型（1单选 2多选 3判断 4填空 5简答）',
  difficulty_level      char(1)         default '2' comment '难度等级（1简单 2中等 3困难）',
  score                 decimal(8,2)    default 0.00 comment '默认分值',
  question_title        text            not null comment '题干',
  answer_json           longtext        comment '标准答案JSON',
  analysis              longtext        comment '答案解析',
  attachment_url        varchar(500)    default '' comment '附件地址',
  auto_marking          char(1)         default '1' comment '是否自动判分（0否 1是）',
  status                char(1)         default '0' comment '状态（0正常 1停用）',
  del_flag              char(1)         default '0' comment '删除标志（0存在 2删除）',
  usage_count           int(11)         default 0 comment '使用次数',
  answer_count          int(11)         default 0 comment '答题次数',
  correct_count         int(11)         default 0 comment '答对次数',
  create_by             varchar(64)     default '' comment '创建者',
  create_time           datetime        comment '创建时间',
  update_by             varchar(64)     default '' comment '更新者',
  update_time           datetime        comment '更新时间',
  remark                varchar(500)    default null comment '备注',
  primary key (question_id),
  key idx_question_bank (bank_id),
  key idx_question_creator (creator_id),
  key idx_question_type (question_type),
  key idx_question_status (status, del_flag)
) engine=innodb auto_increment=10000 comment='试题表';

-- ----------------------------
-- 4. 试题选项表
-- 仅用于单选、多选、判断题等带选项试题
-- ----------------------------
create table if not exists edu_question_option (
  option_id             bigint(20)      not null auto_increment comment '选项ID',
  question_id           bigint(20)      not null comment '试题ID',
  option_label          varchar(20)     not null comment '选项标识，如A/B/C',
  option_content        text            not null comment '选项内容',
  is_correct            char(1)         default '0' comment '是否正确答案（0否 1是）',
  sort_order            int(4)          default 0 comment '排序值',
  primary key (option_id),
  key idx_option_question (question_id)
) engine=innodb auto_increment=10000 comment='试题选项表';

-- ----------------------------
-- 5. 试卷表
-- ----------------------------
create table if not exists edu_paper (
  paper_id              bigint(20)      not null auto_increment comment '试卷ID',
  paper_name            varchar(120)    not null comment '试卷名称',
  creator_id            bigint(20)      not null comment '创建教师ID',
  course_id             bigint(20)      default null comment '所属课程ID',
  bank_id               bigint(20)      default null comment '主要题库ID',
  paper_desc            varchar(1000)   default '' comment '试卷说明',
  total_score           decimal(8,2)    default 0.00 comment '总分',
  question_count        int(11)         default 0 comment '题目数量',
  objective_score       decimal(8,2)    default 0.00 comment '客观题总分',
  subjective_score      decimal(8,2)    default 0.00 comment '主观题总分',
  status                char(1)         default '0' comment '状态（0草稿 1启用 2停用）',
  del_flag              char(1)         default '0' comment '删除标志（0存在 2删除）',
  create_by             varchar(64)     default '' comment '创建者',
  create_time           datetime        comment '创建时间',
  update_by             varchar(64)     default '' comment '更新者',
  update_time           datetime        comment '更新时间',
  remark                varchar(500)    default null comment '备注',
  primary key (paper_id),
  key idx_paper_creator (creator_id),
  key idx_paper_course (course_id),
  key idx_paper_status (status, del_flag)
) engine=innodb auto_increment=10000 comment='试卷表';

-- ----------------------------
-- 6. 试卷题目关系表
-- ----------------------------
create table if not exists edu_paper_question (
  id                    bigint(20)      not null auto_increment comment '主键ID',
  paper_id              bigint(20)      not null comment '试卷ID',
  question_id           bigint(20)      not null comment '试题ID',
  question_order        int(4)          default 0 comment '题目顺序',
  question_score        decimal(8,2)    default 0.00 comment '该题分值',
  question_type         char(1)         not null comment '题型（冗余存储）',
  difficulty_level      char(1)         default '2' comment '难度等级（冗余存储）',
  primary key (id),
  unique key uk_paper_question (paper_id, question_id),
  key idx_paper_question_paper (paper_id),
  key idx_paper_question_question (question_id)
) engine=innodb auto_increment=10000 comment='试卷题目关系表';

-- ----------------------------
-- 7. 考试表
-- 与课程内容表 edu_course_content.exam_id 对应
-- ----------------------------
create table if not exists edu_exam (
  exam_id               bigint(20)      not null auto_increment comment '考试ID',
  exam_name             varchar(120)    not null comment '考试名称',
  paper_id              bigint(20)      not null comment '试卷ID',
  creator_id            bigint(20)      not null comment '创建教师ID',
  course_id             bigint(20)      default null comment '所属课程ID',
  exam_desc             varchar(2000)   default '' comment '考试说明',
  start_time            datetime        default null comment '开始时间',
  end_time              datetime        default null comment '结束时间',
  duration_minutes      int(11)         default 0 comment '考试时长（分钟）',
  pass_score            decimal(8,2)    default 0.00 comment '及格分',
  total_score           decimal(8,2)    default 0.00 comment '总分',
  max_attempt_count     int(11)         default 1 comment '最多考试次数',
  allow_interrupt       char(1)         default '0' comment '是否允许中断（0否 1是）',
  interrupt_count_time  char(1)         default '1' comment '中断是否计时（0否 1是）',
  show_answer_after     char(1)         default '0' comment '交卷后是否展示答案解析（0否 1是）',
  show_score_after      char(1)         default '1' comment '交卷后是否显示成绩（0否 1是）',
  question_shuffle      char(1)         default '0' comment '是否题目乱序（0否 1是）',
  option_shuffle        char(1)         default '0' comment '是否选项乱序（0否 1是）',
  status                char(1)         default '0' comment '状态（0草稿 1已发布 2已结束 3已下线）',
  del_flag              char(1)         default '0' comment '删除标志（0存在 2删除）',
  create_by             varchar(64)     default '' comment '创建者',
  create_time           datetime        comment '创建时间',
  update_by             varchar(64)     default '' comment '更新者',
  update_time           datetime        comment '更新时间',
  remark                varchar(500)    default null comment '备注',
  primary key (exam_id),
  key idx_exam_paper (paper_id),
  key idx_exam_course (course_id),
  key idx_exam_creator (creator_id),
  key idx_exam_time (start_time, end_time),
  key idx_exam_status (status, del_flag)
) engine=innodb auto_increment=10000 comment='考试表';

-- ----------------------------
-- 8. 学生考试记录表
-- ----------------------------
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

-- ----------------------------
-- 9. 学生答题明细表
-- ----------------------------
create table if not exists edu_exam_answer (
  answer_id             bigint(20)      not null auto_increment comment '答题明细ID',
  record_id             bigint(20)      not null comment '考试记录ID',
  exam_id               bigint(20)      not null comment '考试ID',
  question_id           bigint(20)      not null comment '试题ID',
  question_type         char(1)         not null comment '题型',
  question_order        int(4)          default 0 comment '题目顺序',
  standard_answer       longtext        comment '标准答案快照',
  student_answer        longtext        comment '学生答案',
  is_correct            char(1)         default '0' comment '是否答对（0否 1是）',
  question_score        decimal(8,2)    default 0.00 comment '题目总分',
  actual_score          decimal(8,2)    default 0.00 comment '实际得分',
  teacher_comment       varchar(1000)   default '' comment '教师评语',
  checked_by            bigint(20)      default null comment '阅卷教师ID',
  checked_time          datetime        default null comment '阅卷时间',
  primary key (answer_id),
  unique key uk_record_question (record_id, question_id),
  key idx_answer_record (record_id),
  key idx_answer_exam (exam_id),
  key idx_answer_question (question_id)
) engine=innodb auto_increment=10000 comment='学生答题明细表';

-- ----------------------------
-- 10. 说明
-- ----------------------------
-- 后续开发建议：
-- 1. 教师端先做题库、试题、试卷、考试管理四个页面。
-- 2. 学生端考试入口可直接通过课程内容表中的 exam_id 进入。
-- 3. 若后续需要支持更复杂标签、随机组卷、防作弊，可在本结构基础上扩展。
