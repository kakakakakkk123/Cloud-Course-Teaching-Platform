package com.ruoyi.system.domain.course;

import java.util.Date;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.common.xss.Xss;

/**
 * 课程轮播图对象 edu_course_banner
 *
 * @author ruoyi
 */
public class EduCourseBanner extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 轮播图ID */
    private Long bannerId;

    /** 轮播标题 */
    private String bannerTitle;

    /** 轮播图片 */
    private String bannerImage;

    /** 关联课程ID */
    private Long courseId;

    /** 跳转地址 */
    private String jumpUrl;

    /** 排序值 */
    private Integer sortOrder;

    /** 状态 */
    private String status;

    /** 生效开始时间 */
    private Date startTime;

    /** 生效结束时间 */
    private Date endTime;

    /** 课程名称 */
    private String courseName;

    public Long getBannerId()
    {
        return bannerId;
    }

    public void setBannerId(Long bannerId)
    {
        this.bannerId = bannerId;
    }

    @Xss(message = "轮播标题不能包含脚本字符")
    @NotBlank(message = "轮播标题不能为空")
    @Size(max = 200, message = "轮播标题长度不能超过200个字符")
    public String getBannerTitle()
    {
        return bannerTitle;
    }

    public void setBannerTitle(String bannerTitle)
    {
        this.bannerTitle = bannerTitle;
    }

    @NotBlank(message = "轮播图片不能为空")
    public String getBannerImage()
    {
        return bannerImage;
    }

    public void setBannerImage(String bannerImage)
    {
        this.bannerImage = bannerImage;
    }

    public Long getCourseId()
    {
        return courseId;
    }

    public void setCourseId(Long courseId)
    {
        this.courseId = courseId;
    }

    public String getJumpUrl()
    {
        return jumpUrl;
    }

    public void setJumpUrl(String jumpUrl)
    {
        this.jumpUrl = jumpUrl;
    }

    public Integer getSortOrder()
    {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder)
    {
        this.sortOrder = sortOrder;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public Date getStartTime()
    {
        return startTime;
    }

    public void setStartTime(Date startTime)
    {
        this.startTime = startTime;
    }

    public Date getEndTime()
    {
        return endTime;
    }

    public void setEndTime(Date endTime)
    {
        this.endTime = endTime;
    }

    public String getCourseName()
    {
        return courseName;
    }

    public void setCourseName(String courseName)
    {
        this.courseName = courseName;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("bannerId", getBannerId())
                .append("bannerTitle", getBannerTitle())
                .append("bannerImage", getBannerImage())
                .append("courseId", getCourseId())
                .append("jumpUrl", getJumpUrl())
                .append("sortOrder", getSortOrder())
                .append("status", getStatus())
                .append("startTime", getStartTime())
                .append("endTime", getEndTime())
                .append("createBy", getCreateBy())
                .append("createTime", getCreateTime())
                .append("updateBy", getUpdateBy())
                .append("updateTime", getUpdateTime())
                .append("remark", getRemark())
                .toString();
    }
}
