package com.ruoyi.system.domain.exam;

import java.math.BigDecimal;
import java.util.Date;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 考试记录对象 edu_exam_record
 */
public class EduExamRecord extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long recordId;
    private Long examId;
    private Long paperId;
    private Long courseId;
    private Long studentId;

    @Excel(name = "作答次数")
    private Integer attemptNo;

    @Excel(name = "开始时间", dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;

    @Excel(name = "提交时间", dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date submitTime;

    @Excel(name = "用时(秒)")
    private Integer durationSeconds;

    @Excel(name = "作答状态", readConverterExp = "0=未开始,1=作答中,2=已提交,3=已完成")
    private String recordStatus;

    @Excel(name = "客观分", scale = 2)
    private BigDecimal objectiveScore;

    @Excel(name = "主观分", scale = 2)
    private BigDecimal subjectiveScore;

    @Excel(name = "总分", scale = 2)
    private BigDecimal totalScore;

    @Excel(name = "成绩结果", readConverterExp = "0=未及格,1=及格")
    private String resultStatus;

    @Excel(name = "批改状态", readConverterExp = "0=待批改,1=已完成")
    private String checkedFlag;

    private String studentKeyword;

    @Excel(name = "学生账号")
    private String studentUserName;

    @Excel(name = "学生姓名")
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

    public String getStudentKeyword()
    {
        return studentKeyword;
    }

    public void setStudentKeyword(String studentKeyword)
    {
        this.studentKeyword = studentKeyword;
    }

    public String getStudentUserName()
    {
        return studentUserName;
    }

    public void setStudentUserName(String studentUserName)
    {
        this.studentUserName = studentUserName;
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
