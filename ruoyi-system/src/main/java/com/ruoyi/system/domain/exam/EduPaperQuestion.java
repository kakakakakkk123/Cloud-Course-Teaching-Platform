package com.ruoyi.system.domain.exam;

import java.math.BigDecimal;

/**
 * 试卷题目关联对象 edu_paper_question
 *
 * @author ruoyi
 */
public class EduPaperQuestion
{
    /** 主键ID */
    private Long id;
    /** 试卷ID */
    private Long paperId;
    /** 题目ID */
    private Long questionId;
    /** 题目排序 */
    private Integer questionOrder;
    /** 题目在试卷中的分值 */
    private BigDecimal questionScore;
    /** 题目类型（冗余，便于统计） */
    private String questionType;
    /** 难度等级（冗余） */
    private String difficultyLevel;

    // ---------- 列表展示字段（不持久化到 edu_paper_question） ----------

    /** 题目标题 */
    private String questionTitle;
    /** 题目类型名称 */
    private String questionTypeName;
    /** 题目原始分值（来自题库） */
    private BigDecimal originalScore;
    /** 题目选项列表 */
    private java.util.List<EduQuestionOption> optionList;

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

    public String getQuestionTitle()
    {
        return questionTitle;
    }

    public void setQuestionTitle(String questionTitle)
    {
        this.questionTitle = questionTitle;
    }

    public String getQuestionTypeName()
    {
        return questionTypeName;
    }

    public void setQuestionTypeName(String questionTypeName)
    {
        this.questionTypeName = questionTypeName;
    }

    public BigDecimal getOriginalScore()
    {
        return originalScore;
    }

    public void setOriginalScore(BigDecimal originalScore)
    {
        this.originalScore = originalScore;
    }

    public java.util.List<EduQuestionOption> getOptionList()
    {
        return optionList;
    }

    public void setOptionList(java.util.List<EduQuestionOption> optionList)
    {
        this.optionList = optionList;
    }
}
