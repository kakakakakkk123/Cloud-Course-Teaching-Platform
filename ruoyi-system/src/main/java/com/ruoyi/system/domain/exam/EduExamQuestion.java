package com.ruoyi.system.domain.exam;

import java.math.BigDecimal;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 考试题目快照对象 edu_exam_question
 */
public class EduExamQuestion extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long examId;
    private Long paperId;
    private Long questionId;
    private String questionType;
    private Integer questionOrder;
    private BigDecimal questionScore;
    private String difficultyLevel;
    private String questionTitle;
    private String optionSnapshot;
    private String standardAnswer;
    private String analysisSnapshot;
    private String attachmentUrl;
    private String autoMarking;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
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

    public Long getQuestionId()
    {
        return questionId;
    }

    public void setQuestionId(Long questionId)
    {
        this.questionId = questionId;
    }

    public String getQuestionType()
    {
        return questionType;
    }

    public void setQuestionType(String questionType)
    {
        this.questionType = questionType;
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

    public String getOptionSnapshot()
    {
        return optionSnapshot;
    }

    public void setOptionSnapshot(String optionSnapshot)
    {
        this.optionSnapshot = optionSnapshot;
    }

    public String getStandardAnswer()
    {
        return standardAnswer;
    }

    public void setStandardAnswer(String standardAnswer)
    {
        this.standardAnswer = standardAnswer;
    }

    public String getAnalysisSnapshot()
    {
        return analysisSnapshot;
    }

    public void setAnalysisSnapshot(String analysisSnapshot)
    {
        this.analysisSnapshot = analysisSnapshot;
    }

    public String getAttachmentUrl()
    {
        return attachmentUrl;
    }

    public void setAttachmentUrl(String attachmentUrl)
    {
        this.attachmentUrl = attachmentUrl;
    }

    public String getAutoMarking()
    {
        return autoMarking;
    }

    public void setAutoMarking(String autoMarking)
    {
        this.autoMarking = autoMarking;
    }
}
