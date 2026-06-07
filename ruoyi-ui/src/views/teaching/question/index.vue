<template>
  <div class="app-container question-manage-page">
    <el-card shadow="never" class="question-manage-card">
      <div slot="header" class="question-manage-card__header">
        <div class="question-manage-card__back">
          <el-button plain icon="el-icon-arrow-left" @click="goBackBankManage">返回题库管理</el-button>
        </div>
        <div class="question-manage-card__meta">
          <div class="question-manage-card__title">试题管理</div>
          <div class="question-manage-card__desc">
            当前题库：{{ currentBankName }}
          </div>
        </div>
      </div>

      <div class="question-bank-banner">
        <div class="question-bank-banner__main">
          <strong>{{ currentBankName }}</strong>
          <span>在这里维护题干、选项、答案、解析和分值，后续试卷管理将从当前题库中选题组卷。</span>
        </div>
        <div class="question-bank-banner__stats">
          <span>试题数 {{ total }}</span>
          <span>题库编号 {{ bankId || "-" }}</span>
          <el-button type="primary" plain size="mini" icon="el-icon-s-order" @click="goPaperManage">试卷管理</el-button>
        </div>
      </div>

      <el-alert
        v-if="interfacePending"
        title="试题后端接口尚未完全接入，当前页面和 API 骨架已准备好，可先用于前端联调和后续接口对接。"
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
        <el-form-item label="题干关键词" prop="questionTitle">
          <el-input
            v-model.trim="queryParams.questionTitle"
            placeholder="请输入题干关键词"
            clearable
            style="width: 240px"
            @keyup.enter.native="handleQuery"
          />
        </el-form-item>
        <el-form-item label="题型" prop="questionType">
          <el-select
            v-model="queryParams.questionType"
            placeholder="请选择题型"
            clearable
            style="width: 180px"
          >
            <el-option
              v-for="item in questionTypeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="难度等级" prop="difficultyLevel">
          <el-select
            v-model="queryParams.difficultyLevel"
            placeholder="请选择难度等级"
            clearable
            style="width: 180px"
          >
            <el-option
              v-for="item in difficultyOptions"
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
          <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增试题</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate()">修改试题</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete()">删除试题</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="warning" plain icon="el-icon-s-order" size="mini" @click="goPaperManage">试卷管理</el-button>
        </el-col>
        <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" />
      </el-row>

      <el-table v-loading="loading" :data="questionList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="题干" min-width="280" show-overflow-tooltip>
          <template slot-scope="scope">
            <span>{{ getQuestionTitle(scope.row.questionTitle) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="题型" width="110" align="center">
          <template slot-scope="scope">
            <el-tag size="mini" :type="getQuestionTypeTag(scope.row.questionType)">
              {{ getQuestionTypeText(scope.row.questionType) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="难度" width="100" align="center">
          <template slot-scope="scope">
            <el-tag size="mini" :type="getDifficultyTag(scope.row.difficultyLevel)">
              {{ getDifficultyText(scope.row.difficultyLevel) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="分值" prop="score" width="90" align="center" />
        <el-table-column label="自动判分" width="100" align="center">
          <template slot-scope="scope">
            <el-tag size="mini" :type="scope.row.autoMarking === '1' ? 'success' : 'info'">
              {{ scope.row.autoMarking === "1" ? "支持" : "人工" }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="使用次数" prop="usageCount" width="100" align="center" />
        <el-table-column label="正确率" width="100" align="center">
          <template slot-scope="scope">
            <span>{{ formatRate(scope.row) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="90" align="center">
          <template slot-scope="scope">
            <el-tag size="mini" :type="scope.row.status === '0' ? 'success' : 'info'">
              {{ scope.row.status === "0" ? "启用" : "停用" }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="更新时间" width="160" align="center">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.updateTime || scope.row.createTime) || "-" }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="220" class-name="small-padding fixed-width">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
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
      <el-form ref="form" :model="form" :rules="rules" label-width="96px">
        <el-row :gutter="18">
          <el-col :span="12">
            <el-form-item label="题型" prop="questionType">
              <el-select v-model="form.questionType" placeholder="请选择题型" style="width: 100%" @change="handleQuestionTypeChange">
                <el-option
                  v-for="item in questionTypeOptions"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                />
              </el-select>
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
            <el-form-item label="分值" prop="score">
              <el-input-number v-model="form.score" :min="0" :max="100" :precision="2" controls-position="right" style="width: 100%" />
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

        <el-form-item label="题干" prop="questionTitle">
          <el-input
            v-model.trim="form.questionTitle"
            type="textarea"
            :rows="4"
            maxlength="2000"
            show-word-limit
            placeholder="请输入试题题干"
          />
        </el-form-item>

        <el-form-item v-if="showOptionEditor" label="题目选项">
          <div v-for="(option, index) in form.optionList" :key="index" class="option-row">
            <div class="option-row__label">{{ option.optionLabel }}</div>
            <el-input
              v-model.trim="option.optionContent"
              maxlength="500"
              placeholder="请输入选项内容"
            />
            <el-checkbox v-model="option.checked">正确答案</el-checkbox>
          </div>
          <div class="option-row__tips">判断题默认使用两个选项，可在后续联调时继续收口为“正确 / 错误”的固定文案。</div>
        </el-form-item>

        <el-form-item v-else-if="isBlankQuestion" label="标准答案" prop="answerText">
          <el-input
            v-model.trim="form.answerText"
            placeholder="请输入填空题标准答案，多个答案可使用英文逗号分隔"
          />
        </el-form-item>

        <el-form-item v-else label="参考答案" prop="answerText">
          <el-input
            v-model.trim="form.answerText"
            type="textarea"
            :rows="3"
            maxlength="2000"
            show-word-limit
            placeholder="请输入简答题参考答案"
          />
        </el-form-item>

        <el-form-item label="答案解析" prop="analysis">
          <el-input
            v-model.trim="form.analysis"
            type="textarea"
            :rows="4"
            maxlength="2000"
            show-word-limit
            placeholder="请输入答案解析"
          />
        </el-form-item>

        <el-form-item label="附件地址" prop="attachmentUrl">
          <el-input
            v-model.trim="form.attachmentUrl"
            placeholder="选填，可填写题目相关图片或视频附件地址"
          />
        </el-form-item>

        <el-form-item label="自动判分" prop="autoMarking">
          <el-radio-group v-model="form.autoMarking">
            <el-radio :label="'1'">支持</el-radio>
            <el-radio :label="'0'">人工</el-radio>
          </el-radio-group>
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
  listQuestion,
  getQuestion,
  addQuestion,
  updateQuestion,
  delQuestion
} from "@/api/edu/question"

export default {
  name: "TeachingQuestion",
  dicts: ["edu_question_type", "edu_course_difficulty", "sys_normal_disable"],
  data() {
    return {
      loading: false,
      showSearch: true,
      interfacePending: false,
      ids: [],
      single: true,
      multiple: true,
      total: 0,
      questionList: [],
      open: false,
      title: "",
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        bankId: undefined,
        questionTitle: "",
        questionType: undefined,
        difficultyLevel: undefined,
        status: undefined
      },
      form: {},
      rules: {
        questionType: [
          { required: true, message: "请选择题型", trigger: "change" }
        ],
        difficultyLevel: [
          { required: true, message: "请选择难度等级", trigger: "change" }
        ],
        questionTitle: [
          { required: true, message: "请输入题干", trigger: "blur" }
        ]
      },
    }
  },
  computed: {
    questionTypeOptions() {
      return this.dictOptions("edu_question_type", [
        { label: "单选题", value: "1", raw: { listClass: "default" } },
        { label: "多选题", value: "2", raw: { listClass: "warning" } },
        { label: "判断题", value: "3", raw: { listClass: "success" } },
        { label: "填空题", value: "4", raw: { listClass: "info" } },
        { label: "简答题", value: "5", raw: { listClass: "danger" } }
      ])
    },
    difficultyOptions() {
      return this.dictOptions("edu_course_difficulty", [
        { label: "初级", value: "1", raw: { listClass: "success" } },
        { label: "中级", value: "2", raw: { listClass: "warning" } },
        { label: "高级", value: "3", raw: { listClass: "danger" } }
      ])
    },
    statusOptions() {
      return this.dictOptions("sys_normal_disable", [
        { label: "启用", value: "0", raw: { listClass: "primary" } },
        { label: "停用", value: "1", raw: { listClass: "danger" } }
      ])
    },
    /** 当前题库编号 */
    bankId() {
      return this.$route.params.bankId
    },
    /** 当前题库名称 */
    currentBankName() {
      return this.$route.query.bankName || "未命名题库"
    },
    /** 是否显示选项编辑区 */
    showOptionEditor() {
      return ["1", "2", "3"].includes(String(this.form.questionType))
    },
    /** 是否为填空题 */
    isBlankQuestion() {
      return String(this.form.questionType) === "4"
    }
  },
  created() {
    this.queryParams.bankId = this.bankId
    this.getList()
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
    /** 查询试题列表 */
    getList() {
      if (!this.bankId) {
        this.questionList = []
        this.total = 0
        return
      }
      this.loading = true
      listQuestion(this.queryParams).then(response => {
        this.questionList = response.rows || []
        this.total = response.total || 0
        this.interfacePending = false
      }).catch(() => {
        this.questionList = []
        this.total = 0
        this.interfacePending = true
      }).finally(() => {
        this.loading = false
      })
    },
    /** 获取题型文案 */
    getQuestionTypeText(value) {
      return this.getOptionLabel(this.questionTypeOptions, value, "未知题型")
    },
    /** 获取题型标签样式 */
    getQuestionTypeTag(value) {
      return this.getOptionTagType(this.questionTypeOptions, value)
    },
    /** 获取难度文案 */
    getDifficultyText(value) {
      return this.getOptionLabel(this.difficultyOptions, value, "中级")
    },
    /** 获取难度标签样式 */
    getDifficultyTag(value) {
      return this.getOptionTagType(this.difficultyOptions, value)
    },
    /** 截取题干预览 */
    getQuestionTitle(value) {
      return value || "未填写题干"
    },
    /** 格式化正确率 */
    formatRate(row) {
      if (row.correctRate !== undefined && row.correctRate !== null) {
        return `${Number(row.correctRate).toFixed(0)}%`
      }
      if (Number(row.answerCount || 0) === 0) {
        return "0%"
      }
      return `${Math.round((Number(row.correctCount || 0) / Number(row.answerCount || 1)) * 100)}%`
    },
    /** 选择行变化 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.questionId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 搜索试题 */
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
        questionId: undefined,
        bankId: this.bankId,
        questionType: "1",
        difficultyLevel: "2",
        score: 5,
        questionTitle: "",
        answerText: "",
        analysis: "",
        attachmentUrl: "",
        autoMarking: "1",
        status: "0",
        optionList: this.createOptionList("1")
      }
      this.resetForm("form")
    },
    /** 构造默认选项 */
    createOptionList(questionType) {
      if (String(questionType) === "3") {
        return [
          { optionLabel: "A", optionContent: "正确", checked: true },
          { optionLabel: "B", optionContent: "错误", checked: false }
        ]
      }
      return ["A", "B", "C", "D"].map(label => ({
        optionLabel: label,
        optionContent: "",
        checked: false
      }))
    },
    /** 题型变化时重建选项 */
    handleQuestionTypeChange(value) {
      this.form.optionList = this.createOptionList(value)
      this.form.autoMarking = value === "5" ? "0" : "1"
      this.form.answerText = ""
    },
    /** 返回题库管理 */
    goBackBankManage() {
      this.$router.push("/teaching/paper")
    },
    /** 进入试卷管理 */
    goPaperManage() {
      if (!this.bankId) {
        this.$modal.msgWarning("当前题库编号无效")
        return
      }
      this.$router.push({
        path: `/teaching/paper-manage/${this.bankId}`,
        query: { bankName: this.currentBankName }
      })
    },
    /** 新增试题 */
    handleAdd() {
      this.reset()
      this.open = true
      this.title = "新增试题"
    },
    /** 修改试题 */
    handleUpdate(row) {
      const questionId = row ? row.questionId : this.ids[0]
      this.reset()
      getQuestion(questionId).then(response => {
        const data = response.data || {}
        const optionList = (data.optionList || this.createOptionList(data.questionType || "1")).map(item => ({
          ...item,
          checked: item.checked === true || item.isCorrect === "1"
        }))
        this.form = Object.assign({}, this.form, data, {
          optionList,
          answerText: data.answerText || ""
        })
        this.open = true
        this.title = "修改试题"
        this.interfacePending = false
      }).catch(() => {
        this.interfacePending = true
      })
    },
    /** 删除试题 */
    handleDelete(row) {
      const questionIds = row ? row.questionId : this.ids
      this.$modal.confirm("是否确认删除所选试题？").then(() => {
        return delQuestion(questionIds)
      }).then(() => {
        this.$modal.msgSuccess("删除成功")
        this.getList()
      }).catch(() => {})
    },
    /** 取消弹窗 */
    cancel() {
      this.open = false
      this.reset()
    },
    /** 组装提交数据 */
    buildSubmitData() {
      const optionList = this.showOptionEditor
        ? (this.form.optionList || []).map(item => ({
            optionLabel: item.optionLabel,
            optionContent: item.optionContent,
            isCorrect: item.checked ? "1" : "0"
          }))
        : []
      return Object.assign({}, this.form, {
        bankId: this.bankId,
        optionList
      })
    },
    /** 提交试题表单 */
    submitForm() {
      this.$refs.form.validate(valid => {
        if (!valid) {
          return
        }
        const requestApi = this.form.questionId ? updateQuestion : addQuestion
        requestApi(this.buildSubmitData()).then(() => {
          this.$modal.msgSuccess(this.form.questionId ? "修改成功" : "新增成功")
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
.question-manage-page {
  min-height: 100vh;
}

.question-manage-card {
  border-radius: 24px;
  border: 1px solid rgba(148, 163, 184, 0.12);
  background: rgba(255, 255, 255, 0.82);
  box-shadow: 0 18px 38px rgba(15, 23, 42, 0.06);
  backdrop-filter: blur(14px);
}

.question-manage-card__header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 18px;
}

.question-manage-card__title {
  color: #0f172a;
  font-size: 22px;
  font-weight: 700;
}

.question-manage-card__desc {
  margin-top: 8px;
  color: #64748b;
  line-height: 1.7;
}

.question-bank-banner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 18px;
  padding: 18px 20px;
  border-radius: 20px;
  background: linear-gradient(135deg, #eff6ff, #f8fafc);
}

.question-bank-banner__main strong {
  display: block;
  color: #0f172a;
  font-size: 18px;
}

.question-bank-banner__main span,
.question-bank-banner__stats span,
.option-row__tips {
  color: #64748b;
}

.question-bank-banner__main span {
  display: block;
  margin-top: 8px;
  line-height: 1.8;
}

.question-bank-banner__stats {
  display: grid;
  gap: 8px;
  flex-shrink: 0;
  text-align: right;
  font-size: 13px;
}

.option-row {
  display: grid;
  grid-template-columns: 56px minmax(0, 1fr) 92px;
  gap: 12px;
  align-items: center;
  margin-bottom: 12px;
}

.option-row__label {
  color: #2563eb;
  font-weight: 700;
}

.option-row__tips {
  margin-top: 4px;
  font-size: 12px;
}

.mb16 {
  margin-bottom: 16px;
}

@media screen and (max-width: 960px) {
  .question-manage-card__header,
  .question-bank-banner {
    flex-direction: column;
    align-items: flex-start;
  }

  .question-bank-banner__stats {
    text-align: left;
  }

  .option-row {
    grid-template-columns: 1fr;
  }
}
</style>
