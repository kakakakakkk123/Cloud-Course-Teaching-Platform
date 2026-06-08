import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

/* Layout */
import Layout from '@/layout'

/**
 * 路由配置说明
 *
 * hidden: true                     // 设置为 true 时该路由不会显示在侧边栏
 * alwaysShow: true                 // 无论子路由数量如何都始终显示根菜单
 * redirect: noRedirect             // 面包屑不可点击
 * name: 'router-name'              // 路由名称，keep-alive 依赖它
 * query: '{"id": 1}'               // 访问路由的默认参数
 * roles: ['admin', 'teacher']      // 访问该路由所需角色
 * permissions: ['a:a:a']           // 访问该路由所需菜单权限
 * meta: {
 *   noCache: true,                 // 不被 keep-alive 缓存
 *   title: 'title',                // 侧边栏和面包屑显示名称
 *   icon: 'svg-name',              // 图标
 *   breadcrumb: false,             // 不显示在面包屑
 *   activeMenu: '/system/user'     // 高亮对应侧边菜单
 * }
 */

export const constantRoutes = [
  {
    path: '/redirect',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/redirect/:path(.*)',
        component: () => import('@/views/redirect')
      }
    ]
  },
  {
    path: '/login',
    component: () => import('@/views/login'),
    hidden: true
  },
  {
    path: '/',
    component: () => import('@/views/index'),
    hidden: true,
    meta: { title: '首页' }
  },
  {
    path: '/register',
    component: () => import('@/views/register'),
    hidden: true
  },
  {
    path: '/forgot-password',
    component: () => import('@/views/forgot-password'),
    hidden: true
  },
  {
    path: '/course-square',
    component: () => import('@/views/course/square/index'),
    hidden: true,
    meta: { title: '课程广场' }
  },
  {
    path: '/course/:courseId(\\d+)',
    component: () => import('@/views/course/detail/index'),
    hidden: true,
    meta: { title: '课程详情' }
  },
  {
    path: '/portal-entry',
    component: () => import('@/views/portal-entry'),
    hidden: true,
    meta: { title: '鍓嶅彴鍏ュ彛' }
  },
  {
    path: '/learning/exam/answer/:recordId(\\d+)',
    component: () => import('@/views/learning/exam/answer'),
    hidden: true,
    meta: { title: '考试作答' }
  },
  {
    path: '/learning/exam/result/:recordId(\\d+)',
    component: () => import('@/views/learning/exam/result'),
    hidden: true,
    meta: { title: '考试结果' }
  },
  {
    path: '/404',
    component: () => import('@/views/error/404'),
    hidden: true
  },
  {
    path: '/401',
    component: () => import('@/views/error/401'),
    hidden: true
  },
  {
    path: '',
    component: Layout,
    redirect: '/index',
    children: [
      {
        path: 'index',
        component: () => import('@/views/index_v1'),
        name: 'Dashboard',
        meta: { title: '仪表盘', icon: 'dashboard', affix: true }
      }
    ]
  },
  {
    path: '/lock',
    component: () => import('@/views/lock'),
    hidden: true,
    meta: { title: '锁定屏幕' }
  },
  {
    path: '/user',
    component: Layout,
    hidden: true,
    redirect: 'noredirect',
    children: [
      {
        path: 'profile',
        component: () => import('@/views/system/user/profile/index'),
        name: 'Profile',
        meta: { title: '个人中心', icon: 'user' }
      }
    ]
  }
]

