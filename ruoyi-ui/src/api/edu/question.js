import request from "@/utils/request"

/**
 * 查询试题列表
 * @param {Object} query 查询参数
 * @returns {Promise}
 */
export function listQuestion(query) {
  return request({
    url: "/edu/exam/question/list",
    method: "get",
    params: query
  })
}

/**
 * 查询试题详情
 * @param {number} questionId 试题编号
 * @returns {Promise}
 */
export function getQuestion(questionId) {
  return request({
    url: "/edu/exam/question/" + questionId,
    method: "get"
  })
}

/**
 * 新增试题
 * @param {Object} data 试题数据
 * @returns {Promise}
 */
export function addQuestion(data) {
  return request({
    url: "/edu/exam/question",
    method: "post",
    data
  })
}

/**
 * 修改试题
 * @param {Object} data 试题数据
 * @returns {Promise}
 */
export function updateQuestion(data) {
  return request({
    url: "/edu/exam/question",
    method: "put",
    data
  })
}

/**
 * 删除试题
 * @param {number|Array} questionIds 试题编号
 * @returns {Promise}
 */
export function delQuestion(questionIds) {
  return request({
    url: "/edu/exam/question/" + questionIds,
    method: "delete"
  })
}
