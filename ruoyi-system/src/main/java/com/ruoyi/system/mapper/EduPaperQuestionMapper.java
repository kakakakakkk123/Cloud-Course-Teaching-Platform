package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.exam.EduPaperQuestion;

/**
 * 试卷题目关系数据层
 */
public interface EduPaperQuestionMapper
{
    public List<EduPaperQuestion> selectPaperQuestionList(Long paperId);
}
