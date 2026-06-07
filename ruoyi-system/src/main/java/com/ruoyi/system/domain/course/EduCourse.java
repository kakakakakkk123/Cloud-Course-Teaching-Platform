package com.ruoyi.system.domain.course;

import java.math.BigDecimal;
import java.util.Date;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.common.xss.Xss;

/**
 * 课程对象 edu_course
 *
 * @author ruoyi
 */
public class EduCourse extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 课程ID */
    private Long courseId;

    /** 分类ID */
    private Long categoryId;

    /** 教师用户ID */
    private Long teacherId;

    /** 课程名称 */
    private String courseName;

    /** 课程副标题 */
    private String courseSubtitle;

    /** 课程封面 */
    private String coverImage;

    /** 课程简介 */
    private String intro;

    /** 课程详情 */
    private String detailHtml;

    /** 课程标签 */
    private String tags;

    /** 难度等级 */
    private String difficultyLevel;

    /** 发布状态 */
    private String publishStatus;

    /** 是否推荐 */
    private String recommendFlag;

    /** 是否热门置顶 */
    private String hotFlag;

    /** 是否可用于轮播 */
    private String bannerFlag;

    /** 是否允许注册 */
    private String allowRegister;

    /** 课程排序值 */
    private Integer sortOrder;

    /** 浏览次数 */
    private Integer viewCount;

    /** 点赞次数 */
    private Integer likeCount;

    /** 注册人数 */
    private Integer enrollCount;

    /** 内容数 */
    private Integer contentCount;

    /** 考试数 */
    private Integer examCount;

    /** 最后内容更新时间 */
    private Date lastContentTime;

    /** 发布时间 */
    private Date publishTime;

    /** 状态 */
    private String status;

    /** 删除标志 */
    private String delFlag;

    /** 分类名称 */
    private String categoryName;

    /** 教师名称 */
    private String teacherName;

    /** 是否已注册 */
    private Boolean registered;

    /** 是否已点赞 */
    private Boolean liked;

    /** 学习进度 */
    private BigDecimal progressPercent;

    /** 注册状态 */
    private String enrollStatus;

    /** 最近学习时间 */
    private Date lastStudyTime;

    /** 完成时间 */
    private Date finishTime;

    /** 门户排序字段 */
    private String sortField;

    /** 门户排序方向 */
    private String sortType;

    public Long getCourseId()
    {
        return courseId;
    }

    public void setCourseId(Long courseId)
    {
        this.courseId = courseId;
    }

    @NotNull(message = "课程分类不能为空")
    public Long getCategoryId()
    {
        return categoryId;
    }

    public void setCategoryId(Long categoryId)
    {
        this.categoryId = categoryId;
    }

    @NotNull(message = "授课教师不能为空")
    public Long getTeacherId()
    {
        return teacherId;
    }

    public void setTeacherId(Long teacherId)
    {
        this.teacherId = teacherId;
    }

    @Xss(message = "课程名称不能包含脚本字符")
    @NotBlank(message = "课程名称不能为空")
    @Size(max = 200, message = "课程名称长度不能超过200个字符")
    public String getCourseName()
    {
        return courseName;
    }

    public void setCourseName(String courseName)
    {
        this.courseName = courseName;
    }

    @Size(max = 255, message = "课程副标题长度不能超过255个字符")
    public String getCourseSubtitle()
    {
        return courseSubtitle;
    }

    public void setCourseSubtitle(String courseSubtitle)
    {
        this.courseSubtitle = courseSubtitle;
    }

    public String getCoverImage()
    {
        return coverImage;
    }

    public void setCoverImage(String coverImage)
    {
        this.coverImage = coverImage;
    }

    public String getIntro()
    {
        return intro;
    }

    public void setIntro(String intro)
    {
        this.intro = intro;
    }

    public String getDetailHtml()
    {
        return detailHtml;
    }

    public void setDetailHtml(String detailHtml)
    {
        this.detailHtml = detailHtml;
    }

    public String getTags()
    {
        return tags;
    }

    public void setTags(String tags)
    {
        this.tags = tags;
    }

    public String getDifficultyLevel()
    {
        return difficultyLevel;
    }

    public void setDifficultyLevel(String difficultyLevel)
    {
        this.difficultyLevel = difficultyLevel;
    }

    public String getPublishStatus()
    {
        return publishStatus;
    }

    public void setPublishStatus(String publishStatus)
    {
        this.publishStatus = publishStatus;
    }

    public String getRecommendFlag()
    {
        return recommendFlag;
    }

    public void setRecommendFlag(String recommendFlag)
    {
        this.recommendFlag = recommendFlag;
    }

    public String getHotFlag()
    {
        return hotFlag;
    }

    public void setHotFlag(String hotFlag)
    {
        this.hotFlag = hotFlag;
    }

    public String getBannerFlag()
    {
        return bannerFlag;
    }

    public void setBannerFlag(String bannerFlag)
    {
        this.bannerFlag = bannerFlag;
    }

    public String getAllowRegister()
    {
        return allowRegister;
    }

    public void setAllowRegister(String allowRegister)
    {
        this.allowRegister = allowRegister;
    }

    public Integer getSortOrder()
    {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder)
    {
        this.sortOrder = sortOrder;
    }

    public Integer getViewCount()
    {
        return viewCount;
    }

    public void setViewCount(Integer viewCount)
    {
        this.viewCount = viewCount;
    }

    public Integer getLikeCount()
    {
        return likeCount;
    }

    public void setLikeCount(Integer likeCount)
    {
        this.likeCount = likeCount;
    }

    public Integer getEnrollCount()
    {
        return enrollCount;
    }

    public void setEnrollCount(Integer enrollCount)
    {
        this.enrollCount = enrollCount;
    }

    public Integer getContentCount()
    {
        return contentCount;
    }

    public void setContentCount(Integer contentCount)
    {
        this.contentCount = contentCount;
    }

    public Integer getExamCount()
    {
        return examCount;
    }

    public void setExamCount(Integer examCount)
    {
        this.examCount = examCount;
    }

    public Date getLastContentTime()
    {
        return lastContentTime;
    }

    public void setLastContentTime(Date lastContentTime)
    {
        this.lastContentTime = lastContentTime;
    }

    public Date getPublishTime()
    {
        return publishTime;
    }

    public void setPublishTime(Date publishTime)
    {
        this.publishTime = publishTime;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getDelFlag()
    {
        return delFlag;
    }

    public void setDelFlag(String delFlag)
    {
        this.delFlag = delFlag;
    }

    public String getCategoryName()
    {
        return categoryName;
    }

    public void setCategoryName(String categoryName)
    {
        this.categoryName = categoryName;
    }

    public String getTeacherName()
    {
        return teacherName;
    }

    public void setTeacherName(String teacherName)
    {
        this.teacherName = teacherName;
    }

    public Boolean getRegistered()
    {
        return registered;
    }

    public void setRegistered(Boolean registered)
    {
        this.registered = registered;
    }

    public Boolean getLiked()
    {
        return liked;
    }

    public void setLiked(Boolean liked)
    {
        this.liked = liked;
    }

    public BigDecimal getProgressPercent()
    {
        return progressPercent;
    }

    public void setProgressPercent(BigDecimal progressPercent)
    {
        this.progressPercent = progressPercent;
    }

    public String getEnrollStatus()
    {
        return enrollStatus;
    }

    public void setEnrollStatus(String enrollStatus)
    {
        this.enrollStatus = enrollStatus;
    }

    public Date getLastStudyTime()
    {
        return lastStudyTime;
    }

    public void setLastStudyTime(Date lastStudyTime)
    {
        this.lastStudyTime = lastStudyTime;
    }

    public Date getFinishTime()
    {
        return finishTime;
    }

    public void setFinishTime(Date finishTime)
    {
        this.finishTime = finishTime;
    }

    public String getSortField()
    {
        return sortField;
    }

    public void setSortField(String sortField)
    {
        this.sortField = sortField;
    }

    public String getSortType()
    {
        return sortType;
    }

    public void setSortType(String sortType)
    {
        this.sortType = sortType;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("courseId", getCourseId())
                .append("categoryId", getCategoryId())
                .append("teacherId", getTeacherId())
                .append("courseName", getCourseName())
                .append("courseSubtitle", getCourseSubtitle())
                .append("difficultyLevel", getDifficultyLevel())
                .append("publishStatus", getPublishStatus())
                .append("recommendFlag", getRecommendFlag())
                .append("hotFlag", getHotFlag())
                .append("bannerFlag", getBannerFlag())
                .append("allowRegister", getAllowRegister())
                .append("sortOrder", getSortOrder())
                .append("viewCount", getViewCount())
                .append("likeCount", getLikeCount())
                .append("enrollCount", getEnrollCount())
                .append("contentCount", getContentCount())
                .append("examCount", getExamCount())
                .append("publishTime", getPublishTime())
                .append("lastContentTime", getLastContentTime())
                .append("status", getStatus())
                .append("delFlag", getDelFlag())
                .append("createBy", getCreateBy())
                .append("createTime", getCreateTime())
                .append("updateBy", getUpdateBy())
                .append("updateTime", getUpdateTime())
                .append("remark", getRemark())
                .toString();
    }
}
