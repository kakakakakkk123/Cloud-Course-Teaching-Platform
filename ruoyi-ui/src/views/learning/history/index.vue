<template>
  <div v-loading="loading" class="history-page">
    <section class="history-hero">
      <div>
        <p class="history-hero__kicker">学习历史</p>
        <h1>课程学习进度</h1>
        <p>按课程汇总你的学习状态、完成进度和最近学习时间，方便快速回到正在推进的内容。</p>
      </div>
      <div class="history-stats">
        <div class="history-stat">
          <strong>{{ courseList.length }}</strong>
          <span>注册课程</span>
        </div>
        <div class="history-stat">
          <strong>{{ studyingCount }}</strong>
          <span>学习中</span>
        </div>
        <div class="history-stat">
          <strong>{{ completedCount }}</strong>
          <span>已完成</span>
        </div>
        <div class="history-stat">
          <strong>{{ averageProgress }}%</strong>
          <span>平均进度</span>
        </div>
      </div>
    </section>

    <section class="history-toolbar">
      <div class="history-tabs">
        <button
          v-for="item in statusOptions"
          :key="item.value"
          type="button"
          :class="{ active: statusFilter === item.value }"
          @click="statusFilter = item.value"
        >
          {{ item.label }}
        </button>
      </div>
      <el-input
        v-model.trim="keyword"
        class="history-search"
        size="small"
        clearable
        prefix-icon="el-icon-search"
        placeholder="搜索课程或教师"
      />
    </section>

    <div v-if="filteredCourses.length" class="history-list">
      <article
        v-for="course in filteredCourses"
        :key="course.courseId"
        class="history-card"
      >
        <div class="history-card__cover" @click="openCourse(course)">
          <img v-if="getCoverUrl(course.coverImage)" :src="getCoverUrl(course.coverImage)" :alt="course.courseName">
          <div v-else class="history-card__fallback">{{ getShortName(course.courseName) }}</div>
          <span class="history-card__badge" :class="getStatusClass(course)">{{ getStatusText(course) }}</span>
        </div>

        <div class="history-card__body">
          <div class="history-card__meta">
            <span>{{ course.categoryName || "未分类" }}</span>
            <span>{{ course.teacherName || "未设置教师" }}</span>
          </div>
          <h3 @click="openCourse(course)">{{ course.courseName }}</h3>
          <p>{{ course.courseSubtitle || course.intro || "教师暂未补充课程简介。" }}</p>

          <div class="history-progress">
            <div class="history-progress__header">
              <span>学习进度</span>
              <strong>{{ formatPercent(course.progressPercent) }}</strong>
            </div>
            <el-progress
              :percentage="normalizeProgress(course.progressPercent)"
              :show-text="false"
              :stroke-width="12"
              :color="getProgressColor(course)"
            />
          </div>

          <div class="history-card__timeline">
            <div>
              <span>最近学习</span>
              <strong>{{ parseTime(course.lastStudyTime) || "暂未开始" }}</strong>
            </div>
            <div>
              <span>完成时间</span>
              <strong>{{ parseTime(course.finishTime) || "未完成" }}</strong>
            </div>
          </div>

          <div class="history-card__actions">
            <el-button round @click="openCourse(course)">课程详情</el-button>
            <el-button type="primary" round @click="continueCourse(course)">继续学习</el-button>
          </div>
        </div>
      </article>
    </div>

    <el-empty
      v-else
      description="暂无符合条件的学习历史"
      :image-size="108"
    >
      <el-button type="primary" round @click="$router.push('/course-square')">去课程广场</el-button>
    </el-empty>
  </div>
</template>

<script>
import { listMyPortalCourses } from "@/api/portal"
import { resolveResourceUrl } from "@/utils/resource"

