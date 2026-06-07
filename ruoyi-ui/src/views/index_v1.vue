<template>
  <div class="dashboard-page" v-loading="loading">
    <section class="dashboard-head">
      <div>
        <p class="dashboard-head__eyebrow">教学管理后台</p>
        <h1>仪表盘</h1>
        <p class="dashboard-head__summary">
          {{ greeting }}，{{ displayName }}。这里汇总当前平台课程、分类和公告动态。
        </p>
      </div>
      <div class="dashboard-head__actions">
        <el-button type="primary" icon="el-icon-reading" @click="$router.push('/teaching/course')">课程管理</el-button>
      </div>
    </section>

    <el-row :gutter="16" class="metric-grid">
      <el-col v-for="item in metrics" :key="item.label" :xs="24" :sm="12" :lg="6">
        <div class="metric-card">
          <div :class="['metric-card__icon', item.type]">
            <i :class="item.icon"></i>
          </div>
          <div>
            <span>{{ item.label }}</span>
            <strong>{{ item.value }}</strong>
            <p>{{ item.hint }}</p>
          </div>
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="16">
      <el-col :xs="24" :lg="15">
        <section class="dashboard-section">
          <div class="section-head">
            <div>
              <h2>课程运行概览</h2>
              <p>来自门户首页和后台课程列表的实时数据</p>
            </div>
            <el-button type="text" @click="$router.push('/course-square')">查看课程广场</el-button>
          </div>

          <div v-if="highlightCourses.length" class="course-list">
            <div
              v-for="course in highlightCourses"
              :key="course.courseId || course.courseName"
              class="course-row"
              @click="openCourse(course)"
            >
              <div class="course-row__cover">
                <img v-if="course.coverImage" :src="getCourseCover(course.coverImage)" :alt="course.courseName">
                <span v-else>{{ getCourseInitial(course.courseName) }}</span>
              </div>
              <div class="course-row__main">
                <div class="course-row__title">
                  <strong>{{ course.courseName || "未命名课程" }}</strong>
                  <el-tag size="mini" type="success" v-if="course.status === '0'">已发布</el-tag>
                  <el-tag size="mini" type="info" v-else-if="course.status">状态 {{ course.status }}</el-tag>
                </div>
                <p>{{ course.courseSubtitle || course.intro || course.categoryName || "暂无课程简介" }}</p>
                <div class="course-row__meta">
                  <span><i class="el-icon-user"></i>{{ course.teacherName || "未设置教师" }}</span>
                  <span><i class="el-icon-collection-tag"></i>{{ course.categoryName || "未分类" }}</span>
                  <span><i class="el-icon-thumb"></i>{{ course.likeCount || 0 }} 点赞</span>
                  <span><i class="el-icon-s-custom"></i>{{ course.enrollCount || 0 }} 注册</span>
                </div>
              </div>
            </div>
          </div>
          <el-empty v-else description="暂无可展示课程"></el-empty>
        </section>
      </el-col>

      <el-col :xs="24" :lg="9">
        <section class="dashboard-section">
          <div class="section-head">
            <div>
              <h2>快捷入口</h2>
              <p>按当前后台功能进入常用页面</p>
            </div>
          </div>
          <div class="quick-grid">
            <button v-for="item in quickLinks" :key="item.path" type="button" @click="$router.push(item.path)">
              <i :class="item.icon"></i>
              <span>{{ item.label }}</span>
            </button>
          </div>
        </section>

        <section class="dashboard-section notice-section" v-loading="noticeLoading">
          <div class="section-head">
            <div>
              <h2>系统公告</h2>
              <p>来自后台公告列表</p>
            </div>
            <el-button type="text" @click="$router.push('/system/notice')">管理公告</el-button>
          </div>
          <div v-if="notices.length" class="notice-list">
            <div v-for="notice in notices" :key="notice.noticeId" class="notice-item">
              <span>{{ notice.noticeTitle }}</span>
              <small>{{ parseTime(notice.createTime, "{m}-{d}") || "最新" }}</small>
            </div>
          </div>
          <el-empty v-else description="暂无公告" :image-size="80"></el-empty>
        </section>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { mapGetters } from "vuex"
import { getPortalHome } from "@/api/portal"
import { listCourse } from "@/api/edu/course"
import { listNoticeTop } from "@/api/system/notice"
import { resolveResourceUrl } from "@/utils/resource"

