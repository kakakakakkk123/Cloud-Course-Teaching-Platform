<template>
  <div v-loading="loading" class="exam-result-page">
    <div class="exam-result-shell">
      <section class="exam-result-hero">
        <div>
          <p class="exam-result-hero__kicker">考试结果</p>
          <h1>{{ result.examName || "考试结果" }}</h1>
          <p class="exam-result-hero__summary">
            <span>{{ result.courseName || "-" }}</span>
            <span>提交时间：{{ parseTime(result.submitTime) || "-" }}</span>
          </p>
        </div>
        <div class="exam-result-hero__actions">
          <el-button plain @click="$router.push('/learning/exam')">返回我的考试</el-button>
          <el-button type="primary" @click="$router.push('/learning/my-course')">返回学习中心</el-button>
        </div>
      </section>

      <section class="exam-result-summary">
        <div class="result-metric-card">
          <span>总分</span>
          <strong v-if="canShowScore">{{ result.totalScore || 0 }}</strong>
          <strong v-else>待公布</strong>
        </div>
        <div class="result-metric-card">
          <span>及格线</span>
          <strong>{{ result.passScore || 0 }}</strong>
        </div>
        <div class="result-metric-card">
          <span>状态</span>
          <strong>{{ statusText }}</strong>
        </div>
        <div class="result-metric-card">
          <span>耗时</span>
          <strong>{{ formatDuration(result.durationSeconds) }}</strong>
        </div>
      </section>

      <el-alert
        v-if="result.checkedFlag !== '1'"
        title="当前考试仍有待教师批改的题目，结果页展示的是已自动判分部分。"
        type="warning"
        :closable="false"
        show-icon
        class="exam-result-alert"
      />

      <section class="exam-result-list">
        <article
          v-for="(question, index) in result.questionList || []"
          :key="question.questionId"
          class="result-question-card"
        >
          <div class="result-question-card__head">
            <div>
              <span class="result-question-card__index">第 {{ index + 1 }} 题</span>
              <el-tag size="mini" :type="getQuestionTagType(question.questionType)">{{ getQuestionTypeText(question.questionType) }}</el-tag>
            </div>
            <span class="result-question-card__score" v-if="canShowScore">
              {{ question.actualScore == null ? "-" : question.actualScore }} / {{ question.questionScore || 0 }}
            </span>
          </div>

          <h2>{{ question.questionTitle }}</h2>

          <div class="result-question-card__block">
            <label>你的答案</label>
            <div>{{ formatAnswer(question.studentAnswer) }}</div>
          </div>

          <div v-if="showAnswerDetail" class="result-question-card__block">
            <label>标准答案</label>
            <div>{{ formatAnswer(question.standardAnswer) }}</div>
          </div>

          <div v-if="showAnswerDetail && question.analysisSnapshot" class="result-question-card__block">
            <label>答案解析</label>
            <div>{{ question.analysisSnapshot }}</div>
          </div>
        </article>
      </section>
    </div>
  </div>
</template>

<script>
import { getStudentExamResult } from "@/api/learning"

export default {
  name: "StudentExamResult",
  data() {
    return {
      loading: false,
      result: {}
    }
  },
  computed: {
    recordId() {
      return this.$route.params.recordId
    },
    canShowScore() {
      return String(this.result.showScoreAfterSubmit) === "1"
    },
    showAnswerDetail() {
      return String(this.result.showAnswerAfterSubmit) === "1"
    },
    statusText() {
      if (this.result.recordStatus === "3") {
        return "已完成批改"
      }
      if (this.result.recordStatus === "2") {
        return this.result.checkedFlag === "1" ? "已提交" : "待批改"
      }
      return "处理中"
    }
  },
  created() {
    this.getResult()
  },
  methods: {
    getResult() {
      this.loading = true
      getStudentExamResult(this.recordId).then(res => {
        this.result = res.data || {}
      }).finally(() => {
        this.loading = false
      })
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
    formatDuration(seconds) {
      const total = Number(seconds || 0)
      if (!total) {
        return "-"
      }
      const minute = Math.floor(total / 60)
      const second = total % 60
      return `${minute} 分 ${second} 秒`
    }
  }
}
</script>

<style lang="scss" scoped>
.exam-result-page {
  min-height: 100vh;
  padding: 24px 20px 40px;
  background: #f4f7fb;
}

.exam-result-shell {
  max-width: 1240px;
  margin: 0 auto;
}

.exam-result-hero,
.result-metric-card,
.result-question-card {
  border: 1px solid rgba(226, 232, 240, 0.96);
  border-radius: 18px;
  background: #fff;
}

.exam-result-hero {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 18px;
  padding: 24px;
}

.exam-result-hero__kicker {
  margin: 0 0 8px;
  color: #2563eb;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.08em;
}

.exam-result-hero h1 {
  margin: 0;
  color: #0f172a;
  font-size: 28px;
}

.exam-result-hero__summary {
  display: flex;
  flex-wrap: wrap;
  gap: 10px 16px;
  margin: 12px 0 0;
  color: #64748b;
}

.exam-result-hero__actions {
  display: flex;
  gap: 10px;
}

.exam-result-summary {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}

.result-metric-card {
  padding: 18px 20px;
}

.result-metric-card span {
  display: block;
  color: #64748b;
  font-size: 13px;
}

.result-metric-card strong {
  display: block;
  margin-top: 8px;
  color: #0f172a;
  font-size: 28px;
}

.exam-result-alert {
  margin-top: 18px;
}

.exam-result-list {
  display: grid;
  gap: 18px;
  margin-top: 18px;
}

.result-question-card {
  padding: 22px;
}

.result-question-card__head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.result-question-card__head > div {
  display: flex;
  align-items: center;
  gap: 10px;
}

.result-question-card__index,
.result-question-card__score {
  color: #475569;
  font-size: 13px;
  font-weight: 600;
}

.result-question-card h2 {
  margin: 16px 0 0;
  color: #0f172a;
  font-size: 20px;
  line-height: 1.5;
}

.result-question-card__block {
  margin-top: 16px;
  padding: 14px 16px;
  border-radius: 14px;
  background: #f8fafc;
  color: #334155;
  line-height: 1.8;
}

.result-question-card__block label {
  display: block;
  margin-bottom: 6px;
  color: #64748b;
  font-size: 12px;
  font-weight: 700;
}

@media (max-width: 900px) {
  .exam-result-summary {
    grid-template-columns: 1fr 1fr;
  }
}

@media (max-width: 768px) {
  .exam-result-page {
    padding: 16px 12px 28px;
  }

  .exam-result-hero,
  .exam-result-hero__actions,
  .result-question-card__head {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
