package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.exam.EduPaper;
import com.ruoyi.system.domain.exam.EduPaperQuestion;

/**
 * 试卷数据层
 *
 * @author ruoyi
 */
public interface EduPaperMapper
{
    /**
     * 查询试卷
     *
     * @param paperId 试卷ID
     * @return 试卷
     */
    public EduPaper selectEduPaperById(Long paperId);

    /**
     * 查询试卷列表
     *
     * @param paper 试卷
     * @return 试卷集合
     */
    public List<EduPaper> selectEduPaperList(EduPaper paper);

    /**
     * 新增试卷
     *
     * @param paper 试卷
     * @return 结果
     */
    public int insertEduPaper(EduPaper paper);

    /**
     * 修改试卷
     *
     * @param paper 试卷
     * @return 结果
     */
    public int updateEduPaper(EduPaper paper);

    /**
     * 逻辑删除试卷
     *
     * @param paperIds 试卷ID数组
     * @return 结果
     */
    public int deleteEduPaperByIds(Long[] paperIds);

    /**
     * 查询试卷关联的课程ID列表
     *
     * @param paperId 试卷ID
     * @return 课程ID集合
     */
    public List<Long> selectCourseIdsByPaperId(Long paperId);

    /**
     * 查询试卷关联的课程名称（逗号分隔），用于列表展示
     *
     * @param paperId 试卷ID
     * @return 课程名称字符串
     */
    public String selectCourseNamesByPaperId(Long paperId);

    /**
     * 批量插入试卷课程关联
     *
     * @param paperId 试卷ID
     * @param courseIds 课程ID列表
     * @return 结果
     */
    public int batchInsertPaperCourse(@Param("paperId") Long paperId, @Param("courseIds") List<Long> courseIds);

    /**
     * 删除试卷的所有课程关联
     *
     * @param paperId 试卷ID
     * @return 结果
     */
    public int deletePaperCourseByPaperId(Long paperId);

    /**
     * 按课程ID批量删除试卷课程关联
     */
    public int deletePaperCourseByCourseIds(Long[] courseIds);

    /**
     * 按课程ID清空试卷旧版 course_id
     */
    public int clearPaperCourseRef(Long[] courseIds);

    /**
     * 仅更新试卷的旧版 course_id 字段（兼容用）
     *
     * @param paperId 试卷ID
     * @param courseId 课程ID
     * @return 结果
     */
    public int updatePaperCourseId(@Param("paperId") Long paperId, @Param("courseId") Long courseId);

    /**
     * 按题库ID统计试卷数量
     */
    public int countByBankId(Long bankId);

    /**
     * 按试题ID统计引用的试卷数量（用于判断试题是否被试卷使用）
     */
    public int countPaperRefByQuestionIds(Long[] questionIds);

    // ==================== 试卷题目关联 ====================

    /**
     * 查询试卷下的题目列表（含题目详情）
     *
     * @param paperId 试卷ID
     * @return 题目关联列表
     */
    public List<EduPaperQuestion> selectPaperQuestionsByPaperId(Long paperId);

    /**
     * 批量插入试卷题目关联
     *
     * @param list 题目关联列表
     * @return 结果
     */
    public int batchInsertPaperQuestion(@Param("list") List<EduPaperQuestion> list);

    /**
     * 删除试卷的所有题目关联
     *
     * @param paperId 试卷ID
     * @return 结果
     */
    public int deletePaperQuestionByPaperId(Long paperId);

    /**
     * 更新试卷统计信息（题目数、总分、主客观分）
     *
     * @param paperId 试卷ID
     * @return 结果
     */
    public int updatePaperStats(Long paperId);
}
