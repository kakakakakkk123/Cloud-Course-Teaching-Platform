package com.ruoyi.system.domain.exam;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 试题选项对象 edu_question_option
 *
 * @author ruoyi
 */
public class EduQuestionOption
{
    /** 选项ID */
    private Long optionId;

    /** 试题ID */
    private Long questionId;

    /** 选项标识 */
    private String optionLabel;

    /** 选项内容 */
    private String optionContent;

    /** 是否正确答案 */
    private String isCorrect;

    /** 排序值 */
    private Integer sortOrder;

    public Long getOptionId()
    {
        return optionId;
    }

    public void setOptionId(Long optionId)
    {
        this.optionId = optionId;
    }

    public Long getQuestionId()
    {
        return questionId;
    }

    public void setQuestionId(Long questionId)
    {
        this.questionId = questionId;
    }

    public String getOptionLabel()
    {
        return optionLabel;
    }

    public void setOptionLabel(String optionLabel)
    {
        this.optionLabel = optionLabel;
    }

    public String getOptionContent()
    {
        return optionContent;
    }

    public void setOptionContent(String optionContent)
    {
        this.optionContent = optionContent;
    }

    public String getIsCorrect()
    {
        return isCorrect;
    }

    public void setIsCorrect(String isCorrect)
    {
        this.isCorrect = isCorrect;
    }

    public Integer getSortOrder()
    {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder)
    {
        this.sortOrder = sortOrder;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("optionId", getOptionId())
                .append("questionId", getQuestionId())
                .append("optionLabel", getOptionLabel())
                .append("optionContent", getOptionContent())
                .append("isCorrect", getIsCorrect())
                .append("sortOrder", getSortOrder())
                .toString();
    }
}
