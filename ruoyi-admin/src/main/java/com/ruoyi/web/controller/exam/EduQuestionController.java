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
import com.ruoyi.system.domain.exam.EduQuestion;
import com.ruoyi.system.service.IEduQuestionService;

/**
 * 试题管理
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/edu/exam/question")
public class EduQuestionController extends BaseController
{
    @Autowired
    private IEduQuestionService questionService;

    /**
     * 查询试题列表
     */
    @PreAuthorize("@ss.hasPermi('edu:question:list')")
    @GetMapping("/list")
    public TableDataInfo list(EduQuestion question)
    {
        startPage();
        if (SecurityUtils.hasRole("teacher") && !SecurityUtils.isAdmin())
        {
            question.setCreatorId(getUserId());
        }
        List<EduQuestion> list = questionService.selectEduQuestionList(question);
        return getDataTable(list);
    }

    /**
     * 查询试题详情
     */
    @PreAuthorize("@ss.hasPermi('edu:question:query')")
    @GetMapping("/{questionId}")
    public AjaxResult getInfo(@PathVariable Long questionId)
    {
        return success(questionService.selectEduQuestionById(questionId));
    }

    /**
     * 新增试题
     */
    @PreAuthorize("@ss.hasPermi('edu:question:add')")
    @Log(title = "试题管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody EduQuestion question)
    {
        question.setCreatorId(getUserId());
        question.setCreateBy(getUsername());
        return toAjax(questionService.insertEduQuestion(question));
    }

    /**
     * 修改试题
     */
    @PreAuthorize("@ss.hasPermi('edu:question:edit')")
    @Log(title = "试题管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody EduQuestion question)
    {
        question.setUpdateBy(getUsername());
        return toAjax(questionService.updateEduQuestion(question));
    }

    /**
     * 删除试题
     */
    @PreAuthorize("@ss.hasPermi('edu:question:remove')")
    @Log(title = "试题管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{questionIds}")
    public AjaxResult remove(@PathVariable Long[] questionIds)
    {
        return toAjax(questionService.deleteEduQuestionByIds(questionIds));
    }
}
