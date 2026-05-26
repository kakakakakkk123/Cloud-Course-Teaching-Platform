package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.course.EduCourse;

/**
 * 课程服务层
 *
 * @author ruoyi
 */
public interface IEduCourseService
{
    /**
     * 查询课程
     *
     * @param courseId 课程ID
     * @return 课程
     */
    public EduCourse selectEduCourseById(Long courseId);

    /**
     * 查询课程列表
     *
     * @param course 课程
     * @return 课程集合
     */
    public List<EduCourse> selectEduCourseList(EduCourse course);

    /**
     * 查询门户课程列表
     *
     * @param course 查询条件
     * @return 课程集合
     */
    public List<EduCourse> selectPortalCourseList(EduCourse course);

    /**
     * 查询已发布课程详情
     *
     * @param courseId 课程ID
     * @return 课程
     */
    public EduCourse selectPublishedCourseById(Long courseId);

    /**
     * 新增课程
     *
     * @param course 课程
     * @return 结果
     */
    public int insertEduCourse(EduCourse course);

    /**
     * 修改课程
     *
     * @param course 课程
     * @return 结果
     */
    public int updateEduCourse(EduCourse course);

    /**
     * 删除课程
     *
     * @param courseId 课程ID
     * @return 结果
     */
    public int deleteEduCourseById(Long courseId);

    /**
     * 批量删除课程
     *
     * @param courseIds 课程ID数组
     * @return 结果
     */
    public int deleteEduCourseByIds(Long[] courseIds);

    /**
     * 查询推荐课程
     *
     * @param limitNum 返回数量
     * @return 课程集合
     */
    public List<EduCourse> selectRecommendCourseList(Integer limitNum);

    /**
     * 查询热门课程
     *
     * @param limitNum 返回数量
     * @return 课程集合
     */
    public List<EduCourse> selectHotCourseList(Integer limitNum);

    /**
     * 查询最新课程
     *
     * @param limitNum 返回数量
     * @return 课程集合
     */
    public List<EduCourse> selectLatestCourseList(Integer limitNum);

    /**
     * 刷新课程内容统计
     *
     * @param courseId 课程ID
     */
    public void refreshCourseContentStats(Long courseId);
}
