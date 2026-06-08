<template>
  <div v-loading="loading" class="dashboard-home">
    <portal-topbar active="home" />

    <div class="dashboard-shell">
      <section class="dashboard-hero">
        <div class="dashboard-hero__content">
          <p class="dashboard-hero__kicker">{{ isTeacherOrAdmin ? "Online Teaching Platform" : "Online Learning Portal" }}</p>
          <h1>{{ heroTitle }}</h1>
          <p class="dashboard-hero__summary">{{ heroSummary }}</p>
          <div class="dashboard-hero__tags">
            <span class="hero-tag">{{ isStudent ? "课程学习" : "课程展示" }}</span>
            <span class="hero-tag">{{ isStudent ? "学习进度" : "课件资料" }}</span>
            <span class="hero-tag">{{ isStudent ? "考试准备" : "考试测评" }}</span>
          </div>
          <div class="dashboard-hero__actions">
            <el-button class="primary-action" @click="goCourseSquare">查看课程广场</el-button>
            <el-button v-if="isStudent" class="secondary-action" @click="goMyCourses">继续学习</el-button>
            <el-button v-else-if="isTeacherOrAdmin" class="secondary-action" @click="goCourseManage">课程管理</el-button>
            <el-button v-else class="secondary-action" @click="goLoginWithRedirect('/learning/my-course')">登录学习</el-button>
          </div>
        </div>

        <div class="dashboard-hero__visual">
          <div class="hero-illustration-wrap">
            <img
              class="hero-illustration-img"
              :src="heroIllustration"
              alt="在线学习插画"
            >
            <div class="hero-floating-card hero-floating-card--top">
              <i class="el-icon-star-on"></i>
              <div>
                <strong>{{ homeData.recommendCourses.length }}</strong>
                <span>推荐课程</span>
              </div>
            </div>

            <div class="hero-floating-card hero-floating-card--bottom">
              <i class="el-icon-time"></i>
              <div>
                <strong>{{ homeData.latestCourses.length }}</strong>
                <span>最新更新</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="search-panel">
        <div class="search-panel__main">
          <h2 class="search-panel__title">搜索课程、教师与学习关键词</h2>
          <div class="search-panel__bar">
            <el-input
              v-model.trim="searchKeyword"
              placeholder="搜索课程名称、教师、关键词"
              clearable
              prefix-icon="el-icon-search"
              @keyup.enter.native="handleSearch"
            />
            <el-button class="primary-action" @click="handleSearch">搜索课程</el-button>
          </div>
        </div>
        <div class="search-panel__actions">
          <div class="search-panel__chip-list">
            <button class="search-chip" @click="goCourseSquare">课程广场</button>
            <button class="search-chip" @click="goProfile">个人中心</button>
            <button v-if="isStudent" class="search-chip" @click="goMyCourses">我的课程</button>
            <button v-else-if="isTeacherOrAdmin" class="search-chip" @click="goCourseManage">课程管理</button>
            <button v-else class="search-chip" @click="goLoginWithRedirect('/learning/my-course')">登录学习</button>
          </div>
        </div>
      </section>

      <section v-if="homeVisualCourses.length" class="home-visual-section">
        <div class="home-visual-section__head">
          <div>
            <h2>推荐课程</h2>
          </div>
          <div class="home-visual-section__summary">
            <span class="home-visual-section__count">当前展示 {{ homeVisualCourses.length }} 个推荐</span>
          </div>
        </div>

        <el-carousel
          class="home-visual-carousel"
          height="340px"
          indicator-position="outside"
          arrow="always"
          :interval="4200"
        >
          <el-carousel-item v-for="(course, index) in homeVisualCourses" :key="course.bannerId || course.courseId || index">
            <div class="home-visual-slide" @click="handleBannerClick(course)">
              <div class="home-visual-slide__content">
                <div class="home-visual-slide__meta">
                  <span class="home-visual-slide__category">{{ course.categoryName || "首页推荐" }}</span>
                  <span v-if="changedCourseIds.includes(course.courseId)" class="home-visual-slide__new">新</span>
                  <span class="home-visual-slide__index">0{{ index + 1 }}</span>
                </div>
                <h3>{{ course.bannerTitle || course.courseName }}</h3>
                <p>{{ course.courseSubtitle || course.intro || "暂无课程简介" }}</p>
                <div class="home-visual-slide__stats">
                  <span>注册 {{ course.enrollCount || 0 }}</span>
                  <span>点赞 {{ course.likeCount || 0 }}</span>
                  <span>教师 {{ course.teacherName || "未设置" }}</span>
                </div>
                <div class="home-visual-slide__actions">
                  <el-button class="primary-action" @click.stop="handleBannerClick(course)">查看推荐内容</el-button>
                  <el-button class="secondary-action" @click.stop="goCourseSquare">进入课程广场</el-button>
                </div>
              </div>
              <div class="home-visual-slide__cover">
                <div class="home-visual-slide__cover-inner">
                  <img :src="getCourseCover(course.bannerImage || course.coverImage)" :alt="course.bannerTitle || course.courseName">
                </div>
                <div class="home-visual-slide__cover-mask"></div>
                <div class="home-visual-slide__cover-content">
                  <span class="home-visual-slide__cover-label">{{ course.categoryName || "课程推荐" }}</span>
                  <strong>{{ course.teacherName || "首页轮播" }}</strong>
                </div>
              </div>
            </div>
          </el-carousel-item>
        </el-carousel>
      </section>

      <transition name="notice-fade">
        <section v-if="showChangeNotice" class="change-notice">
          <i class="el-icon-bell change-notice__icon"></i>
          <div class="notice-marquee">
            <div class="notice-marquee__track">
              <span v-for="(tip, index) in marqueeTips" :key="index" class="notice-marquee__item">
                {{ tip }}
              </span>
            </div>
          </div>
        </section>
      </transition>

      <section class="overview-section">
        <div class="section-heading">
          <h2>常用入口</h2>
        </div>
        <div class="overview-grid">
          <button type="button" class="overview-card overview-card--blue" @click="goCourseSquare">
            <div class="overview-card__top">
              <div class="overview-card__icon overview-card__icon--blue">
                <i class="el-icon-reading"></i>
              </div>
              <i class="el-icon-arrow-right overview-card__arrow"></i>
            </div>
            <div class="overview-card__title">课程学习</div>
          </button>
          <button type="button" class="overview-card overview-card--cyan" @click="handlePathCardClick">
            <div class="overview-card__top">
              <div class="overview-card__icon overview-card__icon--cyan">
                <i class="el-icon-data-analysis"></i>
              </div>
              <i class="el-icon-arrow-right overview-card__arrow"></i>
            </div>
            <div class="overview-card__title">考试测评</div>
          </button>
          <button type="button" class="overview-card overview-card--orange" @click="goCourseManage">
            <div class="overview-card__top">
              <div class="overview-card__icon overview-card__icon--orange">
                <i class="el-icon-s-management"></i>
              </div>
              <i class="el-icon-arrow-right overview-card__arrow"></i>
            </div>
            <div class="overview-card__title">{{ isTeacherOrAdmin ? "教学管理" : "登录学习" }}</div>
          </button>
        </div>
      </section>

      <section class="course-section-wrap">
        <course-section
          v-if="isStudent"
          title="我的课程"
          kicker="Continue Learning"
          :courses="myCourses"
          :changed-course-ids="changedCourseIds"
          :show-more="true"
        />
        <course-section
          v-else
          title="推荐课程"
          kicker="Featured Courses"
          :courses="homeData.recommendCourses"
          :changed-course-ids="changedCourseIds"
          :show-more="true"
        />
      </section>

      <section class="course-section-wrap">
        <course-section
          title="最新课程"
          kicker="Recently Updated"
          :courses="homeData.latestCourses"
          :changed-course-ids="changedCourseIds"
          :show-more="true"
        />
      </section>
    </div>
  </div>
