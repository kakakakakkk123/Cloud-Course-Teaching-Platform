package com.ruoyi.system.domain.exam;

import java.math.BigDecimal;

/**
 * 试卷题目关系对象 edu_paper_question
 */
public class EduPaperQuestion
{
    private Long id;
    private Long paperId;
    private Long questionId;
    private Integer questionOrder;
    private BigDecimal questionScore;
    private String questionType;
    private String difficultyLevel;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getPaperId()
    {
        return paperId;
    }

    public void setPaperId(Long paperId)
    {
        this.paperId = paperId;
    }

    public Long getQuestionId()
    {
        return questionId;
    }

    public void setQuestionId(Long questionId)
    {
        this.questionId = questionId;
    }

    public Integer getQuestionOrder()
    {
        return questionOrder;
    }

    public void setQuestionOrder(Integer questionOrder)
    {
        this.questionOrder = questionOrder;
    }

    public BigDecimal getQuestionScore()
    {
        return questionScore;
    }

    public void setQuestionScore(BigDecimal questionScore)
    {
        this.questionScore = questionScore;
    }

    public String getQuestionType()
    {
        return questionType;
    }

    public void setQuestionType(String questionType)
    {
        this.questionType = questionType;
    }

    public String getDifficultyLevel()
    {
        return difficultyLevel;
    }

    public void setDifficultyLevel(String difficultyLevel)
    {
        this.difficultyLevel = difficultyLevel;
    }
}
