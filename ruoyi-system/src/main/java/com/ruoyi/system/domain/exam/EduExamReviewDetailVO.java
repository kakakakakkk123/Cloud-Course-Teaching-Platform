package com.ruoyi.system.domain.exam;

import java.math.BigDecimal;
import java.util.List;

/**
 * 教师批改详情视图
 */
public class EduExamReviewDetailVO
{
    private Long recordId;
    private Long examId;
    private String recordStatus;
    private String checkedFlag;
    private BigDecimal objectiveScore;
    private BigDecimal subjectiveScore;
    private BigDecimal totalScore;
    private List<EduExamReviewQuestionVO> questionList;

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

    public List<EduExamReviewQuestionVO> getQuestionList()
    {
        return questionList;
    }

    public void setQuestionList(List<EduExamReviewQuestionVO> questionList)
    {
        this.questionList = questionList;
    }
}
