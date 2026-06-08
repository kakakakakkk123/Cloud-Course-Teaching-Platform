package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.exam.EduExamAnswer;
import com.ruoyi.system.domain.exam.EduExamQuestion;

/**
 * 考试运行时快照与答题数据层
 */
public interface EduExamRuntimeMapper
{
    public List<EduExamQuestion> selectExamQuestionList(Long examId);

    public int countExamQuestion(Long examId);

    public int batchInsertExamQuestion(List<EduExamQuestion> list);

    public List<EduExamAnswer> selectExamAnswerListByRecordId(Long recordId);

    public List<EduExamAnswer> selectExamAnswerListByRecordIds(@Param("recordIds") List<Long> recordIds);

    public EduExamAnswer selectExamAnswerById(Long answerId);

    public int batchInsertExamAnswer(List<EduExamAnswer> list);

    public int updateStudentAnswer(EduExamAnswer answer);
}
