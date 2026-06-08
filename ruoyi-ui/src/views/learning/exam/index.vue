<template>
  <div v-loading="loading" class="app-container my-exam-page">
    <section class="my-exam-hero">
      <div>
        <p class="my-exam-hero__kicker">我的考试</p>
        <h1>按课程完成考试任务</h1>
        <p class="my-exam-hero__summary">查看老师已发布的考试，继续进行中的作答，或回看已经提交的结果。</p>
      </div>
      <el-radio-group v-model="query.status" size="small" @change="getList">
        <el-radio-button label="">全部</el-radio-button>
        <el-radio-button label="todo">待完成</el-radio-button>
        <el-radio-button label="done">已提交</el-radio-button>
      </el-radio-group>
    </section>

    <section class="my-exam-metrics">
      <article class="metric-card">
        <span>考试总数</span>
        <strong>{{ examList.length }}</strong>
      </article>
      <article class="metric-card">
        <span>待参加</span>
        <strong>{{ todoCount }}</strong>
      </article>
      <article class="metric-card">
        <span>进行中</span>
        <strong>{{ runningCount }}</strong>
      </article>
      <article class="metric-card">
        <span>已提交</span>
        <strong>{{ doneCount }}</strong>
      </article>
    </section>

    <el-card shadow="never" class="my-exam-table-card">
      <el-table :data="examList" border>
        <el-table-column prop="examName" label="考试名称" min-width="210" show-overflow-tooltip />
        <el-table-column prop="courseName" label="所属课程" min-width="180" show-overflow-tooltip />
        <el-table-column prop="paperName" label="试卷" min-width="150" show-overflow-tooltip />
        <el-table-column label="考试时间" min-width="220">
          <template slot-scope="scope">
            <div>{{ parseTime(scope.row.startTime) || "不限开始时间" }}</div>
            <div class="muted">至 {{ parseTime(scope.row.endTime) || "不限结束时间" }}</div>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="120" align="center">
          <template slot-scope="scope">
            <el-tag :type="getStatusTag(scope.row)">{{ getStatusText(scope.row) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="成绩" width="130" align="center">
          <template slot-scope="scope">
            <span v-if="canShowScore(scope.row)">{{ scope.row.studentScore || 0 }} / {{ scope.row.totalScore || 0 }}</span>
            <span v-else class="muted">待公布</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="260" align="center" fixed="right">
          <template slot-scope="scope">
            <el-button
              v-if="canStart(scope.row)"
              type="primary"
              size="mini"
              @click="handleStart(scope.row)"
            >开始考试</el-button>
            <el-button
              v-else-if="scope.row.recordStatus === '1'"
              type="warning"
              size="mini"
              @click="goAnswer(scope.row.recordId)"
            >继续作答</el-button>
            <el-button
              v-else-if="['2', '3'].includes(String(scope.row.recordStatus))"
              type="success"
              size="mini"
              @click="goResult(scope.row.recordId)"
            >查看结果</el-button>
            <el-button size="mini" @click="handleView(scope.row)">查看详情</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog title="考试信息" :visible.sync="detailOpen" width="620px" append-to-body>
      <el-descriptions :column="1" border>
        <el-descriptions-item label="考试名称">{{ detail.examName }}</el-descriptions-item>
        <el-descriptions-item label="所属课程">{{ detail.courseName || "未关联课程" }}</el-descriptions-item>
        <el-descriptions-item label="考试时长">{{ detail.durationMinutes || 0 }} 分钟</el-descriptions-item>
        <el-descriptions-item label="作答次数">{{ detail.attemptCount || 0 }} / {{ detail.maxAttemptCount || 1 }}</el-descriptions-item>
        <el-descriptions-item label="考试说明">{{ detail.examNotice || "暂无说明" }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer">
        <el-button @click="detailOpen = false">关闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listMyExams, startStudentExam } from "@/api/learning"

export default {
  name: "MyExam",
  data() {
    return {
      loading: false,
      detailOpen: false,
      detail: {},
      query: {
        status: ""
      },
      examList: []
    }
  },
  computed: {
    todoCount() {
      return this.examList.filter(item => this.getStatusText(item) === "待考试").length
    },
    runningCount() {
      return this.examList.filter(item => item.recordStatus === "1").length
    },
    doneCount() {
      return this.examList.filter(item => ["2", "3"].includes(String(item.recordStatus))).length
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      listMyExams(this.query).then(res => {
        const list = res.data || []
        const examId = this.$route.query.examId
        this.examList = examId
          ? list.slice().sort((a, b) => String(a.examId) === String(examId) ? -1 : String(b.examId) === String(examId) ? 1 : 0)
          : list
      }).finally(() => {
        this.loading = false
      })
    },
    handleStart(row) {
      startStudentExam(row.examId).then(res => {
        const record = res.data || {}
        this.$modal.msgSuccess("考试已开始")
        this.goAnswer(record.recordId)
      })
    },
    goAnswer(recordId) {
      this.$router.push(`/learning/exam/answer/${recordId}`)
    },
    goResult(recordId) {
      this.$router.push(`/learning/exam/result/${recordId}`)
    },
    handleView(row) {
      this.detail = row
      this.detailOpen = true
    },
    canStart(row) {
      if (row.recordStatus === "1" || ["2", "3"].includes(String(row.recordStatus))) {
        return false
      }
      if (Number(row.attemptCount || 0) >= Number(row.maxAttemptCount || 1)) {
        return false
      }
      const now = Date.now()
      const start = row.startTime ? new Date(row.startTime).getTime() : 0
      const end = row.endTime ? new Date(row.endTime).getTime() : 0
      return (!start || now >= start) && (!end || now <= end)
    },
    canShowScore(row) {
      return ["2", "3"].includes(String(row.recordStatus)) && String(row.showScoreAfterSubmit) === "1"
    },
    getStatusText(row) {
      if (row.recordStatus === "1") {
        return "进行中"
      }
      if (["2", "3"].includes(String(row.recordStatus))) {
        return row.checkedFlag === "1" ? "已完成" : "待批改"
      }
      const now = Date.now()
      const start = row.startTime ? new Date(row.startTime).getTime() : 0
      const end = row.endTime ? new Date(row.endTime).getTime() : 0
      if (start && now < start) {
        return "未开始"
      }
      if (end && now > end) {
        return "已结束"
      }
      return "待考试"
    },
    getStatusTag(row) {
      const map = {
        "进行中": "warning",
        "已完成": "success",
        "待批改": "info",
        "已结束": "danger",
        "未开始": "info",
        "待考试": "primary"
      }
      return map[this.getStatusText(row)] || "info"
    }
  }
}
</script>

<style lang="scss" scoped>
.my-exam-page {
  min-height: 100vh;
  background: #f4f7fb;
}

.my-exam-hero,
.metric-card,
.my-exam-table-card {
  border: 1px solid rgba(226, 232, 240, 0.96);
  border-radius: 18px;
  background: #fff;
}

.my-exam-hero {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 18px;
  padding: 24px;
}

.my-exam-hero__kicker {
  margin: 0 0 8px;
  color: #2563eb;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.08em;
}

.my-exam-hero h1 {
  margin: 0;
  color: #0f172a;
  font-size: 28px;
}

.my-exam-hero__summary,
.muted {
  color: #64748b;
}

.my-exam-hero__summary {
  max-width: 60ch;
  margin: 12px 0 0;
  line-height: 1.8;
}

.my-exam-metrics {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
  margin-bottom: 18px;
}

.metric-card {
  padding: 18px 20px;
}

.metric-card span {
  display: block;
  color: #64748b;
  font-size: 13px;
}

.metric-card strong {
  display: block;
  margin-top: 8px;
  color: #0f172a;
  font-size: 28px;
}

@media (max-width: 900px) {
  .my-exam-metrics {
    grid-template-columns: 1fr 1fr;
  }
}

@media (max-width: 768px) {
  .my-exam-hero {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
