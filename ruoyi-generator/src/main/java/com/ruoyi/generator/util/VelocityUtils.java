package com.ruoyi.generator.util;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.apache.velocity.VelocityContext;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.constant.GenConstants;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.generator.domain.GenTable;
import com.ruoyi.generator.domain.GenTableColumn;

/**
 * 模板处理工具类
 * 
 * @author ruoyi
 */
public class VelocityUtils
{
    /** 项目空间路径 */
    private static final String PROJECT_PATH = "main/java";

    /** mybatis空间路径 */
    private static final String MYBATIS_PATH = "main/resources/mapper";

    /** 默认上级菜单，系统工具 */
    private static final String DEFAULT_PARENT_MENU_ID = "3";

    /** Vue3 Element Plus 模版 */
    private static final String ELEMENT_PLUS = "element-plus";

    /** Vue3 Element Plus TypeScript 模版 */
    private static final String ELEMENT_PLUS_TYPESSRIPT = "element-plus-typescript";

    /**
     * 设置模板变量信息
     *
     * @return 模板列表
     */
    public static VelocityContext prepareContext(GenTable genTable)
    {
        String moduleName = genTable.getModuleName();
        String businessName = genTable.getBusinessName();
        String packageName = genTable.getPackageName();
        String tplCategory = genTable.getTplCategory();
        String functionName = genTable.getFunctionName();

        VelocityContext velocityContext = new VelocityContext();
        velocityContext.put("tplCategory", genTable.getTplCategory());
        velocityContext.put("tableName", genTable.getTableName());
        velocityContext.put("functionName", StringUtils.isNotEmpty(functionName) ? functionName : "【请填写功能名称】");
        velocityContext.put("ClassName", genTable.getClassName());
        velocityContext.put("className", StringUtils.uncapitalize(genTable.getClassName()));
        velocityContext.put("moduleName", genTable.getModuleName());
        velocityContext.put("BusinessName", StringUtils.capitalize(genTable.getBusinessName()));
        velocityContext.put("businessName", genTable.getBusinessName());
        velocityContext.put("basePackage", getPackagePrefix(packageName));
        velocityContext.put("packageName", packageName);
        velocityContext.put("author", genTable.getFunctionAuthor());
        velocityContext.put("colSpan", getColSpan(genTable.getFormColNum()));
        velocityContext.put("datetime", DateUtils.getDate());
        velocityContext.put("pkColumn", genTable.getPkColumn());
        velocityContext.put("importList", getImportList(genTable));
        velocityContext.put("permissionPrefix", getPermissionPrefix(moduleName, businessName));
        velocityContext.put("columns", genTable.getColumns());
        velocityContext.put("table", genTable);
        velocityContext.put("dicts", getDicts(genTable));
        setExtensionsContext(velocityContext, genTable.getOptions());
        setMenuVelocityContext(velocityContext, genTable);
        if (GenConstants.TPL_TREE.equals(tplCategory))
        {
            setTreeVelocityContext(velocityContext, genTable);
        }
        if (GenConstants.TPL_SUB.equals(tplCategory))
        {
            setSubVelocityContext(velocityContext, genTable);
        }
        return velocityContext;
    }

    public static void setExtensionsContext(VelocityContext context, String options)
    {
        JSONObject paramsObj = JSONObject.parseObject(options);
        boolean genView = genView(paramsObj);
        context.put("genView", genView);
    }

    public static void setMenuVelocityContext(VelocityContext context, GenTable genTable)
    {
        String options = genTable.getOptions();
        JSONObject paramsObj = JSON.parseObject(options);
        String parentMenuId = getParentMenuId(paramsObj);
        context.put("parentMenuId", parentMenuId);
    }

    public static void setTreeVelocityContext(VelocityContext context, GenTable genTable)
    {
        String options = genTable.getOptions();
        JSONObject paramsObj = JSON.parseObject(options);
        String treeCode = getTreecode(paramsObj);
        String treeParentCode = getTreeParentCode(paramsObj);
        String treeName = getTreeName(paramsObj);

        context.put("treeCode", treeCode);
        context.put("treeParentCode", treeParentCode);
        context.put("treeName", treeName);
        context.put("expandColumn", getExpandColumn(genTable));
        if (paramsObj.containsKey(GenConstants.TREE_PARENT_CODE))
        {
            context.put("tree_parent_code", paramsObj.getString(GenConstants.TREE_PARENT_CODE));
        }
        if (paramsObj.containsKey(GenConstants.TREE_NAME))
        {
            context.put("tree_name", paramsObj.getString(GenConstants.TREE_NAME));
        }
    }

