<template>
  <div v-loading="loading" class="online-learning-page">
    <div class="online-learning-shell">
      <section class="online-learning-topbar">
        <div>
          <p class="online-learning-topbar__kicker">在线学习</p>
          <h1>{{ course.courseName || "课程学习空间" }}</h1>
          <p class="online-learning-topbar__summary">
            {{ course.courseSubtitle || course.intro || "查看课程课件、视频、图片资料和后续考试入口，按课程内容有序完成学习任务。" }}
          </p>
        </div>
        <div class="online-learning-topbar__actions">
          <el-button round @click="$router.push('/learning/my-course')">返回我的课程</el-button>
          <el-button v-if="course.courseId" type="primary" round @click="$router.push('/course/' + course.courseId)">课程详情</el-button>
        </div>
      </section>

      <el-empty
        v-if="!courseId"
        description="请先从“我的课程”中选择一门课程再进入在线学习。"
        :image-size="108"
      >
        <el-button type="primary" round @click="$router.push('/learning/my-course')">前往我的课程</el-button>
      </el-empty>

      <template v-else>
        <section class="online-learning-summary">
          <div class="summary-card">
            <strong>{{ contentList.length }}</strong>
            <span>课程内容</span>
          </div>
          <div class="summary-card">
            <strong>{{ documentCount }}</strong>
            <span>文档与资料</span>
          </div>
          <div class="summary-card">
            <strong>{{ videoCount }}</strong>
            <span>视频内容</span>
          </div>
          <div class="summary-card">
            <strong>{{ examCount }}</strong>
            <span>考试入口</span>
          </div>
        </section>

        <section class="online-learning-layout">
          <div class="online-learning-main">
            <div v-if="contentList.length" class="content-list">
              <article
                v-for="item in contentList"
                :key="item.contentId"
                class="content-card"
              >
                <div class="content-card__header">
                  <div>
                    <el-tag size="mini" :type="getTypeTagType(item.contentType)">{{ getTypeText(item.contentType) }}</el-tag>
                    <span class="content-card__preview" v-if="item.isPreview === '1'">支持预览</span>
                  </div>
                  <span class="content-card__duration" v-if="item.durationSeconds">
                    {{ formatDuration(item.durationSeconds) }}
                  </span>
                </div>

                <h3>{{ item.contentTitle }}</h3>
                <p class="content-card__summary">
                  {{ item.summary || item.contentBody || "教师暂未补充该内容的说明信息。" }}
                </p>
                <course-content-resource :item="item" :show-actions="false" />

                <div class="content-card__footer">
                  <span>排序：{{ item.sortOrder || 0 }}</span>
                  <el-button
                    type="primary"
                    plain
                    round
                    size="mini"
                    @click="handleOpenContent(item)"
                  >
                    {{ getActionText(item.contentType) }}
                  </el-button>
                </div>
              </article>
            </div>

            <el-empty
              v-else
              description="当前课程还没有发布学习内容，请稍后再来查看。"
              :image-size="96"
            />
          </div>

          <aside class="online-learning-side">
            <div class="side-card">
              <h3>课程信息</h3>
              <ul class="side-list">
                <li>课程分类：{{ course.categoryName || "未分类" }}</li>
                <li>授课教师：{{ course.teacherName || "未设置教师" }}</li>
                <li>难度等级：{{ getDifficultyText(course.difficultyLevel) }}</li>
                <li>注册人数：{{ course.enrollCount || 0 }}</li>
              </ul>
            </div>

            <div class="side-card">
              <h3>学习提示</h3>
              <ul class="side-list">
                <li>建议优先完成文档与视频类基础内容。</li>
                <li>考试入口会在课程内容中展示，后续可直接接入考试模块。</li>
                <li>如果教师更新了新内容，刷新页面即可看到最新学习任务。</li>
              </ul>
            </div>
          </aside>
        </section>
      </template>
    </div>
  </div>
</template>

<script>
import { getPortalCourseDetail } from "@/api/portal"
import { markContentLearned, startStudentExam } from "@/api/learning"
import CourseContentResource from "@/components/CourseContentResource"

