package com.ruoyi.web.controller.exam;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.exam.EduExamRecord;
import com.ruoyi.system.domain.exam.EduExamReviewSubmitBody;
import com.ruoyi.system.service.IEduExamStatService;

/**
 * 考试统计
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/edu/exam/stat")
public class EduExamStatController extends BaseController
{
    @Autowired
    private IEduExamStatService examStatService;

    /**
     * 查询考试统计概览
     */
    @PreAuthorize("@ss.hasPermi('edu:score:list')")
    @GetMapping("/overview/{examId}")
    public AjaxResult getOverview(@PathVariable Long examId)
    {
        return success(examStatService.selectExamStatOverview(examId));
    }

    /**
     * 查询考试成绩列表
     */
    @PreAuthorize("@ss.hasPermi('edu:score:list')")
    @GetMapping("/record/list")
    public TableDataInfo listRecord(EduExamRecord record)
    {
        startPage();
        List<EduExamRecord> list = examStatService.selectExamStatRecordList(record);
        return getDataTable(list);
    }

    /**
     * 导出考试成绩
     */
    @Log(title = "成绩统计", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('edu:score:list')")
    @PostMapping("/record/export")
    public void export(HttpServletResponse response, EduExamRecord record)
    {
        List<EduExamRecord> list = examStatService.selectExamStatRecordList(record);
        ExcelUtil<EduExamRecord> util = new ExcelUtil<EduExamRecord>(EduExamRecord.class);
        util.exportExcel(response, list, "考试成绩数据");
    }

    /**
     * 查询考试批改详情
     */
    @PreAuthorize("@ss.hasPermi('edu:score:list')")
    @GetMapping("/review/{recordId}")
    public AjaxResult getReviewDetail(@PathVariable Long recordId)
    {
        return success(examStatService.selectExamReviewDetail(recordId));
    }

    /**
     * 保存或完成考试批改
     */
    @PreAuthorize("@ss.hasPermi('edu:score:list')")
    @PostMapping("/review/{recordId}")
    public AjaxResult submitReview(@PathVariable Long recordId, @RequestBody EduExamReviewSubmitBody body)
    {
        examStatService.submitExamReview(recordId, body, SecurityUtils.getUserId(), SecurityUtils.getUsername());
        return success();
    }
}
