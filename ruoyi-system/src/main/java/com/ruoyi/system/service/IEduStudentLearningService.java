package com.ruoyi.system.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.system.domain.exam.EduExamRecord;
import com.ruoyi.system.domain.learning.CourseDiscussion;
import com.ruoyi.system.domain.learning.StudentExamAnswerBody;
import com.ruoyi.system.domain.learning.StudentExamPaperVO;
import com.ruoyi.system.domain.learning.StudentExamResultVO;
import com.ruoyi.system.domain.learning.StudentExamVO;
import com.ruoyi.system.domain.learning.StudentLearningNoteBody;
import com.ruoyi.system.domain.learning.StudentLearningOverview;

/**
 * 学生学习服务层
 *
 * @author ruoyi
 */
public interface IEduStudentLearningService
{
    public StudentLearningOverview selectLearningOverview(Long studentId);

    public List<Map<String, Object>> selectLearningNoteList(Long studentId);

    public Map<String, Object> saveContentLearningNote(Long contentId, Long studentId, StudentLearningNoteBody body);

    public void deleteContentLearningNote(Long contentId, Long studentId);

    public List<StudentExamVO> selectStudentExamList(Long studentId, String status);

    public void markContentLearned(Long contentId, Long studentId);

    public EduExamRecord startExam(Long examId, Long studentId);

    public Map<String, Object> selectExamContent(Long recordId, Long studentId);

    public StudentExamPaperVO selectStudentExamPaper(Long recordId, Long studentId);

    public void saveExamAnswers(Long recordId, Long studentId, StudentExamAnswerBody body);

    public void submitExam(Long recordId, Long studentId);

    public int importExamWrongQuestions(Long recordId, Long studentId);

    public StudentExamResultVO selectStudentExamResult(Long recordId, Long studentId);

    public List<CourseDiscussion> selectCourseDiscussionList(Long courseId, Long studentId);

    public List<CourseDiscussion> selectMyCourseDiscussionList(Long studentId);

    public CourseDiscussion addCourseDiscussion(Long courseId, Long studentId, String content);
}
