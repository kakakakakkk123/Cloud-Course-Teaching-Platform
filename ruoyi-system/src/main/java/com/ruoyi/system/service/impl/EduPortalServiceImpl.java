package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.course.EduCourse;
import com.ruoyi.system.domain.course.EduCourseEnroll;
import com.ruoyi.system.domain.course.EduCourseFavorite;
import com.ruoyi.system.domain.course.EduCourseLike;
import com.ruoyi.system.domain.course.vo.EduPortalCourseDetailVO;
import com.ruoyi.system.domain.course.vo.EduPortalHomeVO;
import com.ruoyi.system.mapper.EduCourseEnrollMapper;
import com.ruoyi.system.mapper.EduCourseFavoriteMapper;
import com.ruoyi.system.mapper.EduCourseLikeMapper;
import com.ruoyi.system.mapper.EduCourseMapper;
import com.ruoyi.system.service.IEduCourseBannerService;
import com.ruoyi.system.service.IEduCourseCategoryService;
import com.ruoyi.system.service.IEduCourseContentService;
import com.ruoyi.system.service.IEduCourseService;
import com.ruoyi.system.service.IEduPortalService;

/**
 * 门户首页服务实现
 *
 * @author ruoyi
 */
@Service
public class EduPortalServiceImpl implements IEduPortalService
{
    @Autowired
    private IEduCourseBannerService bannerService;

    @Autowired
    private IEduCourseCategoryService categoryService;

    @Autowired
    private IEduCourseService courseService;

    @Autowired
    private IEduCourseContentService contentService;

    @Autowired
    private EduCourseMapper courseMapper;

    @Autowired
    private EduCourseEnrollMapper enrollMapper;

    @Autowired
    private EduCourseLikeMapper likeMapper;

    @Autowired
    private EduCourseFavoriteMapper favoriteMapper;

    /**
     * 查询门户首页数据
     */
    @Override
    public EduPortalHomeVO selectPortalHomeData()
    {
        EduPortalHomeVO homeVO = new EduPortalHomeVO();
        homeVO.setBanners(bannerService.selectActiveBannerList());
        homeVO.setCategories(categoryService.selectPortalCategoryTree());
        homeVO.setRecommendCourses(courseService.selectRecommendCourseList(8));
        homeVO.setHotCourses(courseService.selectHotCourseList(8));
        homeVO.setLatestCourses(courseService.selectLatestCourseList(8));
        return homeVO;
    }

    /**
     * 查询课程详情
     */
    @Override
    public EduPortalCourseDetailVO selectPortalCourseDetail(Long courseId, Long userId)
    {
        EduCourse course = courseService.selectPublishedCourseById(courseId);
        if (StringUtils.isNull(course))
        {
            throw new ServiceException("课程不存在或尚未发布");
        }
        courseMapper.increaseViewCount(courseId);
        EduPortalCourseDetailVO detailVO = new EduPortalCourseDetailVO();
        detailVO.setCourse(courseService.selectPublishedCourseById(courseId));
        detailVO.setContentList(contentService.selectPublishedContentByCourseId(courseId));
        if (userId != null)
        {
            detailVO.setRegistered(enrollMapper.selectEduCourseEnroll(courseId, userId) != null);
            detailVO.setLiked(likeMapper.selectEduCourseLike(courseId, userId) != null);
            detailVO.setFavorited(favoriteMapper.selectEduCourseFavorite(courseId, userId) != null);
        }
        return detailVO;
    }

    /**
     * 查询学生已注册课程
     */
    @Override
    public List<EduCourse> selectStudentEnrolledCourseList(Long studentId)
    {
        return enrollMapper.selectStudentEnrolledCourseList(studentId);
    }

    /**
     * 查询学生已收藏课程
     */
    @Override
    public List<EduCourse> selectStudentFavoriteCourseList(Long studentId)
    {
        return favoriteMapper.selectUserFavoriteCourseList(studentId);
    }

    /**
     * 学生注册课程
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void enrollCourse(Long courseId, Long studentId)
    {
        ensureStudentRole();
        EduCourse course = courseService.selectPublishedCourseById(courseId);
        if (StringUtils.isNull(course))
        {
            throw new ServiceException("课程不存在或尚未发布");
        }
        if (!"1".equals(course.getAllowRegister()))
        {
            throw new ServiceException("当前课程暂不支持注册");
        }
        if (enrollMapper.selectEduCourseEnroll(courseId, studentId) != null)
        {
            throw new ServiceException("你已经注册过这门课程");
        }
        EduCourseEnroll enroll = new EduCourseEnroll();
        enroll.setCourseId(courseId);
        enroll.setStudentId(studentId);
        enroll.setEnrollSource("1");
        enroll.setEnrollStatus("1");
        enroll.setCreateBy(SecurityUtils.getUsername());
        enrollMapper.insertEduCourseEnroll(enroll);
        courseMapper.refreshEnrollCount(courseId);
    }

    /**
     * 用户点赞课程
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void likeCourse(Long courseId, Long userId)
    {
        EduCourse course = courseService.selectPublishedCourseById(courseId);
        if (StringUtils.isNull(course))
        {
            throw new ServiceException("课程不存在或尚未发布");
        }
        if (likeMapper.selectEduCourseLike(courseId, userId) != null)
        {
            throw new ServiceException("你已经点过赞了");
        }
        EduCourseLike courseLike = new EduCourseLike();
        courseLike.setCourseId(courseId);
        courseLike.setUserId(userId);
        likeMapper.insertEduCourseLike(courseLike);
        courseMapper.refreshLikeCount(courseId);
    }

    /**
     * 用户取消点赞
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancelCourseLike(Long courseId, Long userId)
    {
        likeMapper.deleteEduCourseLike(courseId, userId);
        courseMapper.refreshLikeCount(courseId);
    }

    /**
     * 学生收藏课程
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void favoriteCourse(Long courseId, Long studentId)
    {
        ensureStudentRole();
        EduCourse course = courseService.selectPublishedCourseById(courseId);
        if (StringUtils.isNull(course))
        {
            throw new ServiceException("课程不存在或尚未发布");
        }
        if (favoriteMapper.selectEduCourseFavorite(courseId, studentId) != null)
        {
            throw new ServiceException("你已经收藏过这门课程");
        }
        EduCourseFavorite courseFavorite = new EduCourseFavorite();
        courseFavorite.setCourseId(courseId);
        courseFavorite.setUserId(studentId);
        favoriteMapper.insertEduCourseFavorite(courseFavorite);
    }

    /**
     * 学生取消收藏
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancelCourseFavorite(Long courseId, Long studentId)
    {
        favoriteMapper.deleteEduCourseFavorite(courseId, studentId);
    }

    /**
     * 校验当前用户是否为学生角色
     */
    private void ensureStudentRole()
    {
        if (SecurityUtils.isAdmin())
        {
            return;
        }
        if (!SecurityUtils.hasRole("student"))
        {
            throw new ServiceException("只有学生账号可以注册课程");
        }
    }
}
