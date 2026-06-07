import auth from '@/plugins/auth'
import router, { constantRoutes, dynamicRoutes } from '@/router'
import { getRouters } from '@/api/menu'
import Layout from '@/layout/index'
import ParentView from '@/components/ParentView'
import InnerLink from '@/layout/components/InnerLink'
import { isStudentRole } from '@/utils/home'

const permission = {
  state: {
    routes: [],
    addRoutes: [],
    defaultRoutes: [],
    topbarRouters: [],
    sidebarRouters: []
  },
  mutations: {
    SET_ROUTES: (state, payload) => {
      const routes = Array.isArray(payload) ? payload : payload.routes
      const baseRoutes = Array.isArray(payload) ? constantRoutes : (payload.baseRoutes || constantRoutes)
      state.addRoutes = routes
      state.routes = baseRoutes.concat(routes)
    },
    SET_DEFAULT_ROUTES: (state, payload) => {
      const routes = Array.isArray(payload) ? payload : payload.routes
      const baseRoutes = Array.isArray(payload) ? constantRoutes : (payload.baseRoutes || constantRoutes)
      state.defaultRoutes = baseRoutes.concat(routes)
    },
    SET_TOPBAR_ROUTES: (state, routes) => {
      state.topbarRouters = routes
    },
    SET_SIDEBAR_ROUTERS: (state, routes) => {
      state.sidebarRouters = routes
    },
    RESET_PERMISSION: (state) => {
      state.routes = []
      state.addRoutes = []
      state.defaultRoutes = []
      state.topbarRouters = []
      state.sidebarRouters = []
    }
  },
  actions: {
    // 生成路由
    GenerateRoutes({ commit, rootState }) {
      return new Promise(resolve => {
        // 向后端请求路由数据
        getRouters().then(res => {
          const sdata = JSON.parse(JSON.stringify(res.data))
          const rdata = JSON.parse(JSON.stringify(res.data))
          const isStudent = isStudentRole(rootState.user.roles)
          const isAdmin = hasExactRole(rootState, 'admin')
          const baseRoutes = filterStudentDashboardRoutes(constantRoutes, isStudent)
          const sidebarRoutes = filterAdminLearningRoutes(filterAsyncRouter(sdata), isAdmin, isStudent)
          const rewriteRoutes = filterAdminLearningRoutes(filterAsyncRouter(rdata, false, true), isAdmin, isStudent)
          const roleRoutes = filterDynamicRoutes(dynamicRoutes)
          const studentLearningRoutes = isStudent ? getStudentLearningFallbackRoutes() : []
          const visibleRoleRoutes = roleRoutes.filter(route => !route.hidden)
          const accessRoutes = roleRoutes.concat(studentLearningRoutes, rewriteRoutes)
          accessRoutes.push({ path: '*', redirect: '/404', hidden: true })
          // 同步注册后台菜单路由和前端手写的隐藏角色路由，避免菜单可见但点击 404。
          router.addRoutes(accessRoutes)
          if (process.env.NODE_ENV === 'development' && typeof window !== 'undefined') {
            window.__ACCESS_ROUTES__ = accessRoutes
            window.__SIDEBAR_ROUTES__ = baseRoutes.concat(visibleRoleRoutes, sidebarRoutes)
          }
          commit('SET_ROUTES', { routes: accessRoutes, baseRoutes })
          commit('SET_SIDEBAR_ROUTERS', baseRoutes.concat(visibleRoleRoutes, sidebarRoutes))
          commit('SET_DEFAULT_ROUTES', { routes: visibleRoleRoutes.concat(sidebarRoutes), baseRoutes })
          commit('SET_TOPBAR_ROUTES', visibleRoleRoutes.concat(sidebarRoutes))
          resolve(accessRoutes)
        })
      })
    }
  }
}

// 遍历后台传来的路由字符串，转换为组件对象
function filterAsyncRouter(asyncRouterMap, lastRouter = false, type = false) {
  return asyncRouterMap.filter(route => {
    if (type && route.children) {
      route.children = filterChildren(route.children)
    }
    if (route.component) {
      // Layout ParentView 组件特殊处理
      if (route.component === 'Layout') {
        route.component = Layout
      } else if (route.component === 'ParentView') {
        route.component = ParentView
      } else if (route.component === 'InnerLink') {
        route.component = InnerLink
      } else {
        route.component = loadView(route.component)
      }
    }
    if (route.children != null && route.children && route.children.length) {
      route.children = filterAsyncRouter(route.children, route, type)
    } else {
      delete route['children']
      delete route['redirect']
    }
    return true
  })
}