    public static void setSubVelocityContext(VelocityContext context, GenTable genTable)
    {
        GenTable subTable = genTable.getSubTable();
        String subTableName = genTable.getSubTableName();
        String subTableFkName = genTable.getSubTableFkName();
        String subClassName = genTable.getSubTable().getClassName();
        String subTableFkClassName = StringUtils.convertToCamelCase(subTableFkName);

        context.put("subTable", subTable);
        context.put("subTableName", subTableName);
        context.put("subTableFkName", subTableFkName);
        context.put("subTableFkClassName", subTableFkClassName);
        context.put("subTableFkclassName", StringUtils.uncapitalize(subTableFkClassName));
        context.put("subClassName", subClassName);
        context.put("subclassName", StringUtils.uncapitalize(subClassName));
        context.put("subImportList", getImportList(genTable.getSubTable()));
    }

    /**
     * 获取模板信息
     * @param tplCategory 生成的模板
     * @param tplWebType 前端类型
     * @return 模板列表
     */
    public static List<String> getTemplateList(GenTable table)
    {
        String tplWebType = table.getTplWebType();
        String tplCategory = table.getTplCategory();
        JSONObject paramsObj = JSONObject.parseObject(table.getOptions());
        boolean isView = genView(paramsObj);

        String useWebType = getWebTemplatePath(tplWebType);
        List<String> templates = getBaseTemplates(getApiTemplate(tplWebType));
        addTypeScriptTemplates(templates, tplWebType);
        addPageTemplates(templates, tplCategory, useWebType);
        if (isView)
        {
            templates.add(useWebType + "/view.vue.vm");
        }
        return templates;
    }

    private static List<String> getBaseTemplates(String apiTemplate)
    {
        List<String> templates = new ArrayList<String>();
        templates.add("vm/java/domain.java.vm");
        templates.add("vm/java/mapper.java.vm");
        templates.add("vm/java/service.java.vm");
        templates.add("vm/java/serviceImpl.java.vm");
        templates.add("vm/java/controller.java.vm");
        templates.add("vm/xml/mapper.xml.vm");
        templates.add("vm/sql/sql.vm");
        templates.add(apiTemplate);
        return templates;
    }

    private static String getWebTemplatePath(String tplWebType)
    {
        if (StringUtils.equals(ELEMENT_PLUS, tplWebType))
        {
            return "vm/vue/v3";
        }
        if (StringUtils.equals(ELEMENT_PLUS_TYPESSRIPT, tplWebType))
        {
            return "vm/vue/v3ts";
        }
        return "vm/vue";
    }

    private static String getApiTemplate(String tplWebType)
    {
        return StringUtils.equals(ELEMENT_PLUS_TYPESSRIPT, tplWebType) ? "vm/ts/api.ts.vm" : "vm/js/api.js.vm";
    }

    private static void addTypeScriptTemplates(List<String> templates, String tplWebType)
    {
        if (StringUtils.equals(ELEMENT_PLUS_TYPESSRIPT, tplWebType))
        {
            templates.add("vm/ts/type.ts.vm");
            templates.add("vm/ts/index.ts.vm");
        }
    }

    private static void addPageTemplates(List<String> templates, String tplCategory, String useWebType)
    {
        if (GenConstants.TPL_CRUD.equals(tplCategory))
        {
            templates.add(useWebType + "/index.vue.vm");
        }
        else if (GenConstants.TPL_TREE.equals(tplCategory))
        {
            templates.add(useWebType + "/index-tree.vue.vm");
        }
        else if (GenConstants.TPL_SUB.equals(tplCategory))
        {
            templates.add(useWebType + "/index.vue.vm");
            templates.add("vm/java/sub-domain.java.vm");
        }
    }

    /**
     * 获取文件名
     */
    public static String getFileName(String template, GenTable genTable)
    {
        // 包路径
        String packageName = genTable.getPackageName();
        // 模块名
        String moduleName = genTable.getModuleName();
        // 大写类名
        String className = genTable.getClassName();
        // 业务名称
        String businessName = genTable.getBusinessName();

        String javaPath = PROJECT_PATH + "/" + StringUtils.replace(packageName, ".", "/");
        String mybatisPath = MYBATIS_PATH + "/" + moduleName;
        String vuePath = "vue";

        String javaFileName = getJavaFileName(template, genTable, javaPath, className);
        if (StringUtils.isNotEmpty(javaFileName))
        {
            return javaFileName;
        }
        String mapperFileName = getMapperXmlFileName(template, mybatisPath, className);
        if (StringUtils.isNotEmpty(mapperFileName))
        {
            return mapperFileName;
        }
        String apiFileName = getApiFileName(template, vuePath, moduleName, businessName);
        if (StringUtils.isNotEmpty(apiFileName))
        {
            return apiFileName;
        }
        String vueFileName = getVueFileName(template, vuePath, moduleName, businessName);
        if (StringUtils.isNotEmpty(vueFileName))
        {
            return vueFileName;
        }
        return getSqlFileName(template, businessName);
    }

