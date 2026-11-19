const TOKEN_KEY = 'zhijian-token'

export class ApiError extends Error {
  constructor(status, code, message, details) {
    super(message)
    this.status = status
    this.code = code
    this.details = details
  }
}

export const getToken = () => {
  try {
    return localStorage.getItem(TOKEN_KEY) || ''
  } catch {
    return ''
  }
}

export const setToken = (token) => {
  try {
    if (token) localStorage.setItem(TOKEN_KEY, token)
    else localStorage.removeItem(TOKEN_KEY)
  } catch {
    // 隐私模式下 localStorage 可能不可用，登录状态仅保留在本次会话。
  }
}

function buildUrl(path, query) {
  if (!query) return `/api/v1${path}`
  const search = new URLSearchParams()
  Object.entries(query).forEach(([key, value]) => {
    if (value === undefined || value === null || value === '') return
    search.append(key, value)
  })
  const qs = search.toString()
  return `/api/v1${path}${qs ? `?${qs}` : ''}`
}

export async function request(path, { method = 'GET', body, query } = {}) {
  const headers = {}
  const token = getToken()
  if (token) headers.Authorization = `Bearer ${token}`
  if (body !== undefined) headers['Content-Type'] = 'application/json'

  let response
  try {
    response = await fetch(buildUrl(path, query), {
      method,
      headers,
      body: body !== undefined ? JSON.stringify(body) : undefined,
    })
  } catch {
    throw new ApiError(0, 'NETWORK_ERROR', '无法连接服务器，请确认后端服务已启动')
  }

  if (response.status === 204) return null

  const payload = await response.json().catch(() => null)
  if (!response.ok) {
    const error = payload?.error || {}
    if (response.status === 401 && token) {
      setToken('')
      window.dispatchEvent(new CustomEvent('zhijian:unauthorized'))
    }
    throw new ApiError(
      response.status,
      error.code || 'REQUEST_FAILED',
      error.message || '请求失败，请稍后再试',
      error.details,
    )
  }
  return payload
}

export const api = {
  auth: {
    register: (body) => request('/auth/register', { method: 'POST', body }),
    login: (body) => request('/auth/login', { method: 'POST', body }),
    me: () => request('/auth/me'),
    changePassword: (body) => request('/auth/password', { method: 'PATCH', body }),
  },
  books: {
    list: (query) => request('/books', { query }),
    categories: () => request('/books/categories'),
    detail: (slug) => request(`/books/${slug}`),
    distribution: (slug) => request(`/books/${slug}/rating-distribution`),
    reviews: (slug, query) => request(`/books/${slug}/reviews`, { query }),
    saveReview: (slug, body) => request(`/books/${slug}/reviews`, { method: 'PUT', body }),
  },
  shelf: {
    list: (status) => request('/me/shelf', { query: { status } }),
    add: (body) => request('/me/shelf', { method: 'POST', body }),
    update: (slug, body) => request(`/me/shelf/${slug}`, { method: 'PATCH', body }),
    remove: (slug) => request(`/me/shelf/${slug}`, { method: 'DELETE' }),
  },
  notes: {
    list: (query) => request('/me/notes', { query }),
    create: (body) => request('/me/notes', { method: 'POST', body }),
    update: (id, body) => request(`/me/notes/${id}`, { method: 'PATCH', body }),
    remove: (id) => request(`/me/notes/${id}`, { method: 'DELETE' }),
  },
  highlights: {
    list: (query) => request('/me/highlights', { query }),
    daily: () => request('/me/highlights/daily'),
    create: (body) => request('/me/highlights', { method: 'POST', body }),
    remove: (id) => request(`/me/highlights/${id}`, { method: 'DELETE' }),
  },
  reviews: {
    list: (query) => request('/reviews', { query }),
    like: (id) => request(`/reviews/${id}/like`, { method: 'POST' }),
    comments: (id) => request(`/reviews/${id}/comments`),
    comment: (id, body) => request(`/reviews/${id}/comments`, { method: 'POST', body }),
    remove: (id) => request(`/reviews/${id}`, { method: 'DELETE' }),
  },
  sessions: {
    list: (query) => request('/me/sessions', { query }),
    create: (body) => request('/me/sessions', { method: 'POST', body }),
    remove: (id) => request(`/me/sessions/${id}`, { method: 'DELETE' }),
  },
  stats: {
    overview: () => request('/me/stats/overview'),
    heatmap: (year) => request('/me/stats/heatmap', { query: { year } }),
    annual: (year) => request('/me/stats/annual', { query: { year } }),
    friendsWeekly: () => request('/me/stats/friends-weekly'),
  },
  goals: {
    get: (year) => request('/me/goals', { query: { year } }),
    set: (body) => request('/me/goals', { method: 'PUT', body }),
  },
  lists: {
    list: (query) => request('/lists', { query }),
    get: (id) => request(`/lists/${id}`),
    create: (body) => request('/lists', { method: 'POST', body }),
    update: (id, body) => request(`/lists/${id}`, { method: 'PATCH', body }),
    remove: (id) => request(`/lists/${id}`, { method: 'DELETE' }),
    addItem: (id, body) => request(`/lists/${id}/items`, { method: 'POST', body }),
    removeItem: (id, slug) => request(`/lists/${id}/items/${slug}`, { method: 'DELETE' }),
  },
  feed: (query) => request('/feed', { query }),
  readers: (query) => request('/readers', { query }),
  suggestions: () => request('/suggestions'),
  profile: (handle) => request(`/users/${handle}`),
  profileShelf: (handle) => request(`/users/${handle}/shelf`),
  profileContent: (handle, type) => request(`/users/${handle}/content/${type}`),
  follow: (handle) => request(`/users/${handle}/follow`, { method: 'POST' }),
  clubs: {
    list: () => request('/clubs'),
    get: (slug) => request(`/clubs/${slug}`),
    create: (body) => request('/clubs', { method: 'POST', body }),
    join: (slug) => request(`/clubs/${slug}/join`, { method: 'POST' }),
    post: (slug, body) => request(`/clubs/${slug}/posts`, { method: 'POST', body }),
    removePost: (slug, id) => request(`/clubs/${slug}/posts/${id}`, { method: 'DELETE' }),
  },
  notifications: {
    list: (query) => request('/notifications', { query }),
    read: (id) => request(`/notifications/${id}/read`, { method: 'POST' }),
    readAll: () => request('/notifications/read-all', { method: 'POST' }),
  },
  me: {
    update: (body) => request('/me', { method: 'PATCH', body }),
    export: () => request('/me/export'),
    import: (body) => request('/me/import', { method: 'POST', body }),
    remove: (body) => request('/me', { method: 'DELETE', body }),
  },
}
