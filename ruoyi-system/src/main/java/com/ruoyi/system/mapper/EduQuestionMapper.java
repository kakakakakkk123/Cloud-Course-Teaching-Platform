package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.exam.EduQuestion;
import com.ruoyi.system.domain.exam.EduQuestionOption;

/**
 * 试题数据层
 *
 * @author ruoyi
 */
public interface EduQuestionMapper
{
    /**
     * 查询试题
     *
     * @param questionId 试题ID
     * @return 试题
     */
    public EduQuestion selectEduQuestionById(Long questionId);

    /**
     * 查询试题列表
     *
     * @param question 试题
     * @return 试题集合
     */
    public List<EduQuestion> selectEduQuestionList(EduQuestion question);

    /**
     * 新增试题
     *
     * @param question 试题
     * @return 结果
     */
    public int insertEduQuestion(EduQuestion question);

    /**
     * 修改试题
     *
     * @param question 试题
     * @return 结果
     */
    public int updateEduQuestion(EduQuestion question);

    /**
     * 逻辑删除试题
     *
     * @param questionIds 试题ID数组
     * @return 结果
     */
    public int deleteEduQuestionByIds(Long[] questionIds);

    /**
     * 查询试题选项列表
     *
     * @param questionId 试题ID
     * @return 选项集合
     */
    public List<EduQuestionOption> selectOptionListByQuestionId(Long questionId);

    /**
     * 删除试题选项
     *
     * @param questionId 试题ID
     * @return 结果
     */
    public int deleteOptionByQuestionId(Long questionId);

    /**
     * 批量新增试题选项
     *
     * @param optionList 选项集合
     * @return 结果
     */
    public int batchInsertOption(List<EduQuestionOption> optionList);
}
