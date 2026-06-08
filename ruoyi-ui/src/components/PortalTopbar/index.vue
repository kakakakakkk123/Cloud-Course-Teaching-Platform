<template>
  <header class="portal-topbar">
    <div class="portal-topbar__inner">
      <button class="portal-topbar__brand" type="button" @click="goHome">
        <span class="portal-topbar__brand-mark">
          <i class="el-icon-reading"></i>
        </span>
        <span class="portal-topbar__brand-copy">
          <strong>在线教育平台</strong>
          <span>Online Learning Portal</span>
        </span>
      </button>

      <nav class="portal-topbar__nav" aria-label="前台主导航">
        <button
          v-for="item in navItems"
          :key="item.key"
          type="button"
          class="portal-topbar__nav-item"
          :class="{ 'portal-topbar__nav-item--active': item.key === active }"
          :aria-current="item.key === active ? 'page' : null"
          @click="handleNavClick(item)"
        >
          {{ item.label }}
        </button>
      </nav>

      <div class="portal-topbar__aside">
        <el-button
          class="portal-topbar__action"
          :type="actionButtonType"
          @click="handleActionClick"
        >
          {{ actionButtonLabel }}
        </el-button>
      </div>
    </div>
  </header>
</template>

<script>
import { mapGetters } from "vuex"
import { getToken } from "@/utils/auth"

export default {
  name: "PortalTopbar",
  props: {
    active: {
      type: String,
      default: "home"
    },
    contextTitle: {
      type: String,
      default: ""
    },
    contextSummary: {
      type: String,
      default: ""
    }
  },
  computed: {
    ...mapGetters(["roles"]),
    isLogin() {
      return !!getToken()
    },
    isStudent() {
      return this.roles.includes("student")
    },
    isTeacherOrAdmin() {
      return this.roles.includes("teacher") || this.roles.includes("admin")
    },
    isGuestVisitor() {
      return !this.isStudent && !this.isTeacherOrAdmin
    },
    navItems() {
      const items = [
        { key: "home", label: "首页", path: "/" },
        { key: "course-square", label: "课程广场", path: "/course-square" }
      ]

      if (this.isStudent) {
        items.push({
          key: "my-course",
          label: "我的课程",
          path: "/learning/my-course",
          requiresAuth: true
        })
      } else if (this.isTeacherOrAdmin) {
        items.push({
          key: "course-manage",
          label: "课程管理",
          path: "/teaching/course",
          requiresAuth: true,
          roleGuard: "teacherOrAdmin"
        })
      } else {
        items.push({
          key: "login",
          label: "登录学习",
          path: "/login"
        })
      }

      return items
    },
    actionButtonLabel() {
      if (!this.isLogin) {
        return "登录"
      }
      if (this.isStudent) {
        return "进入学习"
      }
      if (this.isTeacherOrAdmin) {
        return "进入后台"
      }
      return "个人中心"
    },
    actionButtonType() {
      return this.isLogin ? "primary" : "default"
    }
  },
  methods: {
    goHome() {
      if (this.$route.path !== "/") {
        this.$router.push("/")
      }
    },
    goLoginWithRedirect(redirect) {
      this.$router.push({
        path: "/login",
        query: { redirect }
      })
    },
    handleNavClick(item) {
      if (item.requiresAuth && !this.isLogin) {
        this.goLoginWithRedirect(item.path)
        return
      }
      if (item.roleGuard === "teacherOrAdmin" && !this.isTeacherOrAdmin) {
        this.$router.push("/")
        return
      }
      if (this.$route.path !== item.path) {
        this.$router.push(item.path)
      }
    },
    handleActionClick() {
      if (!this.isLogin) {
        this.goLoginWithRedirect(this.$route.fullPath || "/")
        return
      }
      if (this.isStudent) {
        this.$router.push("/learning/my-course")
        return
      }
      if (this.isTeacherOrAdmin) {
        this.$router.push("/index")
        return
      }
      this.$router.push("/user/profile")
    }
  }
}
</script>

<style lang="scss" scoped>
.portal-topbar {
  position: sticky;
  top: 0;
  z-index: 20;
  padding: 18px 20px 12px;
  background: transparent;
}

.portal-topbar__inner {
  max-width: 1460px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  gap: 18px;
  min-height: 72px;
  padding: 12px 18px;
  border: 1px solid rgba(226, 232, 240, 0.92);
  border-radius: 20px;
  background: #ffffff;
  box-shadow: 0 6px 16px rgba(15, 23, 42, 0.05);
}

.portal-topbar__brand {
  display: inline-flex;
  align-items: center;
  gap: 12px;
  padding: 0;
  border: 0;
  background: transparent;
  cursor: pointer;
  text-align: left;
}

.portal-topbar__brand-mark {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 42px;
  height: 42px;
  border-radius: 14px;
  background: linear-gradient(135deg, #2563eb, #0ea5e9);
  color: #fff;
  font-size: 20px;
  box-shadow: 0 10px 18px rgba(37, 99, 235, 0.2);
}

.portal-topbar__brand-copy {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.portal-topbar__brand-copy strong {
  color: #0f172a;
  font-size: 16px;
  line-height: 1.2;
}

.portal-topbar__brand-copy span {
  color: #64748b;
  font-size: 12px;
  line-height: 1.2;
}

.portal-topbar__nav {
  display: flex;
  flex: 1;
  flex-wrap: wrap;
  justify-content: center;
  gap: 8px;
}

.portal-topbar__nav-item {
  min-height: 40px;
  padding: 0 16px;
  border: 0;
  border-radius: 12px;
  background: transparent;
  color: #475569;
  cursor: pointer;
  font-size: 14px;
  font-weight: 600;
  transition: background-color 0.2s ease, color 0.2s ease, transform 0.2s ease;
}

.portal-topbar__nav-item:hover,
.portal-topbar__nav-item:focus-visible {
  background: rgba(37, 99, 235, 0.08);
  color: #1d4ed8;
  outline: none;
}

.portal-topbar__nav-item:focus-visible,
.portal-topbar__action:focus-visible,
.portal-topbar__brand:focus-visible {
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
}

.portal-topbar__nav-item--active {
  background: #eff6ff;
  color: #1d4ed8;
}

.portal-topbar__aside {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  margin-left: auto;
  min-width: 0;
}

.portal-topbar__action {
  min-height: 42px;
  padding: 0 18px;
  border-radius: 12px;
  font-weight: 600;
}

@media (max-width: 1100px) {
  .portal-topbar {
    padding: 14px 12px 10px;
  }

  .portal-topbar__inner {
    flex-direction: column;
    align-items: stretch;
    gap: 14px;
    padding: 16px;
  }

  .portal-topbar__nav {
    flex: none;
    justify-content: flex-start;
  }

  .portal-topbar__aside {
    margin-left: 0;
    justify-content: flex-start;
  }
}

@media (max-width: 680px) {
  .portal-topbar__aside {
    flex-direction: column;
    align-items: stretch;
  }

  .portal-topbar__action {
    width: 100%;
  }
}
</style>
