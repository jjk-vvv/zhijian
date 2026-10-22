import { computed, reactive, readonly, ref, watch } from 'vue'
import { getBook } from '../data/books.js'
import { readLibrary, saveLibrary, progressStatus } from '../utils/storage.js'

// 模块级状态让三个页面共享同一份数据，无需引入额外状态库。
let storage
try {
  storage = window.localStorage
} catch {
  storage = {
    getItem() {
      throw new Error()
    },
    setItem() {
      throw new Error()
    },
  }
}
const loaded = readLibrary(storage)
const library = reactive(loaded.data)
const storageError = ref(loaded.error)
const toast = ref('')
let toastTimer

watch(
  library,
  (value) => {
    storageError.value = saveLibrary(storage, value)
  },
  { deep: true, flush: 'sync' },
)

function notify(message) {
  clearTimeout(toastTimer)
  toast.value = message
  toastTimer = setTimeout(() => {
    toast.value = ''
  }, 3200)
}

function addBook(bookId) {
  if (!getBook(bookId) || library.shelf.some((entry) => entry.bookId === bookId)) return
  library.shelf.push({ bookId, progress: 0 })
  notify('已加入我的书架')
}

function removeBook(bookId) {
  library.shelf = library.shelf.filter((entry) => entry.bookId !== bookId)
  notify('已移出书架，相关手记仍会保留')
}

function updateProgress(bookId, value) {
  const entry = library.shelf.find((item) => item.bookId === bookId)
  if (entry) entry.progress = Math.min(100, Math.max(0, Number(value) || 0))
}

function saveNote(draft) {
  if (!getBook(draft.bookId) || !draft.title.trim() || !draft.content.trim()) return false
  const existing = library.notes.find((note) => note.id === draft.id)
  const note = {
    id: existing?.id || crypto.randomUUID(),
    bookId: draft.bookId,
    title: draft.title.trim().slice(0, 60),
    content: draft.content.trim().slice(0, 3000),
    type: ['感想', '摘录', '书评'].includes(draft.type) ? draft.type : '感想',
    date: existing?.date || new Date().toISOString(),
    example: false,
  }
  if (existing) library.notes.splice(library.notes.indexOf(existing), 1, note)
  else library.notes.unshift(note)
  notify(existing ? '手记已更新' : '新的阅读回响，已收好')
  return true
}

function deleteNote(id) {
  library.notes = library.notes.filter((note) => note.id !== id)
  notify('手记已删除')
}

const shelfBooks = computed(() =>
  library.shelf.map((entry) => ({
    ...getBook(entry.bookId),
    progress: entry.progress,
    status: progressStatus(entry.progress),
  })),
)
const stats = computed(() => ({
  total: library.shelf.length,
  wishlist: shelfBooks.value.filter((book) => book.status === 'wishlist').length,
  reading: shelfBooks.value.filter((book) => book.status === 'reading').length,
  finished: shelfBooks.value.filter((book) => book.status === 'finished').length,
  notes: library.notes.length,
}))

export function useLibrary() {
  return {
    library: readonly(library),
    storageError: readonly(storageError),
    toast: readonly(toast),
    shelfBooks,
    stats,
    addBook,
    removeBook,
    updateProgress,
    saveNote,
    deleteNote,
    notify,
    isSaved: (id) => library.shelf.some((entry) => entry.bookId === id),
  }
}
