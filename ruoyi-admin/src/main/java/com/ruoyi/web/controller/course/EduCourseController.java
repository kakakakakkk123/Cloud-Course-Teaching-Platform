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
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.course.EduCourse;
import com.ruoyi.system.service.IEduCourseService;

/**
 * 课程管理
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/edu/course")
public class EduCourseController extends BaseController
{
    @Autowired
    private IEduCourseService courseService;

    /**
     * 查询课程列表
     */
    @PreAuthorize("@ss.hasPermi('edu:course:list')")
    @GetMapping("/list")
    public TableDataInfo list(EduCourse course)
    {
        startPage();
        if (SecurityUtils.hasRole("teacher") && !SecurityUtils.isAdmin())
        {
            course.setTeacherId(getUserId());
        }
        List<EduCourse> list = courseService.selectEduCourseList(course);
        return getDataTable(list);
    }

    /**
     * 查询课程详情
     */
    @PreAuthorize("@ss.hasPermi('edu:course:query')")
    @GetMapping("/{courseId}")
    public AjaxResult getInfo(@PathVariable Long courseId)
    {
        return success(courseService.selectEduCourseById(courseId));
    }

    /**
     * 新增课程
     */
    @PreAuthorize("@ss.hasPermi('edu:course:add')")
    @Log(title = "课程管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EduCourse course)
    {
        if (course.getTeacherId() == null)
        {
            course.setTeacherId(getUserId());
        }
        course.setCreateBy(getUsername());
        return toAjax(courseService.insertEduCourse(course));
    }

    /**
     * 修改课程
     */
    @PreAuthorize("@ss.hasPermi('edu:course:edit')")
    @Log(title = "课程管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody EduCourse course)
    {
        if (course.getTeacherId() == null && course.getCourseId() != null)
        {
            EduCourse source = courseService.selectEduCourseById(course.getCourseId());
            if (source != null)
            {
                course.setTeacherId(source.getTeacherId());
            }
        }
        course.setUpdateBy(getUsername());
        return toAjax(courseService.updateEduCourse(course));
    }

    /**
     * 删除课程
     */
    @PreAuthorize("@ss.hasPermi('edu:course:remove')")
    @Log(title = "课程管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{courseIds}")
    public AjaxResult remove(@PathVariable Long[] courseIds)
    {
        return toAjax(courseService.deleteEduCourseByIds(courseIds));
    }
}