</template>

<script>
import { mapGetters } from "vuex"
import { getPortalHome, listMyPortalCourses } from "@/api/portal"
import CourseSection from "@/views/course/components/CourseSection"
import PortalTopbar from "@/components/PortalTopbar"
import heroIllustration from "@/assets/images/education-hero.svg"
import coursePlaceholder from "@/assets/images/course-placeholder.svg"
import { getToken } from "@/utils/auth"
import { resolveResourceUrl } from "@/utils/resource"

export default {
  name: "Index",
  components: { CourseSection, PortalTopbar },
  data() {
    return {
      heroIllustration,
      coursePlaceholder,
      loading: false,
      searchKeyword: "",
      changeTips: [],
      changedCourseIds: [],
      showChangeNotice: false,
      myCourses: [],
      homeData: {
        recommendCourses: [],
        hotCourses: [],
        latestCourses: [],
        banners: []
      }
    }
  },
  computed: {
    ...mapGetters(["roles"]),
    /** 当前是否为学生 */
    isStudent() {
      return this.roles.includes("student")
    },
    /** 当前是否为教师或管理员 */
    isTeacherOrAdmin() {
      return this.roles.includes("teacher") || this.roles.includes("admin")
    },
    isGuestVisitor() {
      return !this.isStudent && !this.isTeacherOrAdmin
    },
    /** 首页标题文案 */
    heroTitle() {
      return this.isStudent
        ? "让学习更高效，让课程进度更清晰"
        : "一站式在线课程学习与教学管理平台"
    },
    /** 首页摘要文案 */
    heroSummary() {
      return this.isStudent
        ? "聚合课程展示、在线学习、课件资料与考试测评能力，帮助你快速找到正在学习的内容，也更高效地规划学习路径。"
        : "聚合课程展示、在线学习、课件资料、考试测评与教学管理能力，帮助学生快速学习，也让教师更高效地管理课程内容。"
    },
    /** 首页主视觉轮播数据 */
    homeVisualCourses() {
      return (this.homeData.banners || []).slice(0, 5)
    },
    /** 跑马灯展示文案 */
    marqueeTips() {
      return this.changeTips.length ? [...this.changeTips, ...this.changeTips] : []
    }
  },
  created() {
    this.initHomeData()
  },
  methods: {
    /** 初始化首页数据并检测变化 */
    async initHomeData() {
      this.loading = true
      try {
        await this.getHomeData()
        if (this.isStudent) {
          await this.getMyCourses()
        } else {
          this.myCourses = []
        }
        this.compareHomeSnapshot()
      } finally {
        this.loading = false
      }
    },
    /** 加载门户首页聚合数据 */
    getHomeData() {
      return getPortalHome().then(res => {
        const data = res.data || {}
        this.homeData = {
          recommendCourses: data.recommendCourses || [],
          hotCourses: data.hotCourses || [],
          latestCourses: data.latestCourses || [],
          banners: data.banners || []
        }
      })
    },
    /** 加载当前学生已注册课程 */
    getMyCourses() {
      return listMyPortalCourses().then(res => {
        this.myCourses = res.data || []
      })
    },
    /** 构建首页课程快照 */
    buildCourseSnapshot() {
      return {
        recommendIds: (this.homeData.recommendCourses || []).map(item => item.courseId),
        hotIds: (this.homeData.hotCourses || []).map(item => item.courseId),
        latestIds: (this.homeData.latestCourses || []).map(item => item.courseId),
        myCourseIds: (this.myCourses || []).map(item => item.courseId)
      }
    },
    /** 对比首页刷新前后的课程变化 */
    compareHomeSnapshot() {
      if (typeof window === "undefined") {
        return
      }
      const storageKey = "portal_home_course_snapshot"
      const oldSnapshot = JSON.parse(localStorage.getItem(storageKey) || "{}")
      const newSnapshot = this.buildCourseSnapshot()
      const isFirstSnapshot = !oldSnapshot.recommendIds && !oldSnapshot.hotIds && !oldSnapshot.latestIds && !oldSnapshot.myCourseIds
      const tips = []
      const changedIds = []

      if (isFirstSnapshot) {
        localStorage.setItem(storageKey, JSON.stringify(newSnapshot))
        this.changeTips = []
        this.changedCourseIds = []
        this.showChangeNotice = false
        return
      }

      const collectNewIds = (oldIds = [], newIds = []) => newIds.filter(id => !oldIds.includes(id))
      const collectCountChange = (label, oldIds = [], newIds = []) => {
        if (oldIds.length !== newIds.length) {
          tips.push(`${label}数量变为 ${newIds.length} 门`)
        }
      }

      const newRecommendIds = collectNewIds(oldSnapshot.recommendIds, newSnapshot.recommendIds)
      const newHotIds = collectNewIds(oldSnapshot.hotIds, newSnapshot.hotIds)
      const newLatestIds = collectNewIds(oldSnapshot.latestIds, newSnapshot.latestIds)
      const newMyCourseIds = collectNewIds(oldSnapshot.myCourseIds, newSnapshot.myCourseIds)

      if (newRecommendIds.length) {
        tips.push(`新增 ${newRecommendIds.length} 门推荐课程`)
        changedIds.push(...newRecommendIds)
      }
      if (newHotIds.length) {
        tips.push(`新增 ${newHotIds.length} 门热门课程`)
        changedIds.push(...newHotIds)
      }
      if (newLatestIds.length) {
        tips.push(`新增 ${newLatestIds.length} 门最新课程`)
        changedIds.push(...newLatestIds)
      }
      if (newMyCourseIds.length) {
        tips.push(`你的课程新增 ${newMyCourseIds.length} 门`)
        changedIds.push(...newMyCourseIds)
      }

      collectCountChange("推荐课程", oldSnapshot.recommendIds || [], newSnapshot.recommendIds || [])
      collectCountChange("热门课程", oldSnapshot.hotIds || [], newSnapshot.hotIds || [])
      collectCountChange("最新课程", oldSnapshot.latestIds || [], newSnapshot.latestIds || [])
      collectCountChange("我的课程", oldSnapshot.myCourseIds || [], newSnapshot.myCourseIds || [])

      this.changeTips = Array.from(new Set(tips))
      this.changedCourseIds = Array.from(new Set(changedIds))
      this.showChangeNotice = this.changeTips.length > 0

      localStorage.setItem(storageKey, JSON.stringify(newSnapshot))
    },
    /** 跳转课程广场 */
    goCourseSquare() {
      this.$router.push("/course-square")
    },
    /** 跳转我的课程 */
    goMyCourses() {
      if (!getToken()) {
        this.goLoginWithRedirect("/learning/my-course")
        return
      }
      this.$router.push("/learning/my-course")
    },
    /** 跳转个人中心 */
    goProfile() {
      if (!getToken()) {
        this.goLoginWithRedirect("/user/profile")
        return
      }
      this.$router.push("/user/profile")
    },
    /** 根据角色跳转学习路径卡片 */
    handlePathCardClick() {
      if (this.isStudent) {
        this.goMyCourses()
        return
      }
      this.goCourseSquare()
    },
    /** 跳转课程管理 */
    goCourseManage() {
      if (!getToken()) {
        this.goLoginWithRedirect("/teaching/course")
        return
      }
      if (!this.isTeacherOrAdmin) {
        this.goLoginWithRedirect("/learning/my-course")
        return
      }
      this.$router.push("/teaching/course")
    },
    /** 未登录时带目标地址进入登录页 */
    goLoginWithRedirect(redirect) {
      this.$router.push({
        path: "/login",
        query: { redirect }
      })
    },
    /** 跳转课程详情 */
    openCourseDetail(courseId) {
      if (!courseId) {
        this.goCourseSquare()
        return
      }
      this.$router.push(`/course/${courseId}`)
    },
    /** 打开首页推荐内容 */
    handleBannerClick(banner) {
      if (banner && banner.jumpUrl) {
        window.open(banner.jumpUrl, "_blank")
        return
      }
      this.openCourseDetail(banner && banner.courseId)
    },
    /** 获取课程封面地址 */
    getCourseCover(cover) {
      if (!cover) {
        return this.coursePlaceholder
      }
      return resolveResourceUrl(cover)
    },
    /** 搜索课程并跳转到课程广场 */
    handleSearch() {
      this.$router.push({
        path: "/course-square",
        query: this.searchKeyword ? { keyword: this.searchKeyword } : {}
      })
    }
  }
}
</script>

