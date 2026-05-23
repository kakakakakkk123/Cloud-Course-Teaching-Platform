<template>
  <div class="profile-page">
    <section class="profile-hero" :class="heroClass">
      <div class="profile-hero__main">
        <p class="profile-hero__eyebrow">{{ heroEyebrow }}</p>
        <h1 class="profile-hero__title">{{ heroTitle }}</h1>
        <p class="profile-hero__subtitle">{{ heroSubtitle }}</p>

        <div class="profile-hero__chips">
          <span v-for="chip in heroChips" :key="chip" class="hero-chip">{{ chip }}</span>
        </div>
      </div>

      <div class="profile-hero__stats">
        <div v-for="item in heroStats" :key="item.label" class="hero-stat">
          <span class="hero-stat__label">{{ item.label }}</span>
          <strong class="hero-stat__value">{{ item.value }}</strong>
        </div>
      </div>
    </section>

    <div class="profile-layout">
      <aside class="profile-sidebar">
        <section class="profile-panel identity-panel">
          <div class="identity-panel__top">
            <userAvatar />
            <div class="identity-panel__meta">
              <h3>{{ displayName }}</h3>
              <p>{{ user.userName || "未设置账号" }}</p>
            </div>
          </div>

          <div class="identity-panel__grid">
            <div v-for="item in identityItems" :key="item.label" class="identity-item">
              <span class="identity-item__label">{{ item.label }}</span>
              <span class="identity-item__value">{{ item.value }}</span>
            </div>
          </div>
        </section>

        <section class="profile-panel summary-panel">
          <div class="panel-heading">
            <span>{{ summaryTitle }}</span>
            <small>{{ summarySubtitle }}</small>
          </div>

          <div class="summary-list">
            <div v-for="item in summaryItems" :key="item.label" class="summary-row">
              <span>{{ item.label }}</span>
              <strong>{{ item.value }}</strong>
            </div>
          </div>
        </section>
      </aside>

      <main class="profile-main">
        <section class="profile-panel workspace-panel">
          <div class="panel-heading panel-heading--spaced">
            <div>
              <span>{{ workspaceTitle }}</span>
              <small>{{ workspaceSubtitle }}</small>
            </div>
          </div>

          <el-tabs v-model="selectedTab" class="profile-tabs">
            <el-tab-pane :label="baseInfoTabLabel" name="userinfo">
              <userInfo :user="user" :role-text="roleText" :is-student="isStudent" />
            </el-tab-pane>
            <el-tab-pane v-if="showStudentProfileTab" label="学习档案" name="studentProfile">
              <studentProfile />
            </el-tab-pane>
            <el-tab-pane label="账号安全" name="resetPwd">
              <resetPwd :role-text="roleText" :is-student="isStudent" />
            </el-tab-pane>
          </el-tabs>
        </section>
      </main>
    </div>
  </div>
</template>

<script>
import userAvatar from "./userAvatar"
import userInfo from "./userInfo"
import resetPwd from "./resetPwd"
import studentProfile from "./studentProfile"
import { getRegisterDeptOptions } from "@/api/login"
import { getUserProfile } from "@/api/system/user"

const EMPTY_TEXT = "待补充"

