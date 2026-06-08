package com.ruoyi.system.domain.exam;

import java.math.BigDecimal;

/**
 * 教师批改提交项
 */
public class EduExamReviewAnswerSubmit
{
    private Long answerId;
    private BigDecimal actualScore;
    private String teacherComment;

    public Long getAnswerId()
    {
        return answerId;
    }

    public void setAnswerId(Long answerId)
    {
        this.answerId = answerId;
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
}