export default {
  name: "OnlineLearning",
  components: {
    CourseContentResource
  },
  data() {
    return {
      loading: false,
      course: {},
      contentList: []
    }
  },
  computed: {
    /** 当前课程编号 */
    courseId() {
      return this.$route.query.courseId
    },
    /** 文档与资料数量 */
    documentCount() {
      return this.contentList.filter(item => ["1", "3", "4"].includes(String(item.contentType))).length
    },
    /** 视频内容数量 */
    videoCount() {
      return this.contentList.filter(item => String(item.contentType) === "2").length
    },
    /** 考试入口数量 */
    examCount() {
      return this.contentList.filter(item => String(item.contentType) === "5").length
    }
  },
  watch: {
    /** 课程切换时重新加载学习内容 */
    courseId: {
      immediate: true,
      handler(value) {
        if (!value) {
          this.course = {}
          this.contentList = []
          return
        }
        this.getDetail(value)
      }
    }
  },
  methods: {
    /** 查询课程详情与学习内容 */
    getDetail(courseId) {
      this.loading = true
      getPortalCourseDetail(courseId).then(res => {
        const data = res.data || {}
        this.course = data.course || {}
        this.contentList = data.contentList || []
      }).finally(() => {
        this.loading = false
      })
    },
    /** 打开课程内容 */
    handleOpenContent(item) {
      if (String(item.contentType) === "5") {
        if (!item.examId) {
          this.$modal.msgWarning("该考试入口暂未关联考试。")
          return
        }
        startStudentExam(item.examId).then(res => {
          const record = res.data || {}
          markContentLearned(item.contentId).finally(() => {
            if (record.recordId) {
              this.$router.push(`/learning/exam/answer/${record.recordId}`)
              return
            }
            this.$router.push({ path: "/learning/exam", query: { examId: item.examId } })
          })
        })
        return
      }

      const targetUrl = this.getContentUrl(item)
      if (!targetUrl) {
        this.$modal.msgWarning("该内容暂未配置可访问地址。")
        return
      }
      markContentLearned(item.contentId).then(() => {
        this.getDetail(this.courseId)
      }).catch(() => {})
      window.open(targetUrl, "_blank")
    },
    /** 生成内容访问地址 */
    getContentUrl(item) {
      const rawUrl = item.sourceType === "2" ? item.linkUrl : item.fileUrl
      if (!rawUrl) {
        return ""
      }
      if (/^(https?:)?\/\//.test(rawUrl)) {
        return rawUrl
      }
      return process.env.VUE_APP_BASE_API + rawUrl
    },
    /** 获取内容类型文案 */
    getTypeText(type) {
      const map = {
        "1": "文档",
        "2": "视频",
        "3": "图片",
        "4": "外链",
        "5": "考试"
      }
      return map[String(type)] || "内容"
    },
    /** 获取内容类型标签样式 */
    getTypeTagType(type) {
      const map = {
        "1": "",
        "2": "success",
        "3": "warning",
        "4": "info",
        "5": "danger"
      }
      return map[String(type)] || "info"
    },
    /** 获取内容操作按钮文案 */
    getActionText(type) {
      const map = {
        "1": "查看文档",
        "2": "观看视频",
        "3": "查看图片",
        "4": "打开链接",
        "5": "进入考试"
      }
      return map[String(type)] || "查看内容"
    },
    /** 获取课程难度文案 */
    getDifficultyText(value) {
      const map = {
        "1": "初级",
        "2": "中级",
        "3": "高级"
      }
      return map[String(value)] || "综合"
    },
    /** 格式化时长 */
    formatDuration(seconds) {
      const total = Number(seconds || 0)
      const hour = Math.floor(total / 3600)
      const minute = Math.floor((total % 3600) / 60)
      const second = total % 60
      if (hour > 0) {
        return `${hour}小时${minute}分`
      }
      if (minute > 0) {
        return `${minute}分${second}秒`
      }
      return `${second}秒`
    }
  }
}
</script>

<style lang="scss" scoped>
.online-learning-page {
  min-height: 100vh;
  padding: 28px clamp(14px, 2vw, 22px) 42px;
  background:
    radial-gradient(circle at top left, rgba(59, 130, 246, 0.12), transparent 24%),
    radial-gradient(circle at right center, rgba(14, 165, 233, 0.1), transparent 20%),
    linear-gradient(180deg, #f8fbff 0%, #f1f5f9 100%);
}

.online-learning-shell {
  max-width: 1380px;
  margin: 0 auto;
}

.online-learning-topbar,
.summary-card,
.content-card,
.side-card {
  border-radius: 24px;
  border: 1px solid rgba(148, 163, 184, 0.12);
  background: rgba(255, 255, 255, 0.82);
  box-shadow: 0 18px 38px rgba(15, 23, 42, 0.06);
  backdrop-filter: blur(14px);
}

.online-learning-topbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  padding: 28px;
}

.online-learning-topbar__kicker {
  margin: 0 0 8px;
  color: #2563eb;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 1.6px;
}

.online-learning-topbar h1 {
  margin: 0;
  color: #0f172a;
}

.online-learning-topbar__summary {
  margin: 12px 0 0;
  color: #64748b;
  line-height: 1.8;
}

.online-learning-topbar__actions {
  display: flex;
  gap: 12px;
  flex-shrink: 0;
}

.online-learning-summary {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
  margin: 22px 0;
}

.summary-card {
  padding: 18px 20px;
}

.summary-card strong {
  display: block;
  color: #0f172a;
  font-size: 28px;
}

.summary-card span {
  display: block;
  margin-top: 6px;
  color: #64748b;
  font-size: 13px;
}

.online-learning-layout {
  display: grid;
  grid-template-columns: minmax(0, 1.35fr) minmax(280px, 0.65fr);
  gap: 22px;
}

.content-list {
  display: grid;
  gap: 18px;
}

.content-card,
.side-card {
  padding: 20px;
}

.content-card__header,
.content-card__footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.content-card__preview,
.content-card__duration {
  color: #64748b;
  font-size: 12px;
}

.content-card__preview {
  margin-left: 10px;
}

.content-card h3 {
  margin: 14px 0 10px;
  color: #0f172a;
  font-size: 20px;
}

.content-card__summary {
  margin: 0 0 18px;
  color: #64748b;
  line-height: 1.8;
}

.side-card h3 {
  margin: 0 0 14px;
  color: #0f172a;
  font-size: 18px;
}

.side-card + .side-card {
  margin-top: 16px;
}

.side-list {
  margin: 0;
  padding-left: 18px;
  color: #64748b;
  line-height: 1.9;
}

@media screen and (max-width: 1100px) {
  .online-learning-summary,
  .online-learning-layout,
  .online-learning-topbar {
    grid-template-columns: 1fr;
  }

  .online-learning-topbar {
    align-items: flex-start;
  }
}

@media screen and (max-width: 768px) {
  .online-learning-topbar__actions,
  .content-card__header,
  .content-card__footer {
    flex-direction: column;
    align-items: flex-start;
  }

  .online-learning-summary {
    grid-template-columns: 1fr 1fr;
  }
}
</style>
