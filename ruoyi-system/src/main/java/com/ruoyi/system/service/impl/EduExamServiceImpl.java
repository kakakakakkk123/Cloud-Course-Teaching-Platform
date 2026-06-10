package com.ruoyi.system.service.impl;

import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.course.EduCourseContent;
import com.ruoyi.system.domain.exam.EduExam;
import com.ruoyi.system.domain.exam.EduPaper;
import com.ruoyi.system.mapper.EduCourseContentMapper;
import com.ruoyi.system.mapper.EduExamMapper;
import com.ruoyi.system.mapper.EduPaperMapper;
import com.ruoyi.system.service.IEduCourseService;
import com.ruoyi.system.service.IEduExamService;

/**
 * 考试服务实现
 */
@Service
public class EduExamServiceImpl implements IEduExamService
{
    @Autowired
    private EduExamMapper examMapper;

    @Autowired
    private EduCourseContentMapper courseContentMapper;

    @Autowired
    private IEduCourseService courseService;

    @Autowired
    private EduPaperMapper paperMapper;

    @Override
    public EduExam selectEduExamById(Long examId)
    {
        EduExam exam = examMapper.selectEduExamById(examId);
        if (exam != null)
        {
            exam.setCourseIds(examMapper.selectCourseIdsByExamId(examId));
            exam.setCourseNames(examMapper.selectCourseNamesByExamId(examId));
        }
        return exam;
    }