export default {
  name: "Dashboard",
  data() {
    return {
      loading: false,
      noticeLoading: false,
      homeData: {
        recommendCourses: [],
        hotCourses: [],
        latestCourses: [],
        categories: []
      },
      manageCourses: [],
      courseTotal: 0,
      notices: []
    }
  },
  computed: {
    ...mapGetters(["name", "nickName", "roles"]),
    displayName() {
      return this.nickName || this.name || "管理员"
    },
    greeting() {
      const hour = new Date().getHours()
      if (hour < 6) return "夜深了"
      if (hour < 12) return "上午好"
      if (hour < 18) return "下午好"
      return "晚上好"
    },
    highlightCourses() {
      return this.uniqueCourses([
        ...this.manageCourses,
        ...this.homeData.latestCourses,
        ...this.homeData.hotCourses,
        ...this.homeData.recommendCourses
      ]).slice(0, 6)
    },
    publicCourseCount() {
      return this.uniqueCourses([
        ...this.homeData.recommendCourses,
        ...this.homeData.hotCourses,
        ...this.homeData.latestCourses
      ]).length
    },
    metrics() {
      const total = this.courseTotal || this.publicCourseCount
      return [
        {
          label: "已发布课程",
          value: total,
          hint: this.courseTotal ? "来自后台课程列表" : "来自门户课程数据",
          icon: "el-icon-reading",
          type: "primary"
        },
        {
          label: "推荐课程",
          value: this.homeData.recommendCourses.length,
          hint: "门户首页推荐位",
          icon: "el-icon-star-on",
          type: "warning"
        },
        {
          label: "热门课程",
          value: this.homeData.hotCourses.length,
          hint: "按门户热门数据展示",
          icon: "el-icon-data-line",
          type: "danger"
        },
        {
          label: "课程分类",
          value: this.homeData.categories.length,
          hint: "当前公开分类数量",
          icon: "el-icon-folder-opened",
          type: "success"
        }
      ]
    },
    quickLinks() {
      return [
        { label: "课程管理", path: "/teaching/course", icon: "el-icon-reading" },
        { label: "试卷管理", path: "/teaching/paper", icon: "el-icon-document" },
        { label: "成绩统计", path: "/teaching/score", icon: "el-icon-s-data" },
        { label: "账号管理", path: "/account/all", icon: "el-icon-user" },
        { label: "课程广场", path: "/course-square", icon: "el-icon-collection" },
        { label: "返回主页", path: "/", icon: "el-icon-s-home" }
      ]
    }
  },
  created() {
    this.loadDashboard()
  },
  methods: {
    async loadDashboard() {
      this.loading = true
      try {
        await Promise.all([
          this.loadPortalHome(),
          this.loadCourseSummary(),
          this.loadNotices()
        ])
      } finally {
        this.loading = false
      }
    },
    async loadPortalHome() {
      try {
        const res = await getPortalHome()
        const data = res.data || {}
        this.homeData = {
          recommendCourses: data.recommendCourses || [],
          hotCourses: data.hotCourses || [],
          latestCourses: data.latestCourses || [],
          categories: data.categories || []
        }
      } catch (error) {
        this.homeData = {
          recommendCourses: [],
          hotCourses: [],
          latestCourses: [],
          categories: []
        }
      }
    },
    async loadCourseSummary() {
      try {
        const res = await listCourse({ pageNum: 1, pageSize: 6 })
        this.manageCourses = res.rows || []
        this.courseTotal = Number(res.total || this.manageCourses.length || 0)
      } catch (error) {
        this.manageCourses = []
        this.courseTotal = 0
      }
    },
    async loadNotices() {
      this.noticeLoading = true
      try {
        const res = await listNoticeTop()
        this.notices = (res.rows || res.data || []).slice(0, 5)
      } catch (error) {
        this.notices = []
      } finally {
        this.noticeLoading = false
      }
    },
    uniqueCourses(courses) {
      const map = new Map()
      courses.filter(Boolean).forEach(course => {
        const key = course.courseId || course.courseName
        if (key && !map.has(key)) {
          map.set(key, course)
        }
      })
      return Array.from(map.values())
    },
    getCourseCover(cover) {
      if (!cover) {
        return ""
      }
      return resolveResourceUrl(cover)
    },
    getCourseInitial(name) {
      return (name || "课程").slice(0, 2)
    },
    openCourse(course) {
      if (course.courseId) {
        this.$router.push(`/course/${course.courseId}`)
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.dashboard-page {
  min-height: calc(100vh - 84px);
  padding: 24px;
  background: #f4f6f8;
}

.dashboard-head,
.dashboard-section,
.metric-card {
  background: #ffffff;
  border: 1px solid #e7eaf0;
  border-radius: 8px;
}

.dashboard-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 22px 24px;
  margin-bottom: 16px;
}

.dashboard-head__eyebrow {
  margin: 0 0 6px;
  color: #409eff;
  font-size: 13px;
  font-weight: 600;
}

.dashboard-head h1 {
  margin: 0;
  color: #1f2d3d;
  font-size: 26px;
  font-weight: 700;
}

.dashboard-head__summary {
  margin: 8px 0 0;
  color: #606266;
  font-size: 14px;
}

.dashboard-head__actions {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  justify-content: flex-end;
}

.metric-grid {
  margin-bottom: 16px;
}

.metric-card {
  display: flex;
  min-height: 120px;
  gap: 14px;
  padding: 18px;
  margin-bottom: 16px;
}

.metric-card__icon {
  width: 44px;
  height: 44px;
  border-radius: 8px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: #ffffff;
  font-size: 22px;
}

.metric-card__icon.primary {
  background: #409eff;
}

.metric-card__icon.warning {
  background: #e6a23c;
}

.metric-card__icon.danger {
  background: #f56c6c;
}

.metric-card__icon.success {
  background: #67c23a;
}

.metric-card span {
  display: block;
  color: #606266;
  font-size: 13px;
}

.metric-card strong {
  display: block;
  margin-top: 4px;
  color: #1f2d3d;
  font-size: 28px;
  line-height: 1.2;
}

.metric-card p {
  margin: 6px 0 0;
  color: #909399;
  font-size: 12px;
}

.dashboard-section {
  padding: 18px;
  margin-bottom: 16px;
}

.section-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 14px;
}

.section-head h2 {
  margin: 0;
  color: #1f2d3d;
  font-size: 18px;
}

.section-head p {
  margin: 6px 0 0;
  color: #909399;
  font-size: 13px;
}

.course-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.course-row {
  display: flex;
  gap: 14px;
  padding: 12px;
  border: 1px solid #ebeef5;
  border-radius: 8px;
  cursor: pointer;
  transition: border-color .2s ease, background-color .2s ease;
}

.course-row:hover {
  border-color: #b3d8ff;
  background: #f8fbff;
}

.course-row__cover {
  width: 116px;
  height: 72px;
  border-radius: 6px;
  overflow: hidden;
  flex: 0 0 116px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #409eff;
  background: #ecf5ff;
  font-weight: 700;
}

.course-row__cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.course-row__main {
  min-width: 0;
  flex: 1;
}

.course-row__title {
  display: flex;
  align-items: center;
  gap: 8px;
  min-width: 0;
}

.course-row__title strong {
  color: #303133;
  font-size: 15px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.course-row__main p {
  margin: 8px 0;
  color: #606266;
  font-size: 13px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.course-row__meta {
  display: flex;
  flex-wrap: wrap;
  gap: 8px 14px;
  color: #909399;
  font-size: 12px;
}

.course-row__meta i {
  margin-right: 4px;
}

.quick-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 10px;
}

.quick-grid button {
  height: 58px;
  border: 1px solid #ebeef5;
  border-radius: 8px;
  background: #ffffff;
  color: #303133;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  cursor: pointer;
  transition: border-color .2s ease, color .2s ease, background-color .2s ease;
}

.quick-grid button:hover {
  border-color: #409eff;
  color: #409eff;
  background: #f8fbff;
}

.quick-grid i {
  font-size: 18px;
}

.notice-section {
  min-height: 260px;
}

.notice-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.notice-item {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  padding: 10px 0;
  border-bottom: 1px solid #ebeef5;
}

.notice-item:last-child {
  border-bottom: 0;
}

.notice-item span {
  min-width: 0;
  color: #303133;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.notice-item small {
  color: #909399;
  flex: 0 0 auto;
}

@media (max-width: 768px) {
  .dashboard-page {
    padding: 12px;
  }

  .dashboard-head {
    align-items: flex-start;
    flex-direction: column;
  }

  .dashboard-head__actions {
    width: 100%;
    justify-content: flex-start;
  }

  .course-row {
    flex-direction: column;
  }

  .course-row__cover {
    width: 100%;
    height: 150px;
    flex-basis: auto;
  }

  .quick-grid {
    grid-template-columns: 1fr;
  }
}
</style>
