package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.system.domain.course.EduCourseContent;
import com.ruoyi.system.mapper.EduCourseContentMapper;
import com.ruoyi.system.service.IEduCourseContentService;
import com.ruoyi.system.service.IEduCourseService;

/**
 * 课程内容服务实现
 *
 * @author ruoyi
 */
@Service
public class EduCourseContentServiceImpl implements IEduCourseContentService
{
    @Autowired
    private EduCourseContentMapper contentMapper;

    @Autowired
    private IEduCourseService courseService;

    /**
     * 查询课程内容
     */
    @Override
    public EduCourseContent selectEduCourseContentById(Long contentId)
    {
        return contentMapper.selectEduCourseContentById(contentId);
    }

    /**
     * 查询课程内容列表
     */
    @Override
    public List<EduCourseContent> selectEduCourseContentList(EduCourseContent content)
    {
        return contentMapper.selectEduCourseContentList(content);
    }

    /**
     * 查询课程已发布内容
     */
    @Override
    public List<EduCourseContent> selectPublishedContentByCourseId(Long courseId)
    {
        return contentMapper.selectPublishedContentByCourseId(courseId);
    }

    /**
     * 新增课程内容
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertEduCourseContent(EduCourseContent content)
    {
        fillContentDefaults(content);
        int rows = contentMapper.insertEduCourseContent(content);
        courseService.refreshCourseContentStats(content.getCourseId());
        return rows;
    }

    /**
     * 修改课程内容
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateEduCourseContent(EduCourseContent content)
    {
        fillContentDefaults(content);
        int rows = contentMapper.updateEduCourseContent(content);
        courseService.refreshCourseContentStats(content.getCourseId());
        return rows;
    }

    /**
     * 删除课程内容
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteEduCourseContentById(Long contentId)
    {
        EduCourseContent content = contentMapper.selectEduCourseContentById(contentId);
        int rows = contentMapper.deleteEduCourseContentById(contentId);
        if (content != null)
        {
            courseService.refreshCourseContentStats(content.getCourseId());
        }
        return rows;
    }

    /**
     * 批量删除课程内容
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteEduCourseContentByIds(Long[] contentIds)
    {
        Long courseId = null;
        if (contentIds.length > 0)
        {
            EduCourseContent content = contentMapper.selectEduCourseContentById(contentIds[0]);
            courseId = content == null ? null : content.getCourseId();
        }
        int rows = contentMapper.deleteEduCourseContentByIds(contentIds);
        if (courseId != null)
        {
            courseService.refreshCourseContentStats(courseId);
        }
        return rows;
    }

    /**
     * 填充课程内容默认值
     */
    private void fillContentDefaults(EduCourseContent content)
    {
        if (content.getParentId() == null)
        {
            content.setParentId(0L);
        }
        if (content.getSortOrder() == null)
        {
            content.setSortOrder(0);
        }
        if (content.getDurationSeconds() == null)
        {
            content.setDurationSeconds(0);
        }
        if (content.getContentType() == null)
        {
            content.setContentType("1");
        }
        if (content.getSourceType() == null)
        {
            content.setSourceType("1");
        }
        if (content.getIsPreview() == null)
        {
            content.setIsPreview("0");
        }
        if (content.getPublishStatus() == null)
        {
            content.setPublishStatus("1");
        }
    }
}
