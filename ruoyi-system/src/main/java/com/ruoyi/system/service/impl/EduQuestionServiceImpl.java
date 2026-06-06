package com.ruoyi.system.service.impl;

import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.alibaba.fastjson2.JSON;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.exam.EduQuestion;
import com.ruoyi.system.domain.exam.EduQuestionOption;
import com.ruoyi.system.mapper.EduQuestionMapper;
import com.ruoyi.system.service.IEduQuestionService;

/**
 * 试题服务实现
 *
 * @author ruoyi
 */
@Service
public class EduQuestionServiceImpl implements IEduQuestionService
{
    @Autowired
    private EduQuestionMapper questionMapper;

    /**
     * 查询试题
     */
    @Override
    public EduQuestion selectEduQuestionById(Long questionId)
    {
        EduQuestion question = questionMapper.selectEduQuestionById(questionId);
        if (StringUtils.isNotNull(question))
        {
            question.setOptionList(questionMapper.selectOptionListByQuestionId(questionId));
            question.setAnswerText(question.getAnswerJson());
        }
        return question;
    }

    /**
     * 查询试题列表
     */
    @Override
    public List<EduQuestion> selectEduQuestionList(EduQuestion question)
    {
        return questionMapper.selectEduQuestionList(question);
    }

    /**
     * 新增试题
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertEduQuestion(EduQuestion question)
    {
        fillQuestionDefaults(question);
        question.setAnswerJson(buildAnswerJson(question));
        int rows = questionMapper.insertEduQuestion(question);
        syncOptions(question);
        return rows;
    }

    /**
     * 修改试题
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateEduQuestion(EduQuestion question)
    {
        fillQuestionDefaults(question);
        question.setAnswerJson(buildAnswerJson(question));
        int rows = questionMapper.updateEduQuestion(question);
        syncOptions(question);
        return rows;
    }

    /**
     * 删除试题
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteEduQuestionByIds(Long[] questionIds)
    {
        for (Long questionId : questionIds)
        {
            questionMapper.deleteOptionByQuestionId(questionId);
        }
        return questionMapper.deleteEduQuestionByIds(questionIds);
    }

    /**
     * 同步试题选项
     */
    private void syncOptions(EduQuestion question)
    {
        if (StringUtils.isNull(question.getQuestionId()))
        {
            return;
        }
        questionMapper.deleteOptionByQuestionId(question.getQuestionId());
        if (StringUtils.isEmpty(question.getOptionList()))
        {
            return;
        }
        List<EduQuestionOption> optionList = new ArrayList<>();
        int index = 0;
        for (EduQuestionOption option : question.getOptionList())
        {
            if (StringUtils.isEmpty(option.getOptionContent()))
            {
                continue;
            }
            option.setQuestionId(question.getQuestionId());
            option.setSortOrder(index++);
            optionList.add(option);
        }
        if (!optionList.isEmpty())
        {
            questionMapper.batchInsertOption(optionList);
        }
    }

    /**
     * 组装标准答案
     */
    private String buildAnswerJson(EduQuestion question)
    {
        if (StringUtils.isNotEmpty(question.getAnswerText()))
        {
            return question.getAnswerText();
        }
        if (StringUtils.isEmpty(question.getOptionList()))
        {
            return "";
        }
        List<String> answers = new ArrayList<>();
        for (EduQuestionOption option : question.getOptionList())
        {
            if ("1".equals(option.getIsCorrect()))
            {
                answers.add(option.getOptionLabel());
            }
        }
        return JSON.toJSONString(answers);
    }

    /**
     * 填充试题默认值
     */
    private void fillQuestionDefaults(EduQuestion question)
    {
        if (StringUtils.isEmpty(question.getDifficultyLevel()))
        {
            question.setDifficultyLevel("2");
        }
        if (StringUtils.isEmpty(question.getAutoMarking()))
        {
            question.setAutoMarking("1");
        }
        if (StringUtils.isEmpty(question.getStatus()))
        {
            question.setStatus("0");
        }
    }
}
