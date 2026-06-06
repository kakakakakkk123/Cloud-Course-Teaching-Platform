package com.ruoyi.web.controller.course;

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
import com.ruoyi.system.domain.course.EduCourseContent;
import com.ruoyi.system.service.IEduCourseContentService;

/**
 * 课程内容管理
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/edu/content")
public class EduCourseContentController extends BaseController
{
    @Autowired
    private IEduCourseContentService contentService;

    /**
     * 查询课程内容列表
     */
    @PreAuthorize("@ss.hasPermi('edu:content:list')")
    @GetMapping("/list")
    public TableDataInfo list(EduCourseContent content)
    {
        startPage();
        return getDataTable(contentService.selectEduCourseContentList(content));
    }

    /**
     * 查询课程内容详情
     */
    @PreAuthorize("@ss.hasPermi('edu:content:query')")
    @GetMapping("/{contentId}")
    public AjaxResult getInfo(@PathVariable Long contentId)
    {
        return success(contentService.selectEduCourseContentById(contentId));
    }

    /**
     * 新增课程内容
     */
    @PreAuthorize("@ss.hasPermi('edu:content:add')")
    @Log(title = "课程内容", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody EduCourseContent content)
    {
        content.setCreateBy(getUsername());
        return toAjax(contentService.insertEduCourseContent(content));
    }

    /**
     * 修改课程内容
     */
    @PreAuthorize("@ss.hasPermi('edu:content:edit')")
    @Log(title = "课程内容", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody EduCourseContent content)
    {
        content.setUpdateBy(getUsername());
        return toAjax(contentService.updateEduCourseContent(content));
    }

    /**
     * 删除课程内容
     */
    @PreAuthorize("@ss.hasPermi('edu:content:remove')")
    @Log(title = "课程内容", businessType = BusinessType.DELETE)
    @DeleteMapping("/{contentIds}")
    public AjaxResult remove(@PathVariable Long[] contentIds)
    {
        return toAjax(contentService.deleteEduCourseContentByIds(contentIds));
    }
}
