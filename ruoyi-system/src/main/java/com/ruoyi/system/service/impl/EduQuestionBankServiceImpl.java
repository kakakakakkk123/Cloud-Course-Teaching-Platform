package com.ruoyi.system.service.impl;

import java.util.Collections;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.exam.EduQuestionBank;
import com.ruoyi.system.mapper.EduPaperMapper;
import com.ruoyi.system.mapper.EduQuestionBankMapper;
import com.ruoyi.system.mapper.EduQuestionMapper;
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

    @Autowired
    private EduQuestionMapper questionMapper;

    @Autowired
    private EduPaperMapper paperMapper;

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
            // 检查题库下是否有试题
            int questionCount = questionMapper.countByBankId(bankId);
            if (questionCount > 0)
            {
                EduQuestionBank bank = questionBankMapper.selectEduQuestionBankById(bankId);
                String bankName = bank != null ? bank.getBankName() : String.valueOf(bankId);
                throw new ServiceException("题库「" + bankName + "」下还有 " + questionCount + " 道试题，请先清空试题后再删除");
            }
            // 检查题库下是否有试卷
            int paperCount = paperMapper.countByBankId(bankId);
            if (paperCount > 0)
            {
                EduQuestionBank bank = questionBankMapper.selectEduQuestionBankById(bankId);
                String bankName = bank != null ? bank.getBankName() : String.valueOf(bankId);
                throw new ServiceException("题库「" + bankName + "」下还有 " + paperCount + " 份试卷，请先清空试卷后再删除");
            }
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
