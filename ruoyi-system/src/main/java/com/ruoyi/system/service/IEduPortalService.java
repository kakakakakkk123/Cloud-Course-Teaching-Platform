package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.course.EduCourse;
import com.ruoyi.system.domain.course.vo.EduPortalCourseDetailVO;
import com.ruoyi.system.domain.course.vo.EduPortalHomeVO;

/**
 * 门户首页服务层
 *
 * @author ruoyi
 */
public interface IEduPortalService
{
    /**
     * 查询门户首页数据
     *
     * @return 首页数据
     */
    public EduPortalHomeVO selectPortalHomeData();

    /**
     * 查询课程详情
     *
     * @param courseId 课程ID
     * @param userId 当前用户ID
     * @return 课程详情
     */
    public EduPortalCourseDetailVO selectPortalCourseDetail(Long courseId, Long userId);

    /**
     * 查询学生已注册课程
     *
     * @param studentId 学生ID
     * @return 课程集合
     */
    public List<EduCourse> selectStudentEnrolledCourseList(Long studentId);

    /**
     * 查询学生已收藏课程
     *
     * @param studentId 学生ID
     * @return 课程集合
     */
    public List<EduCourse> selectStudentFavoriteCourseList(Long studentId);

    /**
     * 学生注册课程
     *
     * @param courseId 课程ID
     * @param studentId 学生ID
     */
    public void enrollCourse(Long courseId, Long studentId);

    /**
     * 用户点赞课程
     *
     * @param courseId 课程ID
     * @param userId 用户ID
     */
    public void likeCourse(Long courseId, Long userId);

    /**
     * 用户取消点赞
     *
     * @param courseId 课程ID
     * @param userId 用户ID
     */
    public void cancelCourseLike(Long courseId, Long userId);

    /**
     * 学生收藏课程
     *
     * @param courseId 课程ID
     * @param studentId 学生ID
     */
    public void favoriteCourse(Long courseId, Long studentId);

    /**
     * 学生取消收藏
     *
     * @param courseId 课程ID
     * @param studentId 学生ID
     */
    public void cancelCourseFavorite(Long courseId, Long studentId);
}
