package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.exam.EduExam;
import com.ruoyi.system.mapper.EduExamMapper;
import com.ruoyi.system.service.IEduExamService;

/**
 * 考试服务实现
 *
 * @author ruoyi
 */
@Service
public class EduExamServiceImpl implements IEduExamService
{
    @Autowired
    private EduExamMapper examMapper;

    @Override
    public EduExam selectEduExamById(Long examId)
    {
        return examMapper.selectEduExamById(examId);
    }

    @Override
    public List<EduExam> selectEduExamList(EduExam exam)
    {
        return examMapper.selectEduExamList(exam);
    }

    @Override
    public int insertEduExam(EduExam exam)
    {
        fillExamDefaults(exam);
        return examMapper.insertEduExam(exam);
    }

    @Override
    public int updateEduExam(EduExam exam)
    {
        fillExamDefaults(exam);
        return examMapper.updateEduExam(exam);
    }

    @Override
    public int deleteEduExamByIds(Long[] examIds)
    {
        return examMapper.deleteEduExamByIds(examIds);
    }

    /**
     * 填充考试默认值
     */
    private void fillExamDefaults(EduExam exam)
    {
        if (StringUtils.isEmpty(exam.getAllowInterrupt()))
        {
            exam.setAllowInterrupt("0");
        }
        if (StringUtils.isEmpty(exam.getInterruptKeepTiming()))
        {
            exam.setInterruptKeepTiming("1");
        }
        if (StringUtils.isEmpty(exam.getShowAnswerAfterSubmit()))
        {
            exam.setShowAnswerAfterSubmit("0");
        }
        if (StringUtils.isEmpty(exam.getShowScoreAfterSubmit()))
        {
            exam.setShowScoreAfterSubmit("1");
        }
        if (StringUtils.isEmpty(exam.getQuestionShuffle()))
        {
            exam.setQuestionShuffle("0");
        }
        if (StringUtils.isEmpty(exam.getOptionShuffle()))
        {
            exam.setOptionShuffle("0");
        }
        if (StringUtils.isEmpty(exam.getStatus()))
        {
            exam.setStatus("0");
        }
    }
}
