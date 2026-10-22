import { books } from '../data/books.js'

export const STORAGE_KEY = 'zhijian-library-v1'
const bookIds = new Set(books.map((book) => book.id))
export const progressStatus = (progress) =>
  progress >= 100 ? 'finished' : progress > 0 ? 'reading' : 'wishlist'

export function initialLibrary() {
  return {
    shelf: [
      { bookId: 'walden', progress: 36 },
      { bookId: 'prince', progress: 100 },
      { bookId: 'ownroom', progress: 0 },
    ],
    notes: [
      {
        id: 'welcome-note',
        bookId: 'walden',
        title: '把脚步放慢一点',
        content:
          '今天读到湖边生活的片段，想起很久没有认真观察窗外的树了。也许可以从每天留出十分钟开始，把注意力还给眼前的生活。',
        type: '感想',
        date: '2026-10-20T08:00:00.000Z',
        example: true,
      },
    ],
  }
}

// 本地存储也需要校验，避免旧版本、损坏 JSON 或非法数值使页面崩溃。
export function sanitizeLibrary(value) {
  if (!value || !Array.isArray(value.shelf) || !Array.isArray(value.notes))
    throw new Error('无效的数据格式')
  const seen = new Set()
  const shelf = value.shelf
    .filter((entry) => {
      if (!entry || !bookIds.has(entry.bookId) || seen.has(entry.bookId)) return false
      seen.add(entry.bookId)
      return true
    })
    .map((entry) => ({
      bookId: entry.bookId,
      progress: Math.min(100, Math.max(0, Number(entry.progress) || 0)),
    }))
  const noteIds = new Set()
  const notes = value.notes
    .filter((note) => {
      if (
        !note ||
        typeof note.id !== 'string' ||
        noteIds.has(note.id) ||
        !bookIds.has(note.bookId) ||
        typeof note.title !== 'string' ||
        typeof note.content !== 'string' ||
        !note.title.trim() ||
        !note.content.trim() ||
        !Number.isFinite(Date.parse(note.date))
      )
        return false
      noteIds.add(note.id)
      return true
    })
    .map((note) => ({
      id: note.id.slice(0, 80),
      bookId: note.bookId,
      title: note.title.slice(0, 60),
      content: note.content.slice(0, 3000),
      type: ['感想', '摘录', '书评'].includes(note.type) ? note.type : '感想',
      date: note.date,
      example: note.example === true,
    }))
  return { shelf, notes }
}

export function readLibrary(storage) {
  try {
    const raw = storage.getItem(STORAGE_KEY)
    return { data: raw === null ? initialLibrary() : sanitizeLibrary(JSON.parse(raw)), error: '' }
  } catch {
    return { data: initialLibrary(), error: '无法读取本地记录，已载入示例内容。你仍可正常使用。' }
  }
}

export function saveLibrary(storage, data) {
  try {
    storage.setItem(STORAGE_KEY, JSON.stringify(data))
    return ''
  } catch {
    return '浏览器暂时无法保存数据，本次操作仍已生效；关闭页面后可能丢失。'
  }
}