    private static String getJavaFileName(String template, GenTable genTable, String javaPath, String className)
    {
        if (template.contains("sub-domain.java.vm") && StringUtils.equals(GenConstants.TPL_SUB, genTable.getTplCategory()))
        {
            return StringUtils.format("{}/domain/{}.java", javaPath, genTable.getSubTable().getClassName());
        }
        if (template.contains("domain.java.vm"))
        {
            return StringUtils.format("{}/domain/{}.java", javaPath, className);
        }
        if (template.contains("mapper.java.vm"))
        {
            return StringUtils.format("{}/mapper/{}Mapper.java", javaPath, className);
        }
        if (template.contains("service.java.vm"))
        {
            return StringUtils.format("{}/service/I{}Service.java", javaPath, className);
        }
        if (template.contains("serviceImpl.java.vm"))
        {
            return StringUtils.format("{}/service/impl/{}ServiceImpl.java", javaPath, className);
        }
        if (template.contains("controller.java.vm"))
        {
            return StringUtils.format("{}/controller/{}Controller.java", javaPath, className);
        }
        return StringUtils.EMPTY;
    }

    private static String getMapperXmlFileName(String template, String mybatisPath, String className)
    {
        if (template.contains("mapper.xml.vm"))
        {
            return StringUtils.format("{}/{}Mapper.xml", mybatisPath, className);
        }
        return StringUtils.EMPTY;
    }

    private static String getSqlFileName(String template, String businessName)
    {
        if (template.contains("sql.vm"))
        {
            return businessName + "Menu.sql";
        }
        return StringUtils.EMPTY;
    }

    private static String getApiFileName(String template, String vuePath, String moduleName, String businessName)
    {
        if (template.contains("api.js.vm"))
        {
            return StringUtils.format("{}/api/{}/{}.js", vuePath, moduleName, businessName);
        }
        if (template.contains("api.ts.vm"))
        {
            return StringUtils.format("{}/api/{}/{}.ts", vuePath, moduleName, businessName);
        }
        if (template.contains("type.ts.vm"))
        {
            return StringUtils.format("{}/types/api/{}/{}.ts", vuePath, moduleName, businessName);
        }
        if (template.contains("index.ts.vm"))
        {
            return StringUtils.format("{}/types/api/index-bak.ts", vuePath);
        }
        return StringUtils.EMPTY;
    }

    private static String getVueFileName(String template, String vuePath, String moduleName, String businessName)
    {
        if (template.contains("index.vue.vm"))
        {
            return StringUtils.format("{}/views/{}/{}/index.vue", vuePath, moduleName, businessName);
        }
        if (template.contains("index-tree.vue.vm"))
        {
            return StringUtils.format("{}/views/{}/{}/index.vue", vuePath, moduleName, businessName);
        }
        if (template.contains("view.vue.vm"))
        {
            return StringUtils.format("{}/views/{}/{}/view.vue", vuePath, moduleName, businessName);
        }
        return StringUtils.EMPTY;
    }

    /**
     * 获取包前缀
     *
     * @param packageName 包名称
     * @return 包前缀名称
     */
    public static String getPackagePrefix(String packageName)
    {
        int lastIndex = packageName.lastIndexOf(".");
        return StringUtils.substring(packageName, 0, lastIndex);
    }

    /**
     * 根据列类型获取导入包
     * 
     * @param genTable 业务表对象
     * @return 返回需要导入的包列表
     */
    public static HashSet<String> getImportList(GenTable genTable)
    {
        List<GenTableColumn> columns = genTable.getColumns();
        GenTable subGenTable = genTable.getSubTable();
        HashSet<String> importList = new HashSet<String>();
        if (StringUtils.isNotNull(subGenTable))
        {
            importList.add("java.util.List");
        }
        for (GenTableColumn column : columns)
        {
            if (!column.isSuperColumn() && GenConstants.TYPE_DATE.equals(column.getJavaType()))
            {
                importList.add("java.util.Date");
                importList.add("com.fasterxml.jackson.annotation.JsonFormat");
            }
            else if (!column.isSuperColumn() && GenConstants.TYPE_BIGDECIMAL.equals(column.getJavaType()))
            {
                importList.add("java.math.BigDecimal");
            }
        }
        return importList;
    }

