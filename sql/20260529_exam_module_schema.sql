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
drop table if exists edu_question_bank;
create table edu_question_bank (
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
drop table if exists edu_question_bank_course;
create table edu_question_bank_course (
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
drop table if exists edu_question;
create table edu_question (
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
drop table if exists edu_question_option;
create table edu_question_option (
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
drop table if exists edu_paper;
create table edu_paper (
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
drop table if exists edu_paper_question;
create table edu_paper_question (
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
drop table if exists edu_exam;
create table edu_exam (
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
drop table if exists edu_exam_record;
create table edu_exam_record (
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
drop table if exists edu_exam_answer;
create table edu_exam_answer (
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
