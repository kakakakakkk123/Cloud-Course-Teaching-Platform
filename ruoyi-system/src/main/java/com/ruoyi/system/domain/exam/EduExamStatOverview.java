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

    /** 已完成批改数 */
    private Integer reviewedCount;

    /** 平均分 */
    private BigDecimal averageScore;

    /** 及格率 */
    private BigDecimal passRate;

    /** 最高分 */
    private BigDecimal highestScore;

    /** 待批阅数量 */
    private Integer pendingReviewCount;

    /** 完成率 */
    private BigDecimal completionRate;

    /** 未及格人数 */
    private Integer failCount;

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

    public Integer getReviewedCount()
    {
        return reviewedCount;
    }

    public void setReviewedCount(Integer reviewedCount)
    {
        this.reviewedCount = reviewedCount;
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

    public BigDecimal getCompletionRate()
    {
        return completionRate;
    }

    public void setCompletionRate(BigDecimal completionRate)
    {
        this.completionRate = completionRate;
    }

    public Integer getFailCount()
    {
        return failCount;
    }

    public void setFailCount(Integer failCount)
    {
        this.failCount = failCount;
    }
}
