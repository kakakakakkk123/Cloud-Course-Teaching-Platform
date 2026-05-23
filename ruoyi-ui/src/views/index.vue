<template>
  <div class="home-page">
    <div class="hero">
      <div class="hero__text">
        <p class="eyebrow">云课教学平台</p>
        <h1>{{ heroTitle }}</h1>
        <p class="summary">{{ heroSummary }}</p>
        <div class="stats">
          <div v-for="item in stats" :key="item.title" class="stat">
            <strong>{{ item.title }}</strong>
            <span>{{ item.desc }}</span>
          </div>
        </div>
      </div>
      <div class="hero__card">
        <h3>{{ sideTitle }}</h3>
        <ul>
          <li v-for="item in sideItems" :key="item">{{ item }}</li>
        </ul>
      </div>
    </div>

    <div class="feature-grid">
      <el-card v-for="item in features" :key="item.title" class="feature-card" shadow="hover">
        <div class="feature-card__title">{{ item.title }}</div>
        <div class="feature-card__desc">{{ item.desc }}</div>
      </el-card>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'Index',
  computed: {
    ...mapGetters(['roles']),
    isTeacherOrAdmin() {
      return this.roles.includes('teacher') || this.roles.includes('admin')
    },
    heroTitle() {
      return this.isTeacherOrAdmin
        ? '让课程、作业、学习档案和账号管理更清晰'
        : '让课程、作业、笔记和个人学习档案更清晰'
    },
    heroSummary() {
      return this.isTeacherOrAdmin
        ? '面向教师与管理员的教学平台工作台，覆盖学生账户管理、教学组织和个人中心等核心功能。'
        : '面向学生的学习平台首页，聚焦选课、学习进度、笔记沉淀和个人中心，不展示账号管理入口。'
    },
    stats() {
      if (this.isTeacherOrAdmin) {
        return [
          { title: '学生账户', desc: '支持导入、重置密码、启停与状态维护。' },
          { title: '教学组织', desc: '按学院、专业、班级维护教学成员结构。' },
          { title: '系统安全', desc: '支持密码策略、验证码与异常登录保护。' }
        ]
      }
      return [
        { title: '我的课程', desc: '查看在学课程、进度状态与课程安排。' },
        { title: '学习沉淀', desc: '整理笔记、错题与收藏内容，形成个人档案。' },
        { title: '个人中心', desc: '维护资料、头像与学习画像，不包含账号管理。' }
      ]
    },
    sideTitle() {
      return this.isTeacherOrAdmin ? '工作台定位' : '学习中心定位'
    },
    sideItems() {
      return this.isTeacherOrAdmin
        ? ['中文界面', '教学账户体系', '个人学习档案', '教师管理后台']
        : ['课程学习入口', '笔记与错题沉淀', '个人学习档案', '安全资料维护']
    },
    features() {
      if (this.isTeacherOrAdmin) {
        return [
          { title: '账号管理', desc: '集中维护学生账户、批量导入和状态控制。' },
          { title: '教学管理', desc: '围绕课程、班级和学生名单开展教学组织。' },
          { title: '安全保护', desc: '密码加密存储，支持登录保护和身份校验。' }
        ]
      }
      return [
        { title: '我的学习', desc: '围绕课程进度、学习记录和内容沉淀展开。' },
        { title: '个人中心', desc: '维护基础资料、头像、密码和学习档案。' },
        { title: '学习安全', desc: '账号具备密码修改、验证码与登录保护能力。' }
      ]
    }
  }
}
</script>

<style lang="scss" scoped>
.home-page {
  padding: 24px;
  color: #1f2d3d;
}

.hero {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 20px;
  margin-bottom: 24px;
}

.hero__text,
.hero__card,
.feature-card {
  background: #fff;
  border-radius: 18px;
  box-shadow: 0 12px 40px rgba(15, 23, 42, 0.08);
}

.hero__text {
  padding: 32px;
  background: linear-gradient(135deg, #eff6ff 0%, #ffffff 55%, #ecfeff 100%);
}

.eyebrow {
  margin: 0 0 12px;
  color: #1d4ed8;
  font-weight: 700;
  letter-spacing: 2px;
}

h1 {
  margin: 0;
  font-size: 34px;
  line-height: 1.2;
}

.summary {
  max-width: 720px;
  margin: 16px 0 0;
  color: #475569;
  line-height: 1.8;
}

.stats {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 14px;
  margin-top: 24px;
}

.stat {
  padding: 16px;
  border-radius: 14px;
  background: rgba(255, 255, 255, 0.8);
}

.stat strong,
.feature-card__title,
.hero__card h3 {
  display: block;
  margin-bottom: 8px;
}

.stat span,
.feature-card__desc,
.hero__card li {
  color: #64748b;
  line-height: 1.7;
}

.hero__card {
  padding: 28px;
}

.hero__card ul {
  margin: 0;
  padding-left: 18px;
}

.feature-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 16px;
}

.feature-card {
  padding: 22px;
}

@media (max-width: 960px) {
  .hero,
  .feature-grid,
  .stats {
    grid-template-columns: 1fr;
  }
}
</style>
