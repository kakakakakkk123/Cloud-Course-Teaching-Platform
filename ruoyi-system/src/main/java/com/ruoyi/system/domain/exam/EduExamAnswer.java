package com.ruoyi.system.domain.exam;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 学生答题明细对象 edu_exam_answer
 */
public class EduExamAnswer
{
    private Long answerId;
    private Long recordId;
    private Long examId;
    private Long questionId;
    private String questionType;
    private Integer questionOrder;
    private String standardAnswer;
    private String studentAnswer;
    private String isCorrect;
    private BigDecimal questionScore;
    private BigDecimal actualScore;
    private String teacherComment;
    private Long checkedBy;
    private Date checkedTime;

    public Long getAnswerId()
    {
        return answerId;
    }

    public void setAnswerId(Long answerId)
    {
        this.answerId = answerId;
    }

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

    public Long getCheckedBy()
    {
        return checkedBy;
    }

    public void setCheckedBy(Long checkedBy)
    {
        this.checkedBy = checkedBy;
    }

    public Date getCheckedTime()
    {
        return checkedTime;
    }

    public void setCheckedTime(Date checkedTime)
    {
        this.checkedTime = checkedTime;
    }
}