export const dynamicRoutes = [
  {
    path: '/account',
    component: Layout,
    hidden: true,
    roles: ['admin'],
    children: [
      {
        path: 'all',
        component: () => import('@/views/system/user/index'),
        name: 'AccountAll',
        meta: { title: '全部账号', activeMenu: '/account/all' }
      },
      {
        path: 'student',
        component: () => import('@/views/system/user/index'),
        name: 'AccountStudent',
        meta: { title: '学生账号', activeMenu: '/account/student' }
      },
      {
        path: 'teacher',
        component: () => import('@/views/system/user/index'),
        name: 'AccountTeacher',
        meta: { title: '教师账号', activeMenu: '/account/teacher' }
      },
      {
        path: 'admin',
        component: () => import('@/views/system/user/index'),
        name: 'AccountAdmin',
        meta: { title: '管理员账号', activeMenu: '/account/admin' }
      }
    ]
  },
  {
    path: '/teaching/score-detail',
    component: Layout,
    hidden: true,
    roles: ['teacher', 'admin'],
    children: [
      {
        path: ':examId?',
        component: () => import('@/views/teaching/score/index'),
        name: 'TeachingScoreDetail',
        meta: { title: '成绩统计', activeMenu: '/teaching/score' }
      }
    ]
  },
  {
    path: '/teaching/exam',
    component: Layout,
    hidden: true,
    roles: ['teacher', 'admin'],
    children: [
      {
        path: ':paperId?',
        component: () => import('@/views/teaching/exam/index'),
        name: 'TeachingExamManage',
        meta: { title: '考试发布', activeMenu: '/teaching/paper' }
      }
    ]
  },
  {
    path: '/teaching/paper-manage',
    component: Layout,
    hidden: true,
    roles: ['teacher', 'admin'],
    children: [
      {
        path: ':bankId?',
        component: () => import('@/views/teaching/paper/manage'),
        name: 'TeachingPaperManage',
        meta: { title: '试卷管理', activeMenu: '/teaching/paper' }
      }
    ]
  },
  {
    path: '/teaching/question',
    component: Layout,
    hidden: true,
    roles: ['teacher', 'admin'],
    children: [
      {
        path: ':bankId(\\d+)',
        component: () => import('@/views/teaching/question/index'),
        name: 'TeachingQuestion',
        meta: { title: '试题管理', activeMenu: '/teaching/paper' }
      }
    ]
  },
  {
    path: '/teaching/content',
    component: Layout,
    hidden: true,
    roles: ['teacher', 'admin'],
    children: [
      {
        path: ':courseId(\\d+)',
        component: () => import('@/views/teaching/content/index'),
        name: 'TeachingContent',
        meta: { title: '课程内容管理', activeMenu: '/teaching/course' }
      }
    ]
  },
  {
    path: '/system/user-auth',
    component: Layout,
    hidden: true,
    permissions: ['system:user:edit'],
    children: [
      {
        path: 'role/:userId(\\d+)',
        component: () => import('@/views/system/user/authRole'),
        name: 'AuthRole',
        meta: { title: '分配角色', activeMenu: '/system/user' }
      }
    ]
  },
  {
    path: '/system/role-auth',
    component: Layout,
    hidden: true,
    permissions: ['system:role:edit'],
    children: [
      {
        path: 'user/:roleId(\\d+)',
        component: () => import('@/views/system/role/authUser'),
        name: 'AuthUser',
        meta: { title: '分配用户', activeMenu: '/system/role' }
      }
    ]
  },
  {
    path: '/system/dict-data',
    component: Layout,
    hidden: true,
    permissions: ['system:dict:list'],
    children: [
      {
        path: 'index/:dictId(\\d+)',
        component: () => import('@/views/system/dict/data'),
        name: 'Data',
        meta: { title: '字典数据', activeMenu: '/system/dict' }
      }
    ]
  },
  {
    path: '/monitor/job-log',
    component: Layout,
    hidden: true,
    permissions: ['monitor:job:list'],
    children: [
      {
        path: 'index/:jobId(\\d+)',
        component: () => import('@/views/monitor/job/log'),
        name: 'JobLog',
        meta: { title: '调度日志', activeMenu: '/monitor/job' }
      }
    ]
  },
  {
    path: '/tool/gen-edit',
    component: Layout,
    hidden: true,
    permissions: ['tool:gen:edit'],
    children: [
      {
        path: 'index/:tableId(\\d+)',
        component: () => import('@/views/tool/gen/editTable'),
        name: 'GenEdit',
        meta: { title: '修改生成配置', activeMenu: '/tool/gen' }
      }
    ]
  }
]

let routerPush = Router.prototype.push
let routerReplace = Router.prototype.replace

Router.prototype.push = function push(location) {
  return routerPush.call(this, location).catch(err => err)
}

Router.prototype.replace = function replace(location) {
  return routerReplace.call(this, location).catch(err => err)
}

const createRouter = () => new Router({
  mode: 'history',
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRoutes
})

const router = createRouter()

export function resetRouter() {
  const newRouter = createRouter()
  router.matcher = newRouter.matcher
}

export default router
