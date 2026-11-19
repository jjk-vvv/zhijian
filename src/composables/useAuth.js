import { computed, reactive, readonly } from 'vue'
import { api, getToken, setToken } from '../api/client.js'

const state = reactive({
  user: null,
  ready: false,
  loading: false,
})

let readyPromise = null

function applySession(payload) {
  state.user = payload.user
  setToken(payload.token)
  state.ready = true
}

export async function ensureReady() {
  if (state.ready) return state.user
  if (readyPromise) return readyPromise
  readyPromise = (async () => {
    if (!getToken()) {
      state.ready = true
      return null
    }
    state.loading = true
    try {
      const payload = await api.auth.me()
      state.user = payload.user
      return state.user
    } catch {
      setToken('')
      state.user = null
      return null
    } finally {
      state.loading = false
      state.ready = true
    }
  })()
  return readyPromise
}

export async function login(credentials) {
  const payload = await api.auth.login(credentials)
  applySession(payload)
  return payload.user
}

export async function register(data) {
  const payload = await api.auth.register(data)
  applySession(payload)
  return payload.user
}

export function logout() {
  setToken('')
  state.user = null
  state.ready = true
}

export async function updateProfile(data) {
  const payload = await api.me.update(data)
  state.user = payload.user
  return payload.user
}

export async function refreshUser() {
  if (!getToken()) return null
  const payload = await api.auth.me()
  state.user = payload.user
  return payload.user
}

if (typeof window !== 'undefined') {
  window.addEventListener('zhijian:unauthorized', () => {
    state.user = null
    state.ready = true
  })
}

const isAuthed = computed(() => Boolean(state.user))
const currentUser = computed(() => state.user)

export function useAuth() {
  return {
    state: readonly(state),
    isAuthed,
    currentUser,
    ensureReady,
    login,
    register,
    logout,
    updateProfile,
    refreshUser,
  }
}
