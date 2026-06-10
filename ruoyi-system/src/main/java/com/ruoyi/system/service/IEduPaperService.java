package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.exam.EduPaper;
import com.ruoyi.system.domain.exam.EduPaperQuestion;

/**
 * 试卷服务层
 *
 * @author ruoyi
 */
public interface IEduPaperService
{
    public EduPaper selectEduPaperById(Long paperId);

    public List<EduPaper> selectEduPaperList(EduPaper paper);

    public int insertEduPaper(EduPaper paper);

    public int updateEduPaper(EduPaper paper);

    public int deleteEduPaperByIds(Long[] paperIds);

    /**
     * 查询试卷下的题目列表（含题目详情）
     *
     * @param paperId 试卷ID
     * @return 题目关联列表
     */
    public List<EduPaperQuestion> selectPaperQuestions(Long paperId);

    /**
     * 保存试卷题目（全量替换：先删后插），并自动更新试卷统计
     *
     * @param paperId   试卷ID
     * @param questions 题目关联列表
     * @return 结果
     */
    public int savePaperQuestions(Long paperId, List<EduPaperQuestion> questions);
}
