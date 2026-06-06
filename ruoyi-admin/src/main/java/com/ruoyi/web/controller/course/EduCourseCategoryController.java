package com.ruoyi.web.controller.course;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.course.EduCourse;
import com.ruoyi.system.domain.course.EduCourseCategory;
import com.ruoyi.system.service.IEduCourseCategoryService;
import com.ruoyi.system.service.IEduCourseService;

/**
 * 课程分类管理
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/edu/category")
public class EduCourseCategoryController extends BaseController
{
    @Autowired
    private IEduCourseCategoryService categoryService;

    @Autowired
    private IEduCourseService courseService;

    /**
     * 查询课程分类列表
     */
    @PreAuthorize("@ss.hasPermi('edu:category:list')")
    @GetMapping("/list")
    public TableDataInfo list(EduCourseCategory category)
    {
        startPage();
        return getDataTable(categoryService.selectEduCourseCategoryList(category));
    }

    /**
     * 查询课程分类树
     */
    @PreAuthorize("@ss.hasAnyRoles('teacher,admin') or @ss.hasPermi('edu:category:list')")
    @GetMapping("/tree")
    public AjaxResult tree()
    {
        return success(categoryService.selectPortalCategoryTree());
    }

    /**
     * 查询课程分类详情
     */
    @PreAuthorize("@ss.hasPermi('edu:category:query')")
    @GetMapping("/{categoryId}")
    public AjaxResult getInfo(@PathVariable Long categoryId)
    {
        return success(categoryService.selectEduCourseCategoryById(categoryId));
    }

    /**
     * 新增课程分类
     */
    @PreAuthorize("@ss.hasPermi('edu:category:add')")
    @Log(title = "课程分类", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody EduCourseCategory category)
    {
        category.setCreateBy(getUsername());
        return toAjax(categoryService.insertEduCourseCategory(category));
    }

    /**
     * 修改课程分类
     */
    @PreAuthorize("@ss.hasPermi('edu:category:edit')")
    @Log(title = "课程分类", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody EduCourseCategory category)
    {
        category.setUpdateBy(getUsername());
        return toAjax(categoryService.updateEduCourseCategory(category));
    }

    /**
     * 删除课程分类
     */
    @PreAuthorize("@ss.hasPermi('edu:category:remove')")
    @Log(title = "课程分类", businessType = BusinessType.DELETE)
    @DeleteMapping("/{categoryIds}")
    public AjaxResult remove(@PathVariable Long[] categoryIds)
    {
        for (Long categoryId : categoryIds)
        {
            EduCourseCategory query = new EduCourseCategory();
            query.setParentId(categoryId);
            List<EduCourseCategory> children = categoryService.selectEduCourseCategoryList(query);
            if (!children.isEmpty())
            {
                return warn("存在下级分类，暂不能删除");
            }
            EduCourse courseQuery = new EduCourse();
            courseQuery.setCategoryId(categoryId);
            if (!courseService.selectEduCourseList(courseQuery).isEmpty())
            {
                return warn("分类下存在课程，暂不能删除");
            }
        }
        return toAjax(categoryService.deleteEduCourseCategoryByIds(categoryIds));
    }
}
