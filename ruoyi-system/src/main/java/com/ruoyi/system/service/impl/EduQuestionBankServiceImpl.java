package com.ruoyi.system.service.impl;

import java.util.Collections;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.exam.EduQuestionBank;
import com.ruoyi.system.mapper.EduQuestionBankMapper;
import com.ruoyi.system.service.IEduQuestionBankService;

/**
 * 题库服务实现
 *
 * @author ruoyi
 */
@Service
public class EduQuestionBankServiceImpl implements IEduQuestionBankService
{
    @Autowired
    private EduQuestionBankMapper questionBankMapper;

    /**
     * 查询题库
     */
    @Override
    public EduQuestionBank selectEduQuestionBankById(Long bankId)
    {
        EduQuestionBank bank = questionBankMapper.selectEduQuestionBankById(bankId);
        if (StringUtils.isNotNull(bank))
        {
            bank.setCourseIds(questionBankMapper.selectCourseIdsByBankId(bankId));
        }
        return bank;
    }

    /**
     * 查询题库列表
     */
    @Override
    public List<EduQuestionBank> selectEduQuestionBankList(EduQuestionBank bank)
    {
        return questionBankMapper.selectEduQuestionBankList(bank);
    }

    /**
     * 新增题库
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertEduQuestionBank(EduQuestionBank bank)
    {
        fillBankDefaults(bank);
        int rows = questionBankMapper.insertEduQuestionBank(bank);
        syncBankCourses(bank);
        return rows;
    }

    /**
     * 修改题库
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateEduQuestionBank(EduQuestionBank bank)
    {
        fillBankDefaults(bank);
        int rows = questionBankMapper.updateEduQuestionBank(bank);
        syncBankCourses(bank);
        return rows;
    }

    /**
     * 删除题库
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteEduQuestionBankByIds(Long[] bankIds)
    {
        for (Long bankId : bankIds)
        {
            questionBankMapper.deleteBankCourseByBankId(bankId);
        }
        return questionBankMapper.deleteEduQuestionBankByIds(bankIds);
    }

    /**
     * 同步题库关联课程
     */
    private void syncBankCourses(EduQuestionBank bank)
    {
        if (StringUtils.isNull(bank.getBankId()))
        {
            return;
        }
        questionBankMapper.deleteBankCourseByBankId(bank.getBankId());
        List<Long> courseIds = bank.getCourseIds();
        if (StringUtils.isEmpty(courseIds))
        {
            return;
        }
        questionBankMapper.batchInsertBankCourse(bank.getBankId(), courseIds);
    }

    /**
     * 填充题库默认值
     */
    private void fillBankDefaults(EduQuestionBank bank)
    {
        if (StringUtils.isEmpty(bank.getVisibility()))
        {
            bank.setVisibility("0");
        }
        if (StringUtils.isEmpty(bank.getStatus()))
        {
            bank.setStatus("0");
        }
        if (bank.getCourseIds() == null)
        {
            bank.setCourseIds(Collections.emptyList());
        }
    }
}
