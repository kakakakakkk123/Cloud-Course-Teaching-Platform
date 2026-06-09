package com.ruoyi.system.domain.course.vo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import com.ruoyi.system.domain.course.EduCourse;
import com.ruoyi.system.domain.course.EduCourseContent;

/**
 * 门户课程详情返回对象
 *
 * @author ruoyi
 */
public class EduPortalCourseDetailVO implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 课程信息 */
    private EduCourse course;

    /** 内容列表 */
    private List<EduCourseContent> contentList = new ArrayList<>();

    /** 是否已注册 */
    private boolean registered;

    /** 是否已点赞 */
    private boolean liked;

    /** 是否已收藏 */
    private boolean favorited;

    public EduCourse getCourse()
    {
        return course;
    }

    public void setCourse(EduCourse course)
    {
        this.course = course;
    }

    public List<EduCourseContent> getContentList()
    {
        return contentList;
    }

    public void setContentList(List<EduCourseContent> contentList)
    {
        this.contentList = contentList;
    }

    public boolean isRegistered()
    {
        return registered;
    }

    public void setRegistered(boolean registered)
    {
        this.registered = registered;
    }

    public boolean isLiked()
    {
        return liked;
    }

    public void setLiked(boolean liked)
    {
        this.liked = liked;
    }

    public boolean isFavorited()
    {
        return favorited;
    }

    public void setFavorited(boolean favorited)
    {
        this.favorited = favorited;
    }
}
