<template>
  <div v-loading="pageLoading" class="course-square-page">
    <portal-topbar
      active="course-square"
      context-title="课程广场"
      context-summary="搜索、筛选与浏览公开课程"
    />

    <transition name="keyword-tip-fade">
      <div v-if="hasKeywordSearch" class="keyword-search-tip">
        <i class="el-icon-search"></i>
        <span>当前搜索关键词：{{ queryParams.keyword }}</span>
        <el-button type="text" @click="resetQuery">清除搜索</el-button>
      </div>
    </transition>

    <section class="portal-hero">
      <div class="portal-hero__content">
        <p class="portal-hero__kicker">{{ heroKicker }}</p>
        <h1>在线课程广场</h1>
        <p class="portal-hero__summary">{{ heroSummary }}</p>
        <div class="portal-hero__actions">
          <template v-if="!isLogin">
            <el-button type="primary" @click="$router.push('/login')">登录学习</el-button>
            <el-button @click="$router.push('/register')">学生注册</el-button>
          </template>
          <template v-else-if="isStudent">
            <el-button type="primary" @click="$router.push('/learning/my-course')">进入我的课程</el-button>
            <el-button @click="$router.push('/learning/history')">学习记录</el-button>
          </template>
          <template v-else>
            <el-button type="primary" @click="$router.push('/index')">进入工作台</el-button>
            <el-button @click="$router.push('/teaching/course')">课程管理</el-button>
          </template>
        </div>
      </div>
      <div class="portal-hero__panel">
        <div class="portal-hero__stat">
          <strong>{{ courseStats.total }}</strong>
          <span>已发布课程</span>
        </div>
        <div class="portal-hero__stat">
          <strong>{{ courseStats.recommend }}</strong>
          <span>推荐课程</span>
        </div>
        <div class="portal-hero__stat">
          <strong>{{ courseStats.hot }}</strong>
          <span>热门课程</span>
        </div>
      </div>
    </section>

    <el-card v-if="featuredCourses.length" class="banner-card banner-card--compact" shadow="never">
      <div class="banner-card__head">
        <div>
          <p class="portal-section__kicker">精选推荐</p>
          <h3>课程推荐横幅</h3>
        </div>
        <span class="banner-card__hint">作为辅助浏览入口展示，课程搜索与列表仍是本页重点</span>
      </div>
      <el-carousel height="200px" indicator-position="outside" :interval="4800">
        <el-carousel-item v-for="item in featuredCourses" :key="item.bannerId || item.courseId">
          <div class="banner-item banner-item--compact" @click="handleBannerClick(item)">
            <img :src="getCourseCover(item.bannerImage || item.coverImage)" :alt="item.bannerTitle || item.courseName">
            <div class="banner-item__mask">
              <h3>{{ item.bannerTitle || item.courseName }}</h3>
              <p>{{ item.courseSubtitle || item.intro || "点击查看课程详情" }}</p>
            </div>
          </div>
        </el-carousel-item>
      </el-carousel>
    </el-card>

    <course-section
      title="推荐课程"
      kicker="推荐内容"
      :courses="homeData.recommendCourses"
      :show-more="true"
    />
    <course-section
      title="热门课程"
      kicker="学习热度"
      :courses="homeData.hotCourses"
      :show-more="true"
    />
    <course-section
      title="最新课程"
      kicker="内容更新"
      :courses="homeData.latestCourses"
      :show-more="true"
    />

    <section class="course-list-section">
      <el-card class="toolbar-card" shadow="never">
        <el-form :inline="true" :model="queryParams" class="toolbar-form">
          <el-form-item class="toolbar-form__keyword">
            <el-input
              v-model.trim="queryParams.keyword"
              clearable
              placeholder="搜索课程名称、课程简介"
              prefix-icon="el-icon-search"
              @keyup.enter.native="handleQuery"
            />
          </el-form-item>
          <el-form-item>
            <el-select v-model="queryParams.orderBy" placeholder="排序方式" @change="handleQuery">
              <el-option label="按发布时间" value="publishTime" />
              <el-option label="按注册人数" value="enrollCount" />
              <el-option label="按更新时间" value="lastContentTime" />
              <el-option label="按点赞人数" value="likeCount" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-select v-model="queryParams.isAsc" placeholder="排序方向" @change="handleQuery">
              <el-option label="降序" value="desc" />
              <el-option label="升序" value="asc" />
            </el-select>
          </el-form-item>
          <el-form-item class="toolbar-form__actions">
            <el-button type="primary" icon="el-icon-search" @click="handleQuery">查询</el-button>
            <el-button icon="el-icon-refresh-left" @click="resetQuery">重置</el-button>
          </el-form-item>
        </el-form>

        <div class="category-list">
          <el-tag
            :effect="!queryParams.categoryId ? 'dark' : 'plain'"
            class="category-tag"
            @click="selectCategory('')"
          >
            全部课程
          </el-tag>
          <el-tag
            v-for="item in homeData.categories"
            :key="item.categoryId"
            :effect="String(queryParams.categoryId) === String(item.categoryId) ? 'dark' : 'plain'"
            class="category-tag"
            @click="selectCategory(item.categoryId)"
          >
            {{ item.categoryName }}
          </el-tag>
        </div>
      </el-card>

      <div class="course-list-section__head">
        <div>
          <p class="portal-section__kicker">课程列表</p>
          <h2>全部课程</h2>
        </div>
        <span class="course-list-section__count">共 {{ total }} 门课程</span>
      </div>
      <div v-if="courseList.length" class="course-list-grid">
        <course-card v-for="item in courseList" :key="item.courseId" :course="item" />
      </div>
      <el-empty v-else description="暂无符合条件的课程" :image-size="100" />
      <pagination
        v-show="total > 0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getCourseList"
      />
    </section>
  </div>
