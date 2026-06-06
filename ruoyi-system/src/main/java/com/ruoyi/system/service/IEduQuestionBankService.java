package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.exam.EduQuestionBank;

/**
 * 题库服务层
 *
 * @author ruoyi
 */
public interface IEduQuestionBankService
{
    /**
     * 查询题库
     *
     * @param bankId 题库ID
     * @return 题库
     */
    public EduQuestionBank selectEduQuestionBankById(Long bankId);

    /**
     * 查询题库列表
     *
     * @param bank 题库
     * @return 题库集合
     */
    public List<EduQuestionBank> selectEduQuestionBankList(EduQuestionBank bank);

    /**
     * 新增题库
     *
     * @param bank 题库
     * @return 结果
     */
    public int insertEduQuestionBank(EduQuestionBank bank);

    /**
     * 修改题库
     *
     * @param bank 题库
     * @return 结果
     */
    public int updateEduQuestionBank(EduQuestionBank bank);

    /**
     * 删除题库
     *
     * @param bankIds 题库ID数组
     * @return 结果
     */
    public int deleteEduQuestionBankByIds(Long[] bankIds);
}
