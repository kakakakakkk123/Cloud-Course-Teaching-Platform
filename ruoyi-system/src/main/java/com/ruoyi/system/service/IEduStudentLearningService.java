package com.ruoyi.system.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.system.domain.exam.EduExamRecord;
import com.ruoyi.system.domain.learning.StudentExamVO;
import com.ruoyi.system.domain.learning.StudentLearningOverview;

/**
 * 学生学习服务层
 *
 * @author ruoyi
 */
public interface IEduStudentLearningService
{
    public StudentLearningOverview selectLearningOverview(Long studentId);

    public List<StudentExamVO> selectStudentExamList(Long studentId, String status);

    public void markContentLearned(Long contentId, Long studentId);

    public EduExamRecord startExam(Long examId, Long studentId);

    public Map<String, Object> selectExamContent(Long recordId, Long studentId);

    public void submitExam(Long recordId, Long studentId);

    public int importExamWrongQuestions(Long recordId, Long studentId);
}
