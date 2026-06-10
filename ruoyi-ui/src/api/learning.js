import request from "@/utils/request"

/**
 * 查询学生学习概览
 */
export function getLearningOverview() {
  return request({
    url: "/student/learning/overview",
    method: "get"
  })
}

/**
 * 查询我的考试
 */
export function listMyExams(params) {
  return request({
    url: "/student/learning/exams",
    method: "get",
    params
  })
}

/**
 * 标记课程内容已学习
 */
export function markContentLearned(contentId) {
  return request({
    url: "/student/learning/contents/" + contentId + "/learn",
    method: "post"
  })
}

/**
 * 开始考试
 */
export function startStudentExam(examId) {
  return request({
    url: "/student/learning/exams/" + examId + "/start",
    method: "post"
  })
}

/**
 * 查询考试内容
 */
export function getStudentExamContent(recordId) {
  return request({
    url: "/student/learning/exam-records/" + recordId + "/content",
    method: "get"
  })
}

/**
 * 提交考试
 */
export function submitStudentExam(recordId) {
  return request({
    url: "/student/learning/exam-records/" + recordId + "/submit",
    method: "post"
  })
}

/**
 * 导入考试错题到我的错题
 */
export function importExamWrongQuestions(recordId) {
  return request({
    url: "/student/learning/exam-records/" + recordId + "/wrong-questions/import",
    method: "post"
  })
}
