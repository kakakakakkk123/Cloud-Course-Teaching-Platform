package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.exam.EduQuestion;

/**
 * 试题服务层
 *
 * @author ruoyi
 */
public interface IEduQuestionService
{
    public EduQuestion selectEduQuestionById(Long questionId);

    public List<EduQuestion> selectEduQuestionList(EduQuestion question);

    public int insertEduQuestion(EduQuestion question);

    public int updateEduQuestion(EduQuestion question);

    public int deleteEduQuestionByIds(Long[] questionIds);
}
