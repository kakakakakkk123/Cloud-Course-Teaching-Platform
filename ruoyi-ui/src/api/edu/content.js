import request from "@/utils/request"

/**
 * 查询课程内容列表
 * @param {Object} query 查询参数
 * @returns {Promise}
 */
export function listCourseContent(query) {
  return request({
    url: "/edu/content/list",
    method: "get",
    params: query
  })
}

/**
 * 查询课程内容详情
 * @param {number} contentId 内容编号
 * @returns {Promise}
 */
export function getCourseContent(contentId) {
  return request({
    url: "/edu/content/" + contentId,
    method: "get"
  })
}

/**
 * 新增课程内容
 * @param {Object} data 内容数据
 * @returns {Promise}
 */
export function addCourseContent(data) {
  return request({
    url: "/edu/content",
    method: "post",
    data
  })
}

/**
 * 修改课程内容
 * @param {Object} data 内容数据
 * @returns {Promise}
 */
export function updateCourseContent(data) {
  return request({
    url: "/edu/content",
    method: "put",
    data
  })
}

/**
 * 删除课程内容
 * @param {number|Array} contentIds 内容编号
 * @returns {Promise}
 */
export function delCourseContent(contentIds) {
  return request({
    url: "/edu/content/" + contentIds,
    method: "delete"
  })
}
