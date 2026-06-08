import request from "@/utils/request"

/**
 * 查询考试统计概览
 * @param {number} examId 考试编号
 * @returns {Promise}
 */
export function getExamStatOverview(examId) {
  return request({
    url: "/edu/exam/stat/overview/" + examId,
    method: "get"
  })
}

/**
 * 查询考试成绩列表
 * @param {Object} query 查询参数
 * @returns {Promise}
 */
export function listExamStatRecord(query) {
  return request({
    url: "/edu/exam/stat/record/list",
    method: "get",
    params: query
  })
}

/**
 * 查询考试批改详情
 * @param {number} recordId 作答记录ID
 * @returns {Promise}
 */
export function getExamReviewDetail(recordId) {
  return request({
    url: "/edu/exam/stat/review/" + recordId,
    method: "get"
  })
}

/**
 * 保存或提交考试批改
 * @param {number} recordId 作答记录ID
 * @param {Object} data 批改内容
 * @returns {Promise}
 */
export function submitExamReview(recordId, data) {
  return request({
    url: "/edu/exam/stat/review/" + recordId,
    method: "post",
    data
  })
}
