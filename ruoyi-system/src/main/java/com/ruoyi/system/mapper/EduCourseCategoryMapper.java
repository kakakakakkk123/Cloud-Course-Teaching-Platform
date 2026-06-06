package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.course.EduCourseCategory;

/**
 * 课程分类数据层
 *
 * @author ruoyi
 */
public interface EduCourseCategoryMapper
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

    /**
     * 查询是否存在子分类
     *
     * @param categoryId 分类ID
     * @return 数量
     */
    public int hasChildByCategoryId(Long categoryId);

    /**
     * 查询分类下课程数量
     *
     * @param categoryId 分类ID
     * @return 数量
     */
    public int countCourseByCategoryId(Long categoryId);
}
