<template>
  <div v-loading="loading" class="my-course-page">
    <div class="my-course-shell">
      <section class="my-course-hero">
        <div class="my-course-hero__content">
          <p class="my-course-hero__kicker">我的学习</p>
          <h1>继续你的课程学习</h1>
          <p class="my-course-hero__summary">
            在这里查看已经注册的课程、学习进度和最近更新的学习内容，快速回到正在学习的课程。
          </p>
        </div>
        <div class="my-course-hero__stats">
          <div class="hero-stat-card">
            <strong>{{ courseList.length }}</strong>
            <span>已注册课程</span>
          </div>
          <div class="hero-stat-card">
            <strong>{{ completedCount }}</strong>
            <span>已完成课程</span>
          </div>
          <div class="hero-stat-card">
            <strong>{{ studyingCount }}</strong>
            <span>学习中课程</span>
          </div>
        </div>
      </section>

      <section class="my-course-toolbar">
        <div>
          <p class="my-course-toolbar__kicker">学习列表</p>
          <h2>我注册的课程</h2>
        </div>
        <el-button round @click="$router.push('/course-square')">去课程广场</el-button>
      </section>

      <div v-if="courseList.length" class="my-course-grid">
        <article
          v-for="course in courseList"
          :key="course.courseId"
          class="my-course-card"
        >
          <div class="my-course-card__cover" @click="handleOpenDetail(course)">
            <img v-if="getCoverUrl(course.coverImage)" :src="getCoverUrl(course.coverImage)" :alt="course.courseName">
            <div v-else class="my-course-card__fallback">{{ getShortName(course.courseName) }}</div>
            <span class="my-course-card__badge">{{ getStatusText(course) }}</span>
          </div>

          <div class="my-course-card__body">
            <div class="my-course-card__meta">
              <span>{{ course.categoryName || "未分类" }}</span>
              <span>{{ course.teacherName || "未设置教师" }}</span>
            </div>
            <h3 @click="handleOpenDetail(course)">{{ course.courseName }}</h3>
            <p class="my-course-card__desc">
              {{ course.courseSubtitle || course.intro || "教师暂未补充课程简介。" }}
            </p>

            <div class="my-course-card__progress">
              <div class="progress-header">
                <span>学习进度</span>
                <strong>{{ formatPercent(course.progressPercent) }}</strong>
              </div>
              <el-progress
                :percentage="Number(course.progressPercent || 0)"
                :show-text="false"
                :stroke-width="10"
                color="#2563eb"
              />
            </div>

            <div class="my-course-card__footer">
              <span>最近学习：{{ parseTime(course.lastStudyTime) || "暂未开始" }}</span>
              <span>注册人数：{{ course.enrollCount || 0 }}</span>
            </div>

            <div class="my-course-card__actions">
              <el-button round @click="handleOpenDetail(course)">查看详情</el-button>
              <el-button type="primary" round @click="handleContinue(course)">继续学习</el-button>
            </div>
          </div>
        </article>
      </div>

      <el-empty v-else description="你还没有注册课程，先去课程广场挑选一门课程吧。" :image-size="104">
        <el-button type="primary" round @click="$router.push('/course-square')">前往课程广场</el-button>
      </el-empty>
    </div>
  </div>
</template>

<script>
import { listMyPortalCourses } from "@/api/portal"
import { resolveResourceUrl } from "@/utils/resource"

