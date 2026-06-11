<template>
  <div v-loading="loading" class="app-container exam-result-page">
    <el-card shadow="never" class="result-header">
      <div>
        <div class="result-title">{{ result.examName || "考试结果" }}</div>
        <div class="result-meta">
          <span>{{ result.courseName || "未关联课程" }}</span>
          <span>{{ result.paperName || "未命名试卷" }}</span>
          <span>{{ formatTime(result.submitTime) || "未提交" }}</span>
        </div>
      </div>
      <div class="result-header__actions">
        <el-button icon="el-icon-arrow-left" @click="goBack">返回我的考试</el-button>
      </div>
    </el-card>

    <section class="score-board">
      <article class="score-item score-item--primary">
        <span>总分</span>
        <strong v-if="canShowScore">{{ scoreText(result.totalScore) }}</strong>
        <strong v-else>待公布</strong>
      </article>
      <article class="score-item">
        <span>客观题</span>
        <strong>{{ canShowScore ? scoreText(result.objectiveScore) : "-" }}</strong>
      </article>
      <article class="score-item">
        <span>主观题</span>
        <strong>{{ canShowScore ? scoreText(result.subjectiveScore) : "-" }}</strong>
      </article>
      <article class="score-item">
        <span>结果</span>
        <el-tag :type="resultTagType">{{ resultStatusText }}</el-tag>
      </article>
    </section>

    <el-alert
      v-if="!canShowAnswer"
      title="本场考试暂未开放答案查看"
      type="info"
      show-icon
      :closable="false"
      class="result-alert"
    />

    <el-empty v-if="!loading && !questions.length" description="暂无试题结果" />

    <div v-else class="question-list">
      <el-card
        v-for="(question, index) in questions"
        :key="question.questionId"
        shadow="never"
        class="question-card"
      >
        <div class="question-card__head">
          <div class="question-title">
            <span>{{ index + 1 }}.</span>
            <span>{{ question.questionTitle }}</span>
          </div>
          <div class="question-tags">
            <el-tag size="mini">{{ getQuestionTypeText(question.questionType) }}</el-tag>
            <el-tag size="mini" type="info">{{ scoreText(question.questionScore || question.score) }} 分</el-tag>
            <el-tag v-if="canShowScore" size="mini" :type="questionTagType(question)">
              {{ questionScoreText(question) }}
            </el-tag>
          </div>
        </div>

        <img
          v-if="question.attachmentUrl"
          class="question-image"
          :src="resolveImageUrl(question.attachmentUrl)"
          alt="题目附件"
        />

        <div v-if="question.optionList && question.optionList.length" class="option-list">
          <div
            v-for="option in question.optionList"
            :key="option.optionId"
            class="option-item"
            :class="{
              'is-selected': isSelected(question.studentAnswer, option.optionLabel),
              'is-correct': canShowAnswer && isSelected(question.standardAnswer, option.optionLabel)
            }"
          >
            <span>{{ option.optionLabel }}.</span>
            <span>{{ option.optionContent }}</span>
          </div>
        </div>

        <div class="answer-grid">
          <div class="answer-box">
            <span>我的答案</span>
            <p>{{ formatAnswer(question.studentAnswer) }}</p>
          </div>
          <div v-if="canShowAnswer" class="answer-box">
            <span>参考答案</span>
            <p>{{ formatAnswer(question.standardAnswer) }}</p>
          </div>
        </div>

        <div v-if="canShowAnswer && question.analysisSnapshot" class="analysis-box">
          <span>解析</span>
          <p>{{ question.analysisSnapshot }}</p>
        </div>
      </el-card>
    </div>
  </div>
</template>

