<template>
  <div class="app-container course-manage-page">
    <el-card shadow="never" class="course-manage-card">
      <div slot="header" class="course-manage-card__header">
        <div>
          <div class="course-manage-card__title">课程管理</div>
          <div class="course-manage-card__desc">
            维护教师发布的课程信息，控制课程展示、注册与发布状态。
          </div>
        </div>
      </div>

      <el-form
        v-show="showSearch"
        ref="queryForm"
        :model="queryParams"
        :inline="true"
        size="small"
        label-width="84px"
        class="query-form"
      >
        <el-form-item label="课程名称" prop="courseName">
          <el-input
            v-model.trim="queryParams.courseName"
            placeholder="请输入课程名称"
            clearable
            style="width: 240px"
            @keyup.enter.native="handleQuery"
          />
        </el-form-item>
        <el-form-item label="课程分类" prop="categoryId">
          <el-select
            v-model="queryParams.categoryId"
            placeholder="请选择课程分类"
            clearable
            filterable
            style="width: 240px"
          >
            <el-option
              v-for="item in categoryOptionList"
              :key="item.id"
              :label="item.label"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="发布状态" prop="publishStatus">
          <el-select
            v-model="queryParams.publishStatus"
            placeholder="请选择发布状态"
            clearable
            style="width: 180px"
          >
            <el-option
              v-for="item in publishStatusOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="允许注册" prop="allowRegister">
          <el-select
            v-model="queryParams.allowRegister"
            placeholder="请选择注册状态"
            clearable
            style="width: 180px"
          >
            <el-option
              v-for="item in yesNoOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
          <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增课程</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate()">修改课程</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete()">删除课程</el-button>
        </el-col>
        <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" />
      </el-row>

      <el-table v-loading="loading" :data="courseList" @selection-change="handleSelectionChange">
        <el-table-column fixed type="selection" width="55" align="center" />
        <el-table-column label="课程封面" width="100" align="center">
          <template slot-scope="scope">
            <el-image
              class="course-cover"
              :src="getCoverUrl(scope.row.coverImage)"
              :preview-src-list="scope.row.coverImage ? [getCoverUrl(scope.row.coverImage)] : []"
              fit="cover"
            >
              <div slot="error" class="course-cover course-cover--empty">
                <i class="el-icon-picture-outline"></i>
              </div>
            </el-image>
          </template>
        </el-table-column>
        <el-table-column label="课程名称" prop="courseName" min-width="220" show-overflow-tooltip />
        <el-table-column label="副标题" prop="courseSubtitle" min-width="220" show-overflow-tooltip />
        <el-table-column label="课程分类" prop="categoryName" width="140" show-overflow-tooltip />
        <el-table-column label="授课教师" prop="teacherName" width="120" show-overflow-tooltip />
        <el-table-column label="难度" width="110" align="center">
          <template slot-scope="scope">
            <el-tag size="mini" :type="getDifficultyTagType(scope.row.difficultyLevel)">
              {{ getDifficultyLabel(scope.row.difficultyLevel) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="注册人数" prop="enrollCount" width="100" align="center" />
        <el-table-column label="内容数" prop="contentCount" width="90" align="center" />
        <el-table-column label="考试数" prop="examCount" width="90" align="center" />
        <el-table-column label="允许注册" width="100" align="center">
          <template slot-scope="scope">
            <el-tag size="mini" :type="scope.row.allowRegister === '1' ? 'success' : 'info'">
              {{ scope.row.allowRegister === "1" ? "允许" : "关闭" }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="展示控制" min-width="180" align="center">
          <template slot-scope="scope">
            <div class="display-tag-group">
              <el-tag
                size="mini"
                :type="scope.row.recommendFlag === '1' ? 'primary' : 'info'"
                effect="plain"
              >
                {{ scope.row.recommendFlag === "1" ? "推荐" : "未推荐" }}
              </el-tag>
              <el-tag
                size="mini"
                :type="scope.row.hotFlag === '1' ? 'warning' : 'info'"
                effect="plain"
              >
                {{ scope.row.hotFlag === "1" ? "热门" : "普通" }}
              </el-tag>
              <el-tag
                size="mini"
                :type="scope.row.bannerFlag === '1' ? 'success' : 'info'"
                effect="plain"
              >
                {{ scope.row.bannerFlag === "1" ? "轮播候选" : "非轮播" }}
              </el-tag>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="发布状态" width="110" align="center">
          <template slot-scope="scope">
            <el-tag size="mini" :type="getPublishTagType(scope.row.publishStatus)">
              {{ getPublishStatusLabel(scope.row.publishStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="排序值" prop="sortOrder" width="90" align="center" />
        <el-table-column label="发布时间" width="160" align="center">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.publishTime) || "-" }}</span>
          </template>
        </el-table-column>
        <el-table-column fixed="right" label="操作" align="center" width="320" class-name="small-padding fixed-width">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
            <el-button size="mini" type="text" icon="el-icon-s-management" @click="handleTogglePublish(scope.row)">
              {{ scope.row.publishStatus === "1" ? "下线" : "发布" }}
            </el-button>
            <el-button size="mini" type="text" icon="el-icon-view" @click="handlePreview(scope.row)">预览</el-button>
            <el-button size="mini" type="text" icon="el-icon-document" @click="handleManageContent(scope.row)">内容管理</el-button>
            <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <pagination
        v-show="total > 0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
      />
    </el-card>

    <el-dialog :title="title" :visible.sync="open" width="860px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="92px">
        <el-row :gutter="18">
          <el-col :span="12">
            <el-form-item label="课程名称" prop="courseName">
              <el-input v-model.trim="form.courseName" maxlength="200" show-word-limit placeholder="请输入课程名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="课程分类" prop="categoryId">
              <el-select v-model="form.categoryId" placeholder="请选择课程分类" filterable style="width: 100%">
                <el-option
                  v-for="item in categoryOptionList"
                  :key="item.id"
                  :label="item.label"
                  :value="item.id"
                />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="18">
          <el-col :span="12">
            <el-form-item label="课程副标题" prop="courseSubtitle">
              <el-input v-model.trim="form.courseSubtitle" maxlength="255" show-word-limit placeholder="请输入课程副标题" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="难度等级" prop="difficultyLevel">
              <el-select v-model="form.difficultyLevel" placeholder="请选择难度等级" style="width: 100%">
                <el-option
                  v-for="item in difficultyOptions"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="18">
          <el-col :span="12">
            <el-form-item label="发布状态" prop="publishStatus">
              <el-radio-group v-model="form.publishStatus">
                <el-radio
                  v-for="item in publishStatusOptions"
                  :key="item.value"
                  :label="item.value"
                >
                  {{ item.label }}
                </el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="允许注册" prop="allowRegister">
              <el-radio-group v-model="form.allowRegister">
                <el-radio
                  v-for="item in yesNoOptions"
                  :key="item.value"
                  :label="item.value"
                >
                  {{ item.label }}
                </el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="18">
          <el-col :span="12">
            <el-form-item label="课程标签" prop="tags">
              <el-input v-model.trim="form.tags" placeholder="多个标签请用逗号分隔" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="排序值" prop="sortOrder">
              <el-input-number v-model="form.sortOrder" :min="0" :max="9999" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="18">
          <el-col :span="8">
            <el-form-item label="推荐课程" prop="recommendFlag">
              <el-radio-group v-model="form.recommendFlag">
                <el-radio v-for="item in yesNoOptions" :key="'recommend-' + item.value" :label="item.value">
                  {{ item.label }}
                </el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="热门课程" prop="hotFlag">
              <el-radio-group v-model="form.hotFlag">
                <el-radio v-for="item in yesNoOptions" :key="'hot-' + item.value" :label="item.value">
                  {{ item.label }}
                </el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="轮播候选" prop="bannerFlag">
              <el-radio-group v-model="form.bannerFlag">
                <el-radio v-for="item in yesNoOptions" :key="'banner-' + item.value" :label="item.value">
                  {{ item.label }}
                </el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="课程封面" prop="coverImage">
          <image-upload v-model="form.coverImage" :limit="1" directory="course/cover" />
        </el-form-item>

        <el-form-item label="课程简介" prop="intro">
          <el-input
            v-model.trim="form.intro"
            type="textarea"
            :rows="4"
            maxlength="1000"
            show-word-limit
            placeholder="请输入课程简介"
          />
        </el-form-item>

        <el-form-item label="课程详情" prop="detailHtml">
          <el-input
            v-model.trim="form.detailHtml"
            type="textarea"
            :rows="8"
            maxlength="5000"
            show-word-limit
            placeholder="请输入课程详情，可填写课程目标、学习内容、考核方式等"
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {
  addCourse,
  delCourse,
  getCourse,
  listCourse,
  listCourseCategoryTree,
  updateCourse
} from "@/api/edu/course"
import { resolveResourceUrl } from "@/utils/resource"

export default {
  name: "TeachingCourse",
  dicts: ["edu_course_publish_status", "edu_course_difficulty"],
  data() {
    return {
      loading: false,
      showSearch: true,
      total: 0,
      single: true,
      multiple: true,
      open: false,
      title: "",
      ids: [],
      courseList: [],
      categoryOptionList: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        courseName: undefined,
        categoryId: undefined,
        publishStatus: undefined,
        allowRegister: undefined
      },
      form: {},
      rules: {
        courseName: [
          { required: true, message: "请输入课程名称", trigger: "blur" }
        ],
        categoryId: [
          { required: true, message: "请选择课程分类", trigger: "change" }
        ],
        difficultyLevel: [
          { required: true, message: "请选择难度等级", trigger: "change" }
        ],
        publishStatus: [
          { required: true, message: "请选择发布状态", trigger: "change" }
        ],
        allowRegister: [
          { required: true, message: "请选择是否允许注册", trigger: "change" }
        ]
      },
      yesNoOptions: [
        { label: "关闭", value: "0" },
        { label: "允许", value: "1" }
      ]
    }
  },
  computed: {
    publishStatusOptions() {
      return this.dictOptions("edu_course_publish_status", [
        { label: "草稿", value: "0", raw: { listClass: "info" } },
        { label: "已发布", value: "1", raw: { listClass: "success" } },
        { label: "已下线", value: "2", raw: { listClass: "warning" } }
      ])
    },
    difficultyOptions() {
      return this.dictOptions("edu_course_difficulty", [
        { label: "初级", value: "1", raw: { listClass: "success" } },
        { label: "中级", value: "2", raw: { listClass: "warning" } },
        { label: "高级", value: "3", raw: { listClass: "danger" } }
      ])
    }
  },
  created() {
    this.getList()
    this.getCategoryTree()
  },
  methods: {
    /** 查询课程列表 */
    getList() {
      this.loading = true
      listCourse(this.queryParams).then(response => {
        this.courseList = response.rows || []
        this.total = response.total || 0
      }).finally(() => {
        this.loading = false
      })
    },
    /** 查询课程分类树 */
    getCategoryTree() {
      listCourseCategoryTree().then(response => {
        this.categoryOptionList = this.flattenCategoryTree(response.data || [])
      }).catch(() => {
        this.categoryOptionList = []
      })
    },
    /** 扁平化课程分类树 */
    flattenCategoryTree(tree, level = 0) {
      return (tree || []).reduce((result, item) => {
        const prefix = level === 0 ? "" : `${"　".repeat(level)}└ `
        const id = item.categoryId !== undefined ? item.categoryId : item.id
        const label = item.categoryName !== undefined ? item.categoryName : item.label
        result.push({
          id,
          label: `${prefix}${label || "未命名分类"}`
        })
        if (item.children && item.children.length) {
          result.push(...this.flattenCategoryTree(item.children, level + 1))
        }
        return result
      }, [])
    },
    /** 获取课程封面地址 */
    getCoverUrl(coverImage) {
      if (!coverImage) {
        return ""
      }
      return resolveResourceUrl(coverImage)
    },
    dictOptions(type, fallback) {
      const options = this.dict && this.dict.type ? this.dict.type[type] : []
      return options && options.length ? options : fallback
    },
    getOptionLabel(options, value, fallback) {
      const option = options.find(item => item.value === String(value))
      return option ? option.label : fallback
    },
    getOptionTagType(options, value, fallback = "info") {
      const option = options.find(item => item.value === String(value))
      if (!option || !option.raw) {
        return fallback
      }
      return option.raw.listClass === "primary" ? "" : (option.raw.listClass || fallback)
    },
    /** 获取难度标签文本 */
    getDifficultyLabel(value) {
      return this.getOptionLabel(this.difficultyOptions, value, "未设置")
    },
    /** 获取难度标签类型 */
    getDifficultyTagType(value) {
      return this.getOptionTagType(this.difficultyOptions, value)
    },
    /** 获取发布状态文本 */
    getPublishStatusLabel(value) {
      return this.getOptionLabel(this.publishStatusOptions, value, "未知")
    },
    /** 获取发布状态标签类型 */
    getPublishTagType(value) {
      return this.getOptionTagType(this.publishStatusOptions, value)
    },
    /** 表单重置 */
    reset() {
      this.form = {
        courseId: undefined,
        categoryId: undefined,
        teacherId: this.$store.getters.id || undefined,
        courseName: "",
        courseSubtitle: "",
        coverImage: "",
        intro: "",
        detailHtml: "",
        tags: "",
        difficultyLevel: "1",
        publishStatus: "0",
        allowRegister: "1",
        recommendFlag: "0",
        hotFlag: "0",
        bannerFlag: "0",
        sortOrder: 0
      }
      this.resetForm("form")
    },
    /** 搜索 */
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    /** 重置搜索 */
    resetQuery() {
      this.resetForm("queryForm")
      this.handleQuery()
    },
    /** 多选变化 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.courseId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 新增课程 */
    handleAdd() {
      this.reset()
      this.open = true
      this.title = "新增课程"
    },
    /** 修改课程 */
    handleUpdate(row) {
      const courseId = row ? row.courseId : this.ids[0]
      this.reset()
      getCourse(courseId).then(response => {
        this.form = Object.assign({}, this.form, response.data || {})
        if (!this.form.teacherId) {
          this.form.teacherId = this.$store.getters.id || undefined
        }
        this.open = true
        this.title = "修改课程"
      })
    },
    /** 删除课程 */
    handleDelete(row) {
      const courseIds = row ? row.courseId : this.ids
      const courseNames = row ? row.courseName : "所选课程"
      this.$modal.confirm(`是否确认删除课程“${courseNames}”？`).then(() => {
        return delCourse(courseIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    },
    /** 提交课程表单 */
    submitForm() {
      this.$refs.form.validate(valid => {
        if (!valid) {
          return
        }
        if (!this.form.teacherId) {
          this.form.teacherId = this.$store.getters.id || undefined
        }
        const requestApi = this.form.courseId ? updateCourse : addCourse
        requestApi(this.form).then(() => {
          this.$modal.msgSuccess(this.form.courseId ? "修改成功" : "新增成功")
          this.open = false
          this.getList()
        })
      })
    },
    /** 取消弹窗 */
    cancel() {
      this.open = false
      this.reset()
    },
    /** 切换发布状态 */
    handleTogglePublish(row) {
      const nextStatus = row.publishStatus === "1" ? "2" : "1"
      const actionText = nextStatus === "1" ? "发布" : "下线"
      this.$modal.confirm(`是否确认${actionText}课程“${row.courseName}”？`).then(() => {
        return getCourse(row.courseId)
      }).then(response => {
        const data = Object.assign({}, response.data || {}, {
          publishStatus: nextStatus
        })
        return updateCourse(data)
      }).then(() => {
        this.$modal.msgSuccess(`${actionText}成功`)
        this.getList()
      }).catch(() => {})
    },
    /** 课程内容管理入口 */
    handleManageContent(row) {
      this.$router.push({
        path: `/teaching/content/${row.courseId}`,
        query: {
          courseName: row.courseName || ""
        }
      })
    },
    /** 预览课程详情 */
    handlePreview(row) {
      if (!row || !row.courseId) {
        this.$modal.msgWarning("当前课程编号无效")
        return
      }
      const routeData = this.$router.resolve({
        path: `/course/${row.courseId}`
      })
      window.open(routeData.href, "_blank")
    }
  }
}
</script>

<style lang="scss" scoped>
.course-manage-card__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.course-manage-card__title {
  font-size: 18px;
  font-weight: 600;
  color: #0f172a;
}

.course-manage-card__desc {
  margin-top: 6px;
  color: #64748b;
  font-size: 13px;
}

.query-form {
  padding: 4px 0 6px;
}

.course-cover {
  width: 56px;
  height: 56px;
  border-radius: 12px;
  overflow: hidden;
  background: #f8fafc;
}

.course-cover--empty {
  display: flex;
  align-items: center;
  justify-content: center;
  color: #94a3b8;
  font-size: 22px;
}

.display-tag-group {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 6px;
}

.dialog-footer {
  text-align: right;
}
</style>
