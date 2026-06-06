import request from "@/utils/request"

/**
 * 查询课程列表
 * @param {Object} query 查询参数
 * @returns {Promise}
 */
export function listCourse(query) {
  return request({
    url: "/edu/course/list",
    method: "get",
    params: query
  })
}

/**
 * 查询课程详情
 * @param {number} courseId 课程编号
 * @returns {Promise}
 */
export function getCourse(courseId) {
  return request({
    url: "/edu/course/" + courseId,
    method: "get"
  })
}

/**
 * 新增课程
 * @param {Object} data 课程数据
 * @returns {Promise}
 */
export function addCourse(data) {
  return request({
    url: "/edu/course",
    method: "post",
    data
  })
}

/**
 * 修改课程
 * @param {Object} data 课程数据
 * @returns {Promise}
 */
export function updateCourse(data) {
  return request({
    url: "/edu/course",
    method: "put",
    data
  })
}

/**
 * 删除课程
 * @param {number|Array} courseIds 课程编号
 * @returns {Promise}
 */
export function delCourse(courseIds) {
  return request({
    url: "/edu/course/" + courseIds,
    method: "delete"
  })
}

/**
 * 查询课程分类树
 * @returns {Promise}
 */
export function listCourseCategoryTree() {
  return request({
    url: "/edu/category/tree",
    method: "get"
  })
}
