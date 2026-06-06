package com.ruoyi.system.domain.course;

import java.util.Date;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 课程点赞对象 edu_course_like
 *
 * @author ruoyi
 */
public class EduCourseLike
{
    /** 点赞ID */
    private Long likeId;

    /** 课程ID */
    private Long courseId;

    /** 用户ID */
    private Long userId;

    /** 创建时间 */
    private Date createTime;

    public Long getLikeId()
    {
        return likeId;
    }

    public void setLikeId(Long likeId)
    {
        this.likeId = likeId;
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
                .append("likeId", getLikeId())
                .append("courseId", getCourseId())
                .append("userId", getUserId())
                .append("createTime", getCreateTime())
                .toString();
    }
}