export default {
  name: "Profile",
  components: { userAvatar, userInfo, resetPwd, studentProfile },
  data() {
    return {
      user: {},
      roleGroup: "",
      postGroup: "",
      majorMetaMap: {},
      selectedTab: "userinfo"
    }
  },
  computed: {
    isAdmin() {
      return this.roleText.includes("管理员")
    },
    isTeacher() {
      return !this.isAdmin && this.roleText.includes("教师")
    },
    isStudent() {
      return !this.isAdmin && !this.isTeacher
    },
    showStudentProfileTab() {
      return this.isStudent
    },
    displayName() {
      return this.user.nickName || this.user.userName || "未命名用户"
    },
    currentMajorMeta() {
      const deptId = this.user && this.user.dept && this.user.dept.deptId
      return this.majorMetaMap[deptId] || null
    },
    academyName() {
      return (this.currentMajorMeta && this.currentMajorMeta.academyName) || "暂未分配学院"
    },
    majorName() {
      return (this.currentMajorMeta && this.currentMajorMeta.majorName) || (this.user.dept && this.user.dept.deptName) || "暂未分配专业"
    },
    deptName() {
      return (this.user.dept && this.user.dept.deptName) || "暂未分配部门"
    },
    roleText() {
      return this.roleGroup || "学生"
    },
    postText() {
      return this.postGroup || "未分配岗位"
    },
    profileCompletion() {
      const fields = [this.user.nickName, this.user.phonenumber, this.user.email]
      if (this.isStudent) {
        fields.push(this.academyName !== "暂未分配学院" ? this.academyName : "")
        fields.push(this.majorName !== "暂未分配专业" ? this.majorName : "")
      } else {
        fields.push(this.deptName !== "暂未分配部门" ? this.deptName : "")
        fields.push(this.postText !== "未分配岗位" ? this.postText : "")
      }
      const filled = fields.filter(Boolean).length
      return Math.round((filled / fields.length) * 100)
    },
    securityStatus() {
      return this.user.phonenumber && this.user.email ? "已完善" : "待完善"
    },
    archiveStatus() {
      if (this.isStudent) {
        return this.academyName !== "暂未分配学院" ? "已建立" : "待完善"
      }
      return this.postText !== "未分配岗位" ? "职责明确" : "待补充"
    },
    heroClass() {
      return {
        "profile-hero--admin": this.isAdmin,
        "profile-hero--teacher": this.isTeacher,
        "profile-hero--student": this.isStudent
      }
    },
    heroEyebrow() {
      if (this.isAdmin) return "ADMIN CONSOLE"
      if (this.isTeacher) return "TEACHING DESK"
      return "STUDENT CENTER"
    },
    heroTitle() {
      if (this.isAdmin) return "管理员工作台"
      if (this.isTeacher) return "教师工作台"
      return "个人学习中心"
    },
    heroSubtitle() {
      if (this.isAdmin) {
        return "在这里维护管理员身份资料与账号安全，快速掌握系统身份、组织归属和个人管理信息。"
      }
      if (this.isTeacher) {
        return "在这里维护教师身份资料与账号安全，让教学协作、课程沟通与个人信息保持清晰同步。"
      }
      return "在这里维护你的身份资料、学习档案与账号安全，让课程学习、任务记录和个人成长保持同步。"
    },
    heroChips() {
      if (this.isAdmin) {
        return [this.deptName, this.postText, this.roleText]
      }
      if (this.isTeacher) {
        return [this.deptName, this.postText, this.roleText]
      }
      return [this.academyName, this.majorName, this.roleText]
    },
    heroStats() {
      if (this.isAdmin) {
        return [
          { label: "当前身份", value: this.roleText },
          { label: "所属部门", value: this.deptName },
          { label: "加入平台", value: this.formatDate(this.user.createTime) }
        ]
      }
      if (this.isTeacher) {
        return [
          { label: "当前身份", value: this.roleText },
          { label: "任职部门", value: this.deptName },
          { label: "加入平台", value: this.formatDate(this.user.createTime) }
        ]
      }
      return [
        { label: "当前身份", value: this.roleText },
        { label: "学业归属", value: this.academyName },
        { label: "加入平台", value: this.formatDate(this.user.createTime) }
      ]
    },
    identityItems() {
      const commonItems = [
        { label: "手机号", value: this.user.phonenumber || EMPTY_TEXT },
        { label: "邮箱", value: this.user.email || EMPTY_TEXT }
      ]

      if (this.isAdmin) {
        return [
          { label: "角色", value: this.roleText },
          { label: "部门", value: this.deptName },
          { label: "岗位", value: this.postText },
          ...commonItems
        ]
      }
      if (this.isTeacher) {
        return [
          { label: "角色", value: this.roleText },
          { label: "任职部门", value: this.deptName },
          { label: "岗位", value: this.postText },
          ...commonItems
        ]
      }
      return [
        { label: "学院", value: this.academyName },
        { label: "专业", value: this.majorName },
        ...commonItems
      ]
    },
    summaryTitle() {
      if (this.isAdmin) return "管理概览"
      if (this.isTeacher) return "工作概览"
      return "状态概览"
    },
    summarySubtitle() {
      if (this.isAdmin) return "快速查看资料、账号安全与职责状态"
      if (this.isTeacher) return "快速查看资料、账号安全与任教状态"
      return "快速查看档案与账号状态"
    },
    summaryItems() {
      if (this.isAdmin) {
        return [
          { label: "资料完整度", value: `${this.profileCompletion}%` },
          { label: "账号安全", value: this.securityStatus },
          { label: "职责状态", value: this.archiveStatus }
        ]
      }
      if (this.isTeacher) {
        return [
          { label: "资料完整度", value: `${this.profileCompletion}%` },
          { label: "账号安全", value: this.securityStatus },
          { label: "任教状态", value: this.archiveStatus }
        ]
      }
      return [
        { label: "资料完整度", value: `${this.profileCompletion}%` },
        { label: "账号安全", value: this.securityStatus },
        { label: "档案状态", value: this.archiveStatus }
      ]
    },
    workspaceTitle() {
      if (this.isAdmin) return "管理工作区"
      if (this.isTeacher) return "教学工作区"
      return "学习工作区"
    },
    workspaceSubtitle() {
      if (this.isAdmin) return "维护管理员基础资料与账号安全，确保管理身份信息准确可用"
      if (this.isTeacher) return "维护教师基础资料与账号安全，确保教学身份信息准确可用"
      return "维护你的基础资料、学习档案与账号安全"
    },
    baseInfoTabLabel() {
      return this.isStudent ? "基础资料" : "个人资料"
    }
  },
  created() {
    const activeTab = this.$route.params && this.$route.params.activeTab
    if (activeTab) {
      this.selectedTab = activeTab
    }
    this.loadMajorMetaMap()
    this.getUser()
  },
  methods: {
    loadMajorMetaMap() {
      getRegisterDeptOptions().then(response => {
        const academyOptions = response.data || []
        const map = {}
        academyOptions.forEach(academy => {
          ;(academy.children || []).forEach(major => {
            map[major.id] = {
              academyName: academy.label,
              majorName: major.label
            }
          })
        })
        this.majorMetaMap = map
      }).catch(() => {
        this.majorMetaMap = {}
      })
    },
    getUser() {
      getUserProfile().then(response => {
        this.user = response.data || {}
        this.roleGroup = response.roleGroup || "学生"
        this.postGroup = response.postGroup || ""
        if (!this.showStudentProfileTab && this.selectedTab === "studentProfile") {
          this.selectedTab = "userinfo"
        }
      })
    },
    formatDate(value) {
      if (!value) {
        return "未知"
      }
      return String(value).slice(0, 10)
    }
  }
}
</script>

