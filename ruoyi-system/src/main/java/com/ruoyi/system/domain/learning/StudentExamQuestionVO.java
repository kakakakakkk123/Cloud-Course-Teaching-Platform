package com.ruoyi.system.domain.learning;

import java.math.BigDecimal;
import java.util.List;
import com.ruoyi.system.domain.exam.EduQuestionOption;

/**
 * 学生答题页题目视图
 */
public class StudentExamQuestionVO
{
    private Long questionId;
    private String questionType;
    private Integer questionOrder;
    private BigDecimal questionScore;
    private String questionTitle;
    private String attachmentUrl;
    private List<EduQuestionOption> optionList;
    private String studentAnswer;
    private String standardAnswer;
    private String analysisSnapshot;
    private String isCorrect;
    private BigDecimal actualScore;

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

    public String getQuestionTitle()
    {
        return questionTitle;
    }

    public void setQuestionTitle(String questionTitle)
    {
        this.questionTitle = questionTitle;
    }

    public String getAttachmentUrl()
    {
        return attachmentUrl;
    }

    public void setAttachmentUrl(String attachmentUrl)
    {
        this.attachmentUrl = attachmentUrl;
    }

    public List<EduQuestionOption> getOptionList()
    {
        return optionList;
    }

    public void setOptionList(List<EduQuestionOption> optionList)
    {
        this.optionList = optionList;
    }

    public String getStudentAnswer()
    {
        return studentAnswer;
    }

    public void setStudentAnswer(String studentAnswer)
    {
        this.studentAnswer = studentAnswer;
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

    public String getIsCorrect()
    {
        return isCorrect;
    }

    public void setIsCorrect(String isCorrect)
    {
        this.isCorrect = isCorrect;
    }

    public BigDecimal getActualScore()
    {
        return actualScore;
    }

    public void setActualScore(BigDecimal actualScore)
    {
        this.actualScore = actualScore;
    }
}