export default {
  name: "MyCourse",
  data() {
    return {
      loading: false,
      courseList: []
    }
  },
  computed: {
    /** 已完成课程数量 */
    completedCount() {
      return this.courseList.filter(item => Number(item.progressPercent || 0) >= 100).length
    },
    /** 学习中的课程数量 */
    studyingCount() {
      return this.courseList.filter(item => Number(item.progressPercent || 0) > 0 && Number(item.progressPercent || 0) < 100).length
    }
  },
  created() {
    this.getList()
  },
  methods: {
    /** 查询我的课程列表 */
    getList() {
      this.loading = true
      listMyPortalCourses().then(res => {
        this.courseList = res.data || []
      }).finally(() => {
        this.loading = false
      })
    },
    /** 获取课程封面地址 */
    getCoverUrl(coverImage) {
      if (!coverImage) {
        return ""
      }
      return resolveResourceUrl(coverImage)
    },
    /** 获取课程简称 */
    getShortName(name) {
      return (name || "课程").slice(0, 2)
    },
    /** 获取课程学习状态文案 */
    getStatusText(course) {
      const progress = Number(course.progressPercent || 0)
      if (progress >= 100 || course.enrollStatus === "3") {
        return "已完成"
      }
      if (progress > 0) {
        return "学习中"
      }
      return "待开始"
    },
    /** 格式化进度百分比 */
    formatPercent(value) {
      return `${Number(value || 0).toFixed(0)}%`
    },
    /** 打开课程详情 */
    handleOpenDetail(course) {
      this.$router.push(`/course/${course.courseId}`)
    },
    /** 进入在线学习 */
    handleContinue(course) {
      this.$router.push({
        path: "/learning/online",
        query: { courseId: course.courseId }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.my-course-page {
  min-height: 100vh;
  padding: 28px clamp(14px, 2vw, 22px) 40px;
  background:
    radial-gradient(circle at top left, rgba(59, 130, 246, 0.12), transparent 24%),
    radial-gradient(circle at right center, rgba(45, 212, 191, 0.1), transparent 20%),
    linear-gradient(180deg, #f8fbff 0%, #f1f5f9 100%);
}

.my-course-shell {
  max-width: 1380px;
  margin: 0 auto;
}

.my-course-hero,
.my-course-toolbar,
.my-course-card {
  border: 1px solid rgba(148, 163, 184, 0.12);
  border-radius: 24px;
  background: rgba(255, 255, 255, 0.82);
  box-shadow: 0 18px 38px rgba(15, 23, 42, 0.06);
  backdrop-filter: blur(14px);
}

.my-course-hero {
  display: grid;
  grid-template-columns: minmax(0, 1.2fr) minmax(320px, 0.8fr);
  gap: 24px;
  padding: 28px;
}

.my-course-hero__kicker,
.my-course-toolbar__kicker {
  margin: 0 0 8px;
  color: #2563eb;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 1.5px;
}

.my-course-hero h1,
.my-course-toolbar h2 {
  margin: 0;
  color: #0f172a;
}

.my-course-hero__summary {
  margin: 14px 0 0;
  color: #64748b;
  line-height: 1.8;
}

.my-course-hero__stats {
  display: grid;
  gap: 14px;
}

.hero-stat-card {
  padding: 18px 20px;
  border-radius: 20px;
  background: linear-gradient(135deg, #ffffff, #f8fafc);
}

.hero-stat-card strong {
  display: block;
  color: #0f172a;
  font-size: 28px;
}

.hero-stat-card span {
  display: block;
  margin-top: 6px;
  color: #64748b;
  font-size: 13px;
}

.my-course-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  margin-top: 22px;
  margin-bottom: 22px;
  padding: 20px 24px;
}

.my-course-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 20px;
}

.my-course-card {
  overflow: hidden;
  transition: all 0.22s ease;
}

.my-course-card:hover {
  transform: translateY(-4px);
}

.my-course-card__cover {
  position: relative;
  height: 210px;
  cursor: pointer;
  overflow: hidden;
  background: linear-gradient(135deg, #dbeafe 0%, #ecfeff 100%);
}

.my-course-card__cover img,
.my-course-card__fallback {
  width: 100%;
  height: 100%;
}

.my-course-card__cover img {
  display: block;
  object-fit: cover;
}

.my-course-card__fallback {
  display: flex;
  align-items: center;
  justify-content: center;
  color: #2563eb;
  font-size: 40px;
  font-weight: 700;
}

.my-course-card__badge {
  position: absolute;
  top: 14px;
  left: 14px;
  padding: 6px 12px;
  border-radius: 999px;
  background: rgba(15, 23, 42, 0.72);
  color: #fff;
  font-size: 12px;
  font-weight: 600;
}

.my-course-card__body {
  padding: 20px;
}

.my-course-card__meta,
.my-course-card__footer,
.progress-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.my-course-card__meta,
.my-course-card__footer {
  color: #64748b;
  font-size: 13px;
}

.my-course-card__meta {
  margin-bottom: 12px;
}

.my-course-card h3 {
  margin: 0;
  color: #0f172a;
  font-size: 20px;
  cursor: pointer;
}

.my-course-card__desc {
  min-height: 50px;
  margin: 12px 0 18px;
  color: #64748b;
  line-height: 1.8;
}

.progress-header {
  margin-bottom: 10px;
  color: #0f172a;
  font-size: 14px;
}

.my-course-card__progress {
  margin-bottom: 18px;
}

.my-course-card__footer {
  margin-bottom: 18px;
}

.my-course-card__actions {
  display: flex;
  gap: 12px;
}

.my-course-card__actions ::v-deep .el-button {
  flex: 1;
}

@media screen and (max-width: 1100px) {
  .my-course-hero {
    grid-template-columns: 1fr;
  }
}

@media screen and (max-width: 768px) {
  .my-course-page {
    padding-top: 20px;
  }

  .my-course-toolbar,
  .my-course-card__actions,
  .my-course-card__meta,
  .my-course-card__footer {
    flex-direction: column;
    align-items: flex-start;
  }

  .my-course-card__actions {
    width: 100%;
  }
}
</style>
