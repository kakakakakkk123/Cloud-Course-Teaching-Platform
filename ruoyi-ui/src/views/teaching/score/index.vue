<template>
  <div class="app-container teaching-score-page">
    <section class="score-page-header">
      <div class="score-page-header__main">
        <el-button v-if="hasActiveExam" plain icon="el-icon-arrow-left" @click="goBackExamManage">返回考试发布</el-button>
        <div>
          <h1>成绩统计</h1>
          <p>{{ hasActiveExam ? currentExamName : "先选择一场考试，再查看对应的成绩、批改和统计数据。" }}</p>
        </div>
      </div>
      <div v-if="hasActiveExam" class="score-page-header__meta">
        <span>考试编号 {{ examId || "-" }}</span>
        <span>试卷编号 {{ paperId || "-" }}</span>
      </div>
    </section>

    <el-card v-if="!hasActiveExam" shadow="never" class="score-selector-card">
      <div class="score-selector-card__head">
        <strong>选择要查看的考试</strong>
        <span>从左侧菜单进入时，先确认要查看的考试，再进入对应的成绩统计工作台。</span>
      </div>

      <el-form :model="examPickerQuery" :inline="true" size="small" class="score-selector-form">
        <el-form-item label="考试名称">
          <el-input
            v-model.trim="examPickerQuery.examName"
            placeholder="输入考试名称"
            clearable
            style="width: 240px"
            @keyup.enter.native="getExamPickerList"
          />
        </el-form-item>
        <el-form-item label="发布状态">
          <el-select
            v-model="examPickerQuery.status"
            placeholder="全部状态"
            clearable
            style="width: 180px"
          >
            <el-option v-for="item in examStatusOptions" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" size="mini" icon="el-icon-search" @click="getExamPickerList">搜索</el-button>
          <el-button size="mini" icon="el-icon-refresh" @click="resetExamPicker">重置</el-button>
        </el-form-item>
      </el-form>

      <el-table v-loading="examPickerLoading" :data="examPickerList">
        <el-table-column label="考试名称" prop="examName" min-width="220" show-overflow-tooltip />
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
        <el-table-column label="发布状态" width="110" align="center">
          <template slot-scope="scope">
            <el-tag size="mini" :type="getExamStatusTag(scope.row.status)">
              {{ getExamStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" align="center">
          <template slot-scope="scope">
            <el-button type="text" size="mini" @click="selectExam(scope.row)">查看统计</el-button>
          </template>
        </el-table-column>
      </el-table>

      <pagination
        v-show="examPickerTotal > 0"
        :total="examPickerTotal"
        :page.sync="examPickerQuery.pageNum"
        :limit.sync="examPickerQuery.pageSize"
        @pagination="getExamPickerList"
      />
    </el-card>

    <template v-else>
      <el-row :gutter="16" class="score-overview">
        <el-col v-for="card in overviewCards" :key="card.title" :xs="24" :sm="12" :lg="8" :xl="4">
          <div class="score-overview-card">
            <span>{{ card.title }}</span>
            <strong>{{ card.value }}</strong>
            <small>{{ card.note }}</small>
          </div>
        </el-col>
      </el-row>

      <el-alert
        v-if="Number(overview.pendingReviewCount || 0) > 0"
        type="warning"
        :closable="false"
        show-icon
        class="score-pending-alert"
      >
        <template slot="title">
          当前还有 {{ overview.pendingReviewCount }} 份作答待批改，建议优先处理待批改记录，学生结果页会在批改完成后自动更新。
        </template>
      </el-alert>

      <el-card shadow="never" class="score-workspace">
        <el-form
          v-show="showSearch"
          ref="queryForm"
          :model="queryParams"
          :inline="true"
          size="small"
          label-width="84px"
          class="score-query-form"
        >
          <el-form-item label="学生账号" prop="studentKeyword">
            <el-input
              v-model.trim="queryParams.studentKeyword"
              placeholder="输入学生账号或姓名"
              clearable
              style="width: 220px"
              @keyup.enter.native="handleQuery"
            />
          </el-form-item>
          <el-form-item label="作答状态" prop="recordStatus">
            <el-select
              v-model="queryParams.recordStatus"
              placeholder="全部状态"
              clearable
              style="width: 170px"
            >
              <el-option
                v-for="item in recordStatusOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="成绩结果" prop="resultStatus">
            <el-select
              v-model="queryParams.resultStatus"
              placeholder="全部结果"
              clearable
              style="width: 170px"
            >
              <el-option
                v-for="item in resultStatusOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="批改状态" prop="checkedFlag">
            <el-select
              v-model="queryParams.checkedFlag"
              placeholder="全部批改状态"
              clearable
              style="width: 170px"
            >
              <el-option
                v-for="item in reviewStatusOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
            <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
            <el-button
              v-if="Number(overview.pendingReviewCount || 0) > 0"
              type="warning"
              plain
              size="mini"
              @click="applyPendingFilter"
            >
              只看待批改
            </el-button>
          </el-form-item>
        </el-form>

        <div class="score-toolbar">
          <div class="score-toolbar__hint">老师可以先筛到待批改记录，再在右侧详情里完成逐题评分与评语。</div>
          <div class="score-toolbar__actions">
            <el-button type="primary" plain size="mini" icon="el-icon-download" @click="handleExport">导出成绩</el-button>
            <right-toolbar :showSearch.sync="showSearch" @queryTable="getRecordList" />
          </div>
        </div>

        <div class="score-insight-strip">
          <div class="score-insight-chip">
            <span>完成率</span>
            <strong>{{ formatRate(overview.completionRate) }}</strong>
          </div>
          <div class="score-insight-chip">
            <span>已完成批改</span>
            <strong>{{ overview.reviewedCount || 0 }}</strong>
          </div>
          <div class="score-insight-chip">
            <span>未及格人数</span>
            <strong>{{ overview.failCount || 0 }}</strong>
          </div>
        </div>

        <el-table v-loading="loading" :data="recordList">
          <el-table-column label="学生账号" prop="studentUserName" min-width="130" />
          <el-table-column label="学生姓名" prop="studentName" min-width="120" />
          <el-table-column label="作答状态" width="110" align="center">
            <template slot-scope="scope">
              <el-tag size="mini" :type="getRecordStatusTag(scope.row.recordStatus)">
                {{ getRecordStatusText(scope.row.recordStatus) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="批改状态" width="110" align="center">
            <template slot-scope="scope">
              <el-tag size="mini" :type="getReviewStatusTag(scope.row)">
                {{ getReviewStatusText(scope.row) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="开始时间" width="160" align="center">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.startTime) || "-" }}</span>
            </template>
          </el-table-column>
          <el-table-column label="提交时间" width="160" align="center">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.submitTime) || "-" }}</span>
            </template>
          </el-table-column>
          <el-table-column label="客观分" prop="objectiveScore" width="100" align="center" />
          <el-table-column label="主观分" prop="subjectiveScore" width="100" align="center" />
          <el-table-column label="总分" prop="totalScore" width="90" align="center" />
          <el-table-column label="结果" width="90" align="center">
            <template slot-scope="scope">
              <el-tag size="mini" :type="scope.row.resultStatus === '1' ? 'success' : 'info'">
                {{ scope.row.resultStatus === "1" ? "及格" : "未及格" }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="170" align="center" fixed="right">
            <template slot-scope="scope">
              <el-button
                v-if="canOpenReview(scope.row)"
                size="mini"
                type="text"
                @click="openReview(scope.row)"
              >
                {{ needsReview(scope.row) ? "批改" : "查看详情" }}
              </el-button>
            </template>
          </el-table-column>
        </el-table>

        <pagination
          v-show="total > 0"
          :total="total"
          :page.sync="queryParams.pageNum"
          :limit.sync="queryParams.pageSize"
          @pagination="getRecordList"
        />
      </el-card>

      <el-dialog
        :title="reviewDialogTitle"
        :visible.sync="reviewOpen"
        width="1040px"
        top="4vh"
        append-to-body
        class="score-review-dialog"
        :close-on-click-modal="false"
      >
        <div v-loading="reviewLoading" class="review-dialog-body">
          <section class="review-summary">
            <div class="review-summary__main">
              <strong>{{ selectedRecord.studentName || selectedRecord.studentUserName || "学生作答" }}</strong>
              <span>{{ currentExamName }}</span>
            </div>
            <div class="review-summary__meta">
              <span>作答状态：{{ getRecordStatusText(selectedRecord.recordStatus) }}</span>
              <span>批改状态：{{ getReviewStatusText(selectedRecord) }}</span>
              <span>提交时间：{{ parseTime(selectedRecord.submitTime) || "-" }}</span>
            </div>
          </section>

          <div class="review-metrics" v-if="reviewDetail.recordId">
            <div class="review-metric-card">
              <span>客观分</span>
              <strong>{{ formatScore(reviewDetail.objectiveScore) }}</strong>
            </div>
            <div class="review-metric-card">
              <span>主观分</span>
              <strong>{{ formatScore(reviewDetail.subjectiveScore) }}</strong>
            </div>
            <div class="review-metric-card">
              <span>当前总分</span>
              <strong>{{ formatScore(reviewDetail.totalScore) }}</strong>
            </div>
          </div>

          <el-alert
            v-if="!hasManualQuestions && reviewDetail.recordId"
            type="info"
            :closable="false"
            show-icon
            class="review-inline-alert"
            title="这份作答没有待教师评分的主观题，当前展示的是系统自动判分结果。"
          />

          <section v-if="reviewDetail.recordId" class="review-question-list">
            <article
              v-for="question in reviewDetail.questionList || []"
              :key="question.answerId || question.questionId"
              class="review-question-card"
            >
              <div class="review-question-card__head">
                <div class="review-question-card__title">
                  <span>第 {{ question.questionOrder }} 题</span>
                  <el-tag size="mini" :type="getQuestionTagType(question.questionType)">
                    {{ getQuestionTypeText(question.questionType) }}
                  </el-tag>
                  <el-tag v-if="canEditQuestion(question)" size="mini" type="warning">主观题</el-tag>
                  <el-tag v-else size="mini" type="success">自动判分</el-tag>
                </div>
                <strong>{{ formatQuestionScore(question.actualScore) }} / {{ formatScore(question.questionScore) }}</strong>
              </div>

              <h3>{{ question.questionTitle }}</h3>

              <div v-if="question.attachmentUrl" class="review-question-card__attachment">
                附件：
                <a :href="getAttachmentUrl(question.attachmentUrl)" target="_blank" rel="noopener noreferrer">查看附件</a>
              </div>

              <div
                v-if="question.optionList && question.optionList.length"
                class="review-question-card__options"
              >
                <div
                  v-for="option in question.optionList"
                  :key="option.optionLabel"
                  class="review-option"
                >
                  <span>{{ option.optionLabel }}</span>
                  <span>{{ option.optionContent }}</span>
                </div>
              </div>

              <div class="review-question-card__grid">
                <div class="review-field">
                  <label>学生答案</label>
                  <div>{{ formatAnswer(question.studentAnswer) }}</div>
                </div>
                <div class="review-field">
                  <label>标准答案</label>
                  <div>{{ formatAnswer(question.standardAnswer) }}</div>
                </div>
              </div>

              <div v-if="question.analysisSnapshot" class="review-field review-field--full">
                <label>答案解析</label>
                <div>{{ question.analysisSnapshot }}</div>
              </div>

              <div v-if="canEditQuestion(question)" class="review-editor">
                <el-form label-width="88px" size="small">
                  <el-form-item label="题目得分">
                    <el-input-number
                      v-model="question.actualScore"
                      :min="0"
                      :max="toScore(question.questionScore)"
                      :precision="2"
                      controls-position="right"
                    />
                    <span class="review-editor__hint">满分 {{ formatScore(question.questionScore) }}</span>
                  </el-form-item>
                  <el-form-item label="教师评语">
                    <el-input
                      v-model.trim="question.teacherComment"
                      type="textarea"
                      :rows="3"
                      maxlength="300"
                      show-word-limit
                      placeholder="可填写本题给分依据或作答建议"
                    />
                  </el-form-item>
                </el-form>
              </div>

              <div v-else class="review-field review-field--full">
                <label>系统判定</label>
                <div>{{ question.isCorrect === "1" ? "回答正确" : "回答错误或未作答" }}</div>
              </div>
            </article>
          </section>
        </div>

        <span slot="footer" class="dialog-footer">
          <el-button @click="reviewOpen = false">关闭</el-button>
          <el-button
            v-if="hasManualQuestions"
            plain
            :loading="reviewSubmitting"
            @click="saveReview(false)"
          >
            保存批改
          </el-button>
          <el-button
            v-if="hasManualQuestions"
            type="primary"
            :loading="reviewSubmitting"
            @click="saveReview(true)"
          >
            提交批改
          </el-button>
        </span>
      </el-dialog>
    </template>
  </div>
</template>

<script>
import {
  getExamStatOverview,
  listExamStatRecord,
  getExamReviewDetail,
  submitExamReview
} from "@/api/edu/examStat"
import { getExam, listExam } from "@/api/edu/exam"

const createOverview = () => ({
  participantCount: 0,
  submittedCount: 0,
  reviewedCount: 0,
  averageScore: 0,
  passRate: 0,
  highestScore: 0,
  pendingReviewCount: 0,
  completionRate: 0,
  failCount: 0
})

export default {
  name: "TeachingScore",
  data() {
    return {
      loading: false,
      examPickerLoading: false,
      reviewLoading: false,
      reviewSubmitting: false,
      showSearch: true,
      total: 0,
      examPickerTotal: 0,
      recordList: [],
      examPickerList: [],
      reviewOpen: false,
      selectedRecord: {},
      examDetail: {},
      reviewDetail: {
        questionList: []
      },
      overview: createOverview(),
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        examId: undefined,
        studentKeyword: "",
        recordStatus: undefined,
        resultStatus: undefined,
        checkedFlag: undefined
      },
      examPickerQuery: {
        pageNum: 1,
        pageSize: 10,
        examName: "",
        status: undefined
      },
      recordStatusOptions: [
        { label: "未开始", value: "0" },
        { label: "作答中", value: "1" },
        { label: "已提交", value: "2" },
        { label: "已完成", value: "3" }
      ],
      resultStatusOptions: [
        { label: "及格", value: "1" },
        { label: "未及格", value: "0" }
      ],
      reviewStatusOptions: [
        { label: "待批改", value: "0" },
        { label: "已完成", value: "1" }
      ],
      examStatusOptions: [
        { label: "未发布", value: "0" },
        { label: "已发布", value: "1" },
        { label: "已结束", value: "2" }
      ]
    }
  },
  computed: {
    examId() {
      return this.$route.params.examId
    },
    hasActiveExam() {
      return !!this.examId
    },
    paperId() {
      return this.$route.query.paperId || this.examDetail.paperId
    },
    currentExamName() {
      return this.$route.query.examName || this.examDetail.examName || "未命名考试"
    },
    bankId() {
      return this.$route.query.bankId
    },
    bankName() {
      return this.$route.query.bankName || "未命名题库"
    },
    overviewCards() {
      return [
        { title: "应参加人数", value: this.overview.participantCount || 0, note: "已有作答记录的学生数量" },
        { title: "已提交人数", value: this.overview.submittedCount || 0, note: "已交卷或已批改记录" },
        { title: "平均分", value: this.formatScore(this.overview.averageScore), note: "已提交记录的平均成绩" },
        { title: "及格率", value: this.formatRate(this.overview.passRate), note: "基于已提交记录计算" },
        { title: "最高分", value: this.formatScore(this.overview.highestScore), note: "当前考试最高总分" },
        { title: "待批改", value: this.overview.pendingReviewCount || 0, note: "仍需教师处理的作答" }
      ]
    },
    reviewDialogTitle() {
      if (!this.selectedRecord.recordId) {
        return "批改详情"
      }
      return this.needsReview(this.selectedRecord) ? "批改作答" : "查看作答详情"
    },
    hasManualQuestions() {
      return (this.reviewDetail.questionList || []).some(question => this.canEditQuestion(question))
    }
  },
  created() {
    this.bootstrapPage()
  },
  watch: {
    "$route.fullPath"() {
      this.bootstrapPage()
    }
  },
  methods: {
    bootstrapPage() {
      this.queryParams.examId = this.examId
      this.recordList = []
      this.total = 0
      this.reviewOpen = false
      this.selectedRecord = {}
      this.reviewDetail = { questionList: [] }
      this.overview = createOverview()
      if (this.hasActiveExam) {
        return this.loadActiveExamContext()
      }
      this.examDetail = {}
      return this.getExamPickerList()
    },
    loadActiveExamContext() {
      const tasks = [this.getOverview(), this.getRecordList()]
      if (!this.$route.query.examName || !this.$route.query.paperId) {
        tasks.unshift(this.getExamContext())
      }
      return Promise.all(tasks)
    },
    getExamContext() {
      if (!this.examId) {
        return Promise.resolve()
      }
      return getExam(this.examId).then(response => {
        this.examDetail = response.data || {}
      })
    },
    getExamPickerList() {
      this.examPickerLoading = true
      return listExam(this.examPickerQuery).then(response => {
        this.examPickerList = response.rows || []
        this.examPickerTotal = response.total || 0
      }).finally(() => {
        this.examPickerLoading = false
      })
    },
    resetExamPicker() {
      this.examPickerQuery = {
        pageNum: 1,
        pageSize: 10,
        examName: "",
        status: undefined
      }
      this.getExamPickerList()
    },
    selectExam(row) {
      this.$router.push({
        path: `/teaching/score-detail/${row.examId}`,
        query: {
          examName: row.examName,
          paperId: row.paperId,
          courseId: row.courseId,
          totalScore: row.totalScore,
          bankId: this.bankId,
          bankName: this.bankName
        }
      })
    },
    getOverview() {
      if (!this.examId) {
        return Promise.resolve()
      }
      return getExamStatOverview(this.examId).then(response => {
        this.overview = Object.assign(createOverview(), response.data || {})
      })
    },
    getRecordList() {
      if (!this.examId) {
        this.recordList = []
        this.total = 0
        return Promise.resolve()
      }
      this.loading = true
      return listExamStatRecord(this.queryParams).then(response => {
        this.recordList = response.rows || []
        this.total = response.total || 0
      }).finally(() => {
        this.loading = false
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getRecordList()
    },
    resetQuery() {
      this.resetForm("queryForm")
      this.queryParams.examId = this.examId
      this.queryParams.pageNum = 1
      this.queryParams.pageSize = 10
      this.getRecordList()
    },
    applyPendingFilter() {
      this.queryParams.checkedFlag = "0"
      this.queryParams.recordStatus = "2"
      this.handleQuery()
    },
    openReview(row) {
      this.selectedRecord = Object.assign({}, row)
      this.reviewOpen = true
      this.reviewLoading = true
      this.reviewDetail = { questionList: [] }
      getExamReviewDetail(row.recordId).then(response => {
        this.reviewDetail = response.data || { questionList: [] }
      }).finally(() => {
        this.reviewLoading = false
      })
    },
    saveReview(finalize) {
      if (!this.selectedRecord.recordId || this.reviewSubmitting) {
        return
      }
      const requestData = {
        finalize,
        answers: (this.reviewDetail.questionList || [])
          .filter(question => this.canEditQuestion(question))
          .filter(question => question.actualScore !== null || question.teacherComment)
          .map(question => ({
            answerId: question.answerId,
            actualScore: question.actualScore,
            teacherComment: question.teacherComment
          }))
      }
      const doSubmit = () => {
        this.reviewSubmitting = true
        return submitExamReview(this.selectedRecord.recordId, requestData).then(() => {
          this.$modal.msgSuccess(finalize ? "批改已提交" : "批改已保存")
          return Promise.all([this.getOverview(), this.getRecordList()])
        }).then(() => {
          if (finalize) {
            this.reviewOpen = false
          } else {
            return getExamReviewDetail(this.selectedRecord.recordId).then(response => {
              this.reviewDetail = response.data || { questionList: [] }
            })
          }
        }).finally(() => {
          this.reviewSubmitting = false
        })
      }
      if (finalize) {
        this.$modal.confirm("确认提交本次批改吗？提交后学生将看到更新后的考试结果。").then(() => {
          return doSubmit()
        }).catch(() => {})
        return
      }
      doSubmit()
    },
    canOpenReview(row) {
      return ["2", "3"].includes(String(row.recordStatus))
    },
    needsReview(row) {
      return String(row.recordStatus) === "2" && String(row.checkedFlag) === "0"
    },
    canEditQuestion(question) {
      return String(question.autoMarking) !== "1"
    },
    formatScore(value) {
      return Number(value || 0).toFixed(1)
    },
    formatQuestionScore(value) {
      if (value === null || value === undefined || value === "") {
        return "-"
      }
      return this.formatScore(value)
    },
    toScore(value) {
      return Number(value || 0)
    },
    formatRate(value) {
      return `${Number(value || 0).toFixed(0)}%`
    },
    getRecordStatusText(value) {
      const option = this.recordStatusOptions.find(item => item.value === String(value))
      return option ? option.label : "未知"
    },
    getRecordStatusTag(value) {
      const tagMap = {
        "0": "info",
        "1": "warning",
        "2": "",
        "3": "success"
      }
      return tagMap[String(value)] || "info"
    },
    getReviewStatusText(row) {
      if (String(row.recordStatus) === "1") {
        return "未交卷"
      }
      if (String(row.recordStatus) === "3" || String(row.checkedFlag) === "1") {
        return "已完成"
      }
      if (String(row.recordStatus) === "2") {
        return "待批改"
      }
      return "未开始"
    },
    getReviewStatusTag(row) {
      if (String(row.recordStatus) === "3" || String(row.checkedFlag) === "1") {
        return "success"
      }
      if (String(row.recordStatus) === "2") {
        return "warning"
      }
      return "info"
    },
    getQuestionTypeText(type) {
      const map = {
        "1": "单选题",
        "2": "多选题",
        "3": "判断题",
        "4": "填空题",
        "5": "简答题"
      }
      return map[String(type)] || "题目"
    },
    getQuestionTagType(type) {
      const map = {
        "1": "",
        "2": "warning",
        "3": "success",
        "4": "info",
        "5": "danger"
      }
      return map[String(type)] || "info"
    },
    getExamStatusText(value) {
      const option = this.examStatusOptions.find(item => item.value === String(value))
      return option ? option.label : "未知"
    },
    getExamStatusTag(value) {
      const map = {
        "0": "info",
        "1": "success",
        "2": "warning"
      }
      return map[String(value)] || "info"
    },
    formatAnswer(value) {
      if (!value) {
        return "未作答"
      }
      const raw = String(value).trim()
      if (raw.startsWith("[")) {
        try {
          return JSON.parse(raw).join("、")
        } catch (error) {
          return raw
        }
      }
      return raw
    },
    getAttachmentUrl(url) {
      if (!url) {
        return ""
      }
      if (/^(https?:)?\/\//.test(url)) {
        return url
      }
      const base = process.env.VUE_APP_BASE_API || ""
      return `${base}${url.startsWith("/") ? "" : "/"}${url}`
    },
    goBackExamManage() {
      this.$router.push({
        path: `/teaching/exam/${this.paperId || ""}`,
        query: {
          paperName: this.$route.query.paperName,
          bankId: this.bankId,
          bankName: this.bankName
        }
      })
    },
    handleExport() {
      this.download("/edu/exam/stat/record/export", {
        ...this.queryParams
      }, `exam-score-${this.examId || "list"}.xlsx`)
    }
  }
}
</script>

<style lang="scss" scoped>
.teaching-score-page {
  min-height: 100vh;
  background: #f6f8fc;
}

.score-page-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 16px;
  padding: 20px 24px;
  border: 1px solid #e2e8f0;
  border-radius: 14px;
  background: #fff;
}

.score-page-header__main {
  display: flex;
  align-items: flex-start;
  gap: 16px;
}

.score-page-header__main h1 {
  margin: 0;
  color: #0f172a;
  font-size: 28px;
  font-weight: 700;
}

.score-page-header__main p {
  margin: 8px 0 0;
  color: #475569;
}

.score-page-header__meta {
  display: grid;
  gap: 8px;
  color: #64748b;
  font-size: 13px;
  text-align: right;
}

.score-selector-card,
.score-workspace {
  border: 1px solid #e2e8f0;
  border-radius: 14px;
}

.score-selector-card {
  margin-bottom: 16px;
}

.score-selector-card__head {
  margin-bottom: 16px;
}

.score-selector-card__head strong {
  display: block;
  color: #0f172a;
  font-size: 18px;
}

.score-selector-card__head span {
  display: block;
  margin-top: 8px;
  color: #64748b;
  line-height: 1.7;
}

.score-selector-form {
  margin-bottom: 8px;
}

.score-overview {
  margin-bottom: 16px;
}

.score-overview-card {
  display: grid;
  gap: 8px;
  height: 100%;
  padding: 18px 20px;
  border: 1px solid #e2e8f0;
  border-radius: 14px;
  background: #fff;
}

.score-overview-card span,
.score-overview-card small {
  color: #64748b;
}

.score-overview-card strong {
  color: #0f172a;
  font-size: 30px;
  line-height: 1;
}

.score-pending-alert,
.score-workspace {
  margin-bottom: 16px;
}

.score-query-form {
  margin-bottom: 4px;
}

.score-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
}

