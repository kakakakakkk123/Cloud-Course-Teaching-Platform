package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.course.EduCourseCategory;

/**
 * 课程分类服务层
 *
 * @author ruoyi
 */
public interface IEduCourseCategoryService
{
    /**
     * 查询课程分类
     *
     * @param categoryId 分类ID
     * @return 课程分类
     */
    public EduCourseCategory selectEduCourseCategoryById(Long categoryId);

    /**
     * 查询课程分类列表
     *
     * @param category 课程分类
     * @return 课程分类集合
     */
    public List<EduCourseCategory> selectEduCourseCategoryList(EduCourseCategory category);

    /**
     * 构建课程分类树
     *
     * @param categories 分类集合
     * @return 树结构集合
     */
    public List<EduCourseCategory> buildCategoryTree(List<EduCourseCategory> categories);

    /**
     * 查询首页可用分类树
     *
     * @return 分类树
     */
    public List<EduCourseCategory> selectPortalCategoryTree();

    /**
     * 新增课程分类
     *
     * @param category 课程分类
     * @return 结果
     */
    public int insertEduCourseCategory(EduCourseCategory category);

    /**
     * 修改课程分类
     *
     * @param category 课程分类
     * @return 结果
     */
    public int updateEduCourseCategory(EduCourseCategory category);

    /**
     * 删除课程分类
     *
     * @param categoryId 分类ID
     * @return 结果
     */
    public int deleteEduCourseCategoryById(Long categoryId);

    /**
     * 批量删除课程分类
     *
     * @param categoryIds 分类ID数组
     * @return 结果
     */
    public int deleteEduCourseCategoryByIds(Long[] categoryIds);
}
