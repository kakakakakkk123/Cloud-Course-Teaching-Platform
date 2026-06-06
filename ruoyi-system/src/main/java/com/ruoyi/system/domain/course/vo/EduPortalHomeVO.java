package com.ruoyi.system.domain.course.vo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import com.ruoyi.system.domain.course.EduCourse;
import com.ruoyi.system.domain.course.EduCourseBanner;
import com.ruoyi.system.domain.course.EduCourseCategory;

/**
 * 门户首页返回对象
 *
 * @author ruoyi
 */
public class EduPortalHomeVO implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 轮播图 */
    private List<EduCourseBanner> banners = new ArrayList<>();

    /** 分类列表 */
    private List<EduCourseCategory> categories = new ArrayList<>();

    /** 推荐课程 */
    private List<EduCourse> recommendCourses = new ArrayList<>();

    /** 热门课程 */
    private List<EduCourse> hotCourses = new ArrayList<>();

    /** 最新课程 */
    private List<EduCourse> latestCourses = new ArrayList<>();

    public List<EduCourseBanner> getBanners()
    {
        return banners;
    }

    public void setBanners(List<EduCourseBanner> banners)
    {
        this.banners = banners;
    }

    public List<EduCourseCategory> getCategories()
    {
        return categories;
    }

    public void setCategories(List<EduCourseCategory> categories)
    {
        this.categories = categories;
    }

    public List<EduCourse> getRecommendCourses()
    {
        return recommendCourses;
    }

    public void setRecommendCourses(List<EduCourse> recommendCourses)
    {
        this.recommendCourses = recommendCourses;
    }

    public List<EduCourse> getHotCourses()
    {
        return hotCourses;
    }

    public void setHotCourses(List<EduCourse> hotCourses)
    {
        this.hotCourses = hotCourses;
    }

    public List<EduCourse> getLatestCourses()
    {
        return latestCourses;
    }

    public void setLatestCourses(List<EduCourse> latestCourses)
    {
        this.latestCourses = latestCourses;
    }
}
