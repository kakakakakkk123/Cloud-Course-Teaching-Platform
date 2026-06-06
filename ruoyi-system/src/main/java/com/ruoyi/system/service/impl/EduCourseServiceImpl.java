package com.ruoyi.system.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.course.EduCourse;
import com.ruoyi.system.mapper.EduCourseContentMapper;
import com.ruoyi.system.mapper.EduCourseEnrollMapper;
import com.ruoyi.system.mapper.EduCourseLikeMapper;
import com.ruoyi.system.mapper.EduCourseMapper;
import com.ruoyi.system.service.IEduCourseService;

/**
 * 课程服务实现
 *
 * @author ruoyi
 */
@Service
public class EduCourseServiceImpl implements IEduCourseService
{
    private static final Map<String, String> PORTAL_ORDER_MAP = new HashMap<>();

    static
    {
        PORTAL_ORDER_MAP.put("publishTime", "c.publish_time");
        PORTAL_ORDER_MAP.put("enrollCount", "c.enroll_count");
        PORTAL_ORDER_MAP.put("updateTime", "c.update_time");
        PORTAL_ORDER_MAP.put("likeCount", "c.like_count");
        PORTAL_ORDER_MAP.put("viewCount", "c.view_count");
    }

    @Autowired
    private EduCourseMapper courseMapper;

    @Autowired
    private EduCourseContentMapper contentMapper;

    @Autowired
    private EduCourseEnrollMapper enrollMapper;

    @Autowired
    private EduCourseLikeMapper likeMapper;

    /**
     * 查询课程
     */
    @Override
    public EduCourse selectEduCourseById(Long courseId)
    {
        return courseMapper.selectEduCourseById(courseId);
    }

    /**
     * 查询课程列表
     */
    @Override
    public List<EduCourse> selectEduCourseList(EduCourse course)
    {
        return courseMapper.selectEduCourseList(course);
    }

    /**
     * 查询门户课程列表
     */
    @Override
    public List<EduCourse> selectPortalCourseList(EduCourse course)
    {
        normalizePortalOrder(course);
        return courseMapper.selectPortalCourseList(course);
    }

    /**
     * 查询已发布课程详情
     */
    @Override
    public EduCourse selectPublishedCourseById(Long courseId)
    {
        return courseMapper.selectPublishedCourseById(courseId);
    }

    /**
     * 新增课程
     */
    @Override
    public int insertEduCourse(EduCourse course)
    {
        fillCourseDefaults(course);
        if ("1".equals(course.getPublishStatus()) && course.getPublishTime() == null)
        {
            course.setPublishTime(new java.util.Date());
        }
        return courseMapper.insertEduCourse(course);
    }

    /**
     * 修改课程
     */
    @Override
    public int updateEduCourse(EduCourse course)
    {
        fillCourseDefaults(course);
        if ("1".equals(course.getPublishStatus()) && course.getPublishTime() == null)
        {
            course.setPublishTime(new java.util.Date());
        }
        return courseMapper.updateEduCourse(course);
    }

    /**
     * 删除课程
     */
    @Override
    public int deleteEduCourseById(Long courseId)
    {
        return deleteEduCourseByIds(new Long[] { courseId });
    }

    /**
     * 批量删除课程
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteEduCourseByIds(Long[] courseIds)
    {
        contentMapper.deleteEduCourseContentByCourseIds(courseIds);
        enrollMapper.deleteEduCourseEnrollByCourseIds(courseIds);
        likeMapper.deleteEduCourseLikeByCourseIds(courseIds);
        courseMapper.clearBannerCourseRef(courseIds);
        return courseMapper.deleteEduCourseByIds(courseIds);
    }

    /**
     * 查询推荐课程
     */
    @Override
    public List<EduCourse> selectRecommendCourseList(Integer limitNum)
    {
        return courseMapper.selectRecommendCourseList(limitNum);
    }

    /**
     * 查询热门课程
     */
    @Override
    public List<EduCourse> selectHotCourseList(Integer limitNum)
    {
        return courseMapper.selectHotCourseList(limitNum);
    }

    /**
     * 查询最新课程
     */
    @Override
    public List<EduCourse> selectLatestCourseList(Integer limitNum)
    {
        return courseMapper.selectLatestCourseList(limitNum);
    }

    /**
     * 刷新课程内容统计
     */
    @Override
    public void refreshCourseContentStats(Long courseId)
    {
        courseMapper.refreshCourseContentStats(courseId);
    }

    /**
     * 规范门户排序字段
     */
    private void normalizePortalOrder(EduCourse course)
    {
        if (StringUtils.isNull(course))
        {
            return;
        }
        String orderColumn = PORTAL_ORDER_MAP.get(course.getSortField());
        if (StringUtils.isEmpty(orderColumn))
        {
            return;
        }
        String orderDirection = "asc".equalsIgnoreCase(course.getSortType()) ? "asc" : "desc";
        course.getParams().put("orderByColumn", orderColumn);
        course.getParams().put("orderByDirection", orderDirection);
    }

    /**
     * 填充课程默认值
     */
    private void fillCourseDefaults(EduCourse course)
    {
        if (course.getSortOrder() == null)
        {
            course.setSortOrder(0);
        }
        if (StringUtils.isEmpty(course.getDifficultyLevel()))
        {
            course.setDifficultyLevel("1");
        }
        if (StringUtils.isEmpty(course.getPublishStatus()))
        {
            course.setPublishStatus("0");
        }
        if (StringUtils.isEmpty(course.getRecommendFlag()))
        {
            course.setRecommendFlag("0");
        }
        if (StringUtils.isEmpty(course.getHotFlag()))
        {
            course.setHotFlag("0");
        }
        if (StringUtils.isEmpty(course.getBannerFlag()))
        {
            course.setBannerFlag("0");
        }
        if (StringUtils.isEmpty(course.getAllowRegister()))
        {
            course.setAllowRegister("1");
        }
        if (StringUtils.isEmpty(course.getStatus()))
        {
            course.setStatus("0");
        }
    }
}
