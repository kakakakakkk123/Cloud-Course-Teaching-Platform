package com.ruoyi.system.service.impl;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.alibaba.fastjson2.JSON;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.exam.EduQuestion;
import com.ruoyi.system.domain.exam.EduQuestionOption;
import com.ruoyi.system.mapper.EduPaperMapper;
import com.ruoyi.system.mapper.EduQuestionMapper;
import com.ruoyi.system.service.IEduQuestionBankService;
import com.ruoyi.system.service.IEduQuestionService;

/**
 * 试题服务实现
 *
 * @author ruoyi
 */
@Service
public class EduQuestionServiceImpl implements IEduQuestionService
{
    @Autowired
    private EduQuestionMapper questionMapper;

    @Autowired
    private IEduQuestionBankService bankService;

    @Autowired
    private EduPaperMapper paperMapper;

    /**
     * 查询试题
     */
    @Override
    public EduQuestion selectEduQuestionById(Long questionId)
    {
        EduQuestion question = questionMapper.selectEduQuestionById(questionId);
        if (StringUtils.isNotNull(question))
        {
            question.setOptionList(questionMapper.selectOptionListByQuestionId(questionId));
            question.setAnswerText(question.getAnswerJson());
        }
        return question;
    }

    /**
     * 查询试题列表
     */
    @Override
    public List<EduQuestion> selectEduQuestionList(EduQuestion question)
    {
        return questionMapper.selectEduQuestionList(question);
    }

    /**
     * 新增试题
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertEduQuestion(EduQuestion question)
    {
        assertQuestionBankValid(question.getBankId());
        fillQuestionDefaults(question);
        question.setAnswerJson(buildAnswerJson(question));
        int rows = questionMapper.insertEduQuestion(question);
        syncOptions(question);
        return rows;
    }

    /**
     * 修改试题
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateEduQuestion(EduQuestion question)
    {
        assertQuestionBankValid(question.getBankId());
        fillQuestionDefaults(question);
        question.setAnswerJson(buildAnswerJson(question));
        int rows = questionMapper.updateEduQuestion(question);
        syncOptions(question);
        return rows;
    }

    /**
     * 删除试题
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteEduQuestionByIds(Long[] questionIds)
    {
        // 检查是否有试卷引用这些试题
        int refCount = paperMapper.countPaperRefByQuestionIds(questionIds);
        if (refCount > 0)
        {
            throw new ServiceException("所选试题中有 " + refCount + " 份试卷正在使用，请先从试卷中移除后再删除");
        }
        for (Long questionId : questionIds)
        {
            questionMapper.deleteOptionByQuestionId(questionId);
        }
        return questionMapper.deleteEduQuestionByIds(questionIds);
    }

    /**
     * 同步试题选项
     */
    private void syncOptions(EduQuestion question)
    {
        if (StringUtils.isNull(question.getQuestionId()))
        {
            return;
        }
        questionMapper.deleteOptionByQuestionId(question.getQuestionId());
        if (StringUtils.isEmpty(question.getOptionList()))
        {
            return;
        }
        List<EduQuestionOption> optionList = new ArrayList<>();
        int index = 0;
        for (EduQuestionOption option : question.getOptionList())
        {
            if (StringUtils.isEmpty(option.getOptionContent()))
            {
                continue;
            }
            option.setQuestionId(question.getQuestionId());
            option.setSortOrder(index++);
            optionList.add(option);
        }
        if (!optionList.isEmpty())
        {
            questionMapper.batchInsertOption(optionList);
        }
    }

    /**
     * 组装标准答案
     */
    private String buildAnswerJson(EduQuestion question)
    {
        if (StringUtils.isNotEmpty(question.getAnswerText()))
        {
            return question.getAnswerText();
        }
        if (StringUtils.isEmpty(question.getOptionList()))
        {
            return "";
        }
        List<String> answers = new ArrayList<>();
        for (EduQuestionOption option : question.getOptionList())
        {
            if ("1".equals(option.getIsCorrect()))
            {
                answers.add(option.getOptionLabel());
            }
        }
        return JSON.toJSONString(answers);
    }

