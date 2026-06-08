package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.course.EduCourseContent;
import com.ruoyi.system.domain.exam.EduExam;
import com.ruoyi.system.mapper.EduCourseContentMapper;
import com.ruoyi.system.mapper.EduExamMapper;
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

    @Override
    public EduExam selectEduExamById(Long examId)
    {
        return examMapper.selectEduExamById(examId);
    }

    @Override
    public List<EduExam> selectEduExamList(EduExam exam)
    {
        return examMapper.selectEduExamList(exam);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertEduExam(EduExam exam)
    {
        fillExamDefaults(exam);
        int rows = examMapper.insertEduExam(exam);
        syncCourseExamContent(exam, true);
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateEduExam(EduExam exam)
    {
        fillExamDefaults(exam);
        int rows = examMapper.updateEduExam(exam);
        EduExam latest = examMapper.selectEduExamById(exam.getExamId());
        if (latest != null)
        {
            latest.setSyncCourseContent(exam.getSyncCourseContent());
            latest.setCreateBy(exam.getCreateBy());
            latest.setUpdateBy(exam.getUpdateBy());
        }
        syncCourseExamContent(latest != null ? latest : exam, false);
        return rows;
    }

    @Override
    public int deleteEduExamByIds(Long[] examIds)
    {
        return examMapper.deleteEduExamByIds(examIds);
    }

    private void syncCourseExamContent(EduExam exam, boolean isInsert)
    {
        if (exam == null || exam.getCourseId() == null || exam.getExamId() == null || !"1".equals(exam.getSyncCourseContent()))
        {
            return;
        }

        EduCourseContent existing = courseContentMapper.selectExamContentByCourseIdAndExamId(exam.getCourseId(), exam.getExamId());
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
            content.setCourseId(exam.getCourseId());
            content.setContentTitle(exam.getExamName());
            content.setContentType("5");
            content.setSourceType("1");
            content.setSummary(StringUtils.defaultIfEmpty(exam.getExamNotice(), "点击进入考试，按要求完成本次作答。"));
            content.setContentBody(StringUtils.defaultString(exam.getExamNotice()));
            content.setDurationSeconds(defaultDurationSeconds(exam.getDurationMinutes()));
            content.setExamId(exam.getExamId());
            content.setIsPreview("0");
            content.setSortOrder(defaultSortOrder(exam.getCourseId()));
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

    private int defaultDurationSeconds(Integer minutes)
    {
        return minutes == null || minutes <= 0 ? 0 : minutes * 60;
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
