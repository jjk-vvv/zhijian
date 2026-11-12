// 小程序与 App 把三个顶级页面放进原生 tabBar，跳转必须用 uni.switchTab；
// 只有 H5 没有 tabBar，继续用 redirectTo。
// 另外 switchTab 不能带 query，所以「写手记」入口改成先写一次性标记、由手记页 onShow 消费。
const COMPOSE_KEY = 'zhijian-compose-request'
const COMPOSE_EVENT = 'zhijian:compose'

export function goTab(path) {
  // #ifndef H5
  uni.switchTab({ url: path })
  // #endif
  // #ifdef H5
  uni.redirectTo({ url: path })
  // #endif
}

function currentRoute() {
  const pages = getCurrentPages()
  const page = pages[pages.length - 1]
  return page ? page.route : ''
}

export function composeNote(bookId) {
  const id = typeof bookId === 'string' ? bookId : ''
  // 已经停在手记页时，switchTab 不会再触发 onShow，改用事件直接打开编辑器
  if (currentRoute() === 'pages/notes/notes') {
    uni.$emit(COMPOSE_EVENT, id)
    return
  }
  // #ifndef H5
  uni.setStorageSync(COMPOSE_KEY, id || '1')
  uni.switchTab({ url: '/pages/notes/notes' })
  // #endif
  // #ifdef H5
  uni.redirectTo({ url: `/pages/notes/notes?compose=1${id ? `&book=${id}` : ''}` })
  // #endif
}

// 手记页 onShow 调用：有待办返回 { bookId }，没有返回 null
export function takeComposeRequest() {
  let raw = ''
  try {
    raw = uni.getStorageSync(COMPOSE_KEY)
  } catch {
    raw = ''
  }
  if (!raw) return null
  try {
    uni.removeStorageSync(COMPOSE_KEY)
  } catch {
    /* 忽略：标记取不走也不会重复打开编辑器 */
  }
  const value = String(raw)
  return { bookId: value === '1' ? '' : value }
}

export { COMPOSE_EVENT }
