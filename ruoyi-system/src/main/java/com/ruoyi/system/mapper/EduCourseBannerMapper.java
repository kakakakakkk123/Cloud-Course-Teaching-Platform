package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.course.EduCourseBanner;

/**
 * 课程轮播图数据层
 *
 * @author ruoyi
 */
public interface EduCourseBannerMapper
{
    /**
     * 查询轮播图
     *
     * @param bannerId 轮播图ID
     * @return 轮播图
     */
    public EduCourseBanner selectEduCourseBannerById(Long bannerId);

    /**
     * 查询轮播图列表
     *
     * @param banner 轮播图
     * @return 轮播图集合
     */
    public List<EduCourseBanner> selectEduCourseBannerList(EduCourseBanner banner);

    /**
     * 查询门户可用轮播图
     *
     * @return 轮播图集合
     */
    public List<EduCourseBanner> selectActiveBannerList();

    /**
     * 新增轮播图
     *
     * @param banner 轮播图
     * @return 结果
     */
    public int insertEduCourseBanner(EduCourseBanner banner);

    /**
     * 修改轮播图
     *
     * @param banner 轮播图
     * @return 结果
     */
    public int updateEduCourseBanner(EduCourseBanner banner);

    /**
     * 删除轮播图
     *
     * @param bannerId 轮播图ID
     * @return 结果
     */
    public int deleteEduCourseBannerById(Long bannerId);

    /**
     * 批量删除轮播图
     *
     * @param bannerIds 轮播图ID数组
     * @return 结果
     */
    public int deleteEduCourseBannerByIds(Long[] bannerIds);
}
