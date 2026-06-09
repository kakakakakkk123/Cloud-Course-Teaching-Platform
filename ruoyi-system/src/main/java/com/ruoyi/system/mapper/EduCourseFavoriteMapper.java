package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.course.EduCourse;
import com.ruoyi.system.domain.course.EduCourseFavorite;

/**
 * 课程收藏数据层
 *
 * @author ruoyi
 */
public interface EduCourseFavoriteMapper
{
    /**
     * 查询课程收藏
     *
     * @param courseId 课程ID
     * @param userId 用户ID
     * @return 收藏信息
     */
    public EduCourseFavorite selectEduCourseFavorite(@Param("courseId") Long courseId, @Param("userId") Long userId);

    /**
     * 新增课程收藏
     *
     * @param courseFavorite 收藏信息
     * @return 结果
     */
    public int insertEduCourseFavorite(EduCourseFavorite courseFavorite);

    /**
     * 删除课程收藏
     *
     * @param courseId 课程ID
     * @param userId 用户ID
     * @return 结果
     */
    public int deleteEduCourseFavorite(@Param("courseId") Long courseId, @Param("userId") Long userId);

    /**
     * 查询用户已收藏课程
     *
     * @param userId 用户ID
     * @return 课程集合
     */
    public List<EduCourse> selectUserFavoriteCourseList(Long userId);

    /**
     * 按课程批量删除收藏关系
     *
     * @param courseIds 课程ID数组
     * @return 结果
     */
    public int deleteEduCourseFavoriteByCourseIds(Long[] courseIds);
}
