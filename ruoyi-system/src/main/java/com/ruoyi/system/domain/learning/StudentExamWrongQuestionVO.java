package com.ruoyi.system.domain.learning;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 学生考试错题视图
 *
 * @author ruoyi
 */
public class StudentExamWrongQuestionVO implements Serializable
{
    private static final long serialVersionUID = 1L;

    private Long answerId;
    private Long recordId;
    private Long examId;
    private String examName;
    private Long paperId;
    private String paperName;
    private Long courseId;
    private String courseName;
    private Long questionId;
    private String questionType;
    private Integer questionOrder;
    private String questionTitle;
    private String standardAnswer;
    private String studentAnswer;
    private String analysis;
    private String attachmentUrl;
    private BigDecimal questionScore;
    private BigDecimal actualScore;
    private String teacherComment;

    public Long getAnswerId() { return answerId; }
    public void setAnswerId(Long answerId) { this.answerId = answerId; }
    public Long getRecordId() { return recordId; }
    public void setRecordId(Long recordId) { this.recordId = recordId; }
    public Long getExamId() { return examId; }
    public void setExamId(Long examId) { this.examId = examId; }
    public String getExamName() { return examName; }
    public void setExamName(String examName) { this.examName = examName; }
    public Long getPaperId() { return paperId; }
    public void setPaperId(Long paperId) { this.paperId = paperId; }
    public String getPaperName() { return paperName; }
    public void setPaperName(String paperName) { this.paperName = paperName; }
    public Long getCourseId() { return courseId; }
    public void setCourseId(Long courseId) { this.courseId = courseId; }
    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }
    public Long getQuestionId() { return questionId; }
    public void setQuestionId(Long questionId) { this.questionId = questionId; }
    public String getQuestionType() { return questionType; }
    public void setQuestionType(String questionType) { this.questionType = questionType; }
    public Integer getQuestionOrder() { return questionOrder; }
    public void setQuestionOrder(Integer questionOrder) { this.questionOrder = questionOrder; }
    public String getQuestionTitle() { return questionTitle; }
    public void setQuestionTitle(String questionTitle) { this.questionTitle = questionTitle; }
    public String getStandardAnswer() { return standardAnswer; }
    public void setStandardAnswer(String standardAnswer) { this.standardAnswer = standardAnswer; }
    public String getStudentAnswer() { return studentAnswer; }
    public void setStudentAnswer(String studentAnswer) { this.studentAnswer = studentAnswer; }
    public String getAnalysis() { return analysis; }
    public void setAnalysis(String analysis) { this.analysis = analysis; }
    public String getAttachmentUrl() { return attachmentUrl; }
    public void setAttachmentUrl(String attachmentUrl) { this.attachmentUrl = attachmentUrl; }
    public BigDecimal getQuestionScore() { return questionScore; }
    public void setQuestionScore(BigDecimal questionScore) { this.questionScore = questionScore; }
    public BigDecimal getActualScore() { return actualScore; }
    public void setActualScore(BigDecimal actualScore) { this.actualScore = actualScore; }
    public String getTeacherComment() { return teacherComment; }
    public void setTeacherComment(String teacherComment) { this.teacherComment = teacherComment; }
}