    /**
     * 填充试题默认值
     */
    private void fillQuestionDefaults(EduQuestion question)
    {
        if (StringUtils.isEmpty(question.getDifficultyLevel()))
        {
            question.setDifficultyLevel("2");
        }
        if (StringUtils.isEmpty(question.getAutoMarking()))
        {
            question.setAutoMarking(questionTypeNeedsManualMarking(question.getQuestionType()) ? "0" : "1");
        }
        if (StringUtils.isEmpty(question.getStatus()))
        {
            question.setStatus("0");
        }
        if (question.getScore() == null || question.getScore().compareTo(BigDecimal.ZERO) <= 0)
        {
            question.setScore(getDefaultScoreByType(question.getQuestionType()));
        }
    }

    /**
     * 题型对应默认分值
     */
    private BigDecimal getDefaultScoreByType(String type)
    {
        switch (type)
        {
            case "1": return BigDecimal.valueOf(2);  // 单选题
            case "2": return BigDecimal.valueOf(3);  // 多选题
            case "3": return BigDecimal.valueOf(2);  // 判断题
            case "4": return BigDecimal.valueOf(3);  // 填空题
            case "5": return BigDecimal.valueOf(10); // 简答题
            default:  return BigDecimal.valueOf(5);
        }
    }

    /**
     * 该题型是否需要人工判分
     */
    private boolean questionTypeNeedsManualMarking(String type)
    {
        return "5".equals(type);
    }

    /**
     * 校验题库存在且可用，防止题目挂到不存在的题库
     */
    private void assertQuestionBankValid(Long bankId)
    {
        if (bankId == null)
        {
            throw new ServiceException("所属题库不能为空");
        }
        if (bankService.selectEduQuestionBankById(bankId) == null)
        {
            throw new ServiceException("所属题库不存在或已删除");
        }
    }

    // ==================== 批量导入 ====================

