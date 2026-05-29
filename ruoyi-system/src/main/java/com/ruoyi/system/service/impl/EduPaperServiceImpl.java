package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.exam.EduPaper;
import com.ruoyi.system.mapper.EduPaperMapper;
import com.ruoyi.system.service.IEduPaperService;

/**
 * 试卷服务实现
 *
 * @author ruoyi
 */
@Service
public class EduPaperServiceImpl implements IEduPaperService
{
    @Autowired
    private EduPaperMapper paperMapper;

    @Override
    public EduPaper selectEduPaperById(Long paperId)
    {
        return paperMapper.selectEduPaperById(paperId);
    }

    @Override
    public List<EduPaper> selectEduPaperList(EduPaper paper)
    {
        return paperMapper.selectEduPaperList(paper);
    }

    @Override
    public int insertEduPaper(EduPaper paper)
    {
        fillPaperDefaults(paper);
        return paperMapper.insertEduPaper(paper);
    }

    @Override
    public int updateEduPaper(EduPaper paper)
    {
        fillPaperDefaults(paper);
        return paperMapper.updateEduPaper(paper);
    }

    @Override
    public int deleteEduPaperByIds(Long[] paperIds)
    {
        return paperMapper.deleteEduPaperByIds(paperIds);
    }

    /**
     * 填充试卷默认值
     */
    private void fillPaperDefaults(EduPaper paper)
    {
        if (StringUtils.isEmpty(paper.getStatus()))
        {
            paper.setStatus("0");
        }
    }
}
