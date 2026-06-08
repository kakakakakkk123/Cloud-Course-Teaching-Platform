package com.ruoyi.system.domain.learning;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * 学生考试结果页视图
 */
public class StudentExamResultVO
{
    private Long recordId;
    private Long examId;
    private String examName;
    private String courseName;
    private String paperName;
    private Date recordStartTime;
    private Date submitTime;
    private Integer durationSeconds;
    private String recordStatus;
    private String checkedFlag;
    private String resultStatus;
    private String showAnswerAfterSubmit;
    private String showScoreAfterSubmit;
    private BigDecimal objectiveScore;
    private BigDecimal subjectiveScore;
    private BigDecimal totalScore;
    private BigDecimal passScore;
    private List<StudentExamQuestionVO> questionList;

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

    public String getExamName()
    {
        return examName;
    }

    public void setExamName(String examName)
    {
        this.examName = examName;
    }

    public String getCourseName()
    {
        return courseName;
    }

    public void setCourseName(String courseName)
    {
        this.courseName = courseName;
    }

    public String getPaperName()
    {
        return paperName;
    }

    public void setPaperName(String paperName)
    {
        this.paperName = paperName;
    }

    public Date getRecordStartTime()
    {
        return recordStartTime;
    }

    public void setRecordStartTime(Date recordStartTime)
    {
        this.recordStartTime = recordStartTime;
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

    public String getCheckedFlag()
    {
        return checkedFlag;
    }

    public void setCheckedFlag(String checkedFlag)
    {
        this.checkedFlag = checkedFlag;
    }

    public String getResultStatus()
    {
        return resultStatus;
    }

    public void setResultStatus(String resultStatus)
    {
        this.resultStatus = resultStatus;
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

    public BigDecimal getPassScore()
    {
        return passScore;
    }

    public void setPassScore(BigDecimal passScore)
    {
        this.passScore = passScore;
    }

    public List<StudentExamQuestionVO> getQuestionList()
    {
        return questionList;
    }

    public void setQuestionList(List<StudentExamQuestionVO> questionList)
    {
        this.questionList = questionList;
    }
}
