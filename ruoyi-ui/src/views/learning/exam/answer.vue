<template>
  <div v-loading="loading" class="exam-answer-page">
    <div class="exam-answer-shell">
      <section class="exam-answer-hero">
        <div class="exam-answer-hero__main">
          <p class="exam-answer-hero__kicker">考试作答</p>
          <h1>{{ exam.examName || "考试作答" }}</h1>
          <p class="exam-answer-hero__summary">{{ exam.examNotice || "请按要求完成考试，系统会自动保存你的作答进度。" }}</p>
          <div class="exam-answer-hero__meta">
            <span>课程：{{ exam.courseName || "-" }}</span>
            <span>试卷：{{ exam.paperName || "-" }}</span>
            <span>题目：{{ questionList.length }} 题</span>
          </div>
        </div>

        <div class="exam-answer-hero__side">
          <div class="exam-timer-card">
            <span class="exam-timer-card__label">剩余时间</span>
            <strong>{{ formatRemainTime(remainingSeconds) }}</strong>
            <span class="exam-timer-card__hint">已完成 {{ answeredCount }}/{{ questionList.length }} 题</span>
          </div>

          <div class="exam-answer-hero__actions">
            <el-button plain :loading="saving" @click="handleSave(false)">保存进度</el-button>
            <el-button type="primary" :loading="submitting" @click="handleSubmit">提交考试</el-button>
          </div>
        </div>
      </section>

      <section class="exam-answer-layout">
        <aside class="exam-answer-nav">
          <div class="exam-answer-nav__head">
            <h3>答题导航</h3>
            <span>{{ answeredCount }}/{{ questionList.length }}</span>
          </div>
          <div class="exam-answer-nav__grid">
            <button
              v-for="(question, index) in questionList"
              :key="question.questionId"
              type="button"
              class="exam-question-anchor"
              :class="{
                'exam-question-anchor--active': activeQuestionId === question.questionId,
                'exam-question-anchor--answered': isAnswered(question)
              }"
              @click="scrollToQuestion(question.questionId)"
            >
              {{ index + 1 }}
            </button>
          </div>
          <p class="exam-answer-nav__foot">{{ saveStatusText }}</p>
        </aside>

        <div class="exam-answer-main">
          <article
            v-for="(question, index) in questionList"
            :key="question.questionId"
            :ref="'question-' + question.questionId"
            class="exam-question-card"
          >
            <div class="exam-question-card__head">
              <div>
                <span class="exam-question-card__index">第 {{ index + 1 }} 题</span>
                <el-tag size="mini" :type="getQuestionTagType(question.questionType)">{{ getQuestionTypeText(question.questionType) }}</el-tag>
              </div>
              <span class="exam-question-card__score">{{ question.questionScore || 0 }} 分</span>
            </div>

            <h2>{{ question.questionTitle }}</h2>

            <div v-if="question.attachmentUrl" class="exam-question-card__attachment">
              附件：<a :href="getAttachmentUrl(question.attachmentUrl)" target="_blank" rel="noopener noreferrer">查看附件</a>
            </div>

            <div class="exam-question-card__body">
              <el-radio-group
                v-if="isSingleQuestion(question)"
                v-model="answerMap[question.questionId]"
                @change="markDirty"
              >
                <el-radio
                  v-for="option in question.optionList || []"
                  :key="option.optionLabel"
                  :label="option.optionLabel"
                  border
                  class="exam-option"
                >
                  {{ option.optionLabel }}. {{ option.optionContent }}
                </el-radio>
              </el-radio-group>

              <el-checkbox-group
                v-else-if="isMultiQuestion(question)"
                v-model="answerMap[question.questionId]"
                @change="markDirty"
              >
                <el-checkbox
                  v-for="option in question.optionList || []"
                  :key="option.optionLabel"
                  :label="option.optionLabel"
                  border
                  class="exam-option"
                >
                  {{ option.optionLabel }}. {{ option.optionContent }}
                </el-checkbox>
              </el-checkbox-group>

              <el-input
                v-else-if="isBlankQuestion(question)"
                v-model.trim="answerMap[question.questionId]"
                placeholder="请输入你的答案"
                @input="markDirty"
              />

              <el-input
                v-else
                v-model.trim="answerMap[question.questionId]"
                type="textarea"
                :rows="6"
                maxlength="2000"
                show-word-limit
                placeholder="请输入你的作答内容"
                @input="markDirty"
              />
            </div>
          </article>
        </div>
      </section>
    </div>
  </div>
</template>

<script>
import {
  getStudentExamPaper,
  saveStudentExamAnswers,
  submitStudentExam
} from "@/api/learning"

