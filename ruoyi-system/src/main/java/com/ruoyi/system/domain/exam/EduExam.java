package com.ruoyi.system.domain.exam;

import java.math.BigDecimal;
import java.util.Date;
import jakarta.validation.constraints.NotBlank;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 考试对象 edu_exam
 *
 * @author ruoyi
 */
public class EduExam extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long examId;
    private String examName;
    private Long paperId;
    private Long creatorId;
    private Long courseId;
    private String examNotice;
    private Date startTime;
    private Date endTime;
    private Integer durationMinutes;
    private BigDecimal passScore;
    private BigDecimal totalScore;
    private Integer maxAttemptCount;
    private String allowInterrupt;
    private String interruptKeepTiming;
    private String showAnswerAfterSubmit;
    private String showScoreAfterSubmit;
    private String questionShuffle;
    private String optionShuffle;
    private String status;
    private String delFlag;
    private String paperName;
    private String courseName;
    private String syncCourseContent;

    /** 关联课程ID列表（新版多课程绑定） */
    private List<Long> courseIds;
    /** 多课程名称，逗号分隔，用于列表展示 */
    private String courseNames;

    public Long getExamId()
    {
        return examId;
    }

    public void setExamId(Long examId)
    {
        this.examId = examId;
    }

    @NotBlank(message = "考试名称不能为空")
    public String getExamName()
    {
        return examName;
    }

    public void setExamName(String examName)
    {
        this.examName = examName;
    }

    public Long getPaperId()
    {
        return paperId;
    }

    public void setPaperId(Long paperId)
    {
        this.paperId = paperId;
    }

    public Long getCreatorId()
    {
        return creatorId;
    }

    public void setCreatorId(Long creatorId)
    {
        this.creatorId = creatorId;
    }

    public Long getCourseId()
    {
        return courseId;
    }

    public void setCourseId(Long courseId)
    {
        this.courseId = courseId;
    }

    public String getExamNotice()
    {
        return examNotice;
    }

    public void setExamNotice(String examNotice)
    {
        this.examNotice = examNotice;
    }

    public Date getStartTime()
    {
        return startTime;
    }

    public void setStartTime(Date startTime)
    {
        this.startTime = startTime;
    }

    public Date getEndTime()
    {
        return endTime;
    }

    public void setEndTime(Date endTime)
    {
        this.endTime = endTime;
    }

    public Integer getDurationMinutes()
    {
        return durationMinutes;
    }

    public void setDurationMinutes(Integer durationMinutes)
    {
        this.durationMinutes = durationMinutes;
    }

    public BigDecimal getPassScore()
    {
        return passScore;
    }

    public void setPassScore(BigDecimal passScore)
    {
        this.passScore = passScore;
    }

    public BigDecimal getTotalScore()
    {
        return totalScore;
    }

    public void setTotalScore(BigDecimal totalScore)
    {
        this.totalScore = totalScore;
    }

    public Integer getMaxAttemptCount()
    {
        return maxAttemptCount;
    }

    public void setMaxAttemptCount(Integer maxAttemptCount)
    {
        this.maxAttemptCount = maxAttemptCount;
    }

    public String getAllowInterrupt()
    {
        return allowInterrupt;
    }

    public void setAllowInterrupt(String allowInterrupt)
    {
        this.allowInterrupt = allowInterrupt;
    }

    public String getInterruptKeepTiming()
    {
        return interruptKeepTiming;
    }

    public void setInterruptKeepTiming(String interruptKeepTiming)
    {
        this.interruptKeepTiming = interruptKeepTiming;
    }

    public String getShowAnswerAfterSubmit()
    {
        return showAnswerAfterSubmit;
    }

    public void setShowAnswerAfterSubmit(String showAnswerAfterSubmit)
    {
        this.showAnswerAfterSubmit = showAnswerAfterSubmit;
    }

    public String getShowScoreAfterSubmit()
    {
        return showScoreAfterSubmit;
    }

    public void setShowScoreAfterSubmit(String showScoreAfterSubmit)
    {
        this.showScoreAfterSubmit = showScoreAfterSubmit;
    }

    public String getQuestionShuffle()
    {
        return questionShuffle;
    }

    public void setQuestionShuffle(String questionShuffle)
    {
        this.questionShuffle = questionShuffle;
    }

    public String getOptionShuffle()
    {
        return optionShuffle;
    }

    public void setOptionShuffle(String optionShuffle)
    {
        this.optionShuffle = optionShuffle;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getDelFlag()
    {
        return delFlag;
    }

    public void setDelFlag(String delFlag)
    {
        this.delFlag = delFlag;
    }

    public String getPaperName()
    {
        return paperName;
    }

    public void setPaperName(String paperName)
    {
        this.paperName = paperName;
    }

    public String getCourseName()
    {
        return courseName;
    }

    public void setCourseName(String courseName)
    {
        this.courseName = courseName;
    }

    public String getSyncCourseContent()
    {
        return syncCourseContent;
    }

    public void setSyncCourseContent(String syncCourseContent)
    {
        this.syncCourseContent = syncCourseContent;
    }

    public List<Long> getCourseIds()
    {
        return courseIds;
    }

    public void setCourseIds(List<Long> courseIds)
    {
        this.courseIds = courseIds;
    }

    public String getCourseNames()
    {
        return courseNames;
    }

    public void setCourseNames(String courseNames)
    {
        this.courseNames = courseNames;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("examId", getExamId())
                .append("examName", getExamName())
                .append("paperId", getPaperId())
                .append("creatorId", getCreatorId())
                .append("courseId", getCourseId())
                .append("examNotice", getExamNotice())
                .append("startTime", getStartTime())
                .append("endTime", getEndTime())
                .append("durationMinutes", getDurationMinutes())
                .append("passScore", getPassScore())
                .append("totalScore", getTotalScore())
                .append("maxAttemptCount", getMaxAttemptCount())
                .append("allowInterrupt", getAllowInterrupt())
                .append("interruptKeepTiming", getInterruptKeepTiming())
                .append("showAnswerAfterSubmit", getShowAnswerAfterSubmit())
                .append("showScoreAfterSubmit", getShowScoreAfterSubmit())
                .append("questionShuffle", getQuestionShuffle())
                .append("optionShuffle", getOptionShuffle())
                .append("status", getStatus())
                .append("delFlag", getDelFlag())
                .append("createBy", getCreateBy())
                .append("createTime", getCreateTime())
                .append("updateBy", getUpdateBy())
                .append("updateTime", getUpdateTime())
                .append("remark", getRemark())
                .toString();
    }
}