<style lang="scss" scoped>
$portal-page-bg:
  radial-gradient(circle at 10% 10%, rgba(59, 130, 246, 0.08), transparent 22%),
  radial-gradient(circle at 22% 64%, rgba(45, 212, 191, 0.06), transparent 16%),
  linear-gradient(180deg, #f7faff 0%, #eef5ff 20%, #eef4fb 52%, #f2f5f9 100%);
$portal-surface-bg: rgba(255, 255, 255, 0.88);
$portal-surface-border: rgba(226, 232, 240, 0.92);
$portal-surface-shadow: 0 10px 28px rgba(15, 23, 42, 0.06);

.dashboard-home {
  min-height: 100vh;
  padding: 0 0 40px;
  background: $portal-page-bg;
}

.dashboard-shell {
  position: relative;
  min-height: 100vh;
  padding: 10px clamp(12px, 1.8vw, 20px) 0;
  overflow-x: hidden;
}

.dashboard-hero,
.home-visual-section {
  max-width: 1460px;
  margin-right: auto;
  margin-left: auto;
}

.search-panel,
.change-notice,
.overview-section,
.course-section-wrap,
.footer-note {
  max-width: 1340px;
  margin-right: auto;
  margin-left: auto;
}

.dashboard-hero {
  position: relative;
  display: grid;
  grid-template-columns: minmax(0, 1.05fr) minmax(360px, 0.95fr);
  gap: 48px;
  overflow: visible;
  margin-bottom: 28px;
  padding: 34px 38px;
  border-radius: 24px;
  border: 1px solid $portal-surface-border;
  background: $portal-surface-bg;
  box-shadow: $portal-surface-shadow;
}

.dashboard-hero__content,
.dashboard-hero__visual {
  position: relative;
  z-index: 1;
}

.dashboard-hero__kicker {
  margin: 0;
  color: #2563eb;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 2px;
}

.dashboard-hero h1 {
  margin: 14px 0 0;
  color: #0f172a;
  max-width: 620px;
  font-size: 42px;
  line-height: 1.2;
  letter-spacing: -0.03em;
  text-wrap: balance;
}

.dashboard-hero__summary {
  max-width: 640px;
  margin: 18px 0 0;
  color: #475569;
  font-size: 16px;
  line-height: 1.8;
}

.dashboard-hero__tags {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 18px;
}

.hero-tag {
  padding: 8px 12px;
  border: 1px solid rgba(191, 219, 254, 0.9);
  border-radius: 999px;
  background: #ffffff;
  color: #1d4ed8;
  font-size: 12px;
  font-weight: 600;
}

.dashboard-hero__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-top: 28px;
}

