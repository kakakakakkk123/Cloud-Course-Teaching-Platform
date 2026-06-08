package com.ruoyi.system.domain.learning;

import java.util.List;

/**
 * 学生保存答题请求
 */
public class StudentExamAnswerBody
{
    private List<StudentExamAnswerItem> answers;

    public List<StudentExamAnswerItem> getAnswers()
    {
        return answers;
    }

    public void setAnswers(List<StudentExamAnswerItem> answers)
    {
        this.answers = answers;
    }
}
