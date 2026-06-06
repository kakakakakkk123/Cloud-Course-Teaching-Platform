package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.course.EduCourseBanner;
import com.ruoyi.system.mapper.EduCourseBannerMapper;
import com.ruoyi.system.service.IEduCourseBannerService;

/**
 * 课程轮播图服务实现
 *
 * @author ruoyi
 */
@Service
public class EduCourseBannerServiceImpl implements IEduCourseBannerService
{
    @Autowired
    private EduCourseBannerMapper bannerMapper;

    /**
     * 查询轮播图
     */
    @Override
    public EduCourseBanner selectEduCourseBannerById(Long bannerId)
    {
        return bannerMapper.selectEduCourseBannerById(bannerId);
    }

    /**
     * 查询轮播图列表
     */
    @Override
    public List<EduCourseBanner> selectEduCourseBannerList(EduCourseBanner banner)
    {
        return bannerMapper.selectEduCourseBannerList(banner);
    }

    /**
     * 查询门户可用轮播图
     */
    @Override
    public List<EduCourseBanner> selectActiveBannerList()
    {
        return bannerMapper.selectActiveBannerList();
    }

    /**
     * 新增轮播图
     */
    @Override
    public int insertEduCourseBanner(EduCourseBanner banner)
    {
        fillBannerDefaults(banner);
        return bannerMapper.insertEduCourseBanner(banner);
    }

    /**
     * 修改轮播图
     */
    @Override
    public int updateEduCourseBanner(EduCourseBanner banner)
    {
        fillBannerDefaults(banner);
        return bannerMapper.updateEduCourseBanner(banner);
    }

    /**
     * 删除轮播图
     */
    @Override
    public int deleteEduCourseBannerById(Long bannerId)
    {
        return bannerMapper.deleteEduCourseBannerById(bannerId);
    }

    /**
     * 批量删除轮播图
     */
    @Override
    public int deleteEduCourseBannerByIds(Long[] bannerIds)
    {
        return bannerMapper.deleteEduCourseBannerByIds(bannerIds);
    }

    /**
     * 填充轮播图默认值
     */
    private void fillBannerDefaults(EduCourseBanner banner)
    {
        if (banner.getSortOrder() == null)
        {
            banner.setSortOrder(0);
        }
        if (StringUtils.isEmpty(banner.getStatus()))
        {
            banner.setStatus("0");
        }
    }
}
