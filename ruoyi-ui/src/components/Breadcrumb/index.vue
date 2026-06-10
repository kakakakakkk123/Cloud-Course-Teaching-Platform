<template>
  <el-breadcrumb class="app-breadcrumb" separator="/">
    <transition-group name="breadcrumb">
      <el-breadcrumb-item v-for="(item, index) in levelList" :key="item.path">
        <span v-if="item.redirect === 'noRedirect' || index == levelList.length - 1" class="no-redirect">{{ item.meta.title }}</span>
        <a v-else @click.prevent="handleLink(item)">{{ item.meta.title }}</a>
      </el-breadcrumb-item>
    </transition-group>
  </el-breadcrumb>
</template>

<script>
import { DEFAULT_HOME_PATH, STUDENT_HOME_PATH, isStudentRole } from '@/utils/home'

export default {
  data() {
    return {
      levelList: null
    }
  },
  computed: {
    isStudent() {
      return isStudentRole(this.$store.getters.roles)
    }
  },
  watch: {
    $route(route) {
      // if you go to the redirect page, do not update the breadcrumbs
      if (route.path.startsWith('/redirect/')) {
        return
      }
      this.getBreadcrumb()
    }
  },
  created() {
    this.getBreadcrumb()
  },
  methods: {
    getBreadcrumb() {
      let matched = []
      const route = this.$route
      const pathNum = this.findPathNum(route.path)

      if (pathNum > 2) {
        // 多级路径：先从后台菜单树搜索父级层次
        const reg = /\/\w+/gi
        const pathList = route.path.match(reg).map((item, index) => {
          if (index !== 0) item = item.slice(1)
          return item
        })
        // 去掉末段参数（如 123），只搜菜单路径
        const parentSegments = pathList.slice(0, -1)
        this.getMatched(parentSegments, this.$store.getters.defaultRoutes, matched)

        // 如果 route 有 activeMenu，尝试注入对应的父菜单（如"题库管理"）
        if (route.meta && route.meta.activeMenu) {
          const parentMenu = this.findRouteByPath(route.meta.activeMenu, this.$store.getters.defaultRoutes)
          if (parentMenu && !matched.some(m => m.path === parentMenu.path)) {
            matched.push(parentMenu)
          }
        }

        // 当前页面自身作为末级
        if (route.meta && route.meta.title) {
          matched.push({ path: route.path, meta: { title: route.meta.title } })
        }
      } else {
        matched = route.matched.filter(item => item.meta && item.meta.title)
      }

      if (!this.isHomeRoute(matched[0])) {
        matched = [this.homeBreadcrumb()].concat(matched)
      }
      this.levelList = matched.filter(item => item.meta && item.meta.title && item.meta.breadcrumb !== false)
    },
    findPathNum(str, char = "/") {
      let index = str.indexOf(char)
      let num = 0
      while (index !== -1) {
        num++
        index = str.indexOf(char, index + 1)
      }
      return num
    },
    getMatched(pathList, routeList, matched) {
      let data = routeList.find(item => item.path == pathList[0] || String(item.name || '').toLowerCase() == pathList[0])
      if (data) {
        matched.push(data)
        if (data.children && pathList.length) {
          pathList.shift()
          this.getMatched(pathList, data.children, matched)
        }
      }
    },
    findRouteByPath(targetPath, routeList) {
      if (!targetPath || !routeList) return null
      for (const route of routeList) {
        // 匹配绝对路径或相对路径拼接
        if (route.path === targetPath || (route.path && targetPath.endsWith('/' + route.path))) {
          return route
        }
        if (route.children) {
          const found = this.findRouteByPath(targetPath, route.children)
          if (found) return found
        }
      }
      return null
    },
    isDashboard(route) {
      const name = route && route.name
      if (!name) {
        return false
      }
      return name.trim() === 'Dashboard' || name.trim() === 'Index'
    },
    isHomeRoute(route) {
      if (this.isStudent) {
        return route && route.path === STUDENT_HOME_PATH
      }
      return this.isDashboard(route)
    },
    homeBreadcrumb() {
      if (this.isStudent) {
        return { path: STUDENT_HOME_PATH, meta: { title: '\u6211\u7684\u8bfe\u7a0b' } }
      }
      return { path: DEFAULT_HOME_PATH, meta: { title: '\u4eea\u8868\u76d8' } }
    },
    handleLink(item) {
      const { redirect, path } = item
      if (redirect) {
        this.$router.push(redirect)
        return
      }
      this.$router.push(path)
    }
  }
}
</script>

<style lang="scss" scoped>
.app-breadcrumb.el-breadcrumb {
  display: inline-block;
  font-size: 14px;
  line-height: 50px;
  .no-redirect {
    color: #97a8be;
    cursor: text;
  }
}
</style>
