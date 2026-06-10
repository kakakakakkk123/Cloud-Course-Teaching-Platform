-- V13: 试卷组卷方式字段，支持手工选题 / 按题型规则 / 随机组卷
ALTER TABLE edu_paper ADD COLUMN compose_mode char(1) DEFAULT '1' COMMENT '组卷方式：1=手工选题 2=按题型规则 3=随机组卷';