export default {
  name: "StudentExamAnswer",
  data() {
    return {
      loading: false,
      saving: false,
      submitting: false,
      dirty: false,
      activeQuestionId: undefined,
      autoSaveTimer: null,
      countdownTimer: null,
      lastSavedAt: null,
      exam: {},
      questionList: [],
      answerMap: {},
      remainingSeconds: 0
    }
  },
  computed: {
    recordId() {
      return this.$route.params.recordId
    },
    answeredCount() {
      return this.questionList.filter(question => this.isAnswered(question)).length
    },
    saveStatusText() {
      if (this.saving) {
        return "正在保存作答进度..."
      }
      if (!this.lastSavedAt) {
        return "系统会自动保存你的作答进度"
      }
      return `最近保存：${this.parseTime(this.lastSavedAt, '{h}:{i}:{s}')}`
    }
  },
  created() {
    this.getPaper()
  },
  beforeDestroy() {
    this.clearTimers()
  },
  methods: {
    getPaper() {
      this.loading = true
      getStudentExamPaper(this.recordId).then(res => {
        const data = res.data || {}
        this.exam = data
        this.questionList = data.questionList || []
        this.remainingSeconds = Number(data.remainingSeconds || 0)
        this.answerMap = {}
        this.questionList.forEach(question => {
          this.$set(this.answerMap, question.questionId, this.decodeAnswer(question, question.studentAnswer))
        })
        this.activeQuestionId = this.questionList.length ? this.questionList[0].questionId : undefined
        this.startTimers()
      }).catch(() => {
        this.$router.replace("/learning/exam")
      }).finally(() => {
        this.loading = false
      })
    },
    startTimers() {
      this.clearTimers()
      this.countdownTimer = setInterval(() => {
        if (this.remainingSeconds > 0) {
          this.remainingSeconds -= 1
        }
        if (this.remainingSeconds === 0 && !this.submitting) {
          this.handleAutoSubmit()
        }
      }, 1000)
      this.autoSaveTimer = setInterval(() => {
        this.handleSave(true)
      }, 20000)
    },
    clearTimers() {
      if (this.countdownTimer) {
        clearInterval(this.countdownTimer)
        this.countdownTimer = null
      }
      if (this.autoSaveTimer) {
        clearInterval(this.autoSaveTimer)
        this.autoSaveTimer = null
      }
    },
    markDirty() {
      this.dirty = true
    },
    handleSave(silent) {
      if (!this.dirty || this.saving || this.submitting) {
        return Promise.resolve()
      }
      this.saving = true
      return saveStudentExamAnswers(this.recordId, {
        answers: this.questionList.map(question => ({
          questionId: question.questionId,
          studentAnswer: this.encodeAnswer(question)
        }))
      }).then(() => {
        this.dirty = false
        this.lastSavedAt = new Date()
        if (!silent) {
          this.$modal.msgSuccess("作答进度已保存")
        }
      }).finally(() => {
        this.saving = false
      })
    },
    handleSubmit() {
      if (this.submitting) {
        return
      }
      this.$modal.confirm("确认提交当前考试吗？提交后将不能继续作答。").then(() => {
        this.submitting = true
        return this.handleSave(true).then(() => submitStudentExam(this.recordId))
      }).then(() => {
        this.$modal.msgSuccess("考试已提交")
        this.$router.replace(`/learning/exam/result/${this.recordId}`)
      }).catch(() => {
        this.submitting = false
      })
    },
    handleAutoSubmit() {
      if (this.submitting) {
        return
      }
      this.submitting = true
      this.handleSave(true).then(() => submitStudentExam(this.recordId)).then(() => {
        this.$modal.msgSuccess("考试时间已到，系统已自动交卷")
        this.$router.replace(`/learning/exam/result/${this.recordId}`)
      }).catch(() => {
        this.submitting = false
      })
    },
    scrollToQuestion(questionId) {
      this.activeQuestionId = questionId
      const ref = this.$refs[`question-${questionId}`]
      const target = Array.isArray(ref) ? ref[0] : ref
      if (target && typeof target.scrollIntoView === "function") {
        target.scrollIntoView({ behavior: "smooth", block: "start" })
      }
    },
    isSingleQuestion(question) {
      return ["1", "3"].includes(String(question.questionType))
    },
    isMultiQuestion(question) {
      return String(question.questionType) === "2"
    },
    isBlankQuestion(question) {
      return String(question.questionType) === "4"
    },
    isAnswered(question) {
      const value = this.answerMap[question.questionId]
      if (Array.isArray(value)) {
        return value.length > 0
      }
      return !!String(value || "").trim()
    },
    decodeAnswer(question, rawValue) {
      if (this.isMultiQuestion(question)) {
        if (!rawValue) {
          return []
        }
        if (String(rawValue).trim().startsWith("[")) {
          return JSON.parse(rawValue)
        }
        return String(rawValue).split(",").filter(Boolean)
      }
      return rawValue || ""
    },
    encodeAnswer(question) {
      const value = this.answerMap[question.questionId]
      if (this.isMultiQuestion(question)) {
        return JSON.stringify(value || [])
      }
      return value || ""
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
    formatRemainTime(seconds) {
      const total = Number(seconds || 0)
      const hour = Math.floor(total / 3600)
      const minute = Math.floor((total % 3600) / 60)
      const second = total % 60
      const HH = String(hour).padStart(2, "0")
      const MM = String(minute).padStart(2, "0")
      const SS = String(second).padStart(2, "0")
      return `${HH}:${MM}:${SS}`
    },
    getAttachmentUrl(url) {
      if (!url) {
        return ""
      }
      if (/^(https?:)?\/\//.test(url)) {
        return url
      }
      return process.env.VUE_APP_BASE_API + url
    }
  }
}
</script>

<style lang="scss" scoped>
.exam-answer-page {
  min-height: 100vh;
  padding: 24px 20px 40px;
  background: #f4f7fb;
}

.exam-answer-shell {
  max-width: 1380px;
  margin: 0 auto;
}

.exam-answer-hero,
.exam-answer-nav,
.exam-question-card {
  border: 1px solid rgba(226, 232, 240, 0.96);
  border-radius: 18px;
  background: #fff;
}

.exam-answer-hero {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 20px;
  margin-bottom: 20px;
  padding: 24px;
}

.exam-answer-hero__kicker {
  margin: 0 0 8px;
  color: #2563eb;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.08em;
}

.exam-answer-hero h1 {
  margin: 0;
  color: #0f172a;
  font-size: 28px;
}

.exam-answer-hero__summary,
.exam-answer-nav__foot,
.exam-timer-card__hint,
.exam-question-card__attachment {
  color: #64748b;
}

.exam-answer-hero__summary {
  max-width: 64ch;
  margin: 12px 0 0;
  line-height: 1.8;
}

.exam-answer-hero__meta {
  display: flex;
  flex-wrap: wrap;
  gap: 10px 16px;
  margin-top: 16px;
  color: #475569;
  font-size: 13px;
}

.exam-answer-hero__side {
  display: grid;
  gap: 14px;
  min-width: 240px;
}

.exam-timer-card {
  padding: 18px;
  border-radius: 16px;
  background: #eff6ff;
}

.exam-timer-card__label,
.exam-timer-card__hint {
  display: block;
}

.exam-timer-card__label {
  color: #1d4ed8;
  font-size: 12px;
  font-weight: 700;
}

.exam-timer-card strong {
  display: block;
  margin: 10px 0 8px;
  color: #0f172a;
  font-size: 32px;
  line-height: 1;
}

.exam-answer-hero__actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.exam-answer-layout {
  display: grid;
  grid-template-columns: 260px minmax(0, 1fr);
  gap: 20px;
}

.exam-answer-nav {
  position: sticky;
  top: 24px;
  align-self: start;
  padding: 18px;
}

.exam-answer-nav__head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 14px;
}

