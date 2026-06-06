package com.ruoyi.system.domain.exam;

import java.math.BigDecimal;
import java.util.List;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 题库对象 edu_question_bank
 *
 * @author ruoyi
 */
public class EduQuestionBank extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 题库ID */
    private Long bankId;

    /** 题库名称 */
    private String bankName;

    /** 创建教师ID */
    private Long creatorId;

    /** 可见范围 */
    private String visibility;

    /** 题库标签 */
    private String tags;

    /** 题目数量 */
    private Integer questionCount;

    /** 使用次数 */
    private Integer usageCount;

    /** 答题次数 */
    private Integer answerCount;

    /** 正确率 */
    private BigDecimal correctRate;

    /** 状态 */
    private String status;

    /** 删除标志 */
    private String delFlag;

    /** 关联课程ID列表 */
    private List<Long> courseIds;

    /** 关联课程名称 */
    private String courseNames;

    public Long getBankId()
    {
        return bankId;
    }

    public void setBankId(Long bankId)
    {
        this.bankId = bankId;
    }

    @NotBlank(message = "题库名称不能为空")
    @Size(max = 120, message = "题库名称长度不能超过120个字符")
    public String getBankName()
    {
        return bankName;
    }

    public void setBankName(String bankName)
    {
        this.bankName = bankName;
    }

    public Long getCreatorId()
    {
        return creatorId;
    }

    public void setCreatorId(Long creatorId)
    {
        this.creatorId = creatorId;
    }

    public String getVisibility()
    {
        return visibility;
    }

    public void setVisibility(String visibility)
    {
        this.visibility = visibility;
    }

    public String getTags()
    {
        return tags;
    }

    public void setTags(String tags)
    {
        this.tags = tags;
    }

    public Integer getQuestionCount()
    {
        return questionCount;
    }

    public void setQuestionCount(Integer questionCount)
    {
        this.questionCount = questionCount;
    }

    public Integer getUsageCount()
    {
        return usageCount;
    }

    public void setUsageCount(Integer usageCount)
    {
        this.usageCount = usageCount;
    }

    public Integer getAnswerCount()
    {
        return answerCount;
    }

    public void setAnswerCount(Integer answerCount)
    {
        this.answerCount = answerCount;
    }

    public BigDecimal getCorrectRate()
    {
        return correctRate;
    }

    public void setCorrectRate(BigDecimal correctRate)
    {
        this.correctRate = correctRate;
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

    public List<Long> getCourseIds()
    {
        return courseIds;
    }

    public void setCourseIds(List<Long> courseIds)
    {
        this.courseIds = courseIds;
    }

    public String getCourseNames()
    {
        return courseNames;
    }

    public void setCourseNames(String courseNames)
    {
        this.courseNames = courseNames;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("bankId", getBankId())
                .append("bankName", getBankName())
                .append("creatorId", getCreatorId())
                .append("visibility", getVisibility())
                .append("tags", getTags())
                .append("questionCount", getQuestionCount())
                .append("usageCount", getUsageCount())
                .append("answerCount", getAnswerCount())
                .append("correctRate", getCorrectRate())
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
