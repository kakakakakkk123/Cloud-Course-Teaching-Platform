<template>
  <div class="app-container content-manage-page">
    <el-card shadow="never" class="content-manage-card">
      <div slot="header" class="content-manage-card__header">
        <div class="content-manage-card__back">
          <el-button plain icon="el-icon-arrow-left" @click="goBackCourseManage">返回课程管理</el-button>
        </div>
        <div class="content-manage-card__meta">
          <div class="content-manage-card__title">课程内容管理</div>
          <div class="content-manage-card__desc">
            当前课程：{{ currentCourseName }}
          </div>
        </div>
      </div>

      <div class="content-course-banner">
        <div class="content-course-banner__main">
          <strong>{{ currentCourseInfo.courseName || currentCourseName }}</strong>
          <span>{{ currentCourseInfo.courseSubtitle || "在此维护文档、视频、图片、外链和考试入口等课程内容。" }}</span>
        </div>
        <div class="content-course-banner__stats">
          <span>内容数 {{ currentCourseInfo.contentCount || 0 }}</span>
          <span>考试数 {{ currentCourseInfo.examCount || 0 }}</span>
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
        <el-form-item label="内容标题" prop="contentTitle">
          <el-input
            v-model.trim="queryParams.contentTitle"
            placeholder="请输入内容标题"
            clearable
            style="width: 240px"
            @keyup.enter.native="handleQuery"
          />
        </el-form-item>
        <el-form-item label="内容类型" prop="contentType">
          <el-select
            v-model="queryParams.contentType"
            placeholder="请选择内容类型"
            clearable
            style="width: 180px"
          >
            <el-option
              v-for="item in contentTypeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
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
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
          <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增内容</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate()">修改内容</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete()">删除内容</el-button>
        </el-col>
        <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" />
      </el-row>

      <el-table v-loading="loading" :data="contentList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="标题" prop="contentTitle" min-width="220" show-overflow-tooltip />
        <el-table-column label="关联考试" min-width="180" show-overflow-tooltip>
          <template slot-scope="scope">
            <span>{{ scope.row.contentType === "5" ? (scope.row.examName || formatExamName(scope.row.examId)) : "-" }}</span>
          </template>
        </el-table-column>
        <el-table-column label="类型" width="120" align="center">
          <template slot-scope="scope">
            <el-tag size="mini" :type="getContentTypeTagType(scope.row.contentType)">
              {{ getContentTypeLabel(scope.row.contentType) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="来源" width="110" align="center">
          <template slot-scope="scope">
            <span>{{ getSourceTypeLabel(scope.row.sourceType) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="允许预览" width="100" align="center">
          <template slot-scope="scope">
            <el-tag size="mini" :type="scope.row.isPreview === '1' ? 'success' : 'info'">
              {{ scope.row.isPreview === "1" ? "允许" : "关闭" }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="排序值" prop="sortOrder" width="90" align="center" />
        <el-table-column label="查看次数" prop="viewCount" width="90" align="center" />
        <el-table-column label="发布状态" width="100" align="center">
          <template slot-scope="scope">
            <el-tag size="mini" :type="getPublishTagType(scope.row.publishStatus)">
              {{ getPublishStatusLabel(scope.row.publishStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="更新时间" width="160" align="center">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.updateTime || scope.row.createTime) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="240" class-name="small-padding fixed-width">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
            <el-button size="mini" type="text" icon="el-icon-s-management" @click="handleTogglePublish(scope.row)">
              {{ scope.row.publishStatus === "1" ? "转为草稿" : "发布" }}
            </el-button>
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

    <el-dialog :title="title" :visible.sync="open" width="960px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="92px">
        <el-row :gutter="18">
          <el-col :span="12">
            <el-form-item label="内容标题" prop="contentTitle">
              <el-input
                v-model.trim="form.contentTitle"
                maxlength="200"
                show-word-limit
                placeholder="请输入内容标题"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="内容类型" prop="contentType">
              <el-select
                v-model="form.contentType"
                placeholder="请选择内容类型"
                style="width: 100%"
                @change="handleContentTypeChange"
              >
                <el-option
                  v-for="item in contentTypeOptions"
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
            <el-form-item label="来源类型" prop="sourceType">
              <el-select
                v-model="form.sourceType"
                placeholder="请选择来源类型"
                style="width: 100%"
                :disabled="isExamContent"
              >
                <el-option
                  v-for="item in sourceTypeOptions"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="排序值" prop="sortOrder">
              <el-input-number v-model="form.sortOrder" :min="0" :max="9999" controls-position="right" style="width: 100%" />
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
            <el-form-item label="允许预览" prop="isPreview">
              <el-radio-group v-model="form.isPreview">
                <el-radio v-for="item in yesNoOptions" :key="item.value" :label="item.value">
                  {{ item.label }}
                </el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item v-if="showFileUrlUpload" :label="fileUploadLabel">
          <template v-if="isImageContent">
            <image-upload v-model="form.fileUrl" :limit="1" />
          </template>
          <template v-else>
            <file-upload
              v-model="form.fileUrl"
              :limit="1"
              :file-size="currentFileSize"
              :file-type="currentFileTypes"
              @success="handleFileUploadSuccess"
            />
          </template>
        </el-form-item>

        <el-form-item v-if="showFileNameInput" label="文件名称" prop="fileName">
          <el-input
            v-model.trim="form.fileName"
            maxlength="255"
            show-word-limit
            placeholder="请输入文件名称"
          />
        </el-form-item>

        <el-form-item v-if="showLinkInput" label="外链地址" prop="linkUrl">
          <el-input
            v-model.trim="form.linkUrl"
            placeholder="请输入外链地址，例如 https://example.com"
          />
        </el-form-item>

        <el-form-item v-if="isExamContent" label="关联考试" prop="examId">
          <el-select
            v-model="form.examId"
            placeholder="请选择当前课程下的考试"
            filterable
            clearable
            style="width: 100%"
          >
            <el-option
              v-for="item in examOptions"
              :key="item.examId"
              :label="item.examName"
              :value="item.examId"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="内容封面">
          <image-upload v-model="form.coverImage" :limit="1" />
        </el-form-item>

        <el-row :gutter="18">
          <el-col :span="12">
            <el-form-item label="预计时长(秒)" prop="durationSeconds">
              <el-input-number v-model="form.durationSeconds" :min="0" :max="999999" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="父级内容ID" prop="parentId">
              <el-input-number v-model="form.parentId" :min="0" :max="999999999" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="内容摘要" prop="summary">
          <el-input
            v-model.trim="form.summary"
            type="textarea"
            :rows="3"
            maxlength="500"
            show-word-limit
            placeholder="请输入内容摘要"
          />
        </el-form-item>

        <el-form-item label="内容正文" prop="contentBody">
          <editor v-model="form.contentBody" :min-height="220" />
        </el-form-item>

        <el-form-item label="备注" prop="remark">
          <el-input
            v-model.trim="form.remark"
            type="textarea"
            :rows="3"
            maxlength="500"
            show-word-limit
            placeholder="请输入备注信息"
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
import { getCourse } from "@/api/edu/course"
import { listExam } from "@/api/edu/exam"
import {
  addCourseContent,
  delCourseContent,
  getCourseContent,
  listCourseContent,
  updateCourseContent
} from "@/api/edu/content"

export default {
  name: "TeachingContent",
  dicts: ["edu_content_type", "edu_content_source_type", "edu_course_publish_status"],
  data() {
    const validateLinkUrl = (rule, value, callback) => {
      if (this.showLinkInput && value && !/^https?:\/\//.test(value)) {
        callback(new Error("外链地址需以 http:// 或 https:// 开头"))
        return
      }
      callback()
    }
    return {
      loading: false,
      showSearch: true,
      total: 0,
      single: true,
      multiple: true,
      open: false,
      title: "",
      ids: [],
      contentList: [],
      examOptions: [],
      currentCourseInfo: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        courseId: undefined,
        contentTitle: undefined,
        contentType: undefined,
        publishStatus: undefined
      },
      form: {},
      rules: {
        contentTitle: [
          { required: true, message: "请输入内容标题", trigger: "blur" }
        ],
        contentType: [
          { required: true, message: "请选择内容类型", trigger: "change" }
        ],
        sourceType: [
          { required: true, message: "请选择来源类型", trigger: "change" }
        ],
        publishStatus: [
          { required: true, message: "请选择发布状态", trigger: "change" }
        ],
        isPreview: [
          { required: true, message: "请选择是否允许预览", trigger: "change" }
        ],
        examId: [
          {
            validator: (rule, value, callback) => {
              if (this.isExamContent && !value) {
                callback(new Error("请选择关联考试"))
                return
              }
              callback()
            },
            trigger: "change"
          }
        ],
        linkUrl: [
          { validator: validateLinkUrl, trigger: "blur" }
        ]
      },
      yesNoOptions: [
        { label: "关闭", value: "0" },
        { label: "允许", value: "1" }
      ],
      documentFileTypes: ["doc", "docx", "xls", "xlsx", "ppt", "pptx", "txt", "pdf", "zip", "rar"],
      videoFileTypes: ["mp4", "avi", "mov", "wmv", "flv", "webm", "mkv", "rmvb", "mpg", "mpeg", "m4v", "3gp"]
    }
  },
  computed: {
    contentTypeOptions() {
      return this.dictOptions("edu_content_type", [
        { label: "文档", value: "1", raw: { listClass: "primary" } },
        { label: "视频", value: "2", raw: { listClass: "success" } },
        { label: "图片", value: "3", raw: { listClass: "warning" } },
        { label: "外链", value: "4", raw: { listClass: "info" } },
        { label: "考试", value: "5", raw: { listClass: "danger" } }
      ])
    },
    sourceTypeOptions() {
      return this.dictOptions("edu_content_source_type", [
        { label: "上传文件", value: "1", raw: { listClass: "primary" } },
        { label: "外部链接", value: "2", raw: { listClass: "info" } }
      ])
    },
    publishStatusOptions() {
      return this.dictOptions("edu_course_publish_status", [
        { label: "草稿", value: "0", raw: { listClass: "info" } },
        { label: "已发布", value: "1", raw: { listClass: "success" } }
      ]).filter(item => item.value !== "2")
    },
    /** 当前课程编号 */
    currentCourseId() {
      return Number(this.$route.params.courseId || this.$route.query.courseId || 0)
    },
    /** 当前课程名称 */
    currentCourseName() {
      return this.$route.query.courseName || this.currentCourseInfo.courseName || "未命名课程"
    },
    /** 是否为考试内容 */
    isExamContent() {
      return this.form.contentType === "5"
    },
    /** 是否为图片内容 */
    isImageContent() {
      return this.form.contentType === "3"
    },
    /** 是否展示上传组件 */
    showFileUrlUpload() {
      return !this.showLinkInput && !this.isExamContent
    },
    /** 是否展示文件名称 */
    showFileNameInput() {
      return this.showFileUrlUpload
    },
    /** 是否展示外链输入 */
    showLinkInput() {
      return this.form.contentType === "4" || this.form.sourceType === "2"
    },
    /** 上传组件标题 */
    fileUploadLabel() {
      if (this.isImageContent) {
        return "上传图片"
      }
      return this.form.contentType === "2" ? "上传视频" : "上传文件"
    },
    /** 当前文件类型限制 */
    currentFileTypes() {
      return this.form.contentType === "2" ? this.videoFileTypes : this.documentFileTypes
    },
    /** 当前文件大小限制，单位 MB */
    currentFileSize() {
      return this.form.contentType === "2" ? 200 : 50
    }
  },
  watch: {
    currentCourseId: {
      immediate: true,
      handler() {
        if (this.currentCourseId) {
          this.queryParams.courseId = this.currentCourseId
          this.getCourseInfo()
          this.getList()
        }
      }
    },
    "form.contentType"(value) {
      if (value === "5") {
        this.getExamOptions()
      } else {
        this.examOptions = []
      }
    }
  },
  methods: {
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
    /** 查询课程基础信息 */
    getCourseInfo() {
      getCourse(this.currentCourseId).then(response => {
        this.currentCourseInfo = response.data || {}
      }).catch(() => {
        this.currentCourseInfo = {}
      })
    },
    /** 查询当前课程考试选项 */
    getExamOptions() {
      if (!this.currentCourseId) {
        this.examOptions = []
        return
      }
      listExam({
        pageNum: 1,
        pageSize: 1000,
        courseId: this.currentCourseId,
        status: "1"
      }).then(response => {
        this.examOptions = response.rows || []
      }).catch(() => {
        this.examOptions = []
      })
    },
    /** 查询课程内容列表 */
    getList() {
      if (!this.currentCourseId) {
        this.contentList = []
        this.total = 0
        return
      }
      this.loading = true
      this.queryParams.courseId = this.currentCourseId
      listCourseContent(this.queryParams).then(response => {
        this.contentList = response.rows || []
        this.total = response.total || 0
      }).finally(() => {
        this.loading = false
      })
    },
    /** 返回课程管理页 */
    goBackCourseManage() {
      this.$router.push("/teaching/course")
    },
    /** 内容类型名称 */
    getContentTypeLabel(value) {
      return this.getOptionLabel(this.contentTypeOptions, value, "未知")
    },
    /** 内容类型标签样式 */
    getContentTypeTagType(value) {
      return this.getOptionTagType(this.contentTypeOptions, value)
    },
    /** 来源类型名称 */
    getSourceTypeLabel(value) {
      return this.getOptionLabel(this.sourceTypeOptions, value, "-")
    },
    /** 发布状态名称 */
    getPublishStatusLabel(value) {
      return this.getOptionLabel(this.publishStatusOptions, value, "未知")
    },
    /** 发布状态标签样式 */
    getPublishTagType(value) {
      return this.getOptionTagType(this.publishStatusOptions, value)
    },
    /** 格式化考试名称 */
    formatExamName(examId) {
      if (!examId) {
        return "-"
      }
      const exam = this.examOptions.find(item => item.examId === examId)
      return exam ? exam.examName : `考试 #${examId}`
    },
    /** 重置表单 */
    reset() {
      this.form = {
        contentId: undefined,
        courseId: this.currentCourseId,
        parentId: 0,
        contentTitle: "",
        contentType: "1",
        sourceType: "1",
        fileName: "",
        fileUrl: "",
        coverImage: "",
        linkUrl: "",
        summary: "",
        contentBody: "",
        durationSeconds: 0,
        examId: undefined,
        isPreview: "0",
        sortOrder: 0,
        publishStatus: "0",
        remark: ""
      }
      this.resetForm("form")
    },
    /** 内容类型变化时联动字段 */
    handleContentTypeChange(value) {
      if (value === "4") {
        this.form.sourceType = "2"
        this.form.fileUrl = ""
        this.form.fileName = ""
      } else if (value === "5") {
        this.form.sourceType = "1"
        this.form.fileUrl = ""
        this.form.fileName = ""
        this.form.linkUrl = ""
        this.form.durationSeconds = 0
      } else {
        this.form.sourceType = "1"
        this.form.linkUrl = ""
        this.form.examId = undefined
      }
    },
    /** 搜索 */
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    /** 重置搜索 */
    resetQuery() {
      this.resetForm("queryForm")
      this.queryParams.courseId = this.currentCourseId
      this.handleQuery()
    },
    /** 多选变化 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.contentId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 新增内容 */
    handleAdd() {
      this.reset()
      this.open = true
      this.title = "新增课程内容"
    },
    /** 修改内容 */
    handleUpdate(row) {
      const contentId = row ? row.contentId : this.ids[0]
      this.reset()
      getCourseContent(contentId).then(response => {
        this.form = Object.assign({}, this.form, response.data || {})
        this.open = true
        this.title = "修改课程内容"
      })
    },
    /** 删除内容 */
    handleDelete(row) {
      const contentIds = row ? row.contentId : this.ids
      const contentTitle = row ? row.contentTitle : "所选内容"
      this.$modal.confirm(`是否确认删除课程内容“${contentTitle}”？`).then(() => {
        return delCourseContent(contentIds)
      }).then(() => {
        this.$modal.msgSuccess("删除成功")
        this.getList()
        this.getCourseInfo()
      }).catch(() => {})
    },
    /** 提交内容表单 */
    submitForm() {
      this.$refs.form.validate(valid => {
        if (!valid) {
          return
        }
        const requestApi = this.form.contentId ? updateCourseContent : addCourseContent
        const submitData = Object.assign({}, this.form, {
          courseId: this.currentCourseId
        })
        requestApi(submitData).then(() => {
          this.$modal.msgSuccess(this.form.contentId ? "修改成功" : "新增成功")
          this.open = false
          this.getList()
          this.getCourseInfo()
        })
      })
    },
    /** 上传成功后回填原始文件名 */
    handleFileUploadSuccess(response, file) {
      if (!this.form.fileName) {
        this.form.fileName = response.originalFilename || (file && file.name) || response.newFileName || ""
      }
    },
    /** 取消弹窗 */
    cancel() {
      this.open = false
      this.reset()
    },
    /** 发布或转草稿 */
    handleTogglePublish(row) {
      const nextStatus = row.publishStatus === "1" ? "0" : "1"
      const actionText = nextStatus === "1" ? "发布" : "转为草稿"
      getCourseContent(row.contentId).then(response => {
        const data = Object.assign({}, response.data || {}, {
          publishStatus: nextStatus
        })
        return updateCourseContent(data)
      }).then(() => {
        this.$modal.msgSuccess(`${actionText}成功`)
        this.getList()
      }).catch(() => {})
    }
  }
}
</script>

<style lang="scss" scoped>
.content-manage-card__header {
  display: flex;
  align-items: center;
  gap: 16px;
}

.content-manage-card__title {
  font-size: 18px;
  font-weight: 600;
  color: #0f172a;
}

.content-manage-card__desc {
  margin-top: 6px;
  color: #64748b;
  font-size: 13px;
}

.content-course-banner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 18px;
  padding: 16px 18px;
  border-radius: 16px;
  background: linear-gradient(135deg, #eff6ff, #f8fafc);
}

.content-course-banner__main strong {
  display: block;
  color: #0f172a;
  font-size: 16px;
  font-weight: 600;
}

.content-course-banner__main span {
  display: block;
  margin-top: 6px;
  color: #64748b;
  font-size: 13px;
}

.content-course-banner__stats {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.content-course-banner__stats span {
  padding: 6px 12px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.78);
  color: #2563eb;
  font-size: 12px;
}

.query-form {
  padding: 4px 0 6px;
}

.dialog-footer {
  text-align: right;
}

@media screen and (max-width: 768px) {
  .content-manage-card__header,
  .content-course-banner {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