    /**
     * 根据列类型获取字典组
     * 
     * @param genTable 业务表对象
     * @return 返回字典组
     */
    public static String getDicts(GenTable genTable)
    {
        List<GenTableColumn> columns = genTable.getColumns();
        Set<String> dicts = new HashSet<String>();
        addDicts(dicts, columns);
        if (StringUtils.isNotNull(genTable.getSubTable()))
        {
            List<GenTableColumn> subColumns = genTable.getSubTable().getColumns();
            addDicts(dicts, subColumns);
        }
        return StringUtils.join(dicts, ", ");
    }

    /**
     * 添加字典列表
     * 
     * @param dicts 字典列表
     * @param columns 列集合
     */
    public static void addDicts(Set<String> dicts, List<GenTableColumn> columns)
    {
        for (GenTableColumn column : columns)
        {
            if (!column.isSuperColumn() && StringUtils.isNotEmpty(column.getDictType()) && StringUtils.equalsAny(
                    column.getHtmlType(),
                    new String[] { GenConstants.HTML_SELECT, GenConstants.HTML_RADIO, GenConstants.HTML_CHECKBOX }))
            {
                dicts.add("'" + column.getDictType() + "'");
            }
        }
    }

    /**
     * 获取权限前缀
     *
     * @param moduleName 模块名称
     * @param businessName 业务名称
     * @return 返回权限前缀
     */
    public static String getPermissionPrefix(String moduleName, String businessName)
    {
        return StringUtils.format("{}:{}", moduleName, businessName);
    }

    /**
     * 获取上级菜单ID字段
     *
     * @param paramsObj 生成其他选项
     * @return 上级菜单ID字段
     */
    public static String getParentMenuId(JSONObject paramsObj)
    {
        if (StringUtils.isNotEmpty(paramsObj) && paramsObj.containsKey(GenConstants.PARENT_MENU_ID)
                && StringUtils.isNotEmpty(paramsObj.getString(GenConstants.PARENT_MENU_ID)))
        {
            return paramsObj.getString(GenConstants.PARENT_MENU_ID);
        }
        return DEFAULT_PARENT_MENU_ID;
    }

    /**
     * 获取树编码
     *
     * @param paramsObj 生成其他选项
     * @return 树编码
     */
    public static String getTreecode(JSONObject paramsObj)
    {
        if (paramsObj.containsKey(GenConstants.TREE_CODE))
        {
            return StringUtils.toCamelCase(paramsObj.getString(GenConstants.TREE_CODE));
        }
        return StringUtils.EMPTY;
    }

    /**
     * 获取树父编码
     *
     * @param paramsObj 生成其他选项
     * @return 树父编码
     */
    public static String getTreeParentCode(JSONObject paramsObj)
    {
        if (paramsObj.containsKey(GenConstants.TREE_PARENT_CODE))
        {
            return StringUtils.toCamelCase(paramsObj.getString(GenConstants.TREE_PARENT_CODE));
        }
        return StringUtils.EMPTY;
    }

    /**
     * 扩展功能/生成详情页
     * 
     * @param paramsObj 生成其他选项
     * @return 是否生成详细页
     */
    public static boolean genView(JSONObject paramsObj)
    {
        if (StringUtils.isNotNull(paramsObj) && paramsObj.containsKey(GenConstants.GEN_VIEW))
        {
            return paramsObj.getBoolean(GenConstants.GEN_VIEW);
        }
        return false;
    }

    /**
     * 获取树名称
     *
     * @param paramsObj 生成其他选项
     * @return 树名称
     */
    public static String getTreeName(JSONObject paramsObj)
    {
        if (paramsObj.containsKey(GenConstants.TREE_NAME))
        {
            return StringUtils.toCamelCase(paramsObj.getString(GenConstants.TREE_NAME));
        }
        return StringUtils.EMPTY;
    }

    /**
     * 获取需要在哪一列上面显示展开按钮
     *
     * @param genTable 业务表对象
     * @return 展开按钮列序号
     */
    public static int getExpandColumn(GenTable genTable)
    {
        String options = genTable.getOptions();
        JSONObject paramsObj = JSON.parseObject(options);
        String treeName = paramsObj.getString(GenConstants.TREE_NAME);
        int num = 0;
        for (GenTableColumn column : genTable.getColumns())
        {
            if (column.isList())
            {
                num++;
                String columnName = column.getColumnName();
                if (columnName.equals(treeName))
                {
                    break;
                }
            }
        }
        return num;
    }

    /**
     * 获取表单 el-col span
     * 
     * @param formColNum 表单布局方式（1单列 2双列 3三列）
     * @return span 数值字符串
     */
    public static String getColSpan(int formColNum)
    {
        if (formColNum == 2)
        {
            return "12";
        }
        else if (formColNum == 3)
        {
            return "8";
        }
        return "24";
    }
}