<script>
import { getStudentExamResult } from "@/api/learning"
import { parseTime } from "@/utils/ruoyi"
import { resolveResourceUrl } from "@/utils/resource"

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
    questions() {
      return this.result.questionList || []
    },
    canShowScore() {
      return String(this.result.showScoreAfterSubmit) === "1"
    },
    canShowAnswer() {
      return String(this.result.showAnswerAfterSubmit) === "1"
    },
    resultStatusText() {
      if (!this.canShowScore) {
        return "待公布"
      }
      if (String(this.result.checkedFlag) !== "1") {
        return "待批改"
      }
      return String(this.result.resultStatus) === "1" ? "已通过" : "未通过"
    },
    resultTagType() {
      if (!this.canShowScore || String(this.result.checkedFlag) !== "1") {
        return "info"
      }
      return String(this.result.resultStatus) === "1" ? "success" : "danger"
    }
  },
  created() {
    this.load()
  },
  methods: {
    load() {
      if (!this.recordId) {
        this.$modal.msgWarning("考试记录不存在")
        this.goBack()
        return
      }
      this.loading = true
      getStudentExamResult(this.recordId).then(res => {
        this.result = res.data || {}
      }).finally(() => {
        this.loading = false
      })
    },
    goBack() {
      this.$router.push("/learning/exam")
    },
    formatTime(value) {
      return value ? parseTime(value) : ""
    },
    scoreText(value) {
      if (value === undefined || value === null || value === "") {
        return "0"
      }
      return Number(value).toString()
    },
    questionScoreText(question) {
      if (String(question.isCorrect) === "1") {
        return "正确"
      }
      if (String(question.isCorrect) === "0") {
        return "错误"
      }
      return `${this.scoreText(question.actualScore)} 分`
    },
    questionTagType(question) {
      if (String(question.isCorrect) === "1") {
        return "success"
      }
      if (String(question.isCorrect) === "0") {
        return "danger"
      }
      return "warning"
    },
    formatAnswer(value) {
      if (value === undefined || value === null || value === "") {
        return "未作答"
      }
      return String(value)
    },
    isSelected(answer, label) {
      if (!answer || !label) {
        return false
      }
      return String(answer).split(/[,，、\s]+/).filter(Boolean).includes(String(label))
    },
    resolveImageUrl(url) {
      return resolveResourceUrl(url)
    },
    getQuestionTypeText(type) {
      const map = {
        "1": "单选题",
        "2": "多选题",
        "3": "判断题",
        "4": "填空题",
        "5": "简答题"
      }
      return map[String(type)] || "试题"
    }
  }
}
</script>

<style lang="scss" scoped>
.exam-result-page {
  background: #f6f8fb;
}

.result-header {
  margin-bottom: 16px;
}

.result-header ::v-deep .el-card__body {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
}

.result-title {
  color: #0f172a;
  font-size: 20px;
  font-weight: 700;
  line-height: 1.35;
}

.result-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 8px;
  color: #64748b;
  font-size: 13px;
}

.score-board {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 12px;
  margin-bottom: 16px;
}

.score-item {
  min-height: 88px;
  padding: 16px;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 6px;
}

.score-item span {
  display: block;
  margin-bottom: 8px;
  color: #64748b;
  font-size: 13px;
}

.score-item strong {
  color: #111827;
  font-size: 24px;
  line-height: 1;
}

.score-item--primary {
  border-color: #bfdbfe;
}

.result-alert {
  margin-bottom: 16px;
}

.question-list {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.question-card {
  border-radius: 6px;
}

.question-card__head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 14px;
}

.question-title {
  display: flex;
  gap: 8px;
  color: #111827;
  font-size: 15px;
  font-weight: 600;
  line-height: 1.7;
}

.question-tags {
  display: flex;
  flex: 0 0 auto;
  flex-wrap: wrap;
  gap: 6px;
  justify-content: flex-end;
}

.question-image {
  display: block;
  max-width: 100%;
  max-height: 360px;
  margin: 10px 0 14px;
  object-fit: contain;
  border: 1px solid #e5e7eb;
  border-radius: 4px;
}

.option-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 14px;
}

.option-item {
  display: flex;
  gap: 8px;
  padding: 10px 12px;
  color: #334155;
  line-height: 1.6;
  background: #f8fafc;
  border: 1px solid #e5e7eb;
  border-radius: 4px;
}

.option-item.is-selected {
  color: #1d4ed8;
  background: #eff6ff;
  border-color: #93c5fd;
}

.option-item.is-correct {
  color: #047857;
  background: #ecfdf5;
  border-color: #86efac;
}

.answer-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
}

.answer-box,
.analysis-box {
  padding: 12px;
  background: #f8fafc;
  border: 1px solid #e5e7eb;
  border-radius: 4px;
}

.answer-box span,
.analysis-box span {
  display: block;
  margin-bottom: 6px;
  color: #64748b;
  font-size: 13px;
}

.answer-box p,
.analysis-box p {
  margin: 0;
  color: #111827;
  line-height: 1.7;
  white-space: pre-wrap;
}

.analysis-box {
  margin-top: 12px;
}

@media screen and (max-width: 768px) {
  .result-header ::v-deep .el-card__body,
  .question-card__head {
    flex-direction: column;
  }

  .result-header__actions,
  .result-header__actions .el-button {
    width: 100%;
  }

  .score-board,
  .answer-grid {
    grid-template-columns: 1fr;
  }
}
</style>