function filterChildren(childrenMap, lastRouter = false) {
  var children = []
  childrenMap.forEach(el => {
    el.path = lastRouter ? lastRouter.path + '/' + el.path : el.path
    if (el.children && el.children.length && el.component === 'ParentView') {
      children = children.concat(filterChildren(el.children, el))
    } else {
      children.push(el)
    }
  })
  return children
}

// 动态路由遍历，验证是否具备权限
export function filterDynamicRoutes(routes) {
  const res = []
  routes.forEach(route => {
    if (route.permissions) {
      if (auth.hasPermiOr(route.permissions)) {
        res.push(route)
      }
    } else if (route.roles) {
      if (auth.hasRoleOr(route.roles)) {
        res.push(route)
      }
    }
  })
  return res
}

function filterAdminLearningRoutes(routes, isAdmin, isStudent) {
  if (!isAdmin || isStudent) {
    return routes
  }
  return routes.filter(route => {
    if (route.path === '/learning' || route.path === 'learning') {
      return false
    }
    if (route.children && route.children.length) {
      route.children = filterAdminLearningRoutes(route.children, isAdmin, isStudent)
    }
    return true
  })
}

function filterStudentDashboardRoutes(routes, isStudent) {
  if (!isStudent) {
    return routes
  }
  return routes.reduce((list, route) => {
    if (isDashboardRoute(route)) {
      return list
    }
    const nextRoute = { ...route }
    if (nextRoute.children) {
      nextRoute.children = filterStudentDashboardRoutes(nextRoute.children, isStudent)
      if (nextRoute.children.length === 0 && route.children) {
        return list
      }
    }
    list.push(nextRoute)
    return list
  }, [])
}

function isDashboardRoute(route) {
  return route && (route.name === 'Dashboard' || route.path === 'index' || route.redirect === '/index')
}

function hasExactRole(rootState, role) {
  const roles = rootState && rootState.user && rootState.user.roles ? rootState.user.roles : []
  return roles.indexOf(role) !== -1
}

function getStudentLearningFallbackRoutes() {
  return [
    createStudentLearningRoute('/learning/my-course', 'learning/my-course/index', 'StudentMyCourseFallback', '我的课程'),
    createStudentLearningRoute('/learning/online', 'learning/online/index', 'StudentOnlineLearningFallback', '在线学习'),
    createStudentLearningRoute('/learning/todo', 'learning/todo/index', 'StudentLearningTodoFallback', '学习待办'),
    createStudentLearningRoute('/learning/history', 'learning/history/index', 'StudentLearningHistoryFallback', '学习历史'),
    createStudentLearningRoute('/learning/note', 'learning/note/index', 'StudentNoteFallback', '学习笔记'),
    createStudentLearningRoute('/learning/favorite', 'learning/favorite/index', 'StudentFavoriteFallback', '我的收藏'),
    createStudentLearningRoute('/learning/wrong', 'learning/wrong/index', 'StudentWrongQuestionsFallback', '我的错题'),
    createStudentLearningRoute('/learning/discussion', 'learning/discussion/index', 'StudentLearningDiscussionFallback', '我的讨论'),
    createStudentLearningRoute('/learning/exam', 'learning/exam/index', 'StudentMyExamFallback', '我的考试')
  ]
}

function createStudentLearningRoute(path, view, name, title) {
  return {
    path,
    component: Layout,
    hidden: true,
    children: [
      {
        path: '',
        component: loadView(view),
        name,
        meta: { title, activeMenu: path }
      }
    ]
  }
}

export const loadView = (view) => {
  if (process.env.NODE_ENV === 'development') {
    return (resolve) => require([`@/views/${view}`], resolve)
  } else {
    // 使用 import 实现生产环境的路由懒加载
    return () => import(`@/views/${view}`)
  }
}

export default permission