.dashboard-hero__actions ::v-deep .el-button,
.search-panel__bar ::v-deep .el-button,
.quick-actions ::v-deep .el-button {
  transition: all 0.2s ease;
}

.dashboard-hero__actions ::v-deep .el-button:hover,
.search-panel__bar ::v-deep .el-button:hover,
.quick-actions ::v-deep .el-button:hover {
  transform: translateY(-2px);
}

.dashboard-hero__visual {
  min-height: 400px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.hero-illustration-wrap {
  position: relative;
  width: min(520px, 100%);
  display: flex;
  align-items: center;
  justify-content: center;
}

.hero-illustration-img {
  width: 100%;
  max-width: 520px;
  display: block;
  object-fit: contain;
  filter: drop-shadow(0 18px 30px rgba(15, 23, 42, 0.1));
  animation: heroFloat 5s ease-in-out infinite;
}

.hero-floating-card {
  position: absolute;
  z-index: 2;
  display: flex;
  align-items: center;
  gap: 12px;
  min-width: 144px;
  max-width: 168px;
  padding: 12px 14px;
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.94);
  border: 1px solid rgba(226, 232, 240, 0.92);
  box-shadow: 0 12px 24px rgba(15, 23, 42, 0.08);
}

.hero-floating-card i {
  width: 38px;
  height: 38px;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #eff6ff;
  color: #2563eb;
  font-size: 20px;
}

