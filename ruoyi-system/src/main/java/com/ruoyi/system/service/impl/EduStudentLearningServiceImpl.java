package com.ruoyi.system.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.course.EduCourseContent;
import com.ruoyi.system.domain.course.EduCourseEnroll;
import com.ruoyi.system.domain.exam.EduExam;
import com.ruoyi.system.domain.exam.EduExamRecord;
import com.ruoyi.system.domain.learning.StudentExamVO;
import com.ruoyi.system.domain.learning.StudentLearningOverview;
import com.ruoyi.system.mapper.EduCourseContentMapper;
import com.ruoyi.system.mapper.EduCourseEnrollMapper;
import com.ruoyi.system.mapper.EduExamMapper;
import com.ruoyi.system.mapper.StudentLearningMapper;
import com.ruoyi.system.service.IEduStudentLearningService;

/**
 * 学生学习服务实现
 *
 * @author ruoyi
 */
@Service
public class EduStudentLearningServiceImpl implements IEduStudentLearningService
{
    @Autowired
    private StudentLearningMapper studentLearningMapper;

    @Autowired
    private EduCourseContentMapper courseContentMapper;

    @Autowired
    private EduCourseEnrollMapper courseEnrollMapper;

    @Autowired
    private EduExamMapper examMapper;

    /**
     * 查询学习概览
     */
    @Override
    public StudentLearningOverview selectLearningOverview(Long studentId)
    {
        StudentLearningOverview overview = studentLearningMapper.selectLearningOverview(studentId);
        if (overview == null)
        {
            overview = new StudentLearningOverview();
        }
        overview.setPendingExamCount(studentLearningMapper.selectPendingExamCount(studentId));
        return overview;
    }

    /**
     * 查询学生考试列表
     */
    @Override
    public List<StudentExamVO> selectStudentExamList(Long studentId, String status)
    {
        return studentLearningMapper.selectStudentExamList(studentId, status);
    }

    /**
     * 标记课程内容已学习
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void markContentLearned(Long contentId, Long studentId)
    {
        EduCourseContent content = courseContentMapper.selectPublishedContentById(contentId);
        if (StringUtils.isNull(content))
        {
            throw new ServiceException("课程内容不存在或尚未发布");
        }
        EduCourseEnroll enroll = courseEnrollMapper.selectEduCourseEnroll(content.getCourseId(), studentId);
        if (StringUtils.isNull(enroll))
        {
            throw new ServiceException("请先注册该课程再开始学习");
        }

        int totalCount = courseContentMapper.countPublishedContentByCourseId(content.getCourseId());
        if (totalCount <= 0)
        {
            return;
        }
        int learnedPosition = courseContentMapper.countLearnedContentPosition(content);
        BigDecimal progress = BigDecimal.valueOf(learnedPosition)
                .multiply(BigDecimal.valueOf(100))
                .divide(BigDecimal.valueOf(totalCount), 2, RoundingMode.HALF_UP);
        courseEnrollMapper.updateLearningProgress(content.getCourseId(), studentId, progress);
    }

    /**
     * 开始考试
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public EduExamRecord startExam(Long examId, Long studentId)
    {
        EduExam exam = examMapper.selectEduExamById(examId);
        if (StringUtils.isNull(exam) || !"1".equals(exam.getStatus()))
        {
            throw new ServiceException("考试不存在或尚未发布");
        }
        validateExamTime(exam);
        ensureStudentEnrolled(exam.getCourseId(), studentId);

        EduExamRecord runningRecord = studentLearningMapper.selectRunningExamRecord(examId, studentId);
        if (runningRecord != null)
        {
            return runningRecord;
        }

        int attemptCount = defaultInt(studentLearningMapper.selectExamAttemptCount(examId, studentId));
        int maxAttemptCount = exam.getMaxAttemptCount() == null || exam.getMaxAttemptCount() <= 0 ? 1 : exam.getMaxAttemptCount();
        if (attemptCount >= maxAttemptCount)
        {
            throw new ServiceException("已达到本场考试最大参加次数");
        }

        EduExamRecord record = new EduExamRecord();
        record.setExamId(exam.getExamId());
        record.setPaperId(exam.getPaperId());
        record.setCourseId(exam.getCourseId());
        record.setStudentId(studentId);
        record.setAttemptNo(attemptCount + 1);
        studentLearningMapper.insertExamRecord(record);
        return record;
    }

    /**
     * 提交考试
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void submitExam(Long recordId, Long studentId)
    {
        if (studentLearningMapper.submitExamRecord(recordId, studentId) <= 0)
        {
            throw new ServiceException("考试记录不存在或已提交");
        }
    }

    private void validateExamTime(EduExam exam)
    {
        Date now = new Date();
        if (exam.getStartTime() != null && now.before(exam.getStartTime()))
        {
            throw new ServiceException("考试尚未开始");
        }
        if (exam.getEndTime() != null && now.after(exam.getEndTime()))
        {
            throw new ServiceException("考试已结束");
        }
    }

    private void ensureStudentEnrolled(Long courseId, Long studentId)
    {
        if (courseId == null)
        {
            return;
        }
        if (courseEnrollMapper.selectEduCourseEnroll(courseId, studentId) == null)
        {
            throw new ServiceException("请先注册该课程再参加考试");
        }
    }

    private int defaultInt(Integer value)
    {
        return value == null ? 0 : value;
    }
}
