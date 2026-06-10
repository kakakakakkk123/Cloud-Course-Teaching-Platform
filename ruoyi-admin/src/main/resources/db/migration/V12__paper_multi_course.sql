-- V12: 试卷多课程绑定改造
-- 1. 新增 edu_paper_course 关系表，支持一份试卷绑定多个课程
-- 2. 迁移旧的 edu_paper.course_id 单课程数据到新关系表

CREATE TABLE IF NOT EXISTS edu_paper_course (
  id          bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  paper_id    bigint(20) NOT NULL COMMENT '试卷ID',
  course_id   bigint(20) NOT NULL COMMENT '课程ID',
  create_time datetime   COMMENT '创建时间',
  PRIMARY KEY (id),
  UNIQUE KEY uk_paper_course (paper_id, course_id),
  KEY idx_paper_course_course (course_id)
) ENGINE=InnoDB AUTO_INCREMENT=10000 COMMENT='试卷关联课程表';

-- 将旧版单课程绑定迁移到新关系表（已有数据不重复插入）
INSERT IGNORE INTO edu_paper_course (paper_id, course_id, create_time)
SELECT paper_id, course_id, sysdate()
FROM edu_paper
WHERE course_id IS NOT NULL
  AND del_flag = '0';
