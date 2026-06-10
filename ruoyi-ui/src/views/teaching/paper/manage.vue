<template>
  <div class="app-container paper-manage-page">
    <el-card shadow="never" class="paper-manage-card">
      <div slot="header" class="paper-manage-card__header">
        <div class="paper-manage-card__back">
          <el-button plain icon="el-icon-arrow-left" @click="goBackBankManage">返回题库管理</el-button>
        </div>
        <div class="paper-manage-card__meta">
          <div class="paper-manage-card__title">{{ currentBankName }} - 试卷管理</div>
          <div class="paper-manage-card__desc">
            题库编号 {{ bankId || "-" }} · 共 {{ total }} 份试卷
          </div>
        </div>
      </div>

      <div class="paper-bank-banner">
        <div class="paper-bank-banner__main">
          <strong>{{ currentBankName }}</strong>
          <span>在这里维护试卷基础信息、关联课程和组卷来源，后续考试发布将直接基于试卷创建。</span>
        </div>
        <div class="paper-bank-banner__stats">
          <span>试卷数 {{ total }}</span>
          <span>题库编号 {{ bankId || "-" }}</span>
        </div>
      </div>

      <el-alert
        v-if="interfacePending"
        title="试卷后端接口尚未完全接入，当前页面和 API 骨架已准备好，可先用于前端联调和后续接口对接。"
        type="warning"
        :closable="false"
        show-icon
        class="mb16"
      />

      <el-form
        v-show="showSearch"
        ref="queryForm"
        :model="queryParams"
        :inline="true"
        size="small"
        label-width="84px"
        class="query-form"
      >
        <el-form-item label="试卷名称" prop="paperName">
          <el-input
            v-model.trim="queryParams.paperName"
            placeholder="请输入试卷名称"
            clearable
            style="width: 220px"
            @keyup.enter.native="handleQuery"
          />
        </el-form-item>
        <el-form-item label="所属课程" prop="courseId">
          <el-select
            v-model="queryParams.courseId"
            placeholder="请选择所属课程"
            clearable
            filterable
            style="width: 220px"
          >
            <el-option
              v-for="item in courseOptions"
              :key="item.courseId"
              :label="item.courseName"
              :value="item.courseId"
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
          <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增试卷</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate()">修改试卷</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete()">删除试卷</el-button>
        </el-col>
        <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" />
      </el-row>

      <el-table v-loading="loading" :data="paperList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="试卷名称" prop="paperName" min-width="220" show-overflow-tooltip />
        <el-table-column label="所属课程" min-width="180" show-overflow-tooltip>
          <template slot-scope="scope">
            <span>{{ scope.row.courseNames || scope.row.courseName || "未关联课程" }}</span>
          </template>
        </el-table-column>
        <el-table-column label="来源题库" min-width="160" show-overflow-tooltip>
          <template slot-scope="scope">
            <span>{{ scope.row.bankName || currentBankName }}</span>
          </template>
        </el-table-column>
        <el-table-column label="题目数" prop="questionCount" width="90" align="center" />
        <el-table-column label="总分" prop="totalScore" width="90" align="center" />
        <el-table-column label="客观题分" prop="objectiveScore" width="100" align="center" />
        <el-table-column label="主观题分" prop="subjectiveScore" width="100" align="center" />
        <el-table-column label="状态" width="100" align="center">
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
        <el-table-column label="操作" align="center" width="300" class-name="small-padding fixed-width">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
            <el-button size="mini" type="text" icon="el-icon-s-operation" @click="handleCompose(scope.row)">组卷</el-button>
            <el-button size="mini" type="text" icon="el-icon-s-order" @click="handleExamPublish(scope.row)">发布考试</el-button>
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
      <el-form ref="form" :model="form" :rules="rules" label-width="96px">
        <el-row :gutter="18">
          <el-col :span="12">
            <el-form-item label="试卷名称" prop="paperName">
              <el-input
                v-model.trim="form.paperName"
                maxlength="120"
                show-word-limit
                placeholder="请输入试卷名称"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="所属课程" prop="courseIds">
              <el-select
                v-model="form.courseIds"
                multiple
                collapse-tags
                clearable
                filterable
                placeholder="可选择多个课程，不选则为通用试卷"
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
          </el-col>
        </el-row>

        <el-row :gutter="18">
          <el-col :span="12">
            <el-form-item label="来源题库" prop="bankId">
              <el-input :value="currentBankName" disabled />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio v-for="item in statusOptions" :key="item.value" :label="item.value">
                  {{ item.label }}
                </el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="18">
          <el-col :span="8">
            <el-form-item label="题目数" prop="questionCount">
              <el-input-number v-model="form.questionCount" :min="0" :max="300" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="总分" prop="totalScore">
              <el-input-number v-model="form.totalScore" :min="0" :max="1000" :precision="2" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="客观题分" prop="objectiveScore">
              <el-input-number v-model="form.objectiveScore" :min="0" :max="1000" :precision="2" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="18">
          <el-col :span="8">
            <el-form-item label="主观题分" prop="subjectiveScore">
              <el-input-number v-model="form.subjectiveScore" :min="0" :max="1000" :precision="2" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="16">
            <el-form-item label="组卷方式" prop="composeMode">
              <el-radio-group v-model="form.composeMode">
                <el-radio :label="'1'">手工选题</el-radio>
                <el-radio :label="'2'">按题型规则</el-radio>
                <el-radio :label="'3'">随机组卷（后续接入）</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="试卷说明" prop="paperDesc">
          <el-input
            v-model.trim="form.paperDesc"
            type="textarea"
            :rows="4"
            maxlength="1000"
            show-word-limit
            placeholder="请输入试卷说明、适用范围或组卷说明"
          />
        </el-form-item>

        <el-form-item label="组卷说明">
          <div class="compose-tips-box">
            试卷基础信息保存后，在列表操作列点击"<strong>组卷</strong>"按钮即可从题库选题、设置分值和排序，系统将自动汇总总分与题型统计。
          </div>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancel">取 消</el-button>
        <el-button type="primary" @click="submitForm">确 定</el-button>
      </div>
    </el-dialog>

    <compose-dialog
      :visible.sync="composeOpen"
      :paper-id="composePaperId"
      :paper-name="composePaperName"
      :bank-id="bankId"
      @saved="onComposeSaved"
    />
  </div>
