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
 * 查询我的学习笔记
 */
export function listLearningNotes() {
  return request({
    url: "/student/learning/notes",
    method: "get"
  })
}

/**
 * 保存课程内容笔记
 */
export function saveContentLearningNote(contentId, data) {
  return request({
    url: "/student/learning/contents/" + contentId + "/note",
    method: "post",
    data
  })
}

/**
 * 删除课程内容笔记
 */
export function deleteContentLearningNote(contentId) {
  return request({
    url: "/student/learning/contents/" + contentId + "/note",
    method: "delete"
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
 * 查询答题页
 */
export function getStudentExamPaper(recordId) {
  return request({
    url: "/student/learning/exam-records/" + recordId + "/paper",
    method: "get"
  })
}

/**
 * 暂存考试答案
 */
export function saveStudentExamAnswers(recordId, data) {
  return request({
    url: "/student/learning/exam-records/" + recordId + "/answers",
    method: "post",
    data
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

/**
 * 查询考试结果
 */
export function getStudentExamResult(recordId) {
  return request({
    url: "/student/learning/exam-records/" + recordId + "/result",
    method: "get"
  })
}

/**
 * 查询课程讨论
 */
export function listCourseDiscussions(courseId) {
  return request({
    url: "/student/learning/courses/" + courseId + "/discussions",
    method: "get"
  })
}

export function addCourseDiscussion(courseId, data) {
  return request({
    url: "/student/learning/courses/" + courseId + "/discussions",
    method: "post",
    data
  })
}

/**
 * 查询我的讨论
 */
export function listMyDiscussions() {
  return request({
    url: "/student/learning/discussions",
    method: "get"
  })
}
