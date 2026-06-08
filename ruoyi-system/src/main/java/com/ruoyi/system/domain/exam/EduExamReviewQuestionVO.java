package com.ruoyi.system.domain.exam;

import java.math.BigDecimal;
import java.util.List;

/**
 * 教师批改题目视图
 */
public class EduExamReviewQuestionVO
{
    private Long answerId;
    private Long questionId;
    private String questionType;
    private Integer questionOrder;
    private String questionTitle;
    private String attachmentUrl;
    private String standardAnswer;
    private String studentAnswer;
    private String analysisSnapshot;
    private String isCorrect;
    private BigDecimal questionScore;
    private BigDecimal actualScore;
    private String teacherComment;
    private String autoMarking;
    private List<EduQuestionOption> optionList;

    public Long getAnswerId()
    {
        return answerId;
    }

    public void setAnswerId(Long answerId)
    {
        this.answerId = answerId;
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

    public String getStandardAnswer()
    {
        return standardAnswer;
    }

    public void setStandardAnswer(String standardAnswer)
    {
        this.standardAnswer = standardAnswer;
    }

    public String getStudentAnswer()
    {
        return studentAnswer;
    }

    public void setStudentAnswer(String studentAnswer)
    {
        this.studentAnswer = studentAnswer;
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

    public BigDecimal getQuestionScore()
    {
        return questionScore;
    }

    public void setQuestionScore(BigDecimal questionScore)
    {
        this.questionScore = questionScore;
    }

    public BigDecimal getActualScore()
    {
        return actualScore;
    }

    public void setActualScore(BigDecimal actualScore)
    {
        this.actualScore = actualScore;
    }

    public String getTeacherComment()
    {
        return teacherComment;
    }

    public void setTeacherComment(String teacherComment)
    {
        this.teacherComment = teacherComment;
    }

    public String getAutoMarking()
    {
        return autoMarking;
    }

    public void setAutoMarking(String autoMarking)
    {
        this.autoMarking = autoMarking;
    }

    public List<EduQuestionOption> getOptionList()
    {
        return optionList;
    }

    public void setOptionList(List<EduQuestionOption> optionList)
    {
        this.optionList = optionList;
    }
}