    private static final Map<String, String> TYPE_NAME_TO_CODE = new HashMap<>();
    private static final Map<String, String> DIFF_NAME_TO_CODE = new HashMap<>();
    static
    {
        TYPE_NAME_TO_CODE.put("单选题", "1");
        TYPE_NAME_TO_CODE.put("多选题", "2");
        TYPE_NAME_TO_CODE.put("判断题", "3");
        TYPE_NAME_TO_CODE.put("填空题", "4");
        TYPE_NAME_TO_CODE.put("简答题", "5");

        DIFF_NAME_TO_CODE.put("简单", "1");
        DIFF_NAME_TO_CODE.put("中等", "2");
        DIFF_NAME_TO_CODE.put("困难", "3");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int batchImportQuestions(InputStream inputStream, String originalFilename, Long bankId)
    {
        assertQuestionBankValid(bankId);

        List<EduQuestion> questions;
        try (Workbook workbook = WorkbookFactory.create(inputStream))
        {
            questions = parseExcel(workbook, bankId);
        }
        catch (IOException e)
        {
            throw new ServiceException("Excel 文件读取失败：" + e.getMessage());
        }

        if (questions.isEmpty())
        {
            throw new ServiceException("Excel 中没有有效的题目数据，请检查模板");
        }

        int count = 0;
        for (EduQuestion q : questions)
        {
            insertEduQuestion(q);
            count++;
        }
        return count;
    }

    /**
     * 解析 Excel 为题目列表，全部校验通过后才返回，否则抛异常附带行号
     */
    private List<EduQuestion> parseExcel(Workbook workbook, Long bankId)
    {
        Sheet sheet = workbook.getSheetAt(0);
        if (sheet == null || sheet.getPhysicalNumberOfRows() < 2)
        {
            throw new ServiceException("Excel 没有数据行，请按模板填写");
        }

        List<EduQuestion> list = new ArrayList<>();
        StringBuilder errors = new StringBuilder();

        for (int i = 1; i <= sheet.getLastRowNum(); i++)
        {
            Row row = sheet.getRow(i);
            if (row == null) continue;

            // 跳过全空行
            if (isRowEmpty(row)) continue;

            try
            {
                EduQuestion q = parseRow(row, bankId);
                if (q != null)
                {
                    list.add(q);
                }
            }
            catch (Exception e)
            {
                errors.append("第").append(i + 1).append("行：").append(e.getMessage()).append("；\n");
            }
        }

        if (errors.length() > 0)
        {
            throw new ServiceException("导入数据校验未通过：\n" + errors.toString().trim());
        }
        return list;
    }

    private EduQuestion parseRow(Row row, Long bankId)
    {
        String typeName = getCellString(row, 0);
        String title = getCellString(row, 1);
        String optionsStr = getCellString(row, 2);
        String answer = getCellString(row, 3);
        String diffName = getCellString(row, 4);
        double scoreVal = getCellDouble(row, 5);
        String analysis = getCellString(row, 6);

        // 必填校验
        if (StringUtils.isEmpty(typeName))
            throw new ServiceException("题型不能为空");
        if (StringUtils.isEmpty(title))
            throw new ServiceException("题干不能为空");

        String questionType = TYPE_NAME_TO_CODE.get(typeName.trim());
        if (questionType == null)
            throw new ServiceException("题型「" + typeName + "」不合法，应为：单选题/多选题/判断题/填空题/简答题");

        String difficultyLevel = DIFF_NAME_TO_CODE.getOrDefault(diffName != null ? diffName.trim() : "", "2");

        EduQuestion q = new EduQuestion();
        q.setBankId(bankId);
        q.setQuestionType(questionType);
        q.setQuestionTitle(title.trim());
        q.setDifficultyLevel(difficultyLevel);
        q.setScore(BigDecimal.valueOf(scoreVal > 0 ? scoreVal : getDefaultScoreByType(questionType).doubleValue()));
        q.setAnalysis(StringUtils.defaultIfEmpty(analysis, ""));
        q.setStatus("0");

        // 解析选项和答案
        List<EduQuestionOption> optionList = new ArrayList<>();
        if ("1".equals(questionType) || "2".equals(questionType))
        {
            // 选择题：选项用 | 分隔
            if (StringUtils.isEmpty(optionsStr))
                throw new ServiceException("选择题必须填写选项（用 | 分隔）");
            if (StringUtils.isEmpty(answer))
                throw new ServiceException("选择题必须填写正确答案");

            String[] parts = optionsStr.split("\\|");
            java.util.Set<String> correctLabels = new java.util.HashSet<>();
            for (String a : answer.split("[,，]"))
            {
                correctLabels.add(a.trim().toUpperCase());
            }

            char label = 'A';
            for (String part : parts)
            {
                String optText = part.trim();
                if (optText.isEmpty()) continue;
                // 去掉可能的前缀 "A." "A、" 等
                optText = optText.replaceFirst("^[A-Za-z][.、]\\s*", "");

                EduQuestionOption option = new EduQuestionOption();
                option.setOptionLabel(String.valueOf(label));
                option.setOptionContent(optText);
                option.setIsCorrect(correctLabels.contains(String.valueOf(label)) ? "1" : "0");
                optionList.add(option);
                label++;
            }
            if (optionList.isEmpty())
                throw new ServiceException("选项解析后为空");

            q.setOptionList(optionList);
            q.setAutoMarking("1");
        }
        else if ("3".equals(questionType))
        {
            // 判断题：默认正确/错误选项
            String isCorrect = "正确".equals(answer) || "对".equals(answer) ? "1" : "0";
            EduQuestionOption optA = new EduQuestionOption();
            optA.setOptionLabel("A");
            optA.setOptionContent("正确");
            optA.setIsCorrect("1".equals(isCorrect) ? "1" : "0");
            optionList.add(optA);
            EduQuestionOption optB = new EduQuestionOption();
            optB.setOptionLabel("B");
            optB.setOptionContent("错误");
            optB.setIsCorrect("1".equals(isCorrect) ? "0" : "1");
            optionList.add(optB);
            q.setOptionList(optionList);
            q.setAutoMarking("1");
        }
        else
        {
            // 填空、简答：答案存为文本
            q.setAnswerText(StringUtils.defaultIfEmpty(answer, ""));
            q.setAutoMarking("5".equals(questionType) ? "0" : "1");
        }

        return q;
    }

    private String getCellString(Row row, int col)
    {
        Cell cell = row.getCell(col);
        if (cell == null) return null;
        cell.setCellType(CellType.STRING);
        return cell.getStringCellValue();
    }

    private double getCellDouble(Row row, int col)
    {
        Cell cell = row.getCell(col);
        if (cell == null) return 0;
        if (cell.getCellType() == CellType.NUMERIC)
            return cell.getNumericCellValue();
        try
        {
            return Double.parseDouble(cell.getStringCellValue().trim());
        }
        catch (Exception e)
        {
            return 0;
        }
    }

    private boolean isRowEmpty(Row row)
    {
        for (int c = 0; c < 7; c++)
        {
            Cell cell = row.getCell(c);
            if (cell != null && cell.getCellType() != CellType.BLANK
                && StringUtils.isNotEmpty(cell.toString().trim()))
                return false;
        }
        return true;
    }
}