.score-toolbar__actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.score-toolbar__hint {
  color: #64748b;
  line-height: 1.6;
}

.score-insight-strip {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-bottom: 14px;
}

.score-insight-chip {
  display: flex;
  align-items: baseline;
  gap: 10px;
  padding: 10px 14px;
  border-radius: 999px;
  background: #f8fafc;
  color: #475569;
}

.score-insight-chip strong {
  color: #0f172a;
  font-size: 18px;
}

.review-dialog-body {
  max-height: 72vh;
  overflow-y: auto;
  padding-right: 4px;
}

.review-summary,
.review-metrics,
.review-question-card {
  border: 1px solid #e2e8f0;
  border-radius: 14px;
  background: #fff;
}

.review-summary {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 16px;
  padding: 18px 20px;
}

.review-summary__main {
  display: grid;
  gap: 6px;
}

.review-summary__main strong {
  color: #0f172a;
  font-size: 18px;
}

.review-summary__main span,
.review-summary__meta span {
  color: #64748b;
}

.review-summary__meta {
  display: grid;
  gap: 8px;
  text-align: right;
  font-size: 13px;
}

.review-metrics {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 0;
  margin-bottom: 16px;
  overflow: hidden;
}

.review-metric-card {
  padding: 16px 18px;
}

.review-metric-card + .review-metric-card {
  border-left: 1px solid #e2e8f0;
}

