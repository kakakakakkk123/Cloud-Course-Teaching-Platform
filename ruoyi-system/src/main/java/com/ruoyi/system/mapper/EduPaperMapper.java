package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.exam.EduPaper;

/**
 * 试卷数据层
 *
 * @author ruoyi
 */
public interface EduPaperMapper
{
    /**
     * 查询试卷
     *
     * @param paperId 试卷ID
     * @return 试卷
     */
    public EduPaper selectEduPaperById(Long paperId);

    /**
     * 查询试卷列表
     *
     * @param paper 试卷
     * @return 试卷集合
     */
    public List<EduPaper> selectEduPaperList(EduPaper paper);

    /**
     * 新增试卷
     *
     * @param paper 试卷
     * @return 结果
     */
    public int insertEduPaper(EduPaper paper);

    /**
     * 修改试卷
     *
     * @param paper 试卷
     * @return 结果
     */
    public int updateEduPaper(EduPaper paper);

    /**
     * 逻辑删除试卷
     *
     * @param paperIds 试卷ID数组
     * @return 结果
     */
    public int deleteEduPaperByIds(Long[] paperIds);
}
