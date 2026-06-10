package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.exam.EduExam;

/**
 * 考试数据层
 *
 * @author ruoyi
 */
public interface EduExamMapper
{
    /**
     * 查询考试
     *
     * @param examId 考试ID
     * @return 考试
     */
    public EduExam selectEduExamById(Long examId);

    /**
     * 查询考试列表
     *
     * @param exam 考试
     * @return 考试集合
     */
    public List<EduExam> selectEduExamList(EduExam exam);

    /**
     * 新增考试
     *
     * @param exam 考试
     * @return 结果
     */
    public int insertEduExam(EduExam exam);

    /**
     * 修改考试
     *
     * @param exam 考试
     * @return 结果
     */
    public int updateEduExam(EduExam exam);

    /**
     * 逻辑删除考试
     *
     * @param examIds 考试ID数组
     * @return 结果
     */
    public int deleteEduExamByIds(Long[] examIds);

    /**
     * 查询考试关联的课程ID列表
     */
    public List<Long> selectCourseIdsByExamId(Long examId);

    /**
     * 查询考试关联的课程名称（逗号分隔）
     */
    public String selectCourseNamesByExamId(Long examId);

    /**
     * 批量插入考试课程关联
     */
    public int batchInsertExamCourse(@org.apache.ibatis.annotations.Param("examId") Long examId, @org.apache.ibatis.annotations.Param("courseIds") List<Long> courseIds);

    /**
     * 删除考试所有课程关联
     */
    public int deleteExamCourseByExamId(Long examId);
}
