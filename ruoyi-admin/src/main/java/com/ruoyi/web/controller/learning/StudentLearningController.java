package com.ruoyi.web.controller.learning;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.service.IEduStudentLearningService;

/**
 * 学生学习接口
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/student/learning")
public class StudentLearningController extends BaseController
{
    @Autowired
    private IEduStudentLearningService studentLearningService;

    /**
     * 学习概览
     */
    @PreAuthorize("@ss.hasAnyRoles('student,admin')")
    @GetMapping("/overview")
    public AjaxResult overview()
    {
        return success(studentLearningService.selectLearningOverview(getUserId()));
    }

    /**
     * 我的考试
     */
    @PreAuthorize("@ss.hasAnyRoles('student,admin')")
    @GetMapping("/exams")
    public AjaxResult exams(@RequestParam(value = "status", required = false) String status)
    {
        return success(studentLearningService.selectStudentExamList(getUserId(), status));
    }

    /**
     * 标记内容已学习
     */
    @PreAuthorize("@ss.hasAnyRoles('student,admin')")
    @PostMapping("/contents/{contentId}/learn")
    public AjaxResult learnContent(@PathVariable Long contentId)
    {
        studentLearningService.markContentLearned(contentId, getUserId());
        return success();
    }

    /**
     * 开始考试
     */
    @PreAuthorize("@ss.hasAnyRoles('student,admin')")
    @PostMapping("/exams/{examId}/start")
    public AjaxResult startExam(@PathVariable Long examId)
    {
        return success(studentLearningService.startExam(examId, getUserId()));
    }

    /**
     * 提交考试
     */
    @PreAuthorize("@ss.hasAnyRoles('student,admin')")
    @PostMapping("/exam-records/{recordId}/submit")
    public AjaxResult submitExam(@PathVariable Long recordId)
    {
        studentLearningService.submitExam(recordId, getUserId());
        return success("考试已提交");
    }
}
