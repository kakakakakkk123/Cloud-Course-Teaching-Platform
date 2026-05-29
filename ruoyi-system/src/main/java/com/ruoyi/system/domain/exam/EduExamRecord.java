package com.ruoyi.system.domain.exam;

import java.math.BigDecimal;
import java.util.Date;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 考试记录对象 edu_exam_record
 *
 * @author ruoyi
 */
public class EduExamRecord extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long recordId;
    private Long examId;
    private Long paperId;
    private Long courseId;
    private Long studentId;
    private Integer attemptNo;
    private Date startTime;
    private Date submitTime;
    private Integer durationSeconds;
    private String recordStatus;
    private BigDecimal objectiveScore;
    private BigDecimal subjectiveScore;
    private BigDecimal totalScore;
    private String resultStatus;
    private String checkedFlag;
    private String studentKeyword;
    private String studentUserName;
    private String studentName;

    public Long getRecordId()
    {
        return recordId;
    }

    public void setRecordId(Long recordId)
    {
        this.recordId = recordId;
    }

    public Long getExamId()
    {
        return examId;
    }

    public void setExamId(Long examId)
    {
        this.examId = examId;
    }

    public Long getPaperId()
    {
        return paperId;
    }

    public void setPaperId(Long paperId)
    {
        this.paperId = paperId;
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

    public Integer getAttemptNo()
    {
        return attemptNo;
    }

    public void setAttemptNo(Integer attemptNo)
    {
        this.attemptNo = attemptNo;
    }

    public Date getStartTime()
    {
        return startTime;
    }

    public void setStartTime(Date startTime)
    {
        this.startTime = startTime;
    }

    public Date getSubmitTime()
    {
        return submitTime;
    }

    public void setSubmitTime(Date submitTime)
    {
        this.submitTime = submitTime;
    }

    public Integer getDurationSeconds()
    {
        return durationSeconds;
    }

    public void setDurationSeconds(Integer durationSeconds)
    {
        this.durationSeconds = durationSeconds;
    }

    public String getRecordStatus()
    {
        return recordStatus;
    }

    public void setRecordStatus(String recordStatus)
    {
        this.recordStatus = recordStatus;
    }

    public BigDecimal getObjectiveScore()
    {
        return objectiveScore;
    }

    public void setObjectiveScore(BigDecimal objectiveScore)
    {
        this.objectiveScore = objectiveScore;
    }

    public BigDecimal getSubjectiveScore()
    {
        return subjectiveScore;
    }

    public void setSubjectiveScore(BigDecimal subjectiveScore)
    {
        this.subjectiveScore = subjectiveScore;
    }

    public BigDecimal getTotalScore()
    {
        return totalScore;
    }

    public void setTotalScore(BigDecimal totalScore)
    {
        this.totalScore = totalScore;
    }

    public String getResultStatus()
    {
        return resultStatus;
    }

    public void setResultStatus(String resultStatus)
    {
        this.resultStatus = resultStatus;
    }

    public String getCheckedFlag()
    {
        return checkedFlag;
    }

    public void setCheckedFlag(String checkedFlag)
    {
        this.checkedFlag = checkedFlag;
    }

    public String getStudentUserName()
    {
        return studentUserName;
    }

    public void setStudentUserName(String studentUserName)
    {
        this.studentUserName = studentUserName;
    }

    public String getStudentKeyword()
    {
        return studentKeyword;
    }

    public void setStudentKeyword(String studentKeyword)
    {
        this.studentKeyword = studentKeyword;
    }

    public String getStudentName()
    {
        return studentName;
    }

    public void setStudentName(String studentName)
    {
        this.studentName = studentName;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("recordId", getRecordId())
                .append("examId", getExamId())
                .append("paperId", getPaperId())
                .append("courseId", getCourseId())
                .append("studentId", getStudentId())
                .append("attemptNo", getAttemptNo())
                .append("startTime", getStartTime())
                .append("submitTime", getSubmitTime())
                .append("durationSeconds", getDurationSeconds())
                .append("recordStatus", getRecordStatus())
                .append("objectiveScore", getObjectiveScore())
                .append("subjectiveScore", getSubjectiveScore())
                .append("totalScore", getTotalScore())
                .append("resultStatus", getResultStatus())
                .append("checkedFlag", getCheckedFlag())
                .toString();
    }
}
