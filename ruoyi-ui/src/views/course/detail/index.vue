<template>
  <div v-loading="loading" class="course-detail-page">
    <portal-topbar
      active="course-square"
      context-title="课程详情"
      context-summary="在同一前台导航中继续浏览课程"
    />

    <div class="course-detail-shell">
      <section class="course-detail-hero">
        <div class="course-detail-hero__content">
          <p class="course-detail-hero__kicker">{{ course.categoryName || "课程详情" }}</p>
          <h1>{{ course.courseName }}</h1>
          <p class="course-detail-hero__subtitle">{{ course.courseSubtitle || course.intro || "暂无课程简介" }}</p>
          <div class="course-detail-hero__stats">
            <span>授课教师：{{ course.teacherName || "未设置" }}</span>
            <span>注册人数：{{ course.enrollCount || 0 }}</span>
            <span>点赞人数：{{ course.likeCount || 0 }}</span>
          </div>
          <div class="course-detail-hero__actions">
            <el-button
              v-if="showEnrollButton"
              type="primary"
              :loading="enrollLoading"
              @click="handleEnroll"
            >
              注册课程
            </el-button>
            <el-button
              v-if="isLogin"
              plain
              :type="liked ? 'warning' : 'default'"
              @click="handleToggleLike"
            >
              {{ liked ? "取消点赞" : "点赞课程" }}
            </el-button>
            <el-button
              v-if="isLogin"
              plain
              icon="el-icon-star-on"
              :type="favorited ? 'warning' : 'default'"
              :loading="favoriteLoading"
              @click="handleFavoriteCourse"
            >
              {{ favorited ? "已收藏" : "收藏课程" }}
            </el-button>
            <el-button @click="$router.push('/course-square')">查看更多课程</el-button>
          </div>
        </div>
        <div class="course-detail-hero__cover">
          <img v-if="coverImage" :src="coverImage" :alt="course.courseName">
          <div v-else class="course-detail-hero__fallback">{{ shortName }}</div>
        </div>
      </section>

      <section class="course-detail-body">
        <div class="course-detail-main">
          <el-card shadow="never" class="course-panel">
            <div slot="header">课程简介</div>
            <p class="course-intro">{{ course.intro || "暂无课程简介" }}</p>
          </el-card>

          <el-card shadow="never" class="course-panel">
            <div slot="header">课程内容</div>
            <div v-if="contentList.length" class="content-list">
              <div
                v-for="item in contentList"
                :key="item.contentId"
                class="content-item"
                :class="{ 'content-item--exam': item.contentType === '5' }"
              >
                <div class="content-item__meta">
                  <span class="content-item__type">{{ typeText(item.contentType) }}</span>
                  <span v-if="item.durationSeconds">时长 {{ formatDuration(item.durationSeconds) }}</span>
                </div>
                <div class="content-item__title-row">
                  <div class="content-item__title">{{ item.contentTitle }}</div>
                  <span v-if="item.contentType === '5'" class="content-item__badge">考试入口</span>
                </div>
                <div v-if="item.contentType === '5'" class="content-item__exam-name">
                  关联考试：{{ item.examName || `考试 #${item.examId}` }}
                </div>
                <div
                  class="content-item__summary content-item__summary--rich"
                  v-html="getContentSummary(item)"
                />
                <course-content-resource :item="item" />
              </div>
            </div>
            <el-empty v-else description="教师暂未发布课程内容" :image-size="88" />
          </el-card>
        </div>

        <aside class="course-detail-side">
          <el-card shadow="never" class="course-panel">
            <div slot="header">学习信息</div>
            <ul class="course-side-list">
              <li>难度等级：{{ difficultyText }}</li>
              <li>课程状态：{{ publishText }}</li>
              <li>允许注册：{{ course.allowRegister === '1' ? '是' : '否' }}</li>
              <li>内容数量：{{ contentList.length }}</li>
              <li>考试数量：{{ examContentCount }}</li>
            </ul>
          </el-card>

          <el-card v-if="examContentCount" shadow="never" class="course-panel course-panel--exam">
            <div slot="header">课程考试</div>
            <p class="course-panel__exam-desc">
              当前课程已配置 {{ examContentCount }} 项考试内容，教师可在课程内容管理中继续调整展示顺序和关联考试。
            </p>
          </el-card>
        </aside>
      </section>
    </div>
  </div>
</template>

<script>
import { getToken } from "@/utils/auth"
import { getPortalCourseDetail, enrollPortalCourse, likePortalCourse, cancelLikePortalCourse } from "@/api/portal"
import { getStudentProfile, updateStudentProfile } from "@/api/system/user"
import CourseContentResource from "@/components/CourseContentResource"
import PortalTopbar from "@/components/PortalTopbar"
import { resolveResourceUrl } from "@/utils/resource"

