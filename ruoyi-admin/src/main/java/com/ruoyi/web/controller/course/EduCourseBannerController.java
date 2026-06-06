package com.ruoyi.web.controller.course;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.course.EduCourseBanner;
import com.ruoyi.system.service.IEduCourseBannerService;

/**
 * 课程轮播图管理
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/edu/banner")
public class EduCourseBannerController extends BaseController
{
    @Autowired
    private IEduCourseBannerService bannerService;

    /**
     * 查询轮播图列表
     */
    @PreAuthorize("@ss.hasPermi('edu:banner:list')")
    @GetMapping("/list")
    public TableDataInfo list(EduCourseBanner banner)
    {
        startPage();
        return getDataTable(bannerService.selectEduCourseBannerList(banner));
    }

    /**
     * 查询轮播图详情
     */
    @PreAuthorize("@ss.hasPermi('edu:banner:query')")
    @GetMapping("/{bannerId}")
    public AjaxResult getInfo(@PathVariable Long bannerId)
    {
        return success(bannerService.selectEduCourseBannerById(bannerId));
    }

    /**
     * 新增轮播图
     */
    @PreAuthorize("@ss.hasPermi('edu:banner:add')")
    @Log(title = "课程轮播图", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody EduCourseBanner banner)
    {
        banner.setCreateBy(getUsername());
        return toAjax(bannerService.insertEduCourseBanner(banner));
    }

    /**
     * 修改轮播图
     */
    @PreAuthorize("@ss.hasPermi('edu:banner:edit')")
    @Log(title = "课程轮播图", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody EduCourseBanner banner)
    {
        banner.setUpdateBy(getUsername());
        return toAjax(bannerService.updateEduCourseBanner(banner));
    }

    /**
     * 删除轮播图
     */
    @PreAuthorize("@ss.hasPermi('edu:banner:remove')")
    @Log(title = "课程轮播图", businessType = BusinessType.DELETE)
    @DeleteMapping("/{bannerIds}")
    public AjaxResult remove(@PathVariable Long[] bannerIds)
    {
        return toAjax(bannerService.deleteEduCourseBannerByIds(bannerIds));
    }
}
