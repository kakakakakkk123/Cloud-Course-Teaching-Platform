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
        <div class="exam-countdown" :class="{ 'is-danger': remainingSeconds <= 300 }">
          <span>剩余时间</span>
          <strong>{{ countdownText }}</strong>
        </div>
        <el-button icon="el-icon-arrow-left" @click="handleAbandon">退出考试</el-button>
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
            <el-tag size="mini" type="info">{{ question.score || question.questionScore || 0 }} 分</el-tag>
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
      <el-button icon="el-icon-arrow-left" @click="handleAbandon">退出考试</el-button>
      <el-button type="primary" icon="el-icon-check" :loading="submitting" @click="handleSubmit">提交考试</el-button>
    </div>
  </div>
</template>

<script>
import { getStudentExamContent, saveStudentExamAnswers, submitStudentExam } from "@/api/learning"
import { resolveResourceUrl } from "@/utils/resource"

export default {
  name: "StudentExamTake",
  data() {
    return {
      loading: false,
      submitting: false,
      exam: {},
      questions: [],
      answers: {},
      remainingSeconds: 0,
      timer: null,
      autoSaveTimer: null,
      dirty: false,
      leavingConfirmed: false
    }
  },
  computed: {
    recordId() {
      return this.$route.params.recordId
    },
    countdownText() {
      const seconds = Math.max(0, Number(this.remainingSeconds || 0))
      const hours = Math.floor(seconds / 3600)
      const minutes = Math.floor((seconds % 3600) / 60)
      const restSeconds = seconds % 60
      return [hours, minutes, restSeconds].map(item => String(item).padStart(2, "0")).join(":")
    },
    examActive() {
      return this.questions.length > 0 && !this.submitting && !this.leavingConfirmed
    }
  },
  created() {
    this.load()
  },
  mounted() {
    window.addEventListener("beforeunload", this.handleBeforeUnload)
  },
  beforeDestroy() {
    this.clearTimer()
    window.removeEventListener("beforeunload", this.handleBeforeUnload)
  },
  beforeRouteLeave(to, from, next) {
    if (!this.examActive) {
      next()
      return
    }
    const confirmed = window.confirm("离开考试将视为放弃作答，系统会提交当前已作答内容并结束考试，确认离开？")
    if (!confirmed) {
      next(false)
      return
    }
    this.leavingConfirmed = true
    this.submitCurrentExam(false).finally(() => {
      next()
    })
  },
  watch: {
    answers: {
      deep: true,
      handler() {
        this.dirty = true
      }
    }
  },
  beforeDestroy() {
    this.stopAutoSave()
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
        this.remainingSeconds = Number(this.exam.remainingSeconds || this.exam.durationSeconds || 0)
        this.initAnswers()
        this.startTimer()
        this.startAutoSave()
      }).catch(() => {
        this.leavingConfirmed = true
        this.goBack()
      }).finally(() => {
        this.loading = false
      })
    },
    initAnswers() {
      const answers = {}
      this.questions.forEach(question => {
        const value = question.studentAnswer || ""
        answers[question.questionId] = String(question.questionType) === "2"
          ? String(value).split(/[,，、\s]+/).filter(Boolean)
          : value
      })
      this.answers = answers
    },
    handleSubmit() {
      this.$modal.confirm("确认提交当前考试吗？").then(() => {
        return this.submitCurrentExam(true)
      }).then(() => {
        this.goBack()
      }).catch(() => {})
    },
    handleAbandon() {
      this.$modal.confirm("退出考试将视为放弃作答，系统会提交当前已作答内容并结束考试，确认退出？").then(() => {
        return this.submitCurrentExam(false)
      }).then(() => {
        this.$modal.msgWarning("已结束本次作答")
        this.goBack()
      }).catch(() => {})
    },
    submitCurrentExam(showSuccess) {
      this.submitting = true
      this.leavingConfirmed = true
      this.clearTimer()
      return saveStudentExamAnswers(this.recordId, { answers: this.buildAnswerPayload() }).then(() => {
        return submitStudentExam(this.recordId)
      }).then(() => {
        if (showSuccess) {
          this.$modal.msgSuccess("提交成功")
        }
      }).finally(() => {
        this.submitting = false
      })
    },
    buildAnswerPayload() {
      return this.questions.map(question => {
        const value = this.answers[question.questionId]
        return {
          questionId: question.questionId,
          studentAnswer: Array.isArray(value) ? value.join(",") : (value || "")
        }
      })
    },
    startTimer() {
      this.clearTimer()
      if (!this.remainingSeconds) {
        return
      }
      this.timer = setInterval(() => {
        this.remainingSeconds = Math.max(0, this.remainingSeconds - 1)
        if (this.remainingSeconds <= 0) {
          this.handleTimeUp()
        }
      }, 1000)
    },
    clearTimer() {
      if (this.timer) {
        clearInterval(this.timer)
        this.timer = null
      }
      this.stopAutoSave()
    },
    startAutoSave() {
      this.stopAutoSave()
      this.autoSaveTimer = setInterval(() => {
        if (this.dirty && !this.submitting) {
          this.dirty = false
          this.autoSave()
        }
      }, 30000)
    },
    stopAutoSave() {
      if (this.autoSaveTimer) {
        clearInterval(this.autoSaveTimer)
        this.autoSaveTimer = null
      }
    },
    autoSave() {
      if (!this.recordId || this.submitting) {
        return
      }
      const payload = this.buildAnswerPayload()
      saveStudentExamAnswers(this.recordId, { answers: payload }).catch(() => {})
    },
    handleTimeUp() {
      if (this.submitting || this.leavingConfirmed) {
        return
      }
      this.$modal.msgWarning("考试时间已截止，系统将自动提交")
      this.submitCurrentExam(false).finally(() => {
        this.goBack()
      })
    },
    handleBeforeUnload(event) {
      if (!this.examActive) {
        return
      }
      event.preventDefault()
      event.returnValue = "离开考试将视为放弃作答，倒计时不会暂停。"
      return event.returnValue
    },
    goBack() {
      this.leavingConfirmed = true
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
  align-items: center;
  gap: 8px;
}

.exam-countdown {
  min-width: 132px;
  padding: 8px 12px;
  text-align: center;
  background: #f8fafc;
  border: 1px solid #dbeafe;
  border-radius: 6px;
}

.exam-countdown span {
  display: block;
  margin-bottom: 3px;
  color: #64748b;
  font-size: 12px;
  line-height: 1;
}

.exam-countdown strong {
  color: #1d4ed8;
  font-size: 18px;
  line-height: 1;
}

.exam-countdown.is-danger {
  background: #fef2f2;
  border-color: #fecaca;
}

.exam-countdown.is-danger strong {
  color: #dc2626;
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

  .exam-header__actions {
    flex-wrap: wrap;
  }

  .exam-countdown,
  .exam-header__actions .el-button,
  .submit-bar .el-button {
    flex: 1 1 100%;
  }
}
</style>
