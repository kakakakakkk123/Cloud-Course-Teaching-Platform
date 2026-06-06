package com.ruoyi.system.domain.course;

import java.math.BigDecimal;
import java.util.Date;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 课程注册对象 edu_course_enroll
 *
 * @author ruoyi
 */
public class EduCourseEnroll extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 注册ID */
    private Long enrollId;

    /** 课程ID */
    private Long courseId;

    /** 学生用户ID */
    private Long studentId;

    /** 注册来源 */
    private String enrollSource;

    /** 注册状态 */
    private String enrollStatus;

    /** 学习进度 */
    private BigDecimal progressPercent;

    /** 最近学习时间 */
    private Date lastStudyTime;

    /** 完成时间 */
    private Date finishTime;

    public Long getEnrollId()
    {
        return enrollId;
    }

    public void setEnrollId(Long enrollId)
    {
        this.enrollId = enrollId;
    }

    public Long getCourseId()
    {
        return courseId;
    }

    public void setCourseId(Long courseId)
    {
        this.courseId = courseId;
    }

    public Long getStudentId()
    {
        return studentId;
    }

    public void setStudentId(Long studentId)
    {
        this.studentId = studentId;
    }

    public String getEnrollSource()
    {
        return enrollSource;
    }

    public void setEnrollSource(String enrollSource)
    {
        this.enrollSource = enrollSource;
    }

    public String getEnrollStatus()
    {
        return enrollStatus;
    }

    public void setEnrollStatus(String enrollStatus)
    {
        this.enrollStatus = enrollStatus;
    }

    public BigDecimal getProgressPercent()
    {
        return progressPercent;
    }

    public void setProgressPercent(BigDecimal progressPercent)
    {
        this.progressPercent = progressPercent;
    }

    public Date getLastStudyTime()
    {
        return lastStudyTime;
    }

    public void setLastStudyTime(Date lastStudyTime)
    {
        this.lastStudyTime = lastStudyTime;
    }

    public Date getFinishTime()
    {
        return finishTime;
    }

    public void setFinishTime(Date finishTime)
    {
        this.finishTime = finishTime;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("enrollId", getEnrollId())
                .append("courseId", getCourseId())
                .append("studentId", getStudentId())
                .append("enrollSource", getEnrollSource())
                .append("enrollStatus", getEnrollStatus())
                .append("progressPercent", getProgressPercent())
                .append("lastStudyTime", getLastStudyTime())
                .append("finishTime", getFinishTime())
                .append("createBy", getCreateBy())
                .append("createTime", getCreateTime())
                .append("updateBy", getUpdateBy())
                .append("updateTime", getUpdateTime())
                .append("remark", getRemark())
                .toString();
    }
}
