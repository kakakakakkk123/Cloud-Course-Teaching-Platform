package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.exam.EduQuestion;

/**
 * 试题服务层
 *
 * @author ruoyi
 */
public interface IEduQuestionService
{
    public EduQuestion selectEduQuestionById(Long questionId);

    public List<EduQuestion> selectEduQuestionList(EduQuestion question);

    public int insertEduQuestion(EduQuestion question);

    public int updateEduQuestion(EduQuestion question);

    public int deleteEduQuestionByIds(Long[] questionIds);

    /**
     * 批量导入试题（Excel 解析 + 逐题校验 + 事务批量插入）
     *
     * @param file   Excel 文件
     * @param bankId 目标题库ID
     * @return 成功导入数量
     */
    public int batchImportQuestions(java.io.InputStream inputStream, String originalFilename, Long bankId);
}
