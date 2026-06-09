SET @schema_name = DATABASE();

SET @exam_question_index_exists = (
  SELECT COUNT(1)
  FROM information_schema.statistics
  WHERE table_schema = @schema_name
    AND table_name = 'edu_exam_question'
    AND index_name = 'uk_exam_question'
);

SET @exam_question_sql = IF(
  @exam_question_index_exists = 0,
  'ALTER TABLE edu_exam_question ADD UNIQUE KEY uk_exam_question (exam_id, question_id)',
  'SELECT 1'
);

PREPARE stmt_exam_question FROM @exam_question_sql;
EXECUTE stmt_exam_question;
DEALLOCATE PREPARE stmt_exam_question;

SET @exam_answer_index_exists = (
  SELECT COUNT(1)
  FROM information_schema.statistics
  WHERE table_schema = @schema_name
    AND table_name = 'edu_exam_answer'
    AND index_name = 'uk_exam_answer_record_question'
);

SET @exam_answer_sql = IF(
  @exam_answer_index_exists = 0,
  'ALTER TABLE edu_exam_answer ADD UNIQUE KEY uk_exam_answer_record_question (record_id, question_id)',
  'SELECT 1'
);

PREPARE stmt_exam_answer FROM @exam_answer_sql;
EXECUTE stmt_exam_answer;
DEALLOCATE PREPARE stmt_exam_answer;
