package com.ruoyi.system.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.course.EduCourseCategory;
import com.ruoyi.system.mapper.EduCourseCategoryMapper;
import com.ruoyi.system.service.IEduCourseCategoryService;

/**
 * 课程分类服务实现
 *
 * @author ruoyi
 */
@Service
public class EduCourseCategoryServiceImpl implements IEduCourseCategoryService
{
    @Autowired
    private EduCourseCategoryMapper categoryMapper;

    /**
     * 查询课程分类
     */
    @Override
    public EduCourseCategory selectEduCourseCategoryById(Long categoryId)
    {
        return categoryMapper.selectEduCourseCategoryById(categoryId);
    }

    /**
     * 查询课程分类列表
     */
    @Override
    public List<EduCourseCategory> selectEduCourseCategoryList(EduCourseCategory category)
    {
        return categoryMapper.selectEduCourseCategoryList(category);
    }

    /**
     * 构建课程分类树
     */
    @Override
    public List<EduCourseCategory> buildCategoryTree(List<EduCourseCategory> categories)
    {
        List<EduCourseCategory> returnList = new ArrayList<>();
        List<Long> ids = categories.stream().map(EduCourseCategory::getCategoryId).collect(Collectors.toList());
        for (EduCourseCategory category : categories)
        {
            if (!ids.contains(category.getParentId()))
            {
                recursionBuildChildren(categories, category);
                returnList.add(category);
            }
        }
        return returnList.isEmpty() ? categories : returnList;
    }

    /**
     * 查询首页可用分类树
     */
    @Override
    public List<EduCourseCategory> selectPortalCategoryTree()
    {
        EduCourseCategory query = new EduCourseCategory();
        query.setStatus("0");
        return buildCategoryTree(categoryMapper.selectEduCourseCategoryList(query));
    }

    /**
     * 新增课程分类
     */
    @Override
    public int insertEduCourseCategory(EduCourseCategory category)
    {
        if (category.getParentId() == null)
        {
            category.setParentId(0L);
        }
        if (category.getOrderNum() == null)
        {
            category.setOrderNum(0);
        }
        if (StringUtils.isEmpty(category.getStatus()))
        {
            category.setStatus("0");
        }
        EduCourseCategory parent = category.getParentId() == null ? null : categoryMapper.selectEduCourseCategoryById(category.getParentId());
        category.setAncestors(parent == null ? "0" : parent.getAncestors() + "," + parent.getCategoryId());
        return categoryMapper.insertEduCourseCategory(category);
    }

    /**
     * 修改课程分类
     */
    @Override
    public int updateEduCourseCategory(EduCourseCategory category)
    {
        if (category.getParentId() == null)
        {
            category.setParentId(0L);
        }
        if (category.getOrderNum() == null)
        {
            category.setOrderNum(0);
        }
        if (StringUtils.isEmpty(category.getStatus()))
        {
            category.setStatus("0");
        }
        EduCourseCategory parent = category.getParentId() == null ? null : categoryMapper.selectEduCourseCategoryById(category.getParentId());
        category.setAncestors(parent == null ? "0" : parent.getAncestors() + "," + parent.getCategoryId());
        return categoryMapper.updateEduCourseCategory(category);
    }

    /**
     * 删除课程分类
     */
    @Override
    public int deleteEduCourseCategoryById(Long categoryId)
    {
        return categoryMapper.deleteEduCourseCategoryById(categoryId);
    }

    /**
     * 批量删除课程分类
     */
    @Override
    public int deleteEduCourseCategoryByIds(Long[] categoryIds)
    {
        return categoryMapper.deleteEduCourseCategoryByIds(categoryIds);
    }

    /**
     * 递归设置子分类
     */
    private void recursionBuildChildren(List<EduCourseCategory> list, EduCourseCategory current)
    {
        List<EduCourseCategory> children = list.stream()
                .filter(item -> StringUtils.isNotNull(item.getParentId()) && item.getParentId().longValue() == current.getCategoryId().longValue())
                .collect(Collectors.toList());
        current.setChildren(children);
        for (EduCourseCategory child : children)
        {
            recursionBuildChildren(list, child);
        }
    }
}
