package com.ruoyi.system.domain.learning;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;
import com.ruoyi.system.domain.exam.EduQuestionOption;

/**
 * 学生考试题目视图
 *
 * @author ruoyi
 */
public class StudentExamQuestionVO implements Serializable
{
    private static final long serialVersionUID = 1L;

    private Long questionId;
    private String questionType;
    private Integer questionOrder;
    private BigDecimal score;
    private String questionTitle;
    private String attachmentUrl;
    private List<EduQuestionOption> optionList;

    public Long getQuestionId() { return questionId; }
    public void setQuestionId(Long questionId) { this.questionId = questionId; }
    public String getQuestionType() { return questionType; }
    public void setQuestionType(String questionType) { this.questionType = questionType; }
    public Integer getQuestionOrder() { return questionOrder; }
    public void setQuestionOrder(Integer questionOrder) { this.questionOrder = questionOrder; }
    public BigDecimal getScore() { return score; }
    public void setScore(BigDecimal score) { this.score = score; }
    public String getQuestionTitle() { return questionTitle; }
    public void setQuestionTitle(String questionTitle) { this.questionTitle = questionTitle; }
    public String getAttachmentUrl() { return attachmentUrl; }
    public void setAttachmentUrl(String attachmentUrl) { this.attachmentUrl = attachmentUrl; }
    public List<EduQuestionOption> getOptionList() { return optionList; }
    public void setOptionList(List<EduQuestionOption> optionList) { this.optionList = optionList; }
}
