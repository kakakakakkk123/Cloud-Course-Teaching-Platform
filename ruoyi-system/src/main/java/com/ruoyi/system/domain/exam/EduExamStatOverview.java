package com.ruoyi.system.domain.exam;

import java.math.BigDecimal;

/**
 * 考试统计概览对象
 *
 * @author ruoyi
 */
public class EduExamStatOverview
{
    /** 应参加人数 */
    private Integer participantCount;

    /** 已提交人数 */
    private Integer submittedCount;

    /** 平均分 */
    private BigDecimal averageScore;

    /** 及格率 */
    private BigDecimal passRate;

    /** 最高分 */
    private BigDecimal highestScore;

    /** 待批阅数量 */
    private Integer pendingReviewCount;

    public Integer getParticipantCount()
    {
        return participantCount;
    }

    public void setParticipantCount(Integer participantCount)
    {
        this.participantCount = participantCount;
    }

    public Integer getSubmittedCount()
    {
        return submittedCount;
    }

    public void setSubmittedCount(Integer submittedCount)
    {
        this.submittedCount = submittedCount;
    }

    public BigDecimal getAverageScore()
    {
        return averageScore;
    }

    public void setAverageScore(BigDecimal averageScore)
    {
        this.averageScore = averageScore;
    }

    public BigDecimal getPassRate()
    {
        return passRate;
    }

    public void setPassRate(BigDecimal passRate)
    {
        this.passRate = passRate;
    }

    public BigDecimal getHighestScore()
    {
        return highestScore;
    }

    public void setHighestScore(BigDecimal highestScore)
    {
        this.highestScore = highestScore;
    }

    public Integer getPendingReviewCount()
    {
        return pendingReviewCount;
    }

    public void setPendingReviewCount(Integer pendingReviewCount)
    {
        this.pendingReviewCount = pendingReviewCount;
    }
}