export default {
  name: "CourseDetail",
  components: {
    CourseContentResource,
    PortalTopbar
  },
  data() {
    return {
      loading: false,
      enrollLoading: false,
      favoriteLoading: false,
      course: {},
      contentList: [],
      liked: false,
      registered: false,
      favorited: false,
      studentProfile: {}
    }
  },
  computed: {
    /** 当前用户是否已登录 */
    isLogin() {
      return !!getToken()
    },
    /** 课程封面完整地址 */
    coverImage() {
      const cover = this.course.coverImage
      if (!cover) {
        return ""
      }
      return resolveResourceUrl(cover)
    },
    /** 课程难度文案 */
    difficultyText() {
      const map = {
        "1": "入门",
        "2": "进阶",
        "3": "高级"
      }
      return map[this.course.difficultyLevel] || "综合"
    },
    /** 发布状态文案 */
    publishText() {
      return this.course.publishStatus === "1" ? "已发布" : "未发布"
    },
    /** 是否展示注册按钮 */
    showEnrollButton() {
      return this.isLogin && !this.registered && this.course.allowRegister === "1"
    },
    /** 封面缺失时显示课程简称 */
    shortName() {
      return (this.course.courseName || "课程").slice(0, 2)
    },
    /** 考试内容数量 */
    examContentCount() {
      return (this.contentList || []).filter(item => item.contentType === "5").length
    }
  },
  created() {
    this.getDetail()
  },
  methods: {
    /** 加载课程详情 */
    getDetail() {
      this.loading = true
      getPortalCourseDetail(this.$route.params.courseId).then(res => {
        const data = res.data || {}
        this.course = data.course || {}
        this.contentList = data.contentList || []
        this.liked = !!data.liked
        this.registered = !!data.registered
        this.loadFavoriteState()
      }).finally(() => {
        this.loading = false
      })
    },
    /** 注册当前课程 */
    handleEnroll() {
      this.enrollLoading = true
      enrollPortalCourse(this.course.courseId).then(() => {
        this.$modal.msgSuccess("课程注册成功")
        this.registered = true
        this.course.enrollCount = (this.course.enrollCount || 0) + 1
      }).finally(() => {
        this.enrollLoading = false
      })
    },
    /** 切换点赞状态 */
    handleToggleLike() {
      const request = this.liked
        ? cancelLikePortalCourse(this.course.courseId)
        : likePortalCourse(this.course.courseId)
      request.then(() => {
        this.liked = !this.liked
        this.course.likeCount = Math.max(0, (this.course.likeCount || 0) + (this.liked ? 1 : -1))
        this.$modal.msgSuccess(this.liked ? "课程点赞成功" : "已取消点赞")
      })
    },
    /** 加载当前课程收藏状态 */
    loadFavoriteState() {
      if (!this.isLogin) {
        this.favorited = false
        return
      }
      getStudentProfile().then(res => {
        this.studentProfile = res.data || {}
        this.favorited = this.isCourseFavorited(this.studentProfile.favorites)
      })
    },
    /** 收藏当前课程 */
    handleFavoriteCourse() {
      if (this.favorited) {
        this.$router.push("/learning/favorite")
        return
      }
      if (!this.course.courseId) {
        return
      }
      this.favoriteLoading = true
      const profileRequest = this.studentProfile && this.studentProfile.userId
        ? Promise.resolve(this.studentProfile)
        : getStudentProfile().then(res => res.data || {})
      profileRequest.then(profile => {
        const storedItems = this.parseStoredFavorites(profile.favorites)
        if (this.isCourseFavorited(profile.favorites || storedItems)) {
          this.studentProfile = profile
          this.favorited = true
          this.$modal.msgSuccess("该课程已收藏")
          return null
        }
        const collectedAt = this.formatDateTime(new Date())
        storedItems.unshift({
          id: `favorite-course-${this.course.courseId}`,
          courseId: this.course.courseId,
          title: this.course.courseName,
          courseName: this.course.courseName,
          courseSubtitle: this.course.courseSubtitle,
          coverImage: this.course.coverImage,
          categoryName: this.course.categoryName,
          teacherName: this.course.teacherName,
          summary: this.course.courseSubtitle || this.course.intro || "",
          detail: this.course.intro || "",
          collectedAt,
          updatedAt: collectedAt,
          tags: ["课程收藏"]
        })
        profile.favorites = JSON.stringify(storedItems, null, 2)
        return updateStudentProfile(profile).then(() => {
          this.studentProfile = profile
          this.favorited = true
          this.$modal.msgSuccess("课程收藏成功，可在我的收藏查看")
        })
      }).finally(() => {
        this.favoriteLoading = false
      })
    },
    /** 判断课程是否已收藏 */
    isCourseFavorited(rawFavorites) {
      const favorites = Array.isArray(rawFavorites) ? rawFavorites : this.parseStoredFavorites(rawFavorites)
      return favorites.some(item => String(item.courseId) === String(this.course.courseId))
    },
    /** 解析学生档案收藏列表 */
    parseStoredFavorites(raw) {
      if (!raw) {
        return []
      }
      if (Array.isArray(raw)) {
        return raw
      }
      if (typeof raw !== "string") {
        return []
      }
      const value = raw.trim()
      if (!value) {
        return []
      }
      try {
        const parsed = JSON.parse(value)
        if (Array.isArray(parsed)) {
          return parsed
        }
        if (Array.isArray(parsed.items)) {
          return parsed.items
        }
      } catch (e) {
        return [{
          id: `favorite-legacy-${Date.now()}`,
          title: "历史收藏",
          detail: value,
          summary: value,
          tags: ["历史文本"]
        }]
      }
      return []
    },
    /** 格式化收藏时间 */
    formatDateTime(date) {
      const pad = value => String(value).padStart(2, "0")
      return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}`
    },
    /** 课程内容类型文案 */
    typeText(type) {
      const map = {
        "1": "文档",
        "2": "视频",
        "3": "图片",
        "4": "链接",
        "5": "考试"
      }
      return map[type] || "内容"
    },
    /** 课程内容摘要/正文展示 */
    getContentSummary(item) {
      const content = item.summary || item.contentBody
      return content || "暂无内容说明"
    },
    /** 将秒数格式化为分秒 */
    formatDuration(seconds) {
      const total = Number(seconds || 0)
      const minute = Math.floor(total / 60)
      const second = total % 60
      return `${minute}分${second}秒`
    }
  }
}
</script>

<style lang="scss" scoped>
.course-detail-page {
  min-height: 100vh;
  padding: 32px 5vw 48px;
  background:
    radial-gradient(circle at top left, rgba(59, 130, 246, 0.14), transparent 26%),
    radial-gradient(circle at top right, rgba(16, 185, 129, 0.14), transparent 22%),
    linear-gradient(180deg, #f8fbff 0%, #eef7ff 100%);
}

.course-detail-shell {
  max-width: 1320px;
  margin: 0 auto;
}

.course-detail-hero {
  display: grid;
  grid-template-columns: 1.8fr 1fr;
  gap: 24px;
  margin-bottom: 24px;
  padding: 28px;
  border-radius: 24px;
  background: #fff;
  box-shadow: 0 18px 48px rgba(15, 23, 42, 0.08);
}

.course-detail-hero__kicker {
  margin: 0 0 10px;
  color: #2563eb;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 2px;
}

.course-detail-hero h1 {
  margin: 0;
  color: #0f172a;
  font-size: 38px;
}

.course-detail-hero__subtitle {
  margin: 14px 0 0;
  color: #475569;
  line-height: 1.8;
}

.course-detail-hero__stats,
.course-detail-hero__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 12px 18px;
  margin-top: 18px;
}

.course-detail-hero__stats span {
  color: #64748b;
}

.course-detail-hero__cover {
  min-height: 260px;
  overflow: hidden;
  border-radius: 18px;
  background: linear-gradient(135deg, #dbeafe 0%, #ecfeff 100%);
}

.course-detail-hero__cover img,
.course-detail-hero__fallback {
  width: 100%;
  height: 100%;
}

.course-detail-hero__cover img {
  object-fit: cover;
}

.course-detail-hero__fallback {
  display: flex;
  align-items: center;
  justify-content: center;
  color: #1d4ed8;
  font-size: 52px;
  font-weight: 700;
}

.course-detail-body {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 24px;
}

.course-panel {
  margin-bottom: 20px;
  border-radius: 18px;
}

.course-panel--exam {
  background: linear-gradient(135deg, #fff7ed, #ffffff);
}

.course-intro,
.course-side-list li,
.course-panel__exam-desc {
  color: #475569;
  line-height: 1.8;
}

.content-item__summary {
  color: #475569;
  line-height: 1.8;
}

.content-list {
  display: grid;
  gap: 14px;
}

.content-item {
  padding: 16px;
  border-radius: 14px;
  background: #f8fafc;
}

.content-item--exam {
  border: 1px solid rgba(37, 99, 235, 0.16);
  background: linear-gradient(135deg, #eff6ff, #f8fbff);
}

.content-item__meta {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  color: #64748b;
  font-size: 13px;
}

.content-item__type {
  color: #1d4ed8;
  font-weight: 700;
}

.content-item__title-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin: 8px 0;
}

.content-item__title {
  color: #0f172a;
  font-weight: 700;
}

.content-item__badge {
  padding: 4px 10px;
  border-radius: 999px;
  background: linear-gradient(135deg, #2563eb, #38bdf8);
  color: #fff;
  font-size: 12px;
  font-weight: 600;
}

.content-item__exam-name {
  margin-bottom: 8px;
  color: #2563eb;
  font-size: 13px;
  font-weight: 600;
}

.content-item__summary--rich :deep(p) {
  margin: 0 0 10px;
}

.content-item__summary--rich :deep(p:last-child) {
  margin-bottom: 0;
}

.content-item__summary--rich :deep(img) {
  max-width: 100%;
  border-radius: 12px;
}

.content-item__summary--rich :deep(a) {
  color: #2563eb;
  text-decoration: none;
}

.content-item__summary--rich :deep(a:hover) {
  text-decoration: underline;
}

.course-side-list {
  margin: 0;
  padding-left: 18px;
}

@media (max-width: 960px) {
  .course-detail-hero,
  .course-detail-body {
    grid-template-columns: 1fr;
  }

  .content-item__title-row {
    align-items: flex-start;
    flex-direction: column;
  }
}
</style>
