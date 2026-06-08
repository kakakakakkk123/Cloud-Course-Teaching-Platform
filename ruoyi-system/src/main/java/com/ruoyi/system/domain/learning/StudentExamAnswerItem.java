package com.ruoyi.system.domain.learning;

/**
 * 学生答题提交项
 */
public class StudentExamAnswerItem
{
    private Long questionId;
    private String studentAnswer;

    public Long getQuestionId()
    {
        return questionId;
    }

    public void setQuestionId(Long questionId)
    {
        this.questionId = questionId;
    }

    public String getStudentAnswer()
    {
        return studentAnswer;
    }

    public void setStudentAnswer(String studentAnswer)
    {
        this.studentAnswer = studentAnswer;
    }
}
