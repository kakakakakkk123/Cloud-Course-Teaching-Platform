package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.exam.EduPaper;

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
}