export default {
  name: "LearningHistory",
  data() {
    return {
      loading: false,
      keyword: "",
      statusFilter: "all",
      courseList: [],
      statusOptions: [
        { label: "全部", value: "all" },
        { label: "学习中", value: "studying" },
        { label: "已完成", value: "completed" },
        { label: "未开始", value: "pending" }
      ]
    }
  },
  computed: {
    completedCount() {
      return this.courseList.filter(item => this.isCompleted(item)).length
    },
    studyingCount() {
      return this.courseList.filter(item => {
        const progress = this.normalizeProgress(item.progressPercent)
        return progress > 0 && !this.isCompleted(item)
      }).length
    },
    averageProgress() {
      if (!this.courseList.length) {
        return 0
      }
      const total = this.courseList.reduce((sum, item) => sum + this.normalizeProgress(item.progressPercent), 0)
      return Math.round(total / this.courseList.length)
    },
    filteredCourses() {
      const keyword = this.keyword.toLowerCase()
      return this.courseList.filter(course => {
        const matchesKeyword = !keyword || [
          course.courseName,
          course.courseSubtitle,
          course.teacherName,
          course.categoryName
        ].some(value => String(value || "").toLowerCase().includes(keyword))
        return matchesKeyword && this.matchesStatus(course)
      })
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      listMyPortalCourses().then(res => {
        this.courseList = (res.data || []).slice().sort((a, b) => {
          return String(b.lastStudyTime || b.createTime || "").localeCompare(String(a.lastStudyTime || a.createTime || ""))
        })
      }).finally(() => {
        this.loading = false
      })
    },
    matchesStatus(course) {
      if (this.statusFilter === "all") {
        return true
      }
      if (this.statusFilter === "completed") {
        return this.isCompleted(course)
      }
      const progress = this.normalizeProgress(course.progressPercent)
      if (this.statusFilter === "studying") {
        return progress > 0 && !this.isCompleted(course)
      }
      return progress === 0 && !this.isCompleted(course)
    },
    isCompleted(course) {
      return this.normalizeProgress(course.progressPercent) >= 100 || course.enrollStatus === "3"
    },
    normalizeProgress(value) {
      const progress = Number(value || 0)
      if (Number.isNaN(progress)) {
        return 0
      }
      return Math.max(0, Math.min(100, Math.round(progress)))
    },
    getCoverUrl(coverImage) {
      return resolveResourceUrl(coverImage)
    },
    getShortName(name) {
      return (name || "课程").slice(0, 2)
    },
    getStatusText(course) {
      if (this.isCompleted(course)) {
        return "已完成"
      }
      if (this.normalizeProgress(course.progressPercent) > 0) {
        return "学习中"
      }
      return "未开始"
    },
    getStatusClass(course) {
      if (this.isCompleted(course)) {
        return "is-completed"
      }
      if (this.normalizeProgress(course.progressPercent) > 0) {
        return "is-studying"
      }
      return "is-pending"
    },
    getProgressColor(course) {
      if (this.isCompleted(course)) {
        return "#16a34a"
      }
      if (this.normalizeProgress(course.progressPercent) > 0) {
        return "#2563eb"
      }
      return "#94a3b8"
    },
    formatPercent(value) {
      return `${this.normalizeProgress(value)}%`
    },
    openCourse(course) {
      this.$router.push(`/course/${course.courseId}`)
    },
    continueCourse(course) {
      this.$router.push({
        path: "/learning/online",
        query: { courseId: course.courseId }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.history-page {
  min-height: 100vh;
  padding: 28px clamp(14px, 2vw, 22px) 42px;
  background:
    radial-gradient(circle at top left, rgba(37, 99, 235, 0.1), transparent 24%),
    radial-gradient(circle at right center, rgba(22, 163, 74, 0.08), transparent 20%),
    linear-gradient(180deg, #f8fbff 0%, #f1f5f9 100%);
}

.history-hero,
.history-toolbar,
.history-card {
  border: 1px solid rgba(148, 163, 184, 0.12);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.88);
  box-shadow: 0 14px 30px rgba(15, 23, 42, 0.06);
}

.history-hero {
  display: grid;
  grid-template-columns: minmax(0, 1.2fr) minmax(380px, 0.8fr);
  gap: 24px;
  padding: 26px;
}

.history-hero__kicker {
  margin: 0 0 8px;
  color: #2563eb;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 1px;
}

.history-hero h1 {
  margin: 0;
  color: #0f172a;
  font-size: 28px;
}

.history-hero p {
  max-width: 680px;
  margin: 12px 0 0;
  color: #64748b;
  line-height: 1.8;
}

.history-stats {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 12px;
}

.history-stat {
  min-height: 92px;
  padding: 16px;
  border-radius: 8px;
  background: #f8fafc;
}

.history-stat strong {
  display: block;
  color: #0f172a;
  font-size: 26px;
}

.history-stat span {
  display: block;
  margin-top: 6px;
  color: #64748b;
  font-size: 13px;
}

.history-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  margin: 18px 0;
  padding: 16px;
}

.history-tabs {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.history-tabs button {
  min-width: 76px;
  height: 32px;
  border: 1px solid #dbe3ef;
  border-radius: 6px;
  background: #fff;
  color: #475569;
  cursor: pointer;
}

.history-tabs button.active {
  border-color: #2563eb;
  background: #2563eb;
  color: #fff;
}

.history-search {
  width: 260px;
}

.history-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 18px;
}

.history-card {
  overflow: hidden;
}

.history-card__cover {
  position: relative;
  height: 180px;
  cursor: pointer;
  overflow: hidden;
  background: linear-gradient(135deg, #dbeafe 0%, #ecfdf5 100%);
}

.history-card__cover img,
.history-card__fallback {
  width: 100%;
  height: 100%;
}

.history-card__cover img {
  display: block;
  object-fit: cover;
}

.history-card__fallback {
  display: flex;
  align-items: center;
  justify-content: center;
  color: #2563eb;
  font-size: 34px;
  font-weight: 700;
}

.history-card__badge {
  position: absolute;
  top: 12px;
  left: 12px;
  padding: 5px 10px;
  border-radius: 6px;
  color: #fff;
  font-size: 12px;
  font-weight: 700;
}

.history-card__badge.is-completed {
  background: #16a34a;
}

.history-card__badge.is-studying {
  background: #2563eb;
}

.history-card__badge.is-pending {
  background: #64748b;
}

.history-card__body {
  padding: 18px;
}

.history-card__meta,
.history-progress__header,
.history-card__timeline,
.history-card__actions {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.history-card__meta {
  color: #64748b;
  font-size: 13px;
}

.history-card h3 {
  margin: 12px 0 8px;
  color: #0f172a;
  font-size: 19px;
  cursor: pointer;
}

.history-card p {
  min-height: 48px;
  margin: 0 0 16px;
  color: #64748b;
  line-height: 1.7;
}

.history-progress {
  margin-bottom: 16px;
}

.history-progress__header {
  margin-bottom: 10px;
  color: #0f172a;
  font-size: 14px;
}

.history-card__timeline {
  align-items: stretch;
  margin-bottom: 16px;
}

.history-card__timeline div {
  flex: 1;
  padding: 12px;
  border-radius: 6px;
  background: #f8fafc;
}

.history-card__timeline span {
  display: block;
  color: #94a3b8;
  font-size: 12px;
}

.history-card__timeline strong {
  display: block;
  margin-top: 6px;
  color: #334155;
  font-size: 13px;
}

.history-card__actions ::v-deep .el-button {
  flex: 1;
}

@media screen and (max-width: 1100px) {
  .history-hero {
    grid-template-columns: 1fr;
  }
}

@media screen and (max-width: 768px) {
  .history-page {
    padding-top: 18px;
  }

  .history-stats {
    grid-template-columns: 1fr 1fr;
  }

  .history-toolbar,
  .history-card__timeline,
  .history-card__actions,
  .history-card__meta {
    flex-direction: column;
    align-items: stretch;
  }

  .history-search {
    width: 100%;
  }
}
</style>
