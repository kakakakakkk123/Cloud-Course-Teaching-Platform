package com.ruoyi.web.controller.exam;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.file.FileUtils;
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

    /**
     * 下载导入模板（真实 .xlsx）
     */
    @PreAuthorize("@ss.hasPermi('edu:question:query')")
    @RequestMapping(value = "/import/template", method = {RequestMethod.GET, RequestMethod.POST})
    public void downloadTemplate(HttpServletResponse response) throws IOException
    {
        try (XSSFWorkbook workbook = new XSSFWorkbook())
        {
            Sheet sheet = workbook.createSheet("试题导入模板");
            // 表头样式
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);

            // 表头
            String[] headers = {"题型", "题干", "选项", "正确答案", "难度", "分值", "答案解析"};
            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++)
            {
                org.apache.poi.ss.usermodel.Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // 示例数据
            Object[][] examples = {
                {"单选题", "中国的首都是哪里？", "北京|上海|广州|深圳", "A", "简单", 2, "北京是中华人民共和国的首都"},
                {"多选题", "以下哪些是哺乳动物？", "狗|猫|蛇|鲸鱼", "A,B,D", "中等", 3, ""},
                {"判断题", "地球是圆的。", "", "正确", "简单", 2, ""},
                {"填空题", "水的化学式是？", "", "H₂O", "中等", 3, ""},
                {"简答题", "请简述光合作用的过程。", "", "（参考答案略）", "困难", 10, ""},
            };
            for (int r = 0; r < examples.length; r++)
            {
                Row row = sheet.createRow(r + 1);
                Object[] vals = examples[r];
                for (int c = 0; c < vals.length; c++)
                {
                    org.apache.poi.ss.usermodel.Cell cell = row.createCell(c);
                    if (vals[c] instanceof Number)
                    {
                        cell.setCellValue(((Number) vals[c]).doubleValue());
                    }
                    else
                    {
                        cell.setCellValue(vals[c] != null ? vals[c].toString() : "");
                    }
                }
            }

            // 设置列宽
            for (int i = 0; i < headers.length; i++)
            {
                sheet.setColumnWidth(i, 18 * 256);
            }

            response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE);
            FileUtils.setAttachmentResponseHeader(response, "试题导入模板.xlsx");
            workbook.write(response.getOutputStream());
        }
    }

    /**
     * 批量导入试题（Excel）
     */
    @PreAuthorize("@ss.hasPermi('edu:question:add')")
    @Log(title = "试题批量导入", businessType = BusinessType.IMPORT)
    @PostMapping("/import")
    public AjaxResult importQuestions(@RequestParam("file") MultipartFile file, @RequestParam("bankId") Long bankId)
    {
        if (file == null || file.isEmpty())
        {
            return error("上传文件不能为空");
        }
        try
        {
            int count = questionService.batchImportQuestions(file.getInputStream(), file.getOriginalFilename(), bankId);
            return success("成功导入 " + count + " 道试题");
        }
        catch (Exception e)
        {
            return error(e.getMessage());
        }
    }
}
