package com.ruoyi.system.domain.course;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.common.xss.Xss;

/**
 * 课程内容对象 edu_course_content
 *
 * @author ruoyi
 */
public class EduCourseContent extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 内容ID */
    private Long contentId;

    /** 课程ID */
    private Long courseId;

    /** 父内容ID */
    private Long parentId;

    /** 内容标题 */
    private String contentTitle;

    /** 内容类型 */
    private String contentType;

    /** 来源类型 */
    private String sourceType;

    /** 文件名称 */
    private String fileName;

    /** 文件地址 */
    private String fileUrl;

    /** 内容封面 */
    private String coverImage;

    /** 外链地址 */
    private String linkUrl;

    /** 内容摘要 */
    private String summary;

    /** 正文 */
    private String contentBody;

    /** 时长 */
    private Integer durationSeconds;

    /** 关联考试ID */
    private Long examId;

    /** 是否可预览 */
    private String isPreview;

    /** 排序值 */
    private Integer sortOrder;

    /** 发布状态 */
    private String publishStatus;

    /** 查看次数 */
    private Integer viewCount;

    /** 课程名称 */
    private String courseName;

    /** 关联考试名称 */
    private String examName;

    public Long getContentId()
    {
        return contentId;
    }

    public void setContentId(Long contentId)
    {
        this.contentId = contentId;
    }

    @NotNull(message = "所属课程不能为空")
    public Long getCourseId()
    {
        return courseId;
    }

    public void setCourseId(Long courseId)
    {
        this.courseId = courseId;
    }

    public Long getParentId()
    {
        return parentId;
    }

    public void setParentId(Long parentId)
    {
        this.parentId = parentId;
    }

    @Xss(message = "内容标题不能包含脚本字符")
    @NotBlank(message = "内容标题不能为空")
    @Size(max = 200, message = "内容标题长度不能超过200个字符")
    public String getContentTitle()
    {
        return contentTitle;
    }

    public void setContentTitle(String contentTitle)
    {
        this.contentTitle = contentTitle;
    }

    public String getContentType()
    {
        return contentType;
    }

    public void setContentType(String contentType)
    {
        this.contentType = contentType;
    }

    public String getSourceType()
    {
        return sourceType;
    }

    public void setSourceType(String sourceType)
    {
        this.sourceType = sourceType;
    }

    public String getFileName()
    {
        return fileName;
    }

    public void setFileName(String fileName)
    {
        this.fileName = fileName;
    }

    public String getFileUrl()
    {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl)
    {
        this.fileUrl = fileUrl;
    }

    public String getCoverImage()
    {
        return coverImage;
    }

    public void setCoverImage(String coverImage)
    {
        this.coverImage = coverImage;
    }

    public String getLinkUrl()
    {
        return linkUrl;
    }

    public void setLinkUrl(String linkUrl)
    {
        this.linkUrl = linkUrl;
    }

    public String getSummary()
    {
        return summary;
    }

    public void setSummary(String summary)
    {
        this.summary = summary;
    }

    public String getContentBody()
    {
        return contentBody;
    }

    public void setContentBody(String contentBody)
    {
        this.contentBody = contentBody;
    }

    public Integer getDurationSeconds()
    {
        return durationSeconds;
    }

    public void setDurationSeconds(Integer durationSeconds)
    {
        this.durationSeconds = durationSeconds;
    }

    public Long getExamId()
    {
        return examId;
    }

    public void setExamId(Long examId)
    {
        this.examId = examId;
    }

    public String getIsPreview()
    {
        return isPreview;
    }

    public void setIsPreview(String isPreview)
    {
        this.isPreview = isPreview;
    }

    public Integer getSortOrder()
    {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder)
    {
        this.sortOrder = sortOrder;
    }

    public String getPublishStatus()
    {
        return publishStatus;
    }

    public void setPublishStatus(String publishStatus)
    {
        this.publishStatus = publishStatus;
    }

    public Integer getViewCount()
    {
        return viewCount;
    }

    public void setViewCount(Integer viewCount)
    {
        this.viewCount = viewCount;
    }

    public String getCourseName()
    {
        return courseName;
    }

    public void setCourseName(String courseName)
    {
        this.courseName = courseName;
    }

    public String getExamName()
    {
        return examName;
    }

    public void setExamName(String examName)
    {
        this.examName = examName;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("contentId", getContentId())
                .append("courseId", getCourseId())
                .append("parentId", getParentId())
                .append("contentTitle", getContentTitle())
                .append("contentType", getContentType())
                .append("sourceType", getSourceType())
                .append("fileName", getFileName())
                .append("fileUrl", getFileUrl())
                .append("linkUrl", getLinkUrl())
                .append("durationSeconds", getDurationSeconds())
                .append("examId", getExamId())
                .append("isPreview", getIsPreview())
                .append("sortOrder", getSortOrder())
                .append("publishStatus", getPublishStatus())
                .append("viewCount", getViewCount())
                .append("courseName", getCourseName())
                .append("examName", getExamName())
                .append("createBy", getCreateBy())
                .append("createTime", getCreateTime())
                .append("updateBy", getUpdateBy())
                .append("updateTime", getUpdateTime())
                .append("remark", getRemark())
                .toString();
    }
}
