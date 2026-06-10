package com.ruoyi.system.domain.exam;

import java.math.BigDecimal;
import java.util.List;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 试题对象 edu_question
 *
 * @author ruoyi
 */
public class EduQuestion extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 试题ID */
    private Long questionId;

    /** 题库ID */
    private Long bankId;

    /** 创建教师ID */
    private Long creatorId;

    /** 题型 */
    private String questionType;

    /** 难度等级 */
    private String difficultyLevel;

    /** 默认分值 */
    private BigDecimal score;

    /** 题干 */
    private String questionTitle;

    /** 标准答案JSON */
    private String answerJson;

    /** 前端编辑使用的参考答案 */
    private String answerText;

    /** 答案解析 */
    private String analysis;

    /** 附件地址 */
    private String attachmentUrl;

    /** 是否自动判分 */
    private String autoMarking;

    /** 状态 */
    private String status;

    /** 删除标志 */
    private String delFlag;

    /** 使用次数 */
    private Integer usageCount;

    /** 答题次数 */
    private Integer answerCount;

    /** 答对次数 */
    private Integer correctCount;

    /** 所属题库名称 */
    private String bankName;

    /** 选项列表 */
    private List<EduQuestionOption> optionList;

    public Long getQuestionId()
    {
        return questionId;
    }

    public void setQuestionId(Long questionId)
    {
        this.questionId = questionId;
    }

    @NotNull(message = "所属题库不能为空")
    public Long getBankId()
    {
        return bankId;
    }

    public void setBankId(Long bankId)
    {
        this.bankId = bankId;
    }

    public Long getCreatorId()
    {
        return creatorId;
    }

    public void setCreatorId(Long creatorId)
    {
        this.creatorId = creatorId;
    }

    public String getQuestionType()
    {
        return questionType;
    }

    public void setQuestionType(String questionType)
    {
        this.questionType = questionType;
    }

    public String getDifficultyLevel()
    {
        return difficultyLevel;
    }

    public void setDifficultyLevel(String difficultyLevel)
    {
        this.difficultyLevel = difficultyLevel;
    }

    public BigDecimal getScore()
    {
        return score;
    }

    public void setScore(BigDecimal score)
    {
        this.score = score;
    }

    @NotBlank(message = "题干不能为空")
    public String getQuestionTitle()
    {
        return questionTitle;
    }

    public void setQuestionTitle(String questionTitle)
    {
        this.questionTitle = questionTitle;
    }

    public String getAnswerJson()
    {
        return answerJson;
    }

    public void setAnswerJson(String answerJson)
    {
        this.answerJson = answerJson;
    }

    public String getAnswerText()
    {
        return answerText;
    }

    public void setAnswerText(String answerText)
    {
        this.answerText = answerText;
    }

    public String getAnalysis()
    {
        return analysis;
    }

    public void setAnalysis(String analysis)
    {
        this.analysis = analysis;
    }

    public String getAttachmentUrl()
    {
        return attachmentUrl;
    }

    public void setAttachmentUrl(String attachmentUrl)
    {
        this.attachmentUrl = attachmentUrl;
    }

    public String getAutoMarking()
    {
        return autoMarking;
    }

    public void setAutoMarking(String autoMarking)
    {
        this.autoMarking = autoMarking;
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

    public Integer getCorrectCount()
    {
        return correctCount;
    }

    public void setCorrectCount(Integer correctCount)
    {
        this.correctCount = correctCount;
    }

    public String getBankName()
    {
        return bankName;
    }

    public void setBankName(String bankName)
    {
        this.bankName = bankName;
    }

    public List<EduQuestionOption> getOptionList()
    {
        return optionList;
    }

    public void setOptionList(List<EduQuestionOption> optionList)
    {
        this.optionList = optionList;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("questionId", getQuestionId())
                .append("bankId", getBankId())
                .append("creatorId", getCreatorId())
                .append("questionType", getQuestionType())
                .append("difficultyLevel", getDifficultyLevel())
                .append("score", getScore())
                .append("questionTitle", getQuestionTitle())
                .append("answerJson", getAnswerJson())
                .append("analysis", getAnalysis())
                .append("attachmentUrl", getAttachmentUrl())
                .append("autoMarking", getAutoMarking())
                .append("status", getStatus())
                .append("delFlag", getDelFlag())
                .append("usageCount", getUsageCount())
                .append("answerCount", getAnswerCount())
                .append("correctCount", getCorrectCount())
                .append("createBy", getCreateBy())
                .append("createTime", getCreateTime())
                .append("updateBy", getUpdateBy())
                .append("updateTime", getUpdateTime())
                .append("remark", getRemark())
                .toString();
    }
}
