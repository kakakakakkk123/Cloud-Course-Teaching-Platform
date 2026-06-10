package com.ruoyi.system.service.impl;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.exam.EduPaper;
import com.ruoyi.system.domain.exam.EduPaperQuestion;
import com.ruoyi.system.domain.exam.EduQuestion;
import com.ruoyi.system.mapper.EduPaperMapper;
import com.ruoyi.system.mapper.EduQuestionMapper;
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

    @Autowired
    private EduQuestionMapper questionMapper;

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
            paperMapper.deletePaperQuestionByPaperId(paperId);
        }
        return paperMapper.deleteEduPaperByIds(paperIds);
    }

    @Override
    public List<EduPaperQuestion> selectPaperQuestions(Long paperId)
    {
        List<EduPaperQuestion> list = paperMapper.selectPaperQuestionsByPaperId(paperId);
        for (EduPaperQuestion pq : list)
        {
            pq.setQuestionTypeName(getQuestionTypeName(pq.getQuestionType()));
        }
        return list;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int savePaperQuestions(Long paperId, List<EduPaperQuestion> questions)
    {
        // 校验试卷存在并获取 bankId
        EduPaper paper = paperMapper.selectEduPaperById(paperId);
        if (paper == null)
        {
            throw new ServiceException("试卷不存在或已删除");
        }
        Long bankId = paper.getBankId();

        // 逐题从数据库校验：题目存在、属于当前题库、题型/难度以数据库为准
        int order = 1;
        for (EduPaperQuestion pq : questions)
        {
            Long qid = pq.getQuestionId();
            if (qid == null)
            {
                throw new ServiceException("组卷数据异常：题目ID不能为空");
            }
            EduQuestion question = questionMapper.selectEduQuestionById(qid);
            if (question == null)
            {
                throw new ServiceException("题目（ID=" + qid + "）不存在或已删除，请刷新后重试");
            }
            if (bankId != null && !bankId.equals(question.getBankId()))
            {
                throw new ServiceException("题目「" + question.getQuestionTitle() + "」不属于当前题库，无法加入试卷");
            }
            // 以数据库真实值为准，拒绝前端伪造
            pq.setPaperId(paperId);
            pq.setQuestionOrder(order++);
            pq.setQuestionType(question.getQuestionType());
            pq.setDifficultyLevel(question.getDifficultyLevel());
            if (pq.getQuestionScore() == null || pq.getQuestionScore().compareTo(BigDecimal.ZERO) <= 0)
            {
                pq.setQuestionScore(question.getScore() != null ? question.getScore() : BigDecimal.ZERO);
            }
        }
        paperMapper.deletePaperQuestionByPaperId(paperId);
        if (!questions.isEmpty())
        {
            paperMapper.batchInsertPaperQuestion(questions);
        }
        return paperMapper.updatePaperStats(paperId);
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
        if (StringUtils.isEmpty(paper.getComposeMode()))
        {
            paper.setComposeMode("1");
        }
        if (paper.getCourseIds() == null)
        {
            paper.setCourseIds(Collections.emptyList());
        }
    }

    /**
     * 题型编码 → 题型名称
     */
    private String getQuestionTypeName(String type)
    {
        if (type == null) return "未知";
        switch (type)
        {
            case "1": return "单选题";
            case "2": return "多选题";
            case "3": return "判断题";
            case "4": return "填空题";
            case "5": return "简答题";
            default:  return "未知";
        }
    }
}
