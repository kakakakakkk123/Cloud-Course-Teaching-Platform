package com.ruoyi.web.controller.portal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.system.domain.course.EduCourse;
import com.ruoyi.system.service.IEduCourseService;
import com.ruoyi.system.service.IEduPortalService;

/**
 * 首页门户接口
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/portal")
public class EduPortalController extends BaseController
{
    @Autowired
    private IEduPortalService portalService;

    @Autowired
    private IEduCourseService courseService;

    /**
     * 查询首页数据
     */
    @Anonymous
    @GetMapping("/home")
    public AjaxResult home()
    {
        return success(portalService.selectPortalHomeData());
    }

    /**
     * 查询门户课程列表
     */
    @Anonymous
    @GetMapping("/courses/list")
    public TableDataInfo courseList(EduCourse course)
    {
        startPage();
        return getDataTable(courseService.selectPortalCourseList(course));
    }

    /**
     * 查询课程详情
     */
    @Anonymous
    @GetMapping("/courses/{courseId}")
    public AjaxResult courseDetail(@PathVariable Long courseId)
    {
        LoginUser loginUser = getLoginUser();
        Long userId = loginUser == null ? null : loginUser.getUserId();
        return success(portalService.selectPortalCourseDetail(courseId, userId));
    }

    /**
     * 查询学生已注册课程
     */
    @PreAuthorize("@ss.hasAnyRoles('student,admin')")
    @GetMapping("/courses/my")
    public AjaxResult myCourses()
    {
        return success(portalService.selectStudentEnrolledCourseList(getUserId()));
    }

    /**
     * 查询学生已收藏课程
     */
    @PreAuthorize("@ss.hasAnyRoles('student,admin')")
    @GetMapping("/courses/favorites")
    public AjaxResult favoriteCourses()
    {
        return success(portalService.selectStudentFavoriteCourseList(getUserId()));
    }

    /**
     * 学生注册课程
     */
    @PreAuthorize("@ss.hasAnyRoles('student,admin')")
    @PostMapping("/courses/{courseId}/enroll")
    public AjaxResult enroll(@PathVariable Long courseId)
    {
        portalService.enrollCourse(courseId, getUserId());
        return success("课程注册成功");
    }

    /**
     * 点赞课程
     */
    @PreAuthorize("@ss.hasAnyRoles('student,teacher,admin')")
    @PostMapping("/courses/{courseId}/like")
    public AjaxResult like(@PathVariable Long courseId)
    {
        portalService.likeCourse(courseId, getUserId());
        return success("课程点赞成功");
    }

    /**
     * 取消点赞
     */
    @PreAuthorize("@ss.hasAnyRoles('student,teacher,admin')")
    @DeleteMapping("/courses/{courseId}/like")
    public AjaxResult cancelLike(@PathVariable Long courseId)
    {
        portalService.cancelCourseLike(courseId, getUserId());
        return success("已取消点赞");
    }

    /**
     * 收藏课程
     */
    @PreAuthorize("@ss.hasAnyRoles('student,admin')")
    @PostMapping("/courses/{courseId}/favorite")
    public AjaxResult favorite(@PathVariable Long courseId)
    {
        portalService.favoriteCourse(courseId, getUserId());
        return success("课程收藏成功");
    }

    /**
     * 取消收藏
     */
    @PreAuthorize("@ss.hasAnyRoles('student,admin')")
    @DeleteMapping("/courses/{courseId}/favorite")
    public AjaxResult cancelFavorite(@PathVariable Long courseId)
    {
        portalService.cancelCourseFavorite(courseId, getUserId());
        return success("已取消收藏");
    }
}
