package com.ruoyi.system.domain.course;

import java.util.Date;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 课程收藏对象 edu_course_favorite
 *
 * @author ruoyi
 */
public class EduCourseFavorite
{
    /** 收藏ID */
    private Long favoriteId;

    /** 课程ID */
    private Long courseId;

    /** 用户ID */
    private Long userId;

    /** 创建时间 */
    private Date createTime;

    public Long getFavoriteId()
    {
        return favoriteId;
    }

    public void setFavoriteId(Long favoriteId)
    {
        this.favoriteId = favoriteId;
    }

    public Long getCourseId()
    {
        return courseId;
    }

    public void setCourseId(Long courseId)
    {
        this.courseId = courseId;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public Date getCreateTime()
    {
        return createTime;
    }

    public void setCreateTime(Date createTime)
    {
        this.createTime = createTime;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("favoriteId", getFavoriteId())
                .append("courseId", getCourseId())
                .append("userId", getUserId())
                .append("createTime", getCreateTime())
                .toString();
    }
}
