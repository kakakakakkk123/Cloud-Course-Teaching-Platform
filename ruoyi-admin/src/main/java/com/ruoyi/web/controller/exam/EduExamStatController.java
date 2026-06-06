package com.ruoyi.web.controller.exam;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.system.domain.exam.EduExamRecord;
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
}