.review-metric-card span {
  color: #64748b;
  display: block;
  margin-bottom: 8px;
}

.review-metric-card strong {
  color: #0f172a;
  font-size: 24px;
}

.review-inline-alert {
  margin-bottom: 16px;
}

.review-question-list {
  display: grid;
  gap: 16px;
}

.review-question-card {
  padding: 20px;
}

.review-question-card__head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.review-question-card__title {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 8px;
  color: #475569;
}

.review-question-card__head strong {
  color: #0f172a;
  font-size: 18px;
}

.review-question-card h3 {
  margin: 14px 0 0;
  color: #0f172a;
  font-size: 18px;
  line-height: 1.6;
}

.review-question-card__attachment {
  margin-top: 12px;
  color: #475569;
}

.review-question-card__attachment a {
  color: #2563eb;
}

.review-question-card__options {
  display: grid;
  gap: 10px;
  margin-top: 16px;
}

.review-option {
  display: grid;
  grid-template-columns: 28px 1fr;
  gap: 10px;
  padding: 12px 14px;
  border-radius: 12px;
  background: #f8fafc;
  color: #334155;
}

.review-question-card__grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 16px;
  margin-top: 16px;
}

.review-field {
  padding: 14px 16px;
  border-radius: 12px;
  background: #f8fafc;
}

.review-field label {
  display: block;
  margin-bottom: 8px;
  color: #475569;
  font-size: 13px;
  font-weight: 600;
}

.review-field div {
  color: #0f172a;
  line-height: 1.7;
  white-space: pre-wrap;
  word-break: break-word;
}

.review-field--full {
  margin-top: 16px;
}

.review-editor {
  margin-top: 16px;
  padding: 16px;
  border-radius: 12px;
  background: #f8fafc;
}

.review-editor__hint {
  margin-left: 12px;
  color: #64748b;
  font-size: 13px;
}

@media screen and (max-width: 960px) {
  .score-page-header,
  .score-page-header__main,
  .score-toolbar,
  .score-toolbar__actions,
  .review-summary {
    flex-direction: column;
    align-items: flex-start;
  }

  .score-page-header__meta,
  .review-summary__meta {
    text-align: left;
  }

  .review-metrics,
  .review-question-card__grid {
    grid-template-columns: 1fr;
  }

  .review-metric-card + .review-metric-card {
    border-left: 0;
    border-top: 1px solid #e2e8f0;
  }
}
</style>