.hero-floating-card strong {
  display: block;
  color: #0f172a;
  font-size: 20px;
}

.hero-floating-card span {
  color: #64748b;
  font-size: 12px;
}

.hero-floating-card--top {
  top: 16px;
  left: -16px;
}

.hero-floating-card--bottom {
  right: -16px;
  bottom: 16px;
}

.search-panel {
  display: grid;
  grid-template-columns: minmax(0, 1.6fr) minmax(240px, 0.9fr);
  gap: 24px;
  align-items: center;
  margin-bottom: 24px;
  padding: 24px;
  border: 1px solid rgba(226, 232, 240, 0.92);
  border-radius: 22px;
  background: #ffffff;
  box-shadow: 0 10px 28px rgba(15, 23, 42, 0.05);
}

.search-panel__title {
  margin: 8px 0 0;
  color: #0f172a;
  font-size: 28px;
  text-wrap: balance;
}

.home-visual-section {
  margin-bottom: 28px;
}

.home-visual-section__head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 16px;
}

.home-visual-section__summary {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 6px;
}

.home-visual-section__head h2 {
  margin: 6px 0 0;
  color: #0f172a;
  font-size: 28px;
  text-wrap: balance;
}

.home-visual-section__count {
  display: inline-flex;
  align-items: center;
  padding: 6px 12px;
  border-radius: 999px;
  background: rgba(37, 99, 235, 0.08);
  color: #1d4ed8;
  font-size: 12px;
  font-weight: 600;
}