</template>

<script>
import { getPortalHome, listPortalCourses } from "@/api/portal"
import PortalTopbar from "@/components/PortalTopbar"
import CourseCard from "../components/CourseCard"
import CourseSection from "../components/CourseSection"
import coursePlaceholder from "@/assets/images/course-placeholder.svg"
import { resolveResourceUrl } from "@/utils/resource"
import { getToken } from "@/utils/auth"
import { mapGetters } from "vuex"

export default {
  name: "CourseSquare",
  components: { CourseCard, CourseSection, PortalTopbar },
  data() {
    return {
      pageLoading: false,
      coursePlaceholder,
      total: 0,
      courseList: [],
      homeData: {
        banners: [],
        categories: [],
        recommendCourses: [],
        hotCourses: [],
        latestCourses: []
      },
      queryParams: {
        pageNum: 1,
        pageSize: 8,
        keyword: "",
        categoryId: "",
        orderBy: "publishTime",
        isAsc: "desc"
      }
    }
  },
  computed: {
    ...mapGetters(["roles"]),
    isLogin() {
      return !!getToken()
    },
    isStudent() {
      return (this.roles || []).includes("student")
    },
    heroKicker() {
      return this.isLogin ? "已登录" : "游客浏览"
    },
    heroSummary() {
      if (!this.isLogin) {
        return "无需登录也可以浏览公开课程、搜索课程和查看详情。登录学生账号后，可以注册课程、点赞课程并进入在线学习。"
      }
      if (this.isStudent) {
        return "欢迎回来。你可以继续筛选课程、注册感兴趣的内容，也可以直接进入我的课程接着学习。"
      }
      return "欢迎回来。你可以浏览公开课程，也可以进入后台维护课程内容与教学资源。"
    },
    /** 首页统计数据 */
    courseStats() {
      return {
        total: this.total,
        recommend: (this.homeData.recommendCourses || []).length,
        hot: (this.homeData.hotCourses || []).length
      }
    },
    /** 当前是否带有关键词搜索 */
    hasKeywordSearch() {
      return !!this.queryParams.keyword
    },
    /** 课程广场精选横幅数据 */
    featuredCourses() {
      return (this.homeData.banners || []).slice(0, 4)
    }
  },
  created() {
    this.initQueryParams()
    this.getHomeData()
    this.getCourseList()
  },
  watch: {
    /** 监听路由关键字变化，自动同步课程查询 */
    "$route.query.keyword"(value) {
      const keyword = value || ""
      if (keyword === this.queryParams.keyword) {
        return
      }
      this.queryParams.keyword = keyword
      this.handleQuery()
    }
  },
  methods: {
    /** 初始化查询参数，接收首页传入的关键字 */
    initQueryParams() {
      this.queryParams.keyword = this.$route.query.keyword || ""
    },
    /** 加载首页聚合数据 */
    getHomeData() {
      this.pageLoading = true
      getPortalHome().then(res => {
        const data = res.data || {}
        this.homeData = {
          banners: data.banners || [],
          categories: data.categories || [],
          recommendCourses: data.recommendCourses || [],
          hotCourses: data.hotCourses || [],
          latestCourses: data.latestCourses || []
        }
      }).finally(() => {
        this.pageLoading = false
      })
    },
    /** 加载课程列表 */
    getCourseList() {
      listPortalCourses(this.queryParams).then(res => {
        this.courseList = res.rows || []
        this.total = res.total || 0
      })
    },
    /** 执行课程查询 */
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getCourseList()
    },
    /** 重置查询条件 */
    resetQuery() {
      this.queryParams = {
        pageNum: 1,
        pageSize: 8,
        keyword: "",
        categoryId: "",
        orderBy: "publishTime",
        isAsc: "desc"
      }
      if (this.$route.query.keyword) {
        this.$router.replace({ path: "/course-square" })
      }
      this.getCourseList()
    },
    /** 切换课程分类 */
    selectCategory(categoryId) {
      this.queryParams.categoryId = categoryId
      this.handleQuery()
    },
    /** 处理轮播图点击 */
    handleBannerClick(item) {
      if (item.jumpUrl) {
        window.open(item.jumpUrl, "_blank")
        return
      }
      if (item.courseId) {
        this.$router.push(`/course/${item.courseId}`)
      }
    },
    /** 跳转课程详情 */
    openCourseDetail(courseId) {
      this.$router.push(`/course/${courseId}`)
    },
    /** 获取课程封面地址 */
    getCourseCover(cover) {
      if (!cover) {
        return this.coursePlaceholder
      }
      return resolveResourceUrl(cover)
    },
    /** 处理图片完整地址 */
    getImageUrl(url) {
      return resolveResourceUrl(url)
    }
  }
}
</script>

