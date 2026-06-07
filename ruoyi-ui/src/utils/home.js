export const DEFAULT_HOME_PATH = '/index'
export const STUDENT_HOME_PATH = '/learning/my-course'

export function isStudentRole(roles) {
  return Array.isArray(roles) && roles.indexOf('student') !== -1
}

export function getHomePath(roles) {
  return isStudentRole(roles) ? STUDENT_HOME_PATH : DEFAULT_HOME_PATH
}

export function isDashboardPath(path) {
  const normalizedPath = String(path || '').split('?')[0].replace(/\/+$/, '')
  return normalizedPath === DEFAULT_HOME_PATH
}

export function normalizeHomePath(roles, path) {
  if (isStudentRole(roles) && isDashboardPath(path)) {
    return STUDENT_HOME_PATH
  }
  return path || getHomePath(roles)
}