.exam-answer-nav__head h3 {
  margin: 0;
  color: #0f172a;
  font-size: 16px;
}

.exam-answer-nav__grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 10px;
}

.exam-question-anchor {
  min-height: 42px;
  border: 1px solid #dbe3ee;
  border-radius: 12px;
  background: #fff;
  color: #475569;
  cursor: pointer;
  font-weight: 600;
  transition: border-color 0.2s ease, background-color 0.2s ease, color 0.2s ease;
}

.exam-question-anchor--answered {
  border-color: #bfdbfe;
  background: #eff6ff;
  color: #1d4ed8;
}

.exam-question-anchor--active {
  border-color: #2563eb;
  background: #2563eb;
  color: #fff;
}

.exam-answer-nav__foot {
  margin: 14px 0 0;
  font-size: 12px;
  line-height: 1.6;
}

.exam-answer-main {
  display: grid;
  gap: 18px;
}

.exam-question-card {
  padding: 22px;
}

.exam-question-card__head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.exam-question-card__head > div {
  display: flex;
  align-items: center;
  gap: 10px;
}

.exam-question-card__index,
.exam-question-card__score {
  color: #475569;
  font-size: 13px;
  font-weight: 600;
}

.exam-question-card h2 {
  margin: 16px 0 12px;
  color: #0f172a;
  font-size: 20px;
  line-height: 1.5;
  text-wrap: pretty;
}

.exam-question-card__attachment {
  margin-bottom: 16px;
  font-size: 13px;
}

.exam-question-card__body ::v-deep .el-radio-group,
.exam-question-card__body ::v-deep .el-checkbox-group {
  display: grid;
  gap: 12px;
}

.exam-option {
  display: flex;
  align-items: flex-start;
  margin-right: 0;
  line-height: 1.7;
}

@media (max-width: 1080px) {
  .exam-answer-layout {
    grid-template-columns: 1fr;
  }

  .exam-answer-nav {
    position: static;
  }
}

@media (max-width: 768px) {
  .exam-answer-page {
    padding: 16px 12px 28px;
  }

  .exam-answer-hero,
  .exam-answer-hero__actions,
  .exam-question-card__head {
    flex-direction: column;
    align-items: flex-start;
  }

  .exam-answer-nav__grid {
    grid-template-columns: repeat(5, minmax(0, 1fr));
  }
}
</style>
