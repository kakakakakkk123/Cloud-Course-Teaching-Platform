package com.ruoyi.system.service.impl;

import java.util.Collections;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
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
        EduPaper paper = paperMapper.selectEduPaperById(paperId);
        if (paper != null)
        {
            paper.setCourseIds(paperMapper.selectCourseIdsByPaperId(paperId));
            paper.setCourseNames(paperMapper.selectCourseNamesByPaperId(paperId));
        }
        return paper;
    }

    @Override
    public List<EduPaper> selectEduPaperList(EduPaper paper)
    {
        List<EduPaper> list = paperMapper.selectEduPaperList(paper);
        // 回填多课程信息，为后续列表展示做准备
        for (EduPaper p : list)
        {
            p.setCourseIds(paperMapper.selectCourseIdsByPaperId(p.getPaperId()));
            p.setCourseNames(paperMapper.selectCourseNamesByPaperId(p.getPaperId()));
        }
        return list;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertEduPaper(EduPaper paper)
    {
        fillPaperDefaults(paper);
        int rows = paperMapper.insertEduPaper(paper);
        syncPaperCourses(paper);
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateEduPaper(EduPaper paper)
    {
        fillPaperDefaults(paper);
        int rows = paperMapper.updateEduPaper(paper);
        syncPaperCourses(paper);
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteEduPaperByIds(Long[] paperIds)
    {
        for (Long paperId : paperIds)
        {
            paperMapper.deletePaperCourseByPaperId(paperId);
        }
        return paperMapper.deleteEduPaperByIds(paperIds);
    }

    /**
     * 同步试卷关联课程，同时兼容旧版 course_id 字段
     */
    private void syncPaperCourses(EduPaper paper)
    {
        if (paper.getPaperId() == null)
        {
            return;
        }
        paperMapper.deletePaperCourseByPaperId(paper.getPaperId());
        List<Long> courseIds = paper.getCourseIds();
        if (courseIds == null || courseIds.isEmpty())
        {
            // 清空旧版 course_id，避免"通用试卷"仍被旧课程绑定
            paperMapper.updatePaperCourseId(paper.getPaperId(), null);
            return;
        }
        paperMapper.batchInsertPaperCourse(paper.getPaperId(), courseIds);
        // 同步旧版 course_id 字段，取第一个课程，兼容发布考试等旧链路
        paperMapper.updatePaperCourseId(paper.getPaperId(), courseIds.get(0));
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
        if (paper.getCourseIds() == null)
        {
            paper.setCourseIds(Collections.emptyList());
        }
    }
}
