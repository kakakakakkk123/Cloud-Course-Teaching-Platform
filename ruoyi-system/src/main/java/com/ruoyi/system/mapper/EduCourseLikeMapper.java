package com.ruoyi.system.mapper;

import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.course.EduCourseLike;

/**
 * 课程点赞数据层
 *
 * @author ruoyi
 */
public interface EduCourseLikeMapper
{
    /**
     * 查询课程点赞
     *
     * @param courseId 课程ID
     * @param userId 用户ID
     * @return 点赞信息
     */
    public EduCourseLike selectEduCourseLike(@Param("courseId") Long courseId, @Param("userId") Long userId);

    /**
     * 新增课程点赞
     *
     * @param courseLike 点赞信息
     * @return 结果
     */
    public int insertEduCourseLike(EduCourseLike courseLike);

    /**
     * 删除课程点赞
     *
     * @param courseId 课程ID
     * @param userId 用户ID
     * @return 结果
     */
    public int deleteEduCourseLike(@Param("courseId") Long courseId, @Param("userId") Long userId);

    /**
     * 按课程批量删除点赞关系
     *
     * @param courseIds 课程ID数组
     * @return 结果
     */
    public int deleteEduCourseLikeByCourseIds(Long[] courseIds);
}