<style lang="scss" scoped>
.course-square-page {
  min-height: 100vh;
  padding: 32px 5vw 48px;
  background:
    radial-gradient(circle at top left, rgba(59, 130, 246, 0.16), transparent 28%),
    radial-gradient(circle at top right, rgba(16, 185, 129, 0.14), transparent 24%),
    linear-gradient(180deg, #f8fbff 0%, #eef7ff 100%);
}

.keyword-search-tip {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 18px;
  padding: 10px 14px;
  border: 1px solid rgba(59, 130, 246, 0.12);
  border-radius: 14px;
  background: rgba(255, 255, 255, 0.86);
  color: #2563eb;
  box-shadow: 0 8px 20px rgba(15, 23, 42, 0.04);
}

.keyword-search-tip span {
  color: #475569;
}

.keyword-tip-fade-enter-active,
.keyword-tip-fade-leave-active {
  transition: all 0.2s ease;
}

.keyword-tip-fade-enter,
.keyword-tip-fade-leave-to {
  opacity: 0;
  transform: translateY(-4px);
}

.portal-hero {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 24px;
  margin-bottom: 24px;
}

.portal-hero__content,
.portal-hero__panel {
  border-radius: 16px;
  background: #fff;
  box-shadow: 0 8px 18px rgba(15, 23, 42, 0.06);
}

.portal-hero__content {
  padding: 30px 32px;
}

.portal-hero__kicker,
.portal-section__kicker {
  margin: 0;
  color: #2563eb;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 2px;
}

.portal-hero h1 {
  margin: 12px 0 0;
  color: #0f172a;
  font-size: 40px;
}

.portal-hero__summary {
  max-width: 720px;
  margin: 16px 0 0;
  color: #475569;
  line-height: 1.8;
}

.portal-hero__actions {
  display: flex;
  gap: 12px;
  margin-top: 22px;
}

.portal-hero__panel {
  display: grid;
  align-content: center;
  gap: 14px;
  padding: 28px;
}

.portal-hero__stat {
  padding: 18px;
  border-radius: 12px;
  background: linear-gradient(135deg, #eff6ff 0%, #f8fafc 100%);
}

.portal-hero__stat strong {
  display: block;
  color: #0f172a;
  font-size: 28px;
}

.portal-hero__stat span,
.course-list-section__count {
  color: #64748b;
}

.banner-card,
.toolbar-card {
  margin-bottom: 24px;
  border-radius: 12px;
}

.banner-card {
  box-shadow: 0 6px 14px rgba(15, 23, 42, 0.04);
}

.banner-card__head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 14px;
  margin-bottom: 14px;
}

.banner-card__head h3 {
  margin: 6px 0 0;
  color: #0f172a;
  font-size: 24px;
}

.banner-card__hint {
  color: #64748b;
  font-size: 13px;
}

.banner-item {
  position: relative;
  width: 100%;
  height: 100%;
  overflow: hidden;
  border-radius: 12px;
  cursor: pointer;
}

.banner-item--compact {
  height: 200px;
}

.banner-item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.banner-item__mask {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  padding: 24px;
  background: linear-gradient(180deg, rgba(15, 23, 42, 0) 20%, rgba(15, 23, 42, 0.72) 100%);
  color: #fff;
}

.banner-item__mask h3 {
  margin: 0;
  font-size: 24px;
}

.banner-item__mask p {
  margin: 10px 0 0;
  line-height: 1.7;
}

.toolbar-form {
  display: flex;
  flex-wrap: wrap;
  align-items: flex-start;
  gap: 10px 12px;
}

.toolbar-form .el-form-item {
  margin-right: 0;
  margin-bottom: 0;
}

.toolbar-form__keyword {
  flex: 1 1 340px;
}

.toolbar-form__actions {
  white-space: nowrap;
}

.category-list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 14px;
  padding-top: 14px;
  border-top: 1px solid #e2e8f0;
}

.category-tag {
  cursor: pointer;
  user-select: none;
}

.course-list-section {
  margin-top: 34px;
}

.course-list-section .toolbar-card {
  margin-bottom: 18px;
  border: 1px solid #e2e8f0;
  box-shadow: none;
}

.course-list-section__head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 18px;
}

.course-list-section__head h2 {
  margin: 6px 0 0;
  color: #0f172a;
  font-size: 28px;
}

.course-list-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 18px;
}

@media (max-width: 960px) {
  .portal-hero {
    grid-template-columns: 1fr;
  }

  .portal-hero__actions,
  .course-list-section__head {
    flex-direction: column;
    align-items: flex-start;
  }

  .banner-card__head {
    align-items: flex-start;
    flex-direction: column;
  }

  .toolbar-form {
    display: block;
  }

  .toolbar-form .el-form-item,
  .toolbar-form .el-input,
  .toolbar-form .el-select,
  .toolbar-form .el-button {
    width: 100%;
  }

  .toolbar-form .el-form-item + .el-form-item {
    margin-top: 10px;
  }

  .toolbar-form__actions {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 10px;
    white-space: normal;
  }

  .toolbar-form__actions .el-button + .el-button {
    margin-left: 0;
  }
}
</style>