</template>

<script>
import {
  listPaper,
  getPaper,
  addPaper,
  updatePaper,
  delPaper
} from "@/api/edu/paper"
import { listCourse } from "@/api/edu/course"
import ComposeDialog from "./components/ComposeDialog"

export default {
  name: "TeachingPaperManage",
  components: { ComposeDialog },
  dicts: ["edu_paper_status"],
  data() {
    return {
      loading: false,
      showSearch: true,
      interfacePending: false,
      ids: [],
      single: true,
      multiple: true,
      total: 0,
      paperList: [],
      courseOptions: [],
      open: false,
      title: "",
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        bankId: undefined,
        paperName: "",
        courseId: undefined,
        status: undefined
      },
      composeOpen: false,
      composePaperId: 0,
      composePaperName: "",
      form: {},
      rules: {
        paperName: [
          { required: true, message: "请输入试卷名称", trigger: "blur" }
        ],
        status: [
          { required: true, message: "请选择状态", trigger: "change" }
        ]
      },
    }
  },
  computed: {
    statusOptions() {
      return this.dictOptions("edu_paper_status", [
        { label: "草稿", value: "0", raw: { listClass: "info" } },
        { label: "启用", value: "1", raw: { listClass: "success" } },
        { label: "停用", value: "2", raw: { listClass: "warning" } }
      ])
    },
    /** 当前题库编号 */
    bankId() {
      return this.$route.params.bankId
    },
    /** 当前题库名称 */
    currentBankName() {
      return this.$route.query.bankName || "未命名题库"
    }
  },
  created() {
    this.queryParams.bankId = this.bankId
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
    /** 查询试卷列表 */
    getList() {
      this.loading = true
      listPaper(this.queryParams).then(response => {
        this.paperList = response.rows || []
        this.total = response.total || 0
        this.interfacePending = false
      }).catch(() => {
        this.paperList = []
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
    /** 获取状态文案 */
    getStatusText(value) {
      return this.getOptionLabel(this.statusOptions, value, "未知")
    },
    /** 获取状态标签样式 */
    getStatusTag(value) {
      return this.getOptionTagType(this.statusOptions, value)
    },
    /** 选择行变化 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.paperId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 搜索试卷 */
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    /** 重置查询 */
    resetQuery() {
      this.resetForm("queryForm")
      this.queryParams.bankId = this.bankId
      this.handleQuery()
    },
    /** 重置表单 */
    reset() {
      this.form = {
        paperId: undefined,
        bankId: this.bankId,
        courseIds: [],
        paperName: "",
        paperDesc: "",
        questionCount: 0,
        totalScore: 100,
        objectiveScore: 60,
        subjectiveScore: 40,
        status: "0",
        composeMode: "1"
      }
      this.resetForm("form")
    },
    /** 返回题库管理 */
    goBackBankManage() {
      this.$router.push("/teaching/paper")
    },
    /** 进入考试发布 */
    goExamManage(row) {
      this.$router.push({
        path: `/teaching/exam/${row.paperId}`,
        query: {
          paperName: row.paperName,
          courseId: row.courseId,
          totalScore: row.totalScore,
          bankId: this.bankId,
          bankName: this.currentBankName
        }
      })
    },
    /** 新增试卷 */
    handleAdd() {
      this.reset()
      this.open = true
      this.title = "新增试卷"
    },
    /** 修改试卷 */
    handleUpdate(row) {
      const paperId = row ? row.paperId : this.ids[0]
      this.reset()
      getPaper(paperId).then(response => {
        const data = response.data || {}
        this.form = Object.assign({}, this.form, data, {
          courseIds: data.courseIds || [],
          composeMode: data.composeMode || "1"
        })
        this.open = true
        this.title = "修改试卷"
        this.interfacePending = false
      }).catch(() => {
        this.interfacePending = true
      })
    },
    /** 删除试卷 */
    handleDelete(row) {
      const paperIds = row ? row.paperId : this.ids
      this.$modal.confirm("是否确认删除所选试卷？").then(() => {
        return delPaper(paperIds)
      }).then(() => {
        this.$modal.msgSuccess("删除成功")
        this.getList()
      }).catch(() => {})
    },
    /** 进入考试发布 */
    handleExamPublish(row) {
      this.goExamManage(row)
    },
    /** 打开组卷对话框 */
    handleCompose(row) {
      this.composePaperId = row.paperId
      this.composePaperName = row.paperName
      this.composeOpen = true
    },
    /** 组卷保存后刷新列表（更新统计） */
    onComposeSaved() {
      this.getList()
    },
    /** 取消弹窗 */
    cancel() {
      this.open = false
      this.reset()
    },
    /** 提交试卷表单 */
    submitForm() {
      this.$refs.form.validate(valid => {
        if (!valid) {
          return
        }
        const requestApi = this.form.paperId ? updatePaper : addPaper
        requestApi(this.form).then(() => {
          this.$modal.msgSuccess(this.form.paperId ? "修改成功" : "新增成功")
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
.paper-manage-page {
  min-height: 100vh;
}

.paper-manage-card {
  border-radius: 24px;
  border: 1px solid rgba(148, 163, 184, 0.12);
  background: rgba(255, 255, 255, 0.82);
  box-shadow: 0 18px 38px rgba(15, 23, 42, 0.06);
  backdrop-filter: blur(14px);
}

.paper-manage-card__header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 18px;
}

.paper-manage-card__title {
  color: #0f172a;
  font-size: 22px;
  font-weight: 700;
}

.paper-manage-card__desc {
  margin-top: 8px;
  color: #64748b;
  line-height: 1.7;
}

.paper-bank-banner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 18px;
  padding: 18px 20px;
  border-radius: 20px;
  background: linear-gradient(135deg, #eff6ff, #f8fafc);
}

.paper-bank-banner__main strong {
  display: block;
  color: #0f172a;
  font-size: 18px;
}

.paper-bank-banner__main span,
.paper-bank-banner__stats span,
.compose-tips-box {
  color: #64748b;
}

.paper-bank-banner__main span {
  display: block;
  margin-top: 8px;
  line-height: 1.8;
}

.paper-bank-banner__stats {
  display: grid;
  gap: 8px;
  flex-shrink: 0;
  text-align: right;
  font-size: 13px;
}

.compose-tips-box {
  padding: 14px 16px;
  border-radius: 16px;
  background: #f8fafc;
  line-height: 1.8;
}

.mb16 {
  margin-bottom: 16px;
}

@media screen and (max-width: 960px) {
  .paper-manage-card__header,
  .paper-bank-banner {
    flex-direction: column;
    align-items: flex-start;
  }

  .paper-bank-banner__stats {
    text-align: left;
  }
}
</style>
