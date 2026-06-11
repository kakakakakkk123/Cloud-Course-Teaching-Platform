<template>
  <div class="app-container exam-manage-page">
    <el-card shadow="never" class="exam-manage-card">
      <div slot="header" class="exam-manage-card__header">
        <div class="exam-manage-card__back">
          <el-button plain icon="el-icon-arrow-left" @click="goBackPaperManage">返回试卷管理</el-button>
        </div>
        <div class="exam-manage-card__meta">
          <div class="exam-manage-card__title">考试发布</div>
          <div class="exam-manage-card__desc">
            当前试卷：{{ currentPaperName }}
          </div>
        </div>
      </div>

      <div class="exam-paper-banner">
        <div class="exam-paper-banner__main">
          <strong>{{ currentPaperName }}</strong>
          <span v-if="currentBankName">题库：{{ currentBankName }}</span>
          <span>在这里配置考试时间、时长、及格线和答后展示策略。</span>
        </div>
        <div class="exam-paper-banner__stats">
          <span>考试总数 {{ total }}</span>
          <span>试卷编号 {{ paperId || "-" }}</span>
          <span v-if="currentBankName">题库编号 {{ bankId || "-" }}</span>
        </div>
      </div>

      <el-alert
        v-if="interfacePending"
        title="考试发布后端接口尚未完全接入，当前页面和 API 骨架已准备好，可先用于前端联调和后续接口对接。"
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
        <el-form-item label="考试名称" prop="examName">
          <el-input
            v-model.trim="queryParams.examName"
            placeholder="请输入考试名称"
            clearable
            style="width: 220px"
            @keyup.enter.native="handleQuery"
          />
        </el-form-item>
        <el-form-item label="发布状态" prop="status">
          <el-select
            v-model="queryParams.status"
            placeholder="请选择发布状态"
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
          <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增考试</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate()">修改考试</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete()">删除考试</el-button>
        </el-col>
        <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" />
      </el-row>

      <el-table v-loading="loading" :data="examList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="考试名称" prop="examName" min-width="180" show-overflow-tooltip />
        <el-table-column label="关联课程" min-width="160" show-overflow-tooltip>
          <template slot-scope="scope">
            <span>{{ scope.row.courseNames || scope.row.courseName || "未关联课程" }}</span>
          </template>
        </el-table-column>
        <el-table-column label="开始时间" width="160" align="center">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.startTime) || "-" }}</span>
          </template>
        </el-table-column>
        <el-table-column label="结束时间" width="160" align="center">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.endTime) || "-" }}</span>
          </template>
        </el-table-column>
        <el-table-column label="时长(分钟)" prop="durationMinutes" width="110" align="center" />
        <el-table-column label="及格分" prop="passScore" width="90" align="center" />
        <el-table-column label="作答次数" prop="maxAttemptCount" width="100" align="center" />
        <el-table-column label="状态" width="100" align="center">
          <template slot-scope="scope">
            <el-tag size="mini" :type="getStatusTag(scope.row.status)">
              {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="240" class-name="small-padding fixed-width">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
            <el-button size="mini" type="text" icon="el-icon-data-analysis" @click="handleStats(scope.row)">成绩统计</el-button>
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

    <el-dialog :title="title" :visible.sync="open" width="920px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="108px">
        <el-row :gutter="18">
          <el-col :span="12">
            <el-form-item label="考试名称" prop="examName">
              <el-input
                v-model.trim="form.examName"
                maxlength="120"
                show-word-limit
                placeholder="请输入考试名称"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="发布状态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio v-for="item in statusOptions" :key="item.value" :label="item.value">
                  {{ item.label }}
                </el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="18">
          <el-col :span="24">
            <el-form-item label="关联课程" prop="courseIds">
              <el-select
                v-model="form.courseIds"
                multiple
                collapse-tags
                clearable
                filterable
                placeholder="可选择多个课程，不选则为通用考试"
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
            <el-form-item label="开始时间" prop="startTime">
              <el-date-picker
                v-model="form.startTime"
                type="datetime"
                value-format="yyyy-MM-dd HH:mm:ss"
                placeholder="请选择开始时间"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="结束时间" prop="endTime">
              <el-date-picker
                v-model="form.endTime"
                type="datetime"
                value-format="yyyy-MM-dd HH:mm:ss"
                placeholder="请选择结束时间"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="18">
          <el-col :span="8">
            <el-form-item label="考试时长" prop="durationMinutes">
              <el-input-number v-model="form.durationMinutes" :min="0" :max="600" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="及格分" prop="passScore">
              <el-input-number v-model="form.passScore" :min="0" :max="1000" :precision="2" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="最多作答次数" prop="maxAttemptCount">
              <el-input-number v-model="form.maxAttemptCount" :min="1" :max="20" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="18">
          <el-col :span="8">
            <el-form-item label="允许中断" prop="allowInterrupt">
              <el-radio-group v-model="form.allowInterrupt">
                <el-radio :label="'1'">允许</el-radio>
                <el-radio :label="'0'">不允许</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="中断计时" prop="interruptKeepTiming">
              <el-radio-group v-model="form.interruptKeepTiming">
                <el-radio :label="'1'">继续计时</el-radio>
                <el-radio :label="'0'">暂停计时</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="答后看答案" prop="showAnswerAfterSubmit">
              <el-radio-group v-model="form.showAnswerAfterSubmit">
                <el-radio :label="'1'">允许</el-radio>
                <el-radio :label="'0'">不允许</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="考试说明" prop="examNotice">
          <el-input
            v-model.trim="form.examNotice"
            type="textarea"
            :rows="4"
            maxlength="1000"
            show-word-limit
            placeholder="请输入考试说明、作答要求或通知内容"
          />
        </el-form-item>

        <el-form-item label="学生入口" prop="syncCourseContent">
          <el-checkbox v-model="syncCourseContentChecked">
            发布时自动生成或更新课程内容中的考试入口
          </el-checkbox>
          <div class="exam-publish-inline-tip">这样学生在课程学习页里能直接看到这场考试，不需要再手动去课程内容页挂载入口。</div>
        </el-form-item>

        <el-form-item label="发布提示">
          <div class="exam-publish-tips">
            发布后的学生可见路径取决于课程绑定、发布时间和课程入口状态。
            <br />
            1. 已绑定课程后，系统可自动生成课程内容中的考试入口
            <br />
            2. 学生从“我的考试”或课程学习页进入考试
            <br />
            3. 客观题会自动判分，主观题保留给教师后续批改
          </div>
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
  listExam,
  getExam,
  addExam,
  updateExam,
  delExam
} from "@/api/edu/exam"
import { listCourse } from "@/api/edu/course"

