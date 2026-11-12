import { test } from 'node:test'
import assert from 'node:assert/strict'
import {
  initialLibrary,
  sanitizeLibrary,
  readLibrary,
  saveLibrary,
  progressStatus,
  STORAGE_KEY,
} from '../uniapp/utils/storage.js'

test('首次访问生成互相独立的示例数据', () => {
  const first = initialLibrary(),
    second = initialLibrary()
  first.shelf.pop()
  assert.equal(second.shelf.length, 3)
  assert.equal(readLibrary({ getItem: () => null }).data.shelf.length, 3)
})
test('损坏 JSON 和禁止读取时可恢复', () => {
  assert.match(readLibrary({ getItem: () => '{broken' }).error, /无法读取/)
  assert.match(
    readLibrary({
      getItem() {
        throw new Error('disabled')
      },
    }).error,
    /无法读取/,
  )
})
test('清洗非法书籍、重复记录并限制进度', () => {
  const data = sanitizeLibrary({
    shelf: [
      { bookId: 'walden', progress: -20 },
      { bookId: 'walden', progress: 80 },
      { bookId: 'prince', progress: 120 },
      { bookId: 'missing', progress: 0 },
    ],
    notes: [],
  })
  assert.deepEqual(data.shelf, [
    { bookId: 'walden', progress: 0 },
    { bookId: 'prince', progress: 100 },
  ])
})
test('阅读状态完全由进度派生', () => {
  assert.equal(progressStatus(0), 'wishlist')
  assert.equal(progressStatus(50), 'reading')
  assert.equal(progressStatus(100), 'finished')
})
test('手记数据校验与字段限长', () => {
  const note = initialLibrary().notes[0]
  const data = sanitizeLibrary({
    shelf: [],
    notes: [
      null,
      { ...note, date: 'invalid' },
      { ...note, title: '' },
      { ...note, title: '字'.repeat(90), content: '字'.repeat(4000), type: 'other' },
      { ...note },
    ],
  })
  assert.equal(data.notes.length, 1)
  assert.equal(data.notes[0].title.length, 60)
  assert.equal(data.notes[0].content.length, 3000)
  assert.equal(data.notes[0].type, '感想')
})
test('空数据保留为空，不重新填充示例', () => {
  assert.deepEqual(readLibrary({ getItem: () => JSON.stringify({ shelf: [], notes: [] }) }).data, {
    shelf: [],
    notes: [],
  })
})
test('持久化成功和存储额度失败有明确结果', () => {
  let saved
  assert.equal(
    saveLibrary(
      {
        setItem(key, data) {
          assert.equal(key, STORAGE_KEY)
          saved = data
        },
      },
      initialLibrary(),
    ),
    '',
  )
  assert.equal(JSON.parse(saved).shelf.length, 3)
  assert.match(
    saveLibrary(
      {
        setItem() {
          throw new Error('quota')
        },
      },
      initialLibrary(),
    ),
    /无法保存/,
  )
})
