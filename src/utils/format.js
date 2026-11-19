export const formatDate = (value, options = {}) => {
  if (!value) return ''
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return ''
  return new Intl.DateTimeFormat('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    ...options,
  }).format(date)
}

export const formatShortDate = (value) => {
  if (!value) return ''
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return ''
  return new Intl.DateTimeFormat('zh-CN', { month: 'long', day: 'numeric' }).format(date)
}

export const formatRelative = (value) => {
  if (!value) return ''
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return ''
  const diff = Date.now() - date.getTime()
  const minute = 60_000
  if (diff < minute) return '刚刚'
  if (diff < 60 * minute) return `${Math.floor(diff / minute)} 分钟前`
  if (diff < 24 * 60 * minute) return `${Math.floor(diff / (60 * minute))} 小时前`
  if (diff < 7 * 24 * 60 * minute) return `${Math.floor(diff / (24 * 60 * minute))} 天前`
  return formatShortDate(value)
}

export const formatMinutes = (minutes) => {
  const total = Number(minutes) || 0
  if (total < 60) return `${total} 分钟`
  const hours = Math.floor(total / 60)
  const rest = total % 60
  return rest ? `${hours} 小时 ${rest} 分钟` : `${hours} 小时`
}

export const monthLabel = (month) => `${month} 月`

export const percent = (value, total) => {
  if (!total) return 0
  return Math.min(100, Math.round((Number(value) / Number(total)) * 100))
}

export const TYPE_LABELS = {
  thought: '感想',
  excerpt: '摘录',
  review: '书评',
}

export const STATUS_LABELS = {
  wishlist: '想读',
  reading: '在读',
  finished: '读完',
  dnf: '弃读',
}

export const ACTIVITY_LABELS = {
  shelf_add: '把书放进了书架',
  finished: '读完了一本书',
  review: '写下一篇书评',
  note: '留下了一篇手记',
  highlight: '划下了一段文字',
  list_create: '创建了一份书单',
  club_join: '加入了一间书友会',
  goal: '更新了年度目标',
}
