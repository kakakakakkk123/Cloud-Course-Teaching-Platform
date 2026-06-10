<template>
  <div v-loading="loading" class="app-container my-exam-page">
    <el-card shadow="never" class="exam-toolbar">
      <div class="toolbar-title">
        <div class="page-title">我的考试</div>
        <div class="page-desc">查看已注册课程下教师发布的考试，完成考试后可查看提交状态与成绩。</div>
      </div>
      <el-radio-group v-model="query.status" size="small" @change="getList">
        <el-radio-button label="">全部</el-radio-button>
        <el-radio-button label="todo">待完成</el-radio-button>
        <el-radio-button label="done">已完成</el-radio-button>
      </el-radio-group>
    </el-card>

    <el-row :gutter="16" class="overview-row">
      <el-col :xs="12" :sm="6">
        <el-card shadow="never" class="stat-card">
          <div class="stat-value">{{ examList.length }}</div>
          <div class="stat-label">考试总数</div>
        </el-card>
      </el-col>
      <el-col :xs="12" :sm="6">
        <el-card shadow="never" class="stat-card">
          <div class="stat-value">{{ todoCount }}</div>
          <div class="stat-label">待完成</div>
        </el-card>
      </el-col>
      <el-col :xs="12" :sm="6">
        <el-card shadow="never" class="stat-card">
          <div class="stat-value">{{ doneCount }}</div>
          <div class="stat-label">已提交</div>
        </el-card>
      </el-col>
      <el-col :xs="12" :sm="6">
        <el-card shadow="never" class="stat-card">
          <div class="stat-value">{{ passCount }}</div>
          <div class="stat-label">已及格</div>
        </el-card>
      </el-col>
    </el-row>

    <el-card shadow="never">
      <el-table :data="examList" border>
        <el-table-column prop="examName" label="考试名称" min-width="190" show-overflow-tooltip />
        <el-table-column prop="courseName" label="所属课程" min-width="170" show-overflow-tooltip />
        <el-table-column prop="paperName" label="试卷" min-width="150" show-overflow-tooltip />
        <el-table-column label="考试时间" min-width="230">
          <template slot-scope="scope">
            <div>{{ parseTime(scope.row.startTime) || "不限开始时间" }}</div>
            <div class="muted">至 {{ parseTime(scope.row.endTime) || "不限结束时间" }}</div>
          </template>
        </el-table-column>
        <el-table-column label="成绩" width="120" align="center">
          <template slot-scope="scope">
            <span v-if="canShowScore(scope.row)">{{ scope.row.studentScore || 0 }} / {{ scope.row.totalScore || 0 }}</span>
            <span v-else class="muted">暂未公布</span>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="110" align="center">
          <template slot-scope="scope">
            <el-tag :type="getStatusTag(scope.row)">{{ getStatusText(scope.row) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="310" align="center" fixed="right">
          <template slot-scope="scope">
            <el-button
              v-if="canStart(scope.row)"
              type="primary"
              size="mini"
              @click="handleStart(scope.row)"
            >开始考试</el-button>
            <el-button
              v-if="canContinue(scope.row)"
              type="primary"
              size="mini"
              @click="openExamContent(scope.row.recordId)"
            >继续考试</el-button>
            <el-button
              v-if="scope.row.recordStatus === '1'"
              type="success"
              size="mini"
              @click="handleSubmit(scope.row)"
            >提交考试</el-button>
            <el-button
              v-if="canImportWrongQuestions(scope.row)"
              type="warning"
              size="mini"
              :loading="wrongImportingRecordId === scope.row.recordId"
              @click="handleImportWrongQuestions(scope.row)"
            >导入错题</el-button>
            <el-button size="mini" @click="handleView(scope.row)">查看</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog title="考试信息" :visible.sync="detailOpen" width="620px" append-to-body>
      <el-descriptions :column="1" border>
        <el-descriptions-item label="考试名称">{{ detail.examName }}</el-descriptions-item>
        <el-descriptions-item label="所属课程">{{ detail.courseName || "未关联课程" }}</el-descriptions-item>
        <el-descriptions-item label="考试时长">{{ detail.durationMinutes || 0 }} 分钟</el-descriptions-item>
        <el-descriptions-item label="及格分">{{ detail.passScore || 0 }} / {{ detail.totalScore || 0 }}</el-descriptions-item>
        <el-descriptions-item label="考试说明">{{ detail.examNotice || "暂无说明" }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer">
        <el-button
          v-if="canImportWrongQuestions(detail)"
          type="warning"
          :loading="wrongImportingRecordId === detail.recordId"
          @click="handleImportWrongQuestions(detail)"
        >一键导入错题</el-button>
        <el-button @click="detailOpen = false">关闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listMyExams, startStudentExam, submitStudentExam, importExamWrongQuestions } from "@/api/learning"

export default {
  name: "MyExam",
  data() {
    return {
      loading: false,
      detailOpen: false,
      detail: {},
      wrongImportingRecordId: undefined,
      query: {
        status: ""
      },
      examList: []
    }
  },
  computed: {
    todoCount() {
      return this.examList.filter(item => !["2", "3"].includes(String(item.recordStatus))).length
    },
    doneCount() {
      return this.examList.filter(item => ["2", "3"].includes(String(item.recordStatus))).length
    },
    passCount() {
      return this.examList.filter(item => String(item.resultStatus) === "1").length
    }
  },
  created() {
    if (this.$route.query.examId) {
      this.query.status = ""
    }
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
        if (record.recordId) {
          this.openExamContent(record.recordId)
          return
        }
        this.getList()
      })
    },
    openExamContent(recordId) {
      this.$router.push(`/learning/exam/take/${recordId}`)
    },
    handleSubmit(row) {
      this.$modal.confirm("确认提交当前考试记录吗？").then(() => {
        return submitStudentExam(row.recordId)
      }).then(() => {
        this.$modal.msgSuccess("提交成功")
        this.getList()
      }).catch(() => {})
    },
    handleView(row) {
      this.detail = row
      this.detailOpen = true
    },
    handleImportWrongQuestions(row) {
      if (!row || !row.recordId) {
        this.$modal.msgWarning("请先完成考试后再导入错题")
        return
      }
      this.wrongImportingRecordId = row.recordId
      importExamWrongQuestions(row.recordId).then(res => {
        this.$modal.msgSuccess(res.msg || "导入成功")
      }).finally(() => {
        this.wrongImportingRecordId = undefined
      })
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
    canContinue(row) {
      return row && row.recordId && String(row.recordStatus) === "1"
    },
    canShowScore(row) {
      return ["2", "3"].includes(String(row.recordStatus)) && String(row.showScoreAfterSubmit) === "1"
    },
    canImportWrongQuestions(row) {
      return row && row.recordId && ["2", "3"].includes(String(row.recordStatus))
    },
    getStatusText(row) {
      if (row.recordStatus === "1") {
        return "进行中"
      }
      if (["2", "3"].includes(String(row.recordStatus))) {
        return row.checkedFlag === "1" ? "已批改" : "已提交"
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
      const text = this.getStatusText(row)
      const map = {
        "进行中": "warning",
        "已批改": "success",
        "已提交": "info",
        "已结束": "danger",
        "未开始": "info",
        "待考试": "primary"
      }
      return map[text] || "info"
    }
  }
}
</script>

<style lang="scss" scoped>
.my-exam-page {
  background: #f6f8fb;
}

.exam-toolbar {
  margin-bottom: 16px;
}

.exam-toolbar ::v-deep .el-card__body {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.page-title {
  color: #0f172a;
  font-size: 20px;
  font-weight: 700;
}

.page-desc,
.muted {
  color: #64748b;
}

.page-desc {
  margin-top: 6px;
  font-size: 13px;
}

.overview-row {
  margin-bottom: 16px;
}

.stat-card {
  margin-bottom: 12px;
}

.stat-value {
  color: #0f172a;
  font-size: 28px;
  font-weight: 700;
}

.stat-label {
  margin-top: 4px;
  color: #64748b;
  font-size: 13px;
}

@media screen and (max-width: 768px) {
  .exam-toolbar ::v-deep .el-card__body {
    align-items: flex-start;
    flex-direction: column;
  }
}
</style>
