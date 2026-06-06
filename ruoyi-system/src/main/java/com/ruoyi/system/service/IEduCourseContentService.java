package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.course.EduCourseContent;

/**
 * 课程内容服务层
 *
 * @author ruoyi
 */
public interface IEduCourseContentService
{
    /**
     * 查询课程内容
     *
     * @param contentId 内容ID
     * @return 课程内容
     */
    public EduCourseContent selectEduCourseContentById(Long contentId);

    /**
     * 查询课程内容列表
     *
     * @param content 课程内容
     * @return 课程内容集合
     */
    public List<EduCourseContent> selectEduCourseContentList(EduCourseContent content);

    /**
     * 查询课程已发布内容
     *
     * @param courseId 课程ID
     * @return 课程内容集合
     */
    public List<EduCourseContent> selectPublishedContentByCourseId(Long courseId);

    /**
     * 新增课程内容
     *
     * @param content 课程内容
     * @return 结果
     */
    public int insertEduCourseContent(EduCourseContent content);

    /**
     * 修改课程内容
     *
     * @param content 课程内容
     * @return 结果
     */
    public int updateEduCourseContent(EduCourseContent content);

    /**
     * 删除课程内容
     *
     * @param contentId 内容ID
     * @return 结果
     */
    public int deleteEduCourseContentById(Long contentId);

    /**
     * 批量删除课程内容
     *
     * @param contentIds 内容ID数组
     * @return 结果
     */
    public int deleteEduCourseContentByIds(Long[] contentIds);
}