export default {
  name: "TeachingExamManage",
  dicts: ["edu_exam_status"],
  data() {
    return {
      loading: false,
      showSearch: true,
      interfacePending: false,
      ids: [],
      single: true,
      courseOptions: [],
      multiple: true,
      total: 0,
      examList: [],
      open: false,
      title: "",
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        paperId: undefined,
        examName: "",
        status: undefined
      },
      form: {},
      rules: {
        examName: [
          { required: true, message: "请输入考试名称", trigger: "blur" }
        ],
        startTime: [
          { required: true, message: "请选择开始时间", trigger: "change" }
        ],
        endTime: [
          { required: true, message: "请选择结束时间", trigger: "change" },
          { validator: this.validateEndTime, trigger: "change" }
        ],
        durationMinutes: [
          { required: true, message: "请输入考试时长", trigger: "blur" },
          { type: "number", min: 1, message: "考试时长必须大于0", trigger: "blur" }
        ],
        passScore: [
          { type: "number", min: 0, message: "及格分不能为负数", trigger: "blur" }
        ],
        status: [
          { required: true, message: "请选择发布状态", trigger: "change" }
        ]
      },
    }
  },
  computed: {
    syncCourseContentChecked: {
      get() {
        return this.form.syncCourseContent === "1"
      },
      set(value) {
        this.form.syncCourseContent = value ? "1" : "0"
      }
    },
    statusOptions() {
      return this.dictOptions("edu_exam_status", [
        { label: "草稿", value: "0", raw: { listClass: "info" } },
        { label: "已发布", value: "1", raw: { listClass: "success" } },
        { label: "已结束", value: "2", raw: { listClass: "warning" } }
      ])
    },
    /** 当前试卷编号 */
    paperId() {
      return this.$route.params.paperId
    },
    /** 当前试卷名称 */
    currentPaperName() {
      return this.$route.query.paperName || "未命名试卷"
    },
    /** 当前试卷总分 */
    currentPaperTotalScore() {
      const value = this.$route.query.totalScore
      return value !== undefined && value !== null && value !== "" ? Number(value) : undefined
    },
    /** 当前题库编号 */
    bankId() {
      return this.$route.query.bankId
    },
    /** 当前题库名称 */
    currentBankName() {
      return this.$route.query.bankName || "未命名题库"
    }
  },
  created() {
    this.queryParams.paperId = this.paperId
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
    /** 查询考试列表 */
    getList() {
      this.loading = true
      listExam(this.queryParams).then(response => {
        this.examList = response.rows || []
        this.total = response.total || 0
        this.interfacePending = false
      }).catch(() => {
        this.examList = []
        this.total = 0
        this.interfacePending = true
      }).finally(() => {
        this.loading = false
      })
    },
    /** 查询课程下拉选项 */
    getCourseOptions() {
      listCourse({
        pageNum: 1, pageSize: 1000, publishStatus: undefined, allowRegister: undefined
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
    /** 校验结束时间必须晚于开始时间 */
    validateEndTime(rule, value, callback) {
      if (this.form.startTime && value && new Date(value) <= new Date(this.form.startTime)) {
        callback(new Error("结束时间必须晚于开始时间"))
      } else {
        callback()
      }
    },
    /** 选择行变化 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.examId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 搜索考试 */
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    /** 重置查询 */
    resetQuery() {
      this.resetForm("queryForm")
      this.queryParams.paperId = this.paperId
      this.handleQuery()
    },
    /** 重置表单 */
    reset() {
      this.form = {
        examId: undefined,
        paperId: this.paperId,
        courseId: undefined,
        courseIds: [],
        examName: "",
        startTime: "",
        endTime: "",
        durationMinutes: 90,
        passScore: 60,
        totalScore: this.currentPaperTotalScore,
        maxAttemptCount: 1,
        allowInterrupt: "0",
        interruptKeepTiming: "1",
        showAnswerAfterSubmit: "0",
        showScoreAfterSubmit: "1",
        questionShuffle: "0",
        optionShuffle: "0",
        status: "0",
        examNotice: "",
        syncCourseContent: "1"
      }
      this.resetForm("form")
    },
    /** 返回试卷管理 */
    goBackPaperManage() {
      const path = this.bankId
        ? `/teaching/paper-manage/${this.bankId}`
        : '/teaching/paper-manage'
      this.$router.push({
        path,
        query: { bankName: this.currentBankName }
      })
    },
    /** 新增考试 */
    handleAdd() {
      this.reset()
      this.open = true
      this.title = "新增考试"
    },
    /** 修改考试 */
    handleUpdate(row) {
      const examId = row ? row.examId : this.ids[0]
      this.reset()
      getExam(examId).then(response => {
        const data = response.data || {}
        this.form = Object.assign({}, this.form, data, {
          courseId: data.courseId || undefined,
          courseIds: data.courseIds || [],
          totalScore: data.totalScore || this.currentPaperTotalScore,
          syncCourseContent: data.syncCourseContent || "1"
        })
        this.open = true
        this.title = "修改考试"
        this.interfacePending = false
      }).catch(() => {
        this.interfacePending = true
      })
    },
    /** 删除考试 */
    handleDelete(row) {
      const examIds = row ? row.examId : this.ids
      this.$modal.confirm("是否确认删除所选考试？").then(() => {
        return delExam(examIds)
      }).then(() => {
        this.$modal.msgSuccess("删除成功")
        this.getList()
      }).catch(() => {})
    },
    /** 查看成绩统计 */
    handleStats(row) {
      this.$router.push({
        path: `/teaching/score-detail/${row.examId}`,
        query: {
          examName: row.examName,
          paperId: this.paperId,
          paperName: this.currentPaperName,
          courseId: row.courseId,
          totalScore: row.totalScore,
          bankId: this.bankId,
          bankName: this.currentBankName
        }
      })
    },
    /** 取消弹窗 */
    cancel() {
      this.open = false
      this.reset()
    },
    /** 提交考试表单 */
    submitForm() {
      this.$refs.form.validate(valid => {
        if (!valid) {
          return
        }
        const requestApi = this.form.examId ? updateExam : addExam
        requestApi(this.form).then(() => {
          this.$modal.msgSuccess(this.form.examId ? "修改成功" : "新增成功")
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
.exam-manage-page {
  min-height: 100vh;
}

.exam-manage-card {
  border-radius: 24px;
  border: 1px solid rgba(148, 163, 184, 0.12);
  background: rgba(255, 255, 255, 0.82);
  box-shadow: 0 18px 38px rgba(15, 23, 42, 0.06);
  backdrop-filter: blur(14px);
}

.exam-manage-card__header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 18px;
}

.exam-manage-card__title {
  color: #0f172a;
  font-size: 22px;
  font-weight: 700;
}

.exam-manage-card__desc {
  margin-top: 8px;
  color: #64748b;
  line-height: 1.7;
}

.exam-paper-banner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 18px;
  padding: 18px 20px;
  border-radius: 20px;
  background: linear-gradient(135deg, #eff6ff, #f8fafc);
}

.exam-paper-banner__main strong {
  display: block;
  color: #0f172a;
  font-size: 18px;
}

.exam-paper-banner__main span,
.exam-paper-banner__stats span,
.exam-publish-tips {
  color: #64748b;
}

.exam-paper-banner__main span {
  display: block;
  margin-top: 8px;
  line-height: 1.8;
}

.exam-paper-banner__stats {
  display: grid;
  gap: 8px;
  flex-shrink: 0;
  text-align: right;
  font-size: 13px;
}

.exam-publish-tips {
  padding: 14px 16px;
  border-radius: 16px;
  background: #f8fafc;
  line-height: 1.8;
}

.exam-publish-inline-tip {
  margin-top: 8px;
  color: #64748b;
  font-size: 12px;
  line-height: 1.7;
}

.mb16 {
  margin-bottom: 16px;
}

@media screen and (max-width: 960px) {
  .exam-manage-card__header,
  .exam-paper-banner {
    flex-direction: column;
    align-items: flex-start;
  }

  .exam-paper-banner__stats {
    text-align: left;
  }
}
</style>