    @Override
    public List<EduExam> selectEduExamList(EduExam exam)
    {
        List<EduExam> list = examMapper.selectEduExamList(exam);
        for (EduExam e : list)
        {
            e.setCourseIds(examMapper.selectCourseIdsByExamId(e.getExamId()));
            e.setCourseNames(examMapper.selectCourseNamesByExamId(e.getExamId()));
        }
        return list;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertEduExam(EduExam exam)
    {
        fillExamDefaults(exam);
        assertPaperNotEmpty(exam.getPaperId());
        applyCourseIdFromCourseIds(exam);
        int rows = examMapper.insertEduExam(exam);
        syncExamCourses(exam);
        syncCourseExamContent(exam, true);
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateEduExam(EduExam exam)
    {
        fillExamDefaults(exam);
        assertPaperNotEmpty(exam.getPaperId());
        applyCourseIdFromCourseIds(exam);
        List<Long> oldCourseIds = examMapper.selectCourseIdsByExamId(exam.getExamId());
        int rows = examMapper.updateEduExam(exam);
        syncExamCourses(exam);
        EduExam latest = examMapper.selectEduExamById(exam.getExamId());
        if (latest != null)
        {
            latest.setSyncCourseContent(exam.getSyncCourseContent());
            latest.setCreateBy(exam.getCreateBy());
            latest.setUpdateBy(exam.getUpdateBy());
        }
        syncCourseExamContent(latest != null ? latest : exam, false);
        // 清理已移除课程的考试内容记录，避免孤儿数据
        cleanupOrphanExamContent(exam.getExamId(), oldCourseIds);
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteEduExamByIds(Long[] examIds)
    {
        for (Long examId : examIds)
        {
            examMapper.deleteExamCourseByExamId(examId);
        }
        return examMapper.deleteEduExamByIds(examIds);
    }

    /**
     * 从前端传入的 courseIds 中取出第一个作为旧版 course_id，保证兼容
     */
    private void applyCourseIdFromCourseIds(EduExam exam)
    {
        List<Long> courseIds = exam.getCourseIds();
        if (courseIds != null && !courseIds.isEmpty())
        {
            exam.setCourseId(courseIds.get(0));
        }
    }

    /**
     * 同步考试多课程关联表
     */
    private void syncExamCourses(EduExam exam)
    {
        if (exam.getExamId() == null)
        {
            return;
        }
        examMapper.deleteExamCourseByExamId(exam.getExamId());
        List<Long> courseIds = exam.getCourseIds();
        if (courseIds != null && !courseIds.isEmpty())
        {
            examMapper.batchInsertExamCourse(exam.getExamId(), courseIds);
        }
    }

    private void syncCourseExamContent(EduExam exam, boolean isInsert)
    {
        if (exam == null || exam.getExamId() == null || !"1".equals(exam.getSyncCourseContent()))
        {
            return;
        }
        // 收集所有需要同步的课程
        java.util.Set<Long> courseIds = new java.util.LinkedHashSet<>();
        if (exam.getCourseIds() != null)
        {
            courseIds.addAll(exam.getCourseIds());
        }
        if (exam.getCourseId() != null)
        {
            courseIds.add(exam.getCourseId());
        }
        for (Long courseId : courseIds)
        {
            syncSingleCourseExamContent(exam, courseId);
        }
    }

    private void syncSingleCourseExamContent(EduExam exam, Long courseId)
    {
        if (courseId == null) return;

        EduCourseContent existing = courseContentMapper.selectExamContentByCourseIdAndExamId(courseId, exam.getExamId());
        if (!"1".equals(exam.getStatus()))
        {
            if (existing != null)
            {
                existing.setPublishStatus("0");
                existing.setUpdateBy(StringUtils.defaultString(exam.getUpdateBy(), exam.getCreateBy()));
                courseContentMapper.updateEduCourseContent(existing);
                courseService.refreshCourseContentStats(existing.getCourseId());
            }
            return;
        }

        if (existing == null)
        {
            EduCourseContent content = new EduCourseContent();
            content.setCourseId(courseId);
            content.setContentTitle(exam.getExamName());
            content.setContentType("5");
            content.setSourceType("1");
            content.setSummary(StringUtils.defaultIfEmpty(exam.getExamNotice(), "点击进入考试，按要求完成本次作答。"));
            content.setContentBody(StringUtils.defaultString(exam.getExamNotice()));
            content.setDurationSeconds(defaultDurationSeconds(exam.getDurationMinutes()));
            content.setExamId(exam.getExamId());
            content.setIsPreview("0");
            content.setSortOrder(defaultSortOrder(courseId));
            content.setPublishStatus("1");
            content.setCreateBy(exam.getCreateBy());
            courseContentMapper.insertEduCourseContent(content);
            courseService.refreshCourseContentStats(content.getCourseId());
            return;
        }

        existing.setContentTitle(exam.getExamName());
        existing.setSummary(StringUtils.defaultIfEmpty(exam.getExamNotice(), "点击进入考试，按要求完成本次作答。"));
        existing.setContentBody(StringUtils.defaultString(exam.getExamNotice()));
        existing.setDurationSeconds(defaultDurationSeconds(exam.getDurationMinutes()));
        existing.setPublishStatus("1");
        existing.setUpdateBy(StringUtils.defaultString(exam.getUpdateBy(), exam.getCreateBy()));
        courseContentMapper.updateEduCourseContent(existing);
        courseService.refreshCourseContentStats(existing.getCourseId());
    }

    /**
     * 清理已移除课程的考试内容记录
     * 更新考试关联课程时，将不再绑定的课程的考试内容标记为下架
     */
    private void cleanupOrphanExamContent(Long examId, List<Long> oldCourseIds)
    {
        if (examId == null || oldCourseIds == null || oldCourseIds.isEmpty())
        {
            return;
        }
        List<Long> newCourseIds = examMapper.selectCourseIdsByExamId(examId);
        Set<Long> newSet = new HashSet<>(newCourseIds != null ? newCourseIds : Collections.emptyList());
        for (Long oldCourseId : oldCourseIds)
        {
            if (!newSet.contains(oldCourseId))
            {
                EduCourseContent existing = courseContentMapper.selectExamContentByCourseIdAndExamId(oldCourseId, examId);
                if (existing != null && "1".equals(existing.getPublishStatus()))
                {
                    existing.setPublishStatus("0");
                    existing.setUpdateBy(SecurityUtils.getUsername());
                    courseContentMapper.updateEduCourseContent(existing);
                    courseService.refreshCourseContentStats(oldCourseId);
                }
            }
        }
    }

    private int defaultDurationSeconds(Integer minutes)
    {
        return minutes == null || minutes <= 0 ? 0 : minutes * 60;
    }

    /**
     * 校验试卷是否已组卷（至少包含一道题目），防止空试卷发布考试
     */
    private void assertPaperNotEmpty(Long paperId)
    {
        if (paperId == null)
        {
            throw new ServiceException("考试必须绑定试卷");
        }
        EduPaper paper = paperMapper.selectEduPaperById(paperId);
        if (paper == null)
        {
            throw new ServiceException("试卷不存在或已删除");
        }
        if (paper.getQuestionCount() == null || paper.getQuestionCount() <= 0)
        {
            throw new ServiceException("试卷「" + paper.getPaperName() + "」尚未组卷，请先添加题目后再发布考试");
        }
    }

    private int defaultSortOrder(Long courseId)
    {
        Integer sortOrder = courseContentMapper.selectMaxSortOrderByCourseId(courseId);
        return (sortOrder == null ? 0 : sortOrder) + 1;
    }

    private void fillExamDefaults(EduExam exam)
    {
        if (StringUtils.isEmpty(exam.getAllowInterrupt()))
        {
            exam.setAllowInterrupt("0");
        }
        if (StringUtils.isEmpty(exam.getInterruptKeepTiming()))
        {
            exam.setInterruptKeepTiming("1");
        }
        if (StringUtils.isEmpty(exam.getShowAnswerAfterSubmit()))
        {
            exam.setShowAnswerAfterSubmit("0");
        }
        if (StringUtils.isEmpty(exam.getShowScoreAfterSubmit()))
        {
            exam.setShowScoreAfterSubmit("1");
        }
        if (StringUtils.isEmpty(exam.getQuestionShuffle()))
        {
            exam.setQuestionShuffle("0");
        }
        if (StringUtils.isEmpty(exam.getOptionShuffle()))
        {
            exam.setOptionShuffle("0");
        }
        if (StringUtils.isEmpty(exam.getStatus()))
        {
            exam.setStatus("0");
        }
        if (StringUtils.isEmpty(exam.getSyncCourseContent()))
        {
            exam.setSyncCourseContent("1");
        }
    }
}
