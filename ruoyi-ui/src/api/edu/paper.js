import request from "@/utils/request"

/**
 * 查询试卷列表
 * @param {Object} query 查询参数
 * @returns {Promise}
 */
export function listPaper(query) {
  return request({
    url: "/edu/exam/paper/list",
    method: "get",
    params: query
  })
}

/**
 * 查询试卷详情
 * @param {number} paperId 试卷编号
 * @returns {Promise}
 */
export function getPaper(paperId) {
  return request({
    url: "/edu/exam/paper/" + paperId,
    method: "get"
  })
}

/**
 * 新增试卷
 * @param {Object} data 试卷数据
 * @returns {Promise}
 */
export function addPaper(data) {
  return request({
    url: "/edu/exam/paper",
    method: "post",
    data
  })
}

/**
 * 修改试卷
 * @param {Object} data 试卷数据
 * @returns {Promise}
 */
export function updatePaper(data) {
  return request({
    url: "/edu/exam/paper",
    method: "put",
    data
  })
}

/**
 * 删除试卷
 * @param {number|Array} paperIds 试卷编号
 * @returns {Promise}
 */
export function delPaper(paperIds) {
  return request({
    url: "/edu/exam/paper/" + paperIds,
    method: "delete"
  })
}
