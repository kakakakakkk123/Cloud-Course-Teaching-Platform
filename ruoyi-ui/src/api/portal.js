import request from '@/utils/request'

/**
 * 查询门户首页数据
 */
export function getPortalHome() {
  return request({
    url: '/portal/home',
    headers: {
      isToken: false
    },
    method: 'get'
  })
}

/**
 * 查询门户课程列表
 */
export function listPortalCourses(params) {
  return request({
    url: '/portal/courses/list',
    headers: {
      isToken: false
    },
    method: 'get',
    params
  })
}

/**
 * 查询课程详情
 */
export function getPortalCourseDetail(courseId) {
  return request({
    url: '/portal/courses/' + courseId,
    method: 'get'
  })
}

/**
 * 查询我的课程
 */
export function listMyPortalCourses() {
  return request({
    url: '/portal/courses/my',
    method: 'get'
  })
}

/**
 * 查询我的收藏课程
 */
export function listFavoritePortalCourses() {
  return request({
    url: '/portal/courses/favorites',
    method: 'get'
  })
}

/**
 * 注册课程
 */
export function enrollPortalCourse(courseId) {
  return request({
    url: '/portal/courses/' + courseId + '/enroll',
    method: 'post'
  })
}

/**
 * 点赞课程
 */
export function likePortalCourse(courseId) {
  return request({
    url: '/portal/courses/' + courseId + '/like',
    method: 'post'
  })
}

/**
 * 取消点赞课程
 */
export function cancelLikePortalCourse(courseId) {
  return request({
    url: '/portal/courses/' + courseId + '/like',
    method: 'delete'
  })
}

/**
 * 收藏课程
 */
export function favoritePortalCourse(courseId) {
  return request({
    url: '/portal/courses/' + courseId + '/favorite',
    method: 'post'
  })
}

/**
 * 取消收藏课程
 */
export function cancelFavoritePortalCourse(courseId) {
  return request({
    url: '/portal/courses/' + courseId + '/favorite',
    method: 'delete'
  })
}
