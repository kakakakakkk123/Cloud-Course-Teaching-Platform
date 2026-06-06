import request from "@/utils/request"

/**
 * 查询考试列表
 * @param {Object} query 查询参数
 * @returns {Promise}
 */
export function listExam(query) {
  return request({
    url: "/edu/exam/manage/list",
    method: "get",
    params: query
  })
}

/**
 * 查询考试详情
 * @param {number} examId 考试编号
 * @returns {Promise}
 */
export function getExam(examId) {
  return request({
    url: "/edu/exam/manage/" + examId,
    method: "get"
  })
}

/**
 * 新增考试
 * @param {Object} data 考试数据
 * @returns {Promise}
 */
export function addExam(data) {
  return request({
    url: "/edu/exam/manage",
    method: "post",
    data
  })
}

/**
 * 修改考试
 * @param {Object} data 考试数据
 * @returns {Promise}
 */
export function updateExam(data) {
  return request({
    url: "/edu/exam/manage",
    method: "put",
    data
  })
}

/**
 * 删除考试
 * @param {number|Array} examIds 考试编号
 * @returns {Promise}
 */
export function delExam(examIds) {
  return request({
    url: "/edu/exam/manage/" + examIds,
    method: "delete"
  })
}
