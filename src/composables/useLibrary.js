import { computed, readonly, ref } from 'vue'
import { api } from '../api/client.js'
import { notify } from './useToast.js'
import { ensureReady, useAuth } from './useAuth.js'

const shelf = ref([])
const notes = ref([])
const shelfLoaded = ref(false)
const notesLoaded = ref(false)
const loading = ref(false)
const progressTimers = new Map()
const { currentUser } = useAuth()

const deriveStatus = (progress) =>
  progress >= 100 ? 'finished' : progress > 0 ? 'reading' : 'wishlist'

async function refreshShelf() {
  if (!currentUser.value) {
    shelf.value = []
    shelfLoaded.value = true
    return
  }
  const payload = await api.shelf.list()
  shelf.value = payload.items
  shelfLoaded.value = true
}

async function refreshNotes() {
  if (!currentUser.value) {
    notes.value = []
    notesLoaded.value = true
    return
  }
  const payload = await api.notes.list()
  notes.value = payload.items
  notesLoaded.value = true
}

async function refreshAll() {
  await ensureReady()
  if (!currentUser.value) {
    shelf.value = []
    notes.value = []
    shelfLoaded.value = true
    notesLoaded.value = true
    return
  }
  loading.value = true
  try {
    await Promise.all([refreshShelf(), refreshNotes()])
  } catch {
    notify('书架加载失败，请稍后重试', 'error')
  } finally {
    loading.value = false
  }
}

async function addBook(slug, status = 'wishlist') {
  if (!currentUser.value) {
    notify('登录后即可收藏到书架', 'error')
    return false
  }
  try {
    const book = await api.shelf.add({ bookSlug: slug, status })
    const existing = shelf.value.find((item) => item.slug === slug)
    if (existing) Object.assign(existing, book)
    else shelf.value.unshift(book)
    notify(status === 'finished' ? '已标记读完，值得纪念' : '已加入我的书架')
    return true
  } catch (error) {
    notify(error.message, 'error')
    return false
  }
}

async function setStatus(slug, status) {
  const entry = shelf.value.find((item) => item.slug === slug)
  if (!entry) return addBook(slug, status)
  const previous = { status: entry.status, progress: entry.progress }
  entry.status = status
  entry.progress = status === 'finished' ? 100 : status === 'wishlist' ? 0 : entry.progress
  try {
    const result = await api.shelf.update(slug, { status })
    Object.assign(entry, result)
    notify(
      status === 'finished'
        ? '已标记读完，去写点什么吧'
        : status === 'reading'
          ? '开始阅读，慢慢来'
          : '阅读状态已更新',
    )
  } catch (error) {
    Object.assign(entry, previous)
    notify(error.message, 'error')
  }
}

function updateProgress(slug, value) {
  const entry = shelf.value.find((item) => item.slug === slug)
  if (!entry) return
  const progress = Math.min(100, Math.max(0, Number(value) || 0))
  const wasFinished = entry.progress >= 100
  entry.progress = progress
  entry.status = deriveStatus(progress)
  clearTimeout(progressTimers.get(slug))
  progressTimers.set(
    slug,
    setTimeout(async () => {
      try {
        const result = await api.shelf.update(slug, { progress })
        Object.assign(entry, result)
        if (result.progress >= 100 && !wasFinished) notify('又读完一本，值得纪念')
      } catch (error) {
        notify(error.message, 'error')
      }
    }, 450),
  )
}

async function removeBook(slug) {
  try {
    await api.shelf.remove(slug)
    shelf.value = shelf.value.filter((item) => item.slug !== slug)
    notify('已移出书架，相关手记仍会保留')
  } catch (error) {
    notify(error.message, 'error')
  }
}

async function saveNote(draft) {
  try {
    if (draft.id) {
      const updated = await api.notes.update(draft.id, {
        bookSlug: draft.bookSlug,
        title: draft.title,
        content: draft.content,
        type: draft.type,
        page: draft.page || null,
        isPrivate: draft.isPrivate,
      })
      const index = notes.value.findIndex((note) => note.id === updated.id)
      if (index >= 0) notes.value.splice(index, 1, updated)
      else notes.value.unshift(updated)
      notify('手记已更新')
    } else {
      const created = await api.notes.create({
        bookSlug: draft.bookSlug,
        title: draft.title,
        content: draft.content,
        type: draft.type,
        page: draft.page || null,
        isPrivate: draft.isPrivate ?? true,
      })
      notes.value.unshift(created)
      notify('新的阅读回响，已收好')
    }
    return true
  } catch (error) {
    notify(error.message, 'error')
    return false
  }
}

async function deleteNote(id) {
  try {
    await api.notes.remove(id)
    notes.value = notes.value.filter((note) => note.id !== id)
    notify('手记已删除')
    return true
  } catch (error) {
    notify(error.message, 'error')
    return false
  }
}

const shelfBooks = computed(() =>
  shelf.value.map((book) => ({
    ...book,
    status: book.status || deriveStatus(book.progress || 0),
  })),
)

const stats = computed(() => ({
  total: shelf.value.length,
  wishlist: shelf.value.filter((book) => book.status === 'wishlist').length,
  reading: shelf.value.filter((book) => book.status === 'reading').length,
  finished: shelf.value.filter((book) => book.status === 'finished').length,
  dnf: shelf.value.filter((book) => book.status === 'dnf').length,
  notes: notes.value.length,
}))

const isSaved = (slug) => shelf.value.some((book) => book.slug === slug)

export function useLibrary() {
  return {
    shelf: readonly(shelf),
    notes: readonly(notes),
    shelfBooks,
    stats,
    loading: readonly(loading),
    shelfLoaded: readonly(shelfLoaded),
    notesLoaded: readonly(notesLoaded),
    refreshShelf,
    refreshNotes,
    refreshAll,
    addBook,
    setStatus,
    updateProgress,
    removeBook,
    saveNote,
    deleteNote,
    isSaved,
  }
}