.home-visual-carousel {
  border-radius: 22px;
  overflow: hidden;
  border: 1px solid rgba(226, 232, 240, 0.92);
  box-shadow: 0 10px 26px rgba(15, 23, 42, 0.05);
}

.home-visual-carousel ::v-deep .el-carousel__arrow {
  width: 42px;
  height: 42px;
  background: rgba(255, 255, 255, 0.88);
  color: #2563eb;
  box-shadow: 0 10px 28px rgba(15, 23, 42, 0.12);
}

.home-visual-carousel ::v-deep .el-carousel__indicator button {
  width: 22px;
  height: 6px;
  border-radius: 999px;
  background: rgba(148, 163, 184, 0.45);
}

.home-visual-carousel ::v-deep .el-carousel__indicator.is-active button {
  background: #2563eb;
}

.home-visual-slide {
  position: relative;
  display: grid;
  grid-template-columns: minmax(0, 1.3fr) minmax(300px, 0.9fr);
  gap: 24px;
  height: 100%;
  padding: 28px;
  background: linear-gradient(135deg, #f8fbff 0%, #ffffff 62%, #f2fbfd 100%);
  cursor: pointer;
}

.home-visual-slide__content,
.home-visual-slide__cover {
  position: relative;
  z-index: 1;
  height: 100%;
}

.home-visual-slide__meta,
.home-visual-slide__stats,
.home-visual-slide__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 10px 14px;
}

.home-visual-slide__category {
  padding: 6px 12px;
  border-radius: 999px;
  background: rgba(37, 99, 235, 0.12);
  color: #1d4ed8;
  font-size: 12px;
  font-weight: 700;
}

.home-visual-slide__new {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 32px;
  height: 20px;
  padding: 0 8px;
  border-radius: 999px;
  background: linear-gradient(135deg, #ff7a45, #ff4d4f);
  color: #fff;
  font-size: 12px;
  font-weight: 600;
  box-shadow: 0 6px 14px rgba(255, 77, 79, 0.25);
}

.home-visual-slide__index {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 38px;
  height: 24px;
  padding: 0 10px;
  border: 1px solid rgba(37, 99, 235, 0.16);
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.78);
  color: #2563eb;
  font-size: 12px;
  font-weight: 700;
}

