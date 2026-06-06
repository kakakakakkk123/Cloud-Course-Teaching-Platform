package com.ruoyi.system.domain.learning;

import java.io.Serializable;

/**
 * 学生学习概览
 *
 * @author ruoyi
 */
public class StudentLearningOverview implements Serializable
{
    private static final long serialVersionUID = 1L;

    private Integer enrolledCourseCount;

    private Integer studyingCourseCount;

    private Integer completedCourseCount;

    private Integer pendingExamCount;

    public Integer getEnrolledCourseCount()
    {
        return enrolledCourseCount;
    }

    public void setEnrolledCourseCount(Integer enrolledCourseCount)
    {
        this.enrolledCourseCount = enrolledCourseCount;
    }

    public Integer getStudyingCourseCount()
    {
        return studyingCourseCount;
    }

    public void setStudyingCourseCount(Integer studyingCourseCount)
    {
        this.studyingCourseCount = studyingCourseCount;
    }

    public Integer getCompletedCourseCount()
    {
        return completedCourseCount;
    }

    public void setCompletedCourseCount(Integer completedCourseCount)
    {
        this.completedCourseCount = completedCourseCount;
    }

    public Integer getPendingExamCount()
    {
        return pendingExamCount;
    }

    public void setPendingExamCount(Integer pendingExamCount)
    {
        this.pendingExamCount = pendingExamCount;
    }
}
