<template>
  <div class="app-container question-bank-page">
    <section class="question-bank-hero">
      <div>
        <p class="question-bank-hero__kicker">考试管理</p>
        <h1>题库管理</h1>
        <p class="question-bank-hero__summary">
          统一维护教师自己的题库，后续试题、试卷和考试发布都将围绕题库展开，作为考试模块第一阶段的核心入口。
        </p>
      </div>
      <div class="question-bank-hero__stats">
        <div class="hero-stat-card">
          <strong>{{ total }}</strong>
          <span>题库总数</span>
        </div>
        <div class="hero-stat-card">
          <strong>{{ publicCount }}</strong>
          <span>公开题库</span>
        </div>
        <div class="hero-stat-card">
          <strong>{{ normalCount }}</strong>
          <span>启用题库</span>
        </div>
      </div>
    </section>

    <el-alert
      v-if="interfacePending"
      title="题库后端接口尚未完全接入，当前页面和 API 骨架已准备好，可先用于前端联调和后续接口对接。"
      type="warning"
      :closable="false"
      show-icon
      class="mb16"
    />

    <el-card shadow="never" class="question-bank-card">
      <el-form
        v-show="showSearch"
        ref="queryForm"
        :model="queryParams"
        :inline="true"
        size="small"
        label-width="84px"
        class="query-form"
      >
        <el-form-item label="题库名称" prop="bankName">
          <el-input
            v-model.trim="queryParams.bankName"
            placeholder="请输入题库名称"
            clearable
            style="width: 220px"
            @keyup.enter.native="handleQuery"
          />
        </el-form-item>
        <el-form-item label="可见范围" prop="visibility">
          <el-select
            v-model="queryParams.visibility"
            placeholder="请选择可见范围"
            clearable
            style="width: 180px"
          >
            <el-option
              v-for="item in visibilityOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select
            v-model="queryParams.status"
            placeholder="请选择状态"
            clearable
            style="width: 180px"
          >
            <el-option
              v-for="item in statusOptions"
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
          <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增题库</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate()">修改题库</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete()">删除题库</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="warning" plain icon="el-icon-s-order" size="mini" :disabled="single" @click="handlePaperManage()">试卷管理</el-button>
        </el-col>
        <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" />
      </el-row>

      <el-table v-loading="loading" :data="bankList" @selection-change="handleSelectionChange">
        <el-table-column fixed type="selection" width="55" align="center" />
        <el-table-column label="题库名称" prop="bankName" min-width="220" show-overflow-tooltip />
        <el-table-column label="关联课程" min-width="220" show-overflow-tooltip>
          <template slot-scope="scope">
            <span>{{ formatCourseNames(scope.row) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="标签" min-width="160" show-overflow-tooltip>
          <template slot-scope="scope">
            <span>{{ scope.row.tags || "-" }}</span>
          </template>
        </el-table-column>
        <el-table-column label="可见范围" width="110" align="center">
          <template slot-scope="scope">
            <el-tag size="mini" :type="scope.row.visibility === '1' ? 'success' : 'info'">
              {{ getVisibilityText(scope.row.visibility) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="题目数" prop="questionCount" width="90" align="center" />
        <el-table-column label="使用次数" prop="usageCount" width="100" align="center" />
        <el-table-column label="正确率" width="100" align="center">
          <template slot-scope="scope">
            <span>{{ formatRate(scope.row.correctRate) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="90" align="center">
          <template slot-scope="scope">
            <el-tag size="mini" :type="getStatusTag(scope.row.status)">
              {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="更新时间" width="160" align="center">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.updateTime || scope.row.createTime) || "-" }}</span>
          </template>
        </el-table-column>
        <el-table-column fixed="right" label="操作" align="center" width="260" class-name="small-padding fixed-width">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
            <el-button size="mini" type="text" icon="el-icon-document" @click="handleQuestionManage(scope.row)">试题管理</el-button>
            <el-button size="mini" type="text" icon="el-icon-s-order" @click="handlePaperManage(scope.row)">试卷管理</el-button>
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

    <el-dialog :title="title" :visible.sync="open" width="760px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="92px">
        <el-form-item label="题库名称" prop="bankName">
          <el-input
            v-model.trim="form.bankName"
            maxlength="120"
            show-word-limit
            placeholder="请输入题库名称"
          />
        </el-form-item>

        <el-form-item label="关联课程" prop="courseIds">
          <el-select
            v-model="form.courseIds"
            multiple
            collapse-tags
            clearable
            filterable
            placeholder="可选择 0~多个课程"
            style="width: 100%"
          >
            <el-option
              v-for="item in courseOptions"
              :key="item.courseId"
              :label="item.courseName"
              :value="item.courseId"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="题库标签" prop="tags">
          <el-input
            v-model.trim="form.tags"
            placeholder="多个标签请使用逗号分隔"
          />
        </el-form-item>

        <el-row :gutter="18">
          <el-col :span="12">
            <el-form-item label="可见范围" prop="visibility">
              <el-radio-group v-model="form.visibility">
                <el-radio
                  v-for="item in visibilityOptions"
                  :key="item.value"
                  :label="item.value"
                >
                  {{ item.label }}
                </el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio
                  v-for="item in statusOptions"
                  :key="item.value"
                  :label="item.value"
                >
                  {{ item.label }}
                </el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="备注" prop="remark">
          <el-input
            v-model.trim="form.remark"
            type="textarea"
            :rows="4"
            maxlength="500"
            show-word-limit
            placeholder="请输入题库说明或维护备注"
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancel">取 消</el-button>
        <el-button type="primary" @click="submitForm">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {
  listQuestionBank,
  getQuestionBank,
  addQuestionBank,
  updateQuestionBank,
  delQuestionBank
} from "@/api/edu/questionBank"
import { listCourse } from "@/api/edu/course"

export default {
  name: "TeachingPaper",
  dicts: ["edu_bank_visibility", "sys_normal_disable"],
  data() {
    return {
      loading: false,
      showSearch: true,
      interfacePending: false,
      ids: [],
      single: true,
      multiple: true,
      total: 0,
      bankList: [],
      courseOptions: [],
      open: false,
      title: "",
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        bankName: "",
        visibility: undefined,
        status: undefined
      },
      form: {},
      rules: {
        bankName: [
          { required: true, message: "请输入题库名称", trigger: "blur" }
        ],
        visibility: [
          { required: true, message: "请选择可见范围", trigger: "change" }
        ],
        status: [
          { required: true, message: "请选择状态", trigger: "change" }
        ]
      },
    }
  },
  computed: {
    visibilityOptions() {
      return this.dictOptions("edu_bank_visibility", [
        { label: "私有", value: "0", raw: { listClass: "info" } },
        { label: "公开", value: "1", raw: { listClass: "success" } }
      ])
    },
    statusOptions() {
      return this.dictOptions("sys_normal_disable", [
        { label: "启用", value: "0", raw: { listClass: "primary" } },
        { label: "停用", value: "1", raw: { listClass: "danger" } }
      ])
    },
    /** 公开题库数量 */
    publicCount() {
      return this.bankList.filter(item => item.visibility === "1").length
    },
    /** 启用题库数量 */
    normalCount() {
      return this.bankList.filter(item => item.status === "0").length
    }
  },
  created() {
    this.getList()
    this.getCourseOptions()
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
    /** 查询题库列表 */
    getList() {
      this.loading = true
      listQuestionBank(this.queryParams).then(response => {
        this.bankList = response.rows || []
        this.total = response.total || 0
        this.interfacePending = false
      }).catch(() => {
        this.bankList = []
        this.total = 0
        this.interfacePending = true
      }).finally(() => {
        this.loading = false
      })
    },
    /** 查询课程下拉选项 */
    getCourseOptions() {
      listCourse({
        pageNum: 1,
        pageSize: 1000,
        publishStatus: undefined,
        allowRegister: undefined
      }).then(response => {
        this.courseOptions = response.rows || []
      }).catch(() => {
        this.courseOptions = []
      })
    },
    /** 获取可见范围文案 */
    getVisibilityText(value) {
      return this.getOptionLabel(this.visibilityOptions, value, "未知")
    },
    /** 获取状态文案 */
    getStatusText(value) {
      return this.getOptionLabel(this.statusOptions, value, "未知")
    },
    /** 获取状态标签样式 */
    getStatusTag(value) {
      return this.getOptionTagType(this.statusOptions, value)
    },
    /** 格式化正确率 */
    formatRate(value) {
      return `${Number(value || 0).toFixed(0)}%`
    },
    /** 格式化关联课程显示 */
    formatCourseNames(row) {
      if (row.courseNames) {
        return row.courseNames
      }
      if (Array.isArray(row.courseList) && row.courseList.length) {
        return row.courseList.map(item => item.courseName || item).join("、")
      }
      return "未关联课程"
    },
    /** 选择行变更 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.bankId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 搜索题库 */
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    /** 重置查询 */
    resetQuery() {
      this.resetForm("queryForm")
      this.handleQuery()
    },
    /** 重置表单 */
    reset() {
      this.form = {
        bankId: undefined,
        bankName: "",
        courseIds: [],
        tags: "",
        visibility: "0",
        status: "0",
        remark: ""
      }
      this.resetForm("form")
    },
    /** 新增题库 */
    handleAdd() {
      this.reset()
      this.open = true
      this.title = "新增题库"
    },
    /** 修改题库 */
    handleUpdate(row) {
      const bankId = row ? row.bankId : this.ids[0]
      this.reset()
      getQuestionBank(bankId).then(response => {
        const data = response.data || {}
        this.form = Object.assign({}, this.form, data, {
          courseIds: data.courseIds || []
        })
        this.open = true
        this.title = "修改题库"
        this.interfacePending = false
      }).catch(() => {
        this.interfacePending = true
      })
    },
    /** 删除题库 */
    handleDelete(row) {
      const bankIds = row ? row.bankId : this.ids
      const bankName = row ? row.bankName : "所选题库"
      this.$modal.confirm(`是否确认删除题库“${bankName}”？`).then(() => {
        return delQuestionBank(bankIds)
      }).then(() => {
        this.$modal.msgSuccess("删除成功")
        this.getList()
      }).catch(() => {})
    },
    /** 进入试题管理 */
    handleQuestionManage(row) {
      this.$router.push({
        path: `/teaching/question/${row.bankId}`,
        query: { bankName: row.bankName }
      })
    },
    /** 进入试卷管理 */
    handlePaperManage(row) {
      const targetRow = row || this.bankList.find(item => item.bankId === this.ids[0])
      if (!targetRow) {
        this.$modal.msgWarning("请先选择一个题库")
        return
      }
      this.$router.push({
        path: `/teaching/paper-manage/${targetRow.bankId}`,
        query: { bankName: targetRow.bankName }
      })
    },
    /** 取消弹窗 */
    cancel() {
      this.open = false
      this.reset()
    },
    /** 提交题库表单 */
    submitForm() {
      this.$refs.form.validate(valid => {
        if (!valid) {
          return
        }
        const requestApi = this.form.bankId ? updateQuestionBank : addQuestionBank
        requestApi(this.form).then(() => {
          this.$modal.msgSuccess(this.form.bankId ? "修改成功" : "新增成功")
          this.open = false
          this.getList()
        }).catch(() => {
          this.interfacePending = true
        })
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.question-bank-page {
  min-height: 100vh;
  padding: 4px 0 20px;
}

.question-bank-hero,
.question-bank-card {
  border-radius: 24px;
  border: 1px solid rgba(148, 163, 184, 0.12);
  background: rgba(255, 255, 255, 0.82);
  box-shadow: 0 18px 38px rgba(15, 23, 42, 0.06);
  backdrop-filter: blur(14px);
}

.question-bank-hero {
  display: grid;
  grid-template-columns: minmax(0, 1.2fr) minmax(280px, 0.8fr);
  gap: 24px;
  margin-bottom: 18px;
  padding: 28px;
}

.question-bank-hero__kicker {
  margin: 0 0 8px;
  color: #2563eb;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 1.6px;
}

.question-bank-hero h1 {
  margin: 0;
  color: #0f172a;
}

.question-bank-hero__summary {
  margin: 14px 0 0;
  color: #64748b;
  line-height: 1.8;
}

.question-bank-hero__stats {
  display: grid;
  gap: 14px;
}

.hero-stat-card {
  padding: 18px 20px;
  border-radius: 20px;
  background: linear-gradient(135deg, #ffffff, #f8fafc);
}

.hero-stat-card strong {
  display: block;
  color: #0f172a;
  font-size: 28px;
}

.hero-stat-card span {
  display: block;
  margin-top: 6px;
  color: #64748b;
  font-size: 13px;
}

.question-bank-card {
  padding: 2px 0;
}

.mb16 {
  margin-bottom: 16px;
}

.question-bank-card ::v-deep .fixed-width .cell {
  display: grid;
  grid-template-columns: repeat(2, max-content);
  justify-content: center;
  align-content: center;
  gap: 4px 12px;
  white-space: normal;
  line-height: 1.6;
  padding-top: 6px;
  padding-bottom: 6px;
}

.question-bank-card ::v-deep .fixed-width .el-button--text {
  margin: 0;
  padding-top: 2px;
  padding-bottom: 2px;
}

.question-bank-card ::v-deep .el-table .el-table__row td {
  padding-top: 10px;
  padding-bottom: 10px;
}

@media screen and (max-width: 1100px) {
  .question-bank-hero {
    grid-template-columns: 1fr;
  }
}
</style>