.home-visual-slide h3 {
  margin: 18px 0 12px;
  color: #0f172a;
  font-size: 30px;
  line-height: 1.25;
  text-wrap: balance;
}

.home-visual-slide p {
  margin: 0;
  color: #475569;
  line-height: 1.85;
}

.home-visual-slide__stats {
  margin-top: 20px;
  color: #64748b;
  font-size: 13px;
}

.home-visual-slide__actions {
  margin-top: 24px;
}

.home-visual-slide__cover {
  overflow: hidden;
  border-radius: 18px;
  background: linear-gradient(135deg, #dbeafe 0%, #ecfeff 100%);
  box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.5);
}

.home-visual-slide__cover-inner {
  position: absolute;
  inset: 0;
}

.home-visual-slide__cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transform: scale(1.04);
  transition: transform 8s linear;
}

.home-visual-slide__cover-mask {
  position: absolute;
  inset: 0;
  background: linear-gradient(90deg, rgba(15, 23, 42, 0.82), rgba(15, 23, 42, 0.32));
}

.home-visual-slide__cover-content {
  position: absolute;
  right: 22px;
  bottom: 22px;
  left: 22px;
  display: flex;
  flex-direction: column;
  gap: 8px;
  color: #fff;
}

.home-visual-slide__cover-label {
  display: inline-flex;
  align-items: center;
  width: fit-content;
  padding: 6px 12px;
  border: 1px solid rgba(255, 255, 255, 0.22);
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.12);
  font-size: 12px;
}

.home-visual-slide__cover-content strong {
  font-size: 20px;
  line-height: 1.3;
}

.home-visual-carousel ::v-deep .el-carousel__item.is-active .home-visual-slide__cover img {
  transform: scale(1.1);
}

.search-panel__bar {
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 12px;
  margin-top: 10px;
}

.search-panel__actions {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 12px;
}

.search-panel__chip-list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.search-chip {
  padding: 10px 14px;
  border: 1px solid rgba(37, 99, 235, 0.12);
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.72);
  color: #2563eb;
  cursor: pointer;
  font-size: 13px;
  transition: all 0.2s ease;
}

.search-chip:hover {
  transform: translateY(-2px);
  border-color: rgba(37, 99, 235, 0.22);
  box-shadow: 0 12px 20px rgba(37, 99, 235, 0.08);
}

.change-notice {
  display: flex;
  align-items: center;
  gap: 12px;
  overflow: hidden;
  margin-bottom: 24px;
  padding: 14px 18px;
  border: 1px solid rgba(191, 219, 254, 0.9);
  border-radius: 16px;
  background: #ffffff;
  box-shadow: 0 8px 20px rgba(59, 130, 246, 0.05);
}

.change-notice__icon {
  flex: none;
  color: #2563eb;
  font-size: 18px;
}

.notice-marquee {
  position: relative;
  flex: 1;
  overflow: hidden;
}

.notice-marquee__track {
  display: inline-flex;
  align-items: center;
  gap: 28px;
  min-width: max-content;
  animation: marquee-scroll 14s linear infinite;
}

.notice-marquee__item {
  position: relative;
  color: #1e40af;
  font-size: 14px;
  white-space: nowrap;
}

.notice-marquee__item::after {
  content: "";
  position: absolute;
  top: 50%;
  right: -14px;
  width: 6px;
  height: 6px;
  border-radius: 999px;
  background: rgba(59, 130, 246, 0.35);
  transform: translateY(-50%);
}

.overview-section {
  margin-bottom: 10px;
}

.section-heading {
  margin-bottom: 24px;
}

.section-heading h2 {
  margin: 0;
  color: #0f172a;
  font-size: 34px;
  text-wrap: balance;
}

.overview-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 18px;
}

.overview-card {
  position: relative;
  min-height: 180px;
  height: 100%;
  overflow: hidden;
  border: 1px solid rgba(226, 232, 240, 0.92);
  border-radius: 18px;
  cursor: pointer;
  background: #ffffff;
  box-shadow: 0 10px 26px rgba(15, 23, 42, 0.05);
  transition: transform 0.22s ease, border-color 0.22s ease, box-shadow 0.22s ease;
  padding: 24px;
  text-align: left;
}

