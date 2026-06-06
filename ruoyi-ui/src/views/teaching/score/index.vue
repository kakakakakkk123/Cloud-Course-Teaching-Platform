<template>
  <div class="app-container teaching-score-page">
    <el-card shadow="never" class="teaching-score-card">
      <div slot="header" class="teaching-score-card__header">
        <div class="teaching-score-card__back">
          <el-button plain icon="el-icon-arrow-left" @click="goBackExamManage">返回考试发布</el-button>
        </div>
        <div class="teaching-score-card__meta">
          <div class="teaching-score-card__title">成绩统计</div>
          <div class="teaching-score-card__desc">
            当前考试：{{ currentExamName }}
          </div>
        </div>
      </div>

      <div class="score-banner">
        <div class="score-banner__main">
          <strong>{{ currentExamName }}</strong>
          <span>在这里查看考试完成情况、平均分、及格率与学生作答记录，后续还可以继续接入每题正确率和主观题批阅能力。</span>
        </div>
        <div class="score-banner__meta">
          <span>考试编号 {{ examId || "-" }}</span>
          <span>试卷编号 {{ paperId || "-" }}</span>
        </div>
      </div>

      <el-alert
        v-if="interfacePending"
        title="成绩统计后端接口尚未完全接入，当前页面和 API 骨架已准备好，可先用于前端联调和后续接口对接。"
        type="warning"
        :closable="false"
        show-icon
        class="mb16"
      />

      <el-row :gutter="16" class="mb16">
        <el-col :xs="24" :sm="12" :lg="6" v-for="card in overviewCards" :key="card.title">
          <div class="score-stat-card">
            <div class="score-stat-card__title">{{ card.title }}</div>
            <div class="score-stat-card__value">{{ card.value }}</div>
          </div>
        </el-col>
      </el-row>

      <el-form
        v-show="showSearch"
        ref="queryForm"
        :model="queryParams"
        :inline="true"
        size="small"
        label-width="84px"
        class="query-form"
      >
        <el-form-item label="学生账号" prop="studentKeyword">
          <el-input
            v-model.trim="queryParams.studentKeyword"
            placeholder="请输入学生账号或姓名"
            clearable
            style="width: 220px"
            @keyup.enter.native="handleQuery"
          />
        </el-form-item>
        <el-form-item label="作答状态" prop="recordStatus">
          <el-select
            v-model="queryParams.recordStatus"
            placeholder="请选择作答状态"
            clearable
            style="width: 180px"
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
            placeholder="请选择成绩结果"
            clearable
            style="width: 180px"
          >
            <el-option
              v-for="item in resultStatusOptions"
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
          <el-button type="primary" plain icon="el-icon-download" size="mini" @click="handleExport">导出成绩</el-button>
        </el-col>
        <right-toolbar :showSearch.sync="showSearch" @queryTable="getRecordList" />
      </el-row>

      <el-table v-loading="loading" :data="recordList">
        <el-table-column label="学生账号" prop="studentUserName" min-width="140" />
        <el-table-column label="学生姓名" prop="studentName" min-width="120" />
        <el-table-column label="作答状态" width="110" align="center">
          <template slot-scope="scope">
            <el-tag size="mini" :type="getRecordStatusTag(scope.row.recordStatus)">
              {{ getRecordStatusText(scope.row.recordStatus) }}
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
        <el-table-column label="客观题得分" prop="objectiveScore" width="110" align="center" />
        <el-table-column label="主观题得分" prop="subjectiveScore" width="110" align="center" />
        <el-table-column label="总分" prop="totalScore" width="90" align="center" />
        <el-table-column label="结果" width="90" align="center">
          <template slot-scope="scope">
            <el-tag size="mini" :type="scope.row.resultStatus === '1' ? 'success' : 'info'">
              {{ scope.row.resultStatus === "1" ? "及格" : "未及格" }}
            </el-tag>
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
  </div>
</template>

<script>
import { getExamStatOverview, listExamStatRecord } from "@/api/edu/examStat"

