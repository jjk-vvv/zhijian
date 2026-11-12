// 小程序与部分低版本 WebView 没有 crypto.randomUUID，这里做统一兜底。
export function createId() {
  if (typeof crypto !== 'undefined' && crypto && typeof crypto.randomUUID === 'function') {
    return crypto.randomUUID()
  }
  const time = Date.now().toString(36)
  const random = Math.random().toString(36).slice(2, 10)
  return `note-${time}-${random}`
}