.overview-card:hover {
  transform: translateY(-4px);
  border-color: rgba(96, 165, 250, 0.72);
  box-shadow: 0 14px 28px rgba(15, 23, 42, 0.07);
}

.overview-card:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.18);
}

.overview-card__top {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.overview-card__icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
  margin-bottom: 16px;
  border-radius: 14px;
  font-size: 20px;
}

.overview-card__icon--blue {
  background: rgba(59, 130, 246, 0.12);
  color: #2563eb;
}

.overview-card__icon--cyan {
  background: rgba(34, 211, 238, 0.14);
  color: #0891b2;
}

.overview-card__icon--orange {
  background: rgba(251, 146, 60, 0.14);
  color: #ea580c;
}

.overview-card__arrow {
  color: #94a3b8;
  transition: all 0.2s ease;
}

.overview-card:hover .overview-card__arrow {
  color: #2563eb;
  transform: translateX(4px);
}

.overview-card__title {
  margin-bottom: 14px;
  color: #0f172a;
  font-size: 22px;
  font-weight: 700;
}

.course-section-wrap {
  margin-top: 12px;
}

.primary-action,
.secondary-action {
  border-radius: 999px;
  padding: 12px 22px;
  font-weight: 600;
}

.primary-action {
  border: none;
  background: linear-gradient(135deg, #2563eb, #38bdf8);
  color: #fff;
  box-shadow: 0 14px 26px rgba(37, 99, 235, 0.22);
}

.primary-action:hover,
.primary-action:focus {
  color: #fff;
  background: linear-gradient(135deg, #1d4ed8, #0ea5e9);
}

.secondary-action {
  border: 1px solid rgba(37, 99, 235, 0.18);
  background: rgba(255, 255, 255, 0.72);
  color: #2563eb;
}

.secondary-action:hover,
.secondary-action:focus {
  color: #1d4ed8;
  border-color: rgba(37, 99, 235, 0.28);
  background: rgba(255, 255, 255, 0.88);
}

.notice-fade-enter-active,
.notice-fade-leave-active {
  transition: all 0.25s ease;
}

.notice-fade-enter,
.notice-fade-leave-to {
  opacity: 0;
  transform: translateY(-6px);
}

@keyframes marquee-scroll {
  0% {
    transform: translateX(0);
  }
  100% {
    transform: translateX(-50%);
  }
}

@keyframes heroFloat {
  0%,
  100% {
    transform: translateY(0);
  }

  50% {
    transform: translateY(-8px);
  }
}

@media screen and (max-width: 1100px) {
  .dashboard-home {
    padding-bottom: 30px;
  }

  .dashboard-shell {
    padding: 12px 12px 0;
  }

  .dashboard-hero {
    grid-template-columns: 1fr;
    padding: 24px 20px;
  }

  .dashboard-hero h1 {
    font-size: 34px;
  }

  .dashboard-hero__visual {
    min-height: auto;
    margin-top: 32px;
  }

  .hero-illustration-wrap {
    width: 100%;
    max-width: 460px;
  }

  .hero-floating-card--top,
  .hero-floating-card--bottom {
    position: static;
    margin-top: 14px;
  }

  .search-panel {
    grid-template-columns: 1fr;
  }

  .home-visual-section__head,
  .home-visual-slide {
    grid-template-columns: 1fr;
  }

  .home-visual-section__summary {
    align-items: flex-start;
  }

  .home-visual-slide {
    padding: 24px;
  }

  .home-visual-slide__cover {
    min-height: 220px;
  }

  .home-visual-carousel {
    border-radius: 24px;
  }

  .home-visual-slide h3 {
    font-size: 28px;
  }

  .search-panel__bar {
    grid-template-columns: 1fr;
  }

  .search-panel__actions {
    width: 100%;
  }

  .overview-grid {
    grid-template-columns: 1fr;
  }

  .change-notice {
    align-items: flex-start;
  }
}
</style>
