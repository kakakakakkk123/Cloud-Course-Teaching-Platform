package com.ruoyi.web.controller.exam;

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
import com.ruoyi.system.domain.exam.EduExam;
import com.ruoyi.system.service.IEduExamService;

/**
 * 考试发布管理
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/edu/exam/manage")
public class EduExamManageController extends BaseController
{
    @Autowired
    private IEduExamService examService;

    /**
     * 查询考试列表
     */
    @PreAuthorize("@ss.hasAnyRoles('teacher,admin') or @ss.hasPermi('edu:score:list')")
    @GetMapping("/list")
    public TableDataInfo list(EduExam exam)
    {
        startPage();
        if (SecurityUtils.hasRole("teacher") && !SecurityUtils.isAdmin())
        {
            exam.setCreatorId(getUserId());
        }
        List<EduExam> list = examService.selectEduExamList(exam);
        return getDataTable(list);
    }

    /**
     * 查询考试详情
     */
    @PreAuthorize("@ss.hasPermi('edu:score:query')")
    @GetMapping("/{examId}")
    public AjaxResult getInfo(@PathVariable Long examId)
    {
        return success(examService.selectEduExamById(examId));
    }

    /**
     * 新增考试
     */
    @PreAuthorize("@ss.hasPermi('edu:score:add')")
    @Log(title = "考试发布", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody EduExam exam)
    {
        exam.setCreatorId(getUserId());
        exam.setCreateBy(getUsername());
        return toAjax(examService.insertEduExam(exam));
    }

    /**
     * 修改考试
     */
    @PreAuthorize("@ss.hasPermi('edu:score:edit')")
    @Log(title = "考试发布", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody EduExam exam)
    {
        exam.setUpdateBy(getUsername());
        return toAjax(examService.updateEduExam(exam));
    }

    /**
     * 删除考试
     */
    @PreAuthorize("@ss.hasPermi('edu:score:remove')")
    @Log(title = "考试发布", businessType = BusinessType.DELETE)
    @DeleteMapping("/{examIds}")
    public AjaxResult remove(@PathVariable Long[] examIds)
    {
        return toAjax(examService.deleteEduExamByIds(examIds));
    }
}
