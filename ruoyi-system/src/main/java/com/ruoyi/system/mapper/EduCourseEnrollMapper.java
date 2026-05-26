package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.course.EduCourse;
import com.ruoyi.system.domain.course.EduCourseEnroll;

/**
 * 课程注册数据层
 *
 * @author ruoyi
 */
public interface EduCourseEnrollMapper
{
    /**
     * 查询课程注册
     *
     * @param courseId 课程ID
     * @param studentId 学生ID
     * @return 课程注册
     */
    public EduCourseEnroll selectEduCourseEnroll(@Param("courseId") Long courseId, @Param("studentId") Long studentId);

    /**
     * 新增课程注册
     *
     * @param enroll 注册信息
     * @return 结果
     */
    public int insertEduCourseEnroll(EduCourseEnroll enroll);

    /**
     * 删除课程注册
     *
     * @param courseId 课程ID
     * @param studentId 学生ID
     * @return 结果
     */
    public int deleteEduCourseEnroll(@Param("courseId") Long courseId, @Param("studentId") Long studentId);

    /**
     * 按课程批量删除注册关系
     *
     * @param courseIds 课程ID数组
     * @return 结果
     */
    public int deleteEduCourseEnrollByCourseIds(Long[] courseIds);

    /**
     * 查询学生已注册课程
     *
     * @param studentId 学生ID
     * @return 课程集合
     */
    public List<EduCourse> selectStudentEnrolledCourseList(Long studentId);
}
