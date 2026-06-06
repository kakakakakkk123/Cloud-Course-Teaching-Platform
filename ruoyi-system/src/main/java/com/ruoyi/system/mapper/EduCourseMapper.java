package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.course.EduCourse;

/**
 * 课程数据层
 *
 * @author ruoyi
 */
public interface EduCourseMapper
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
     * @param course 课程查询条件
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
     * 刷新课程内容统计
     *
     * @param courseId 课程ID
     * @return 结果
     */
    public int refreshCourseContentStats(Long courseId);

    /**
     * 课程浏览次数加一
     *
     * @param courseId 课程ID
     * @return 结果
     */
    public int increaseViewCount(Long courseId);

    /**
     * 更新课程注册人数
     *
     * @param courseId 课程ID
     * @return 结果
     */
    public int refreshEnrollCount(Long courseId);

    /**
     * 更新课程点赞人数
     *
     * @param courseId 课程ID
     * @return 结果
     */
    public int refreshLikeCount(Long courseId);

    /**
     * 清空轮播图中的课程引用
     *
     * @param courseIds 课程ID数组
     * @return 结果
     */
    public int clearBannerCourseRef(Long[] courseIds);

    /**
     * 查询教师名下课程数量
     *
     * @param teacherId 教师ID
     * @return 数量
     */
    public int countCourseByTeacherId(Long teacherId);

    /**
     * 根据课程ID查询推荐/收藏状态
     *
     * @param courseId 课程ID
     * @param userId 用户ID
     * @return 课程
     */
    public EduCourse selectPortalCourseState(@Param("courseId") Long courseId, @Param("userId") Long userId);
}
