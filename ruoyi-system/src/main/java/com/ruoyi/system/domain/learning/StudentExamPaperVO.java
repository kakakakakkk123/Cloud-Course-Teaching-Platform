package com.ruoyi.system.domain.learning;

import java.util.Date;
import java.util.List;

/**
 * 学生答题页视图
 */
public class StudentExamPaperVO
{
    private Long recordId;
    private Long examId;
    private Long paperId;
    private Long courseId;
    private String examName;
    private String courseName;
    private String paperName;
    private String examNotice;
    private Integer durationMinutes;
    private Integer durationSeconds;
    private Integer remainingSeconds;
    private Date startTime;
    private Date endTime;
    private Date recordStartTime;
    private String recordStatus;
    private String showAnswerAfterSubmit;
    private String showScoreAfterSubmit;
    private List<StudentExamQuestionVO> questionList;

    public Long getRecordId()
    {
        return recordId;
    }

    public void setRecordId(Long recordId)
    {
        this.recordId = recordId;
    }

    public Long getExamId()
    {
        return examId;
    }

    public void setExamId(Long examId)
    {
        this.examId = examId;
    }

    public Long getPaperId()
    {
        return paperId;
    }

    public void setPaperId(Long paperId)
    {
        this.paperId = paperId;
    }

    public Long getCourseId()
    {
        return courseId;
    }

    public void setCourseId(Long courseId)
    {
        this.courseId = courseId;
    }

    public String getExamName()
    {
        return examName;
    }

    public void setExamName(String examName)
    {
        this.examName = examName;
    }

    public String getCourseName()
    {
        return courseName;
    }

    public void setCourseName(String courseName)
    {
        this.courseName = courseName;
    }

    public String getPaperName()
    {
        return paperName;
    }

    public void setPaperName(String paperName)
    {
        this.paperName = paperName;
    }

    public String getExamNotice()
    {
        return examNotice;
    }

    public void setExamNotice(String examNotice)
    {
        this.examNotice = examNotice;
    }

    public Integer getDurationMinutes()
    {
        return durationMinutes;
    }

    public void setDurationMinutes(Integer durationMinutes)
    {
        this.durationMinutes = durationMinutes;
    }

    public Integer getDurationSeconds()
    {
        return durationSeconds;
    }

    public void setDurationSeconds(Integer durationSeconds)
    {
        this.durationSeconds = durationSeconds;
    }

    public Integer getRemainingSeconds()
    {
        return remainingSeconds;
    }

    public void setRemainingSeconds(Integer remainingSeconds)
    {
        this.remainingSeconds = remainingSeconds;
    }

    public Date getStartTime()
    {
        return startTime;
    }

    public void setStartTime(Date startTime)
    {
        this.startTime = startTime;
    }

    public Date getEndTime()
    {
        return endTime;
    }

    public void setEndTime(Date endTime)
    {
        this.endTime = endTime;
    }

    public Date getRecordStartTime()
    {
        return recordStartTime;
    }

    public void setRecordStartTime(Date recordStartTime)
    {
        this.recordStartTime = recordStartTime;
    }

    public String getRecordStatus()
    {
        return recordStatus;
    }

    public void setRecordStatus(String recordStatus)
    {
        this.recordStatus = recordStatus;
    }

    public String getShowAnswerAfterSubmit()
    {
        return showAnswerAfterSubmit;
    }

    public void setShowAnswerAfterSubmit(String showAnswerAfterSubmit)
    {
        this.showAnswerAfterSubmit = showAnswerAfterSubmit;
    }

    public String getShowScoreAfterSubmit()
    {
        return showScoreAfterSubmit;
    }

    public void setShowScoreAfterSubmit(String showScoreAfterSubmit)
    {
        this.showScoreAfterSubmit = showScoreAfterSubmit;
    }

    public List<StudentExamQuestionVO> getQuestionList()
    {
        return questionList;
    }

    public void setQuestionList(List<StudentExamQuestionVO> questionList)
    {
        this.questionList = questionList;
    }
}
