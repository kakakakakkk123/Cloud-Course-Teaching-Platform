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
import com.ruoyi.system.domain.exam.EduQuestionBank;
import com.ruoyi.system.service.IEduQuestionBankService;

/**
 * 题库管理
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/edu/exam/bank")
public class EduQuestionBankController extends BaseController
{
    @Autowired
    private IEduQuestionBankService questionBankService;

    /**
     * 查询题库列表
     */
    @PreAuthorize("@ss.hasPermi('edu:paper:list')")
    @GetMapping("/list")
    public TableDataInfo list(EduQuestionBank bank)
    {
        startPage();
        if (SecurityUtils.hasRole("teacher") && !SecurityUtils.isAdmin())
        {
            bank.setCreatorId(getUserId());
        }
        List<EduQuestionBank> list = questionBankService.selectEduQuestionBankList(bank);
        return getDataTable(list);
    }

    /**
     * 查询题库详情
     */
    @PreAuthorize("@ss.hasPermi('edu:paper:query')")
    @GetMapping("/{bankId}")
    public AjaxResult getInfo(@PathVariable Long bankId)
    {
        return success(questionBankService.selectEduQuestionBankById(bankId));
    }

    /**
     * 新增题库
     */
    @PreAuthorize("@ss.hasPermi('edu:paper:add')")
    @Log(title = "题库管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody EduQuestionBank bank)
    {
        bank.setCreatorId(getUserId());
        bank.setCreateBy(getUsername());
        return toAjax(questionBankService.insertEduQuestionBank(bank));
    }

    /**
     * 修改题库
     */
    @PreAuthorize("@ss.hasPermi('edu:paper:edit')")
    @Log(title = "题库管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody EduQuestionBank bank)
    {
        bank.setUpdateBy(getUsername());
        return toAjax(questionBankService.updateEduQuestionBank(bank));
    }

    /**
     * 删除题库
     */
    @PreAuthorize("@ss.hasPermi('edu:paper:remove')")
    @Log(title = "题库管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{bankIds}")
    public AjaxResult remove(@PathVariable Long[] bankIds)
    {
        return toAjax(questionBankService.deleteEduQuestionBankByIds(bankIds));
    }
}
