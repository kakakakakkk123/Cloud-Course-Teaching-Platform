import request from "@/utils/request"

/**
 * 查询题库列表
 * @param {Object} query 查询参数
 * @returns {Promise}
 */
export function listQuestionBank(query) {
  return request({
    url: "/edu/exam/bank/list",
    method: "get",
    params: query
  })
}

/**
 * 查询题库详情
 * @param {number} bankId 题库编号
 * @returns {Promise}
 */
export function getQuestionBank(bankId) {
  return request({
    url: "/edu/exam/bank/" + bankId,
    method: "get"
  })
}

/**
 * 新增题库
 * @param {Object} data 题库数据
 * @returns {Promise}
 */
export function addQuestionBank(data) {
  return request({
    url: "/edu/exam/bank",
    method: "post",
    data
  })
}

/**
 * 修改题库
 * @param {Object} data 题库数据
 * @returns {Promise}
 */
export function updateQuestionBank(data) {
  return request({
    url: "/edu/exam/bank",
    method: "put",
    data
  })
}

/**
 * 删除题库
 * @param {number|Array} bankIds 题库编号
 * @returns {Promise}
 */
export function delQuestionBank(bankIds) {
  return request({
    url: "/edu/exam/bank/" + bankIds,
    method: "delete"
  })
}
