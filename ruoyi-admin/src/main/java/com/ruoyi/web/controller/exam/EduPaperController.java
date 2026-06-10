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
import com.ruoyi.system.domain.exam.EduPaper;
import com.ruoyi.system.domain.exam.EduPaperQuestion;
import com.ruoyi.system.service.IEduPaperService;

/**
 * 试卷管理
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/edu/exam/paper")
public class EduPaperController extends BaseController
{
    @Autowired
    private IEduPaperService paperService;

    /**
     * 查询试卷列表
     */
    @PreAuthorize("@ss.hasPermi('edu:paper:list')")
    @GetMapping("/list")
    public TableDataInfo list(EduPaper paper)
    {
        startPage();
        if (SecurityUtils.hasRole("teacher") && !SecurityUtils.isAdmin())
        {
            paper.setCreatorId(getUserId());
        }
        List<EduPaper> list = paperService.selectEduPaperList(paper);
        return getDataTable(list);
    }

    /**
     * 查询试卷详情
     */
    @PreAuthorize("@ss.hasPermi('edu:paper:query')")
    @GetMapping("/{paperId}")
    public AjaxResult getInfo(@PathVariable Long paperId)
    {
        return success(paperService.selectEduPaperById(paperId));
    }

    /**
     * 新增试卷
     */
    @PreAuthorize("@ss.hasPermi('edu:paper:add')")
    @Log(title = "试卷管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody EduPaper paper)
    {
        paper.setCreatorId(getUserId());
        paper.setCreateBy(getUsername());
        return toAjax(paperService.insertEduPaper(paper));
    }

    /**
     * 修改试卷
     */
    @PreAuthorize("@ss.hasPermi('edu:paper:edit')")
    @Log(title = "试卷管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody EduPaper paper)
    {
        paper.setUpdateBy(getUsername());
        return toAjax(paperService.updateEduPaper(paper));
    }

    /**
     * 删除试卷
     */
    @PreAuthorize("@ss.hasPermi('edu:paper:remove')")
    @Log(title = "试卷管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{paperIds}")
    public AjaxResult remove(@PathVariable Long[] paperIds)
    {
        return toAjax(paperService.deleteEduPaperByIds(paperIds));
    }

    /**
     * 查询试卷题目列表
     */
    @PreAuthorize("@ss.hasPermi('edu:paper:query')")
    @GetMapping("/{paperId}/questions")
    public AjaxResult getQuestions(@PathVariable Long paperId)
    {
        List<EduPaperQuestion> list = paperService.selectPaperQuestions(paperId);
        return success(list);
    }

    /**
     * 保存试卷题目（组卷）
     */
    @PreAuthorize("@ss.hasPermi('edu:paper:edit')")
    @Log(title = "试卷组卷", businessType = BusinessType.UPDATE)
    @PutMapping("/{paperId}/questions")
    public AjaxResult saveQuestions(@PathVariable Long paperId, @RequestBody List<EduPaperQuestion> questions)
    {
        paperService.savePaperQuestions(paperId, questions);
        return success();
    }
}
