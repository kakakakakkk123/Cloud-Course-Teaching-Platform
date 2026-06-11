package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.exam.EduExamRecord;
import com.ruoyi.system.domain.learning.CourseDiscussion;
import com.ruoyi.system.domain.learning.StudentExamQuestionVO;
import com.ruoyi.system.domain.learning.StudentExamVO;
import com.ruoyi.system.domain.learning.StudentExamWrongQuestionVO;
import com.ruoyi.system.domain.learning.StudentLearningOverview;

/**
 * 学生学习数据层
 *
 * @author ruoyi
 */
public interface StudentLearningMapper
{
    public StudentLearningOverview selectLearningOverview(Long studentId);

    public int selectPendingExamCount(Long studentId);

    public List<StudentExamVO> selectStudentExamList(@Param("studentId") Long studentId, @Param("status") String status);

    public EduExamRecord selectRunningExamRecord(@Param("examId") Long examId, @Param("studentId") Long studentId);

    public List<EduExamRecord> selectRunningExamRecords(@Param("examId") Long examId, @Param("studentId") Long studentId);

    public Integer selectExamAttemptCount(@Param("examId") Long examId, @Param("studentId") Long studentId);

    public int insertExamRecord(EduExamRecord record);

    public EduExamRecord selectExamRecordById(@Param("recordId") Long recordId, @Param("studentId") Long studentId);

    public int finishExamRecord(EduExamRecord record);

    public int finishExamReview(EduExamRecord record);

    public List<StudentExamWrongQuestionVO> selectExamWrongQuestionList(@Param("recordId") Long recordId, @Param("studentId") Long studentId);

    public StudentExamVO selectStudentExamByRecordId(@Param("recordId") Long recordId, @Param("studentId") Long studentId);

    public List<StudentExamQuestionVO> selectExamQuestionList(@Param("recordId") Long recordId, @Param("studentId") Long studentId);

    public List<CourseDiscussion> selectCourseDiscussionList(@Param("courseId") Long courseId);

    public List<CourseDiscussion> selectMyCourseDiscussionList(@Param("studentId") Long studentId);

    public int insertCourseDiscussion(CourseDiscussion discussion);
}