<style scoped lang="scss">
.profile-page {
  padding: 6px;
}

.profile-hero {
  display: grid;
  grid-template-columns: minmax(0, 1.5fr) minmax(280px, 0.9fr);
  gap: 20px;
  margin-bottom: 20px;
  padding: 28px 30px;
  border-radius: 28px;
  box-shadow: 0 24px 48px rgba(15, 36, 74, 0.18);
  color: #f5f7fb;
}

.profile-hero--student {
  background:
    radial-gradient(circle at top right, rgba(255, 203, 124, 0.18), transparent 30%),
    linear-gradient(135deg, #102544, #173766 58%, #215089);
}

.profile-hero--teacher {
  background:
    radial-gradient(circle at top right, rgba(102, 212, 255, 0.2), transparent 30%),
    linear-gradient(135deg, #12304d, #1b4b6e 58%, #2d6995);
}

.profile-hero--admin {
  background:
    radial-gradient(circle at top right, rgba(255, 184, 108, 0.18), transparent 30%),
    linear-gradient(135deg, #16202f, #24364e 58%, #38506f);
}

.profile-hero__eyebrow {
  margin: 0 0 10px;
  color: rgba(255, 224, 182, 0.92);
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.18em;
  text-transform: uppercase;
}

.profile-hero__title {
  margin: 0;
  font-size: 34px;
  line-height: 1.1;
}

.profile-hero__subtitle {
  max-width: 680px;
  margin: 14px 0 0;
  color: rgba(235, 241, 250, 0.82);
  line-height: 1.8;
}

.profile-hero__chips {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 18px;
}

.hero-chip {
  display: inline-flex;
  align-items: center;
  padding: 8px 14px;
  border: 1px solid rgba(255, 255, 255, 0.16);
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.08);
  font-size: 13px;
}

.profile-hero__stats {
  display: grid;
  gap: 12px;
}

.hero-stat {
  padding: 16px 18px;
  border-radius: 20px;
  background: rgba(255, 255, 255, 0.08);
  backdrop-filter: blur(8px);
}

.hero-stat__label {
  display: block;
  color: rgba(235, 241, 250, 0.72);
  font-size: 12px;
  letter-spacing: 0.08em;
}

.hero-stat__value {
  display: block;
  margin-top: 8px;
  font-size: 18px;
  font-weight: 700;
}

.profile-layout {
  display: grid;
  grid-template-columns: minmax(280px, 320px) minmax(0, 1fr);
  gap: 20px;
}

.profile-sidebar,
.profile-main {
  min-width: 0;
}

.profile-panel {
  margin-bottom: 20px;
  border-radius: 24px;
  background: #fff;
  box-shadow: 0 16px 32px rgba(17, 36, 79, 0.08);
}

.identity-panel {
  padding: 24px;
}

.identity-panel__top {
  display: grid;
  grid-template-columns: 112px minmax(0, 1fr);
  gap: 18px;
  align-items: center;
  margin-bottom: 22px;
}

.identity-panel__meta h3 {
  margin: 0;
  color: #11284c;
  font-size: 22px;
}

.identity-panel__meta p {
  margin: 8px 0 0;
  color: #66748b;
}

.identity-panel__grid {
  display: grid;
  gap: 12px;
}

.identity-item {
  display: grid;
  gap: 4px;
  padding: 14px 16px;
  border-radius: 18px;
  background: #f6f8fc;
}

.identity-item__label {
  color: #8390a8;
  font-size: 12px;
}

.identity-item__value {
  color: #1a2f52;
  font-weight: 600;
  word-break: break-word;
}

.summary-panel,
.workspace-panel {
  padding: 22px 24px;
}

.panel-heading {
  display: grid;
  gap: 4px;
  margin-bottom: 18px;
}

.panel-heading span {
  color: #11284c;
  font-size: 20px;
  font-weight: 700;
}

.panel-heading small {
  color: #76839b;
  line-height: 1.6;
}

.panel-heading--spaced {
  margin-bottom: 8px;
}

.summary-list {
  display: grid;
  gap: 12px;
}

.summary-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 0;
  border-bottom: 1px solid #eef2f8;
  color: #5e6d85;
}

.summary-row:last-child {
  border-bottom: none;
  padding-bottom: 0;
}

.summary-row strong {
  color: #173766;
  font-size: 15px;
}

.profile-tabs ::v-deep .el-tabs__header {
  margin-bottom: 20px;
}

.profile-tabs ::v-deep .el-tabs__item {
  height: 42px;
  line-height: 42px;
  font-size: 15px;
}

.profile-tabs ::v-deep .el-tabs__active-bar {
  height: 3px;
  border-radius: 999px;
  background: linear-gradient(90deg, #2f7df6, #f0ab4d);
}

@media (max-width: 1280px) {
  .profile-layout {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 992px) {
  .profile-hero {
    grid-template-columns: 1fr;
    padding: 24px 22px;
  }
}

@media (max-width: 768px) {
  .profile-page {
    padding: 0;
  }

  .identity-panel__top {
    grid-template-columns: 1fr;
    justify-items: center;
    text-align: center;
  }

  .profile-panel,
  .identity-panel,
  .summary-panel,
  .workspace-panel {
    border-radius: 18px;
  }
}
</style>
