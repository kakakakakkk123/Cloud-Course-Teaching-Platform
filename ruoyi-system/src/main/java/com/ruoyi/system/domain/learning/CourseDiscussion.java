package com.ruoyi.system.domain.learning;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Course discussion item.
 */
public class CourseDiscussion extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long discussionId;

    private Long courseId;

    private String courseName;

    private Long studentId;

    private String studentName;

    private String studentAvatar;

    private String content;

    private String status;

    public Long getDiscussionId()
    {
        return discussionId;
    }

    public void setDiscussionId(Long discussionId)
    {
        this.discussionId = discussionId;
    }

    public Long getCourseId()
    {
        return courseId;
    }

    public void setCourseId(Long courseId)
    {
        this.courseId = courseId;
    }

    public String getCourseName()
    {
        return courseName;
    }

    public void setCourseName(String courseName)
    {
        this.courseName = courseName;
    }

    public Long getStudentId()
    {
        return studentId;
    }

    public void setStudentId(Long studentId)
    {
        this.studentId = studentId;
    }

    public String getStudentName()
    {
        return studentName;
    }

    public void setStudentName(String studentName)
    {
        this.studentName = studentName;
    }

    public String getStudentAvatar()
    {
        return studentAvatar;
    }

    public void setStudentAvatar(String studentAvatar)
    {
        this.studentAvatar = studentAvatar;
    }

    public String getContent()
    {
        return content;
    }

    public void setContent(String content)
    {
        this.content = content;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }
}
