<template>
  <div v-loading="loading" class="app-container exam-take-page">
    <el-card shadow="never" class="exam-header">
      <div>
        <div class="exam-title">{{ exam.examName || "考试内容" }}</div>
        <div class="exam-meta">
          <span>{{ exam.courseName || "未关联课程" }}</span>
          <span>{{ exam.paperName || "未命名试卷" }}</span>
          <span>{{ exam.durationMinutes || 0 }} 分钟</span>
          <span>{{ exam.totalScore || 0 }} 分</span>
        </div>
      </div>
      <div class="exam-header__actions">
        <el-button icon="el-icon-arrow-left" @click="goBack">返回</el-button>
        <el-button type="primary" icon="el-icon-check" :loading="submitting" @click="handleSubmit">提交考试</el-button>
      </div>
    </el-card>

    <el-empty v-if="!loading && !questions.length" description="暂无试题" />

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
            <el-tag size="mini" type="info">{{ question.score || 0 }} 分</el-tag>
          </div>
        </div>

        <img
          v-if="question.attachmentUrl"
          class="question-image"
          :src="resolveImageUrl(question.attachmentUrl)"
          alt="题目附件"
        />

        <el-radio-group
          v-if="String(question.questionType) === '1' || String(question.questionType) === '3'"
          v-model="answers[question.questionId]"
          class="answer-options"
        >
          <el-radio
            v-for="option in question.optionList || []"
            :key="option.optionId"
            :label="option.optionLabel"
            border
          >{{ option.optionLabel }}. {{ option.optionContent }}</el-radio>
        </el-radio-group>

        <el-checkbox-group
          v-else-if="String(question.questionType) === '2'"
          v-model="answers[question.questionId]"
          class="answer-options"
        >
          <el-checkbox
            v-for="option in question.optionList || []"
            :key="option.optionId"
            :label="option.optionLabel"
            border
          >{{ option.optionLabel }}. {{ option.optionContent }}</el-checkbox>
        </el-checkbox-group>

        <el-input
          v-else
          v-model.trim="answers[question.questionId]"
          type="textarea"
          :rows="String(question.questionType) === '4' ? 2 : 5"
          maxlength="2000"
          show-word-limit
          placeholder="请输入答案"
        />
      </el-card>
    </div>

    <div v-if="questions.length" class="submit-bar">
      <el-button icon="el-icon-arrow-left" @click="goBack">返回我的考试</el-button>
      <el-button type="primary" icon="el-icon-check" :loading="submitting" @click="handleSubmit">提交考试</el-button>
    </div>
  </div>
</template>

<script>
import { getStudentExamContent, submitStudentExam } from "@/api/learning"
import { resolveResourceUrl } from "@/utils/resource"

export default {
  name: "StudentExamTake",
  data() {
    return {
      loading: false,
      submitting: false,
      exam: {},
      questions: [],
      answers: {}
    }
  },
  computed: {
    recordId() {
      return this.$route.params.recordId
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
      getStudentExamContent(this.recordId).then(res => {
        const data = res.data || {}
        this.exam = data.exam || {}
        this.questions = data.questions || []
        this.initAnswers()
      }).finally(() => {
        this.loading = false
      })
    },
    initAnswers() {
      const answers = {}
      this.questions.forEach(question => {
        answers[question.questionId] = String(question.questionType) === "2" ? [] : ""
      })
      this.answers = answers
    },
    handleSubmit() {
      this.$modal.confirm("确认提交当前考试吗？").then(() => {
        this.submitting = true
        return submitStudentExam(this.recordId)
      }).then(() => {
        this.$modal.msgSuccess("提交成功")
        this.goBack()
      }).finally(() => {
        this.submitting = false
      }).catch(() => {})
    },
    goBack() {
      this.$router.push("/learning/exam")
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
.exam-take-page {
  background: #f6f8fb;
}

.exam-header {
  margin-bottom: 16px;
}

.exam-header ::v-deep .el-card__body {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
}

.exam-title {
  color: #0f172a;
  font-size: 20px;
  font-weight: 700;
  line-height: 1.35;
}

.exam-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 8px;
  color: #64748b;
  font-size: 13px;
}

.exam-header__actions {
  display: flex;
  gap: 8px;
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
  gap: 6px;
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

.answer-options {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.answer-options ::v-deep .el-radio,
.answer-options ::v-deep .el-checkbox {
  width: 100%;
  height: auto;
  margin-right: 0;
  padding: 10px 12px;
  line-height: 1.6;
  white-space: normal;
}

.submit-bar {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 16px;
  padding: 16px 0;
}

@media screen and (max-width: 768px) {
  .exam-header ::v-deep .el-card__body,
  .question-card__head {
    flex-direction: column;
  }

  .exam-header__actions,
  .submit-bar {
    width: 100%;
  }

  .exam-header__actions .el-button,
  .submit-bar .el-button {
    flex: 1;
  }
}
</style>
