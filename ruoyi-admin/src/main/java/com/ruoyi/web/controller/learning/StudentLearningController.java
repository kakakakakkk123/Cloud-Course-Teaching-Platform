package com.ruoyi.web.controller.learning;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.learning.StudentExamAnswerBody;
import com.ruoyi.system.service.IEduStudentLearningService;

/**
 * 学生学习接口
 */
@RestController
@RequestMapping("/student/learning")
public class StudentLearningController extends BaseController
{
    @Autowired
    private IEduStudentLearningService studentLearningService;

    @PreAuthorize("@ss.hasAnyRoles('student,admin')")
    @GetMapping("/overview")
    public AjaxResult overview()
    {
        return success(studentLearningService.selectLearningOverview(getUserId()));
    }

    @PreAuthorize("@ss.hasAnyRoles('student,admin')")
    @GetMapping("/exams")
    public AjaxResult exams(@RequestParam(value = "status", required = false) String status)
    {
        return success(studentLearningService.selectStudentExamList(getUserId(), status));
    }

    @PreAuthorize("@ss.hasAnyRoles('student,admin')")
    @PostMapping("/contents/{contentId}/learn")
    public AjaxResult learnContent(@PathVariable Long contentId)
    {
        studentLearningService.markContentLearned(contentId, getUserId());
        return success();
    }

    @PreAuthorize("@ss.hasAnyRoles('student,admin')")
    @PostMapping("/exams/{examId}/start")
    public AjaxResult startExam(@PathVariable Long examId)
    {
        return success(studentLearningService.startExam(examId, getUserId()));
    }

    @PreAuthorize("@ss.hasAnyRoles('student,admin')")
    @GetMapping("/exam-records/{recordId}/paper")
    public AjaxResult examPaper(@PathVariable Long recordId)
    {
        return success(studentLearningService.selectStudentExamPaper(recordId, getUserId()));
    }

    @PreAuthorize("@ss.hasAnyRoles('student,admin')")
    @PostMapping("/exam-records/{recordId}/answers")
    public AjaxResult saveAnswers(@PathVariable Long recordId, @RequestBody(required = false) StudentExamAnswerBody body)
    {
        studentLearningService.saveExamAnswers(recordId, getUserId(), body);
        return success("答案已保存");
    }

    @PreAuthorize("@ss.hasAnyRoles('student,admin')")
    @PostMapping("/exam-records/{recordId}/submit")
    public AjaxResult submitExam(@PathVariable Long recordId)
    {
        studentLearningService.submitExam(recordId, getUserId());
        return success("考试已提交");
    }

    @PreAuthorize("@ss.hasAnyRoles('student,admin')")
    @GetMapping("/exam-records/{recordId}/result")
    public AjaxResult examResult(@PathVariable Long recordId)
    {
        return success(studentLearningService.selectStudentExamResult(recordId, getUserId()));
    }
}
