package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.exam.EduQuestionBank;

/**
 * 题库数据层
 *
 * @author ruoyi
 */
public interface EduQuestionBankMapper
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
     * 逻辑删除题库
     *
     * @param bankIds 题库ID数组
     * @return 结果
     */
    public int deleteEduQuestionBankByIds(Long[] bankIds);

    /**
     * 查询题库关联课程ID列表
     *
     * @param bankId 题库ID
     * @return 课程ID列表
     */
    public List<Long> selectCourseIdsByBankId(Long bankId);

    /**
     * 删除题库课程关联
     *
     * @param bankId 题库ID
     * @return 结果
     */
    public int deleteBankCourseByBankId(Long bankId);

    /**
     * 批量新增题库课程关联
     *
     * @param bankId 题库ID
     * @param courseIds 课程ID列表
     * @return 结果
     */
    public int batchInsertBankCourse(@Param("bankId") Long bankId, @Param("courseIds") List<Long> courseIds);

    /**
     * 按课程ID批量删除题库课程关联
     */
    public int deleteBankCourseByCourseIds(Long[] courseIds);
}