export default {
  name: "TeachingScore",
  data() {
    return {
      loading: false,
      showSearch: true,
      interfacePending: false,
      total: 0,
      recordList: [],
      overview: {
        participantCount: 0,
        submittedCount: 0,
        averageScore: 0,
        passRate: 0,
        highestScore: 0,
        pendingReviewCount: 0
      },
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        examId: undefined,
        studentKeyword: "",
        recordStatus: undefined,
        resultStatus: undefined
      },
      recordStatusOptions: [
        { label: "未开始", value: "0" },
        { label: "作答中", value: "1" },
        { label: "已提交", value: "2" },
        { label: "已批阅", value: "3" }
      ],
      resultStatusOptions: [
        { label: "及格", value: "1" },
        { label: "未及格", value: "0" }
      ]
    }
  },
  computed: {
    /** 当前考试编号 */
    examId() {
      return this.$route.params.examId
    },
    /** 当前试卷编号 */
    paperId() {
      return this.$route.query.paperId
    },
    /** 当前考试名称 */
    currentExamName() {
      return this.$route.query.examName || "未命名考试"
    },
    /** 当前题库编号 */
    bankId() {
      return this.$route.query.bankId
    },
    /** 当前题库名称 */
    bankName() {
      return this.$route.query.bankName || "未命名题库"
    },
    /** 统计卡片 */
    overviewCards() {
      return [
        { title: "应参加人数", value: this.overview.participantCount || 0 },
        { title: "已提交人数", value: this.overview.submittedCount || 0 },
        { title: "平均分", value: this.formatScore(this.overview.averageScore) },
        { title: "及格率", value: this.formatRate(this.overview.passRate) },
        { title: "最高分", value: this.formatScore(this.overview.highestScore) },
        { title: "待批阅", value: this.overview.pendingReviewCount || 0 }
      ]
    }
  },
  created() {
    this.queryParams.examId = this.examId
    this.getOverview()
    this.getRecordList()
  },
  methods: {
    /** 查询成绩概览 */
    getOverview() {
      if (!this.examId) {
        return
      }
      getExamStatOverview(this.examId).then(response => {
        this.overview = Object.assign({}, this.overview, response.data || {})
        this.interfacePending = false
      }).catch(() => {
        this.interfacePending = true
      })
    },
    /** 查询成绩记录列表 */
    getRecordList() {
      if (!this.examId) {
        this.recordList = []
        this.total = 0
        return
      }
      this.loading = true
      listExamStatRecord(this.queryParams).then(response => {
        this.recordList = response.rows || []
        this.total = response.total || 0
        this.interfacePending = false
      }).catch(() => {
        this.recordList = []
        this.total = 0
        this.interfacePending = true
      }).finally(() => {
        this.loading = false
      })
    },
    /** 格式化分数 */
    formatScore(value) {
      return Number(value || 0).toFixed(1)
    },
    /** 格式化比例 */
    formatRate(value) {
      return `${Number(value || 0).toFixed(0)}%`
    },
    /** 获取作答状态文案 */
    getRecordStatusText(value) {
      const option = this.recordStatusOptions.find(item => item.value === String(value))
      return option ? option.label : "未知"
    },
    /** 获取作答状态标签样式 */
    getRecordStatusTag(value) {
      const tagMap = {
        "0": "info",
        "1": "warning",
        "2": "success",
        "3": "success"
      }
      return tagMap[String(value)] || "info"
    },
    /** 搜索成绩记录 */
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getRecordList()
    },
    /** 重置查询 */
    resetQuery() {
      this.resetForm("queryForm")
      this.queryParams.examId = this.examId
      this.handleQuery()
    },
    /** 返回考试发布 */
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
    /** 导出成绩 */
    handleExport() {
      this.$modal.msgSuccess("成绩导出能力将在后续联调后接入。")
    }
  }
}
</script>

<style lang="scss" scoped>
.teaching-score-page {
  min-height: 100vh;
}

.teaching-score-card {
  border-radius: 24px;
  border: 1px solid rgba(148, 163, 184, 0.12);
  background: rgba(255, 255, 255, 0.82);
  box-shadow: 0 18px 38px rgba(15, 23, 42, 0.06);
  backdrop-filter: blur(14px);
}

.teaching-score-card__header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 18px;
}

.teaching-score-card__title {
  color: #0f172a;
  font-size: 22px;
  font-weight: 700;
}

.teaching-score-card__desc {
  margin-top: 8px;
  color: #64748b;
  line-height: 1.7;
}

.score-banner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 18px;
  padding: 18px 20px;
  border-radius: 20px;
  background: linear-gradient(135deg, #eff6ff, #f8fafc);
}

.score-banner__main strong {
  display: block;
  color: #0f172a;
  font-size: 18px;
}

.score-banner__main span,
.score-banner__meta span {
  color: #64748b;
}

.score-banner__main span {
  display: block;
  margin-top: 8px;
  line-height: 1.8;
}

.score-banner__meta {
  display: grid;
  gap: 8px;
  flex-shrink: 0;
  text-align: right;
  font-size: 13px;
}

.score-stat-card {
  height: 100%;
  padding: 18px 20px;
  border-radius: 20px;
  border: 1px solid rgba(148, 163, 184, 0.12);
  background: rgba(255, 255, 255, 0.82);
  box-shadow: 0 18px 38px rgba(15, 23, 42, 0.06);
}

.score-stat-card__title {
  color: #64748b;
  margin-bottom: 10px;
}

.score-stat-card__value {
  font-size: 28px;
  font-weight: 700;
  color: #0f172a;
}

.mb16 {
  margin-bottom: 16px;
}

@media screen and (max-width: 960px) {
  .teaching-score-card__header,
  .score-banner {
    flex-direction: column;
    align-items: flex-start;
  }

  .score-banner__meta {
    text-align: left;
  }
}
</style>
