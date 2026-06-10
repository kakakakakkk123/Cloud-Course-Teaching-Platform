package com.ruoyi.system.domain.exam;

import java.math.BigDecimal;
import java.util.List;
import jakarta.validation.constraints.NotBlank;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 试卷对象 edu_paper
 *
 * @author ruoyi
 */
public class EduPaper extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 试卷ID */
    private Long paperId;
    /** 试卷名称 */
    private String paperName;
    /** 创建教师ID */
    private Long creatorId;
    /** 课程ID（兼容旧版单课程绑定） */
    private Long courseId;

    /** 关联课程ID列表（新版多课程绑定） */
    private List<Long> courseIds;
    /** 题库ID */
    private Long bankId;
    /** 试卷说明 */
    private String paperDesc;
    /** 总分 */
    private BigDecimal totalScore;
    /** 题目数量 */
    private Integer questionCount;
    /** 客观题总分 */
    private BigDecimal objectiveScore;
    /** 主观题总分 */
    private BigDecimal subjectiveScore;
    /** 状态 */
    private String status;
    /** 删除标志 */
    private String delFlag;
    /** 组卷方式 */
    private String composeMode;
    /** 课程名称（旧版单课程） */
    private String courseName;
    /** 多课程名称，逗号分隔，用于列表展示 */
    private String courseNames;
    /** 题库名称 */
    private String bankName;

    public Long getPaperId()
    {
        return paperId;
    }

    public void setPaperId(Long paperId)
    {
        this.paperId = paperId;
    }

    @NotBlank(message = "试卷名称不能为空")
    public String getPaperName()
    {
        return paperName;
    }

    public void setPaperName(String paperName)
    {
        this.paperName = paperName;
    }

    public Long getCreatorId()
    {
        return creatorId;
    }

    public void setCreatorId(Long creatorId)
    {
        this.creatorId = creatorId;
    }

    public Long getCourseId()
    {
        return courseId;
    }

    public void setCourseId(Long courseId)
    {
        this.courseId = courseId;
    }

    public List<Long> getCourseIds()
    {
        return courseIds;
    }

    public void setCourseIds(List<Long> courseIds)
    {
        this.courseIds = courseIds;
    }

    public Long getBankId()
    {
        return bankId;
    }

    public void setBankId(Long bankId)
    {
        this.bankId = bankId;
    }

    public String getPaperDesc()
    {
        return paperDesc;
    }

    public void setPaperDesc(String paperDesc)
    {
        this.paperDesc = paperDesc;
    }

    public BigDecimal getTotalScore()
    {
        return totalScore;
    }

    public void setTotalScore(BigDecimal totalScore)
    {
        this.totalScore = totalScore;
    }

    public Integer getQuestionCount()
    {
        return questionCount;
    }

    public void setQuestionCount(Integer questionCount)
    {
        this.questionCount = questionCount;
    }

    public BigDecimal getObjectiveScore()
    {
        return objectiveScore;
    }

    public void setObjectiveScore(BigDecimal objectiveScore)
    {
        this.objectiveScore = objectiveScore;
    }

    public BigDecimal getSubjectiveScore()
    {
        return subjectiveScore;
    }

    public void setSubjectiveScore(BigDecimal subjectiveScore)
    {
        this.subjectiveScore = subjectiveScore;
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

    public String getComposeMode()
    {
        return composeMode;
    }

    public void setComposeMode(String composeMode)
    {
        this.composeMode = composeMode;
    }

    public String getCourseName()
    {
        return courseName;
    }

    public void setCourseName(String courseName)
    {
        this.courseName = courseName;
    }

    public String getCourseNames()
    {
        return courseNames;
    }

    public void setCourseNames(String courseNames)
    {
        this.courseNames = courseNames;
    }

    public String getBankName()
    {
        return bankName;
    }

    public void setBankName(String bankName)
    {
        this.bankName = bankName;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("paperId", getPaperId())
                .append("paperName", getPaperName())
                .append("creatorId", getCreatorId())
                .append("courseId", getCourseId())
                .append("bankId", getBankId())
                .append("paperDesc", getPaperDesc())
                .append("totalScore", getTotalScore())
                .append("questionCount", getQuestionCount())
                .append("objectiveScore", getObjectiveScore())
                .append("subjectiveScore", getSubjectiveScore())
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
