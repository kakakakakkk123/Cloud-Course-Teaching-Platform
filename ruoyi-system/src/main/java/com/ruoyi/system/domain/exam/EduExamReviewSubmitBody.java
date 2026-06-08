package com.ruoyi.system.domain.exam;

import java.util.List;

/**
 * 教师批改提交体
 */
public class EduExamReviewSubmitBody
{
    private Boolean finalize;
    private List<EduExamReviewAnswerSubmit> answers;

    public Boolean getFinalize()
    {
        return finalize;
    }

    public void setFinalize(Boolean finalize)
    {
        this.finalize = finalize;
    }

    public List<EduExamReviewAnswerSubmit> getAnswers()
    {
        return answers;
    }

    public void setAnswers(List<EduExamReviewAnswerSubmit> answers)
    {
        this.answers = answers;
    }
}
