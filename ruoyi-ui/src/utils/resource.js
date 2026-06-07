export function resolveResourceUrl(url) {
  if (!url) {
    return ""
  }
  if (/^(https?:)?\/\//.test(url) || /^(data|blob):/.test(url)) {
    return url
  }
  if (/^\/static\//.test(url)) {
    return url
  }
  return process.env.VUE_APP_BASE_API + url
}
