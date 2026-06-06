package com.ruoyi.system.domain.learning;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 学生考试列表视图
 *
 * @author ruoyi
 */
public class StudentExamVO implements Serializable
{
    private static final long serialVersionUID = 1L;

    private Long examId;
    private String examName;
    private Long paperId;
    private Long courseId;
    private String courseName;
    private String paperName;
    private String examNotice;
    private Date startTime;
    private Date endTime;
    private Integer durationMinutes;
    private BigDecimal passScore;
    private BigDecimal totalScore;
    private Integer maxAttemptCount;
    private String showScoreAfterSubmit;
    private String showAnswerAfterSubmit;
    private String status;
    private Integer attemptCount;
    private Long recordId;
    private Integer attemptNo;
    private Date recordStartTime;
    private Date submitTime;
    private String recordStatus;
    private BigDecimal studentScore;
    private String resultStatus;
    private String checkedFlag;

    public Long getExamId() { return examId; }
    public void setExamId(Long examId) { this.examId = examId; }
    public String getExamName() { return examName; }
    public void setExamName(String examName) { this.examName = examName; }
    public Long getPaperId() { return paperId; }
    public void setPaperId(Long paperId) { this.paperId = paperId; }
    public Long getCourseId() { return courseId; }
    public void setCourseId(Long courseId) { this.courseId = courseId; }
    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }
    public String getPaperName() { return paperName; }
    public void setPaperName(String paperName) { this.paperName = paperName; }
    public String getExamNotice() { return examNotice; }
    public void setExamNotice(String examNotice) { this.examNotice = examNotice; }
    public Date getStartTime() { return startTime; }
    public void setStartTime(Date startTime) { this.startTime = startTime; }
    public Date getEndTime() { return endTime; }
    public void setEndTime(Date endTime) { this.endTime = endTime; }
    public Integer getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(Integer durationMinutes) { this.durationMinutes = durationMinutes; }
    public BigDecimal getPassScore() { return passScore; }
    public void setPassScore(BigDecimal passScore) { this.passScore = passScore; }
    public BigDecimal getTotalScore() { return totalScore; }
    public void setTotalScore(BigDecimal totalScore) { this.totalScore = totalScore; }
    public Integer getMaxAttemptCount() { return maxAttemptCount; }
    public void setMaxAttemptCount(Integer maxAttemptCount) { this.maxAttemptCount = maxAttemptCount; }
    public String getShowScoreAfterSubmit() { return showScoreAfterSubmit; }
    public void setShowScoreAfterSubmit(String showScoreAfterSubmit) { this.showScoreAfterSubmit = showScoreAfterSubmit; }
    public String getShowAnswerAfterSubmit() { return showAnswerAfterSubmit; }
    public void setShowAnswerAfterSubmit(String showAnswerAfterSubmit) { this.showAnswerAfterSubmit = showAnswerAfterSubmit; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getAttemptCount() { return attemptCount; }
    public void setAttemptCount(Integer attemptCount) { this.attemptCount = attemptCount; }
    public Long getRecordId() { return recordId; }
    public void setRecordId(Long recordId) { this.recordId = recordId; }
    public Integer getAttemptNo() { return attemptNo; }
    public void setAttemptNo(Integer attemptNo) { this.attemptNo = attemptNo; }
    public Date getRecordStartTime() { return recordStartTime; }
    public void setRecordStartTime(Date recordStartTime) { this.recordStartTime = recordStartTime; }
    public Date getSubmitTime() { return submitTime; }
    public void setSubmitTime(Date submitTime) { this.submitTime = submitTime; }
    public String getRecordStatus() { return recordStatus; }
    public void setRecordStatus(String recordStatus) { this.recordStatus = recordStatus; }
    public BigDecimal getStudentScore() { return studentScore; }
    public void setStudentScore(BigDecimal studentScore) { this.studentScore = studentScore; }
    public String getResultStatus() { return resultStatus; }
    public void setResultStatus(String resultStatus) { this.resultStatus = resultStatus; }
    public String getCheckedFlag() { return checkedFlag; }
    public void setCheckedFlag(String checkedFlag) { this.checkedFlag = checkedFlag; }
}
