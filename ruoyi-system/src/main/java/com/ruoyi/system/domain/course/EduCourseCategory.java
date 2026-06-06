package com.ruoyi.system.domain.course;

import java.util.ArrayList;
import java.util.List;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.common.xss.Xss;

/**
 * 课程分类对象 edu_course_category
 *
 * @author ruoyi
 */
public class EduCourseCategory extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 分类ID */
    private Long categoryId;

    /** 父分类ID */
    private Long parentId;

    /** 祖级列表 */
    private String ancestors;

    /** 分类名称 */
    private String categoryName;

    /** 显示顺序 */
    private Integer orderNum;

    /** 分类图标 */
    private String icon;

    /** 状态 */
    private String status;

    /** 删除标志 */
    private String delFlag;

    /** 子分类 */
    private List<EduCourseCategory> children = new ArrayList<>();

    public Long getCategoryId()
    {
        return categoryId;
    }

    public void setCategoryId(Long categoryId)
    {
        this.categoryId = categoryId;
    }

    @NotNull(message = "父分类不能为空")
    public Long getParentId()
    {
        return parentId;
    }

    public void setParentId(Long parentId)
    {
        this.parentId = parentId;
    }

    public String getAncestors()
    {
        return ancestors;
    }

    public void setAncestors(String ancestors)
    {
        this.ancestors = ancestors;
    }

    @Xss(message = "分类名称不能包含脚本字符")
    @NotBlank(message = "分类名称不能为空")
    @Size(max = 100, message = "分类名称长度不能超过100个字符")
    public String getCategoryName()
    {
        return categoryName;
    }

    public void setCategoryName(String categoryName)
    {
        this.categoryName = categoryName;
    }

    public Integer getOrderNum()
    {
        return orderNum;
    }

    public void setOrderNum(Integer orderNum)
    {
        this.orderNum = orderNum;
    }

    @Size(max = 100, message = "分类图标长度不能超过100个字符")
    public String getIcon()
    {
        return icon;
    }

    public void setIcon(String icon)
    {
        this.icon = icon;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getDelFlag()
    {
        return delFlag;
    }

    public void setDelFlag(String delFlag)
    {
        this.delFlag = delFlag;
    }

    public List<EduCourseCategory> getChildren()
    {
        return children;
    }

    public void setChildren(List<EduCourseCategory> children)
    {
        this.children = children;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("categoryId", getCategoryId())
                .append("parentId", getParentId())
                .append("ancestors", getAncestors())
                .append("categoryName", getCategoryName())
                .append("orderNum", getOrderNum())
                .append("icon", getIcon())
                .append("status", getStatus())
                .append("delFlag", getDelFlag())
                .append("createBy", getCreateBy())
                .append("createTime", getCreateTime())
                .append("updateBy", getUpdateBy())
                .append("updateTime", getUpdateTime())
                .append("remark", getRemark())
                .toString();
    }
}
