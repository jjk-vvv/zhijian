// 在 Node 中用最小 uni API stub 驱动迁移后的 useLibrary，
// 验证加入/移出书架、进度派生、手记增删改与持久化行为与原 Web 版一致。
import assert from 'node:assert/strict'

const storage = new Map()
globalThis.uni = {
  getStorageSync(key) {
    return storage.has(key) ? storage.get(key) : ''
  },
  setStorageSync(key, value) {
    storage.set(key, value)
  },
}

const { useLibrary } = await import('../uniapp/composables/useLibrary.js')
const { STORAGE_KEY } = await import('../uniapp/utils/storage.js')

const lib = useLibrary()
const checks = []
const check = (name, fn) => {
  fn()
  checks.push(name)
}

check('首次进入载入 3 本示例藏书与 1 篇示例手记', () => {
  assert.equal(lib.stats.value.total, 3)
  assert.equal(lib.stats.value.notes, 1)
  assert.deepEqual(
    lib.shelfBooks.value.map((b) => [b.id, b.progress, b.status]),
    [
      ['walden', 36, 'reading'],
      ['prince', 100, 'finished'],
      ['ownroom', 0, 'wishlist'],
    ],
  )
  assert.equal(lib.stats.value.reading, 1)
  assert.equal(lib.stats.value.finished, 1)
  assert.equal(lib.stats.value.wishlist, 1)
})

check('首次进入只读载入，未发生修改前不写盘（与原 Web 版一致）', () => {
  assert.equal(storage.has(STORAGE_KEY), false)
})

check('加入书架并给出提示，重复加入无效', () => {
  lib.addBook('moon')
  assert.equal(lib.stats.value.total, 4)
  assert.equal(lib.isSaved('moon'), true)
  assert.equal(lib.toast.value, '已加入我的书架')
  lib.addBook('moon')
  assert.equal(lib.stats.value.total, 4)
  assert.equal(storage.get(STORAGE_KEY).shelf.length, 4)
})

check('非法书号不会入库', () => {
  lib.addBook('not-a-book')
  assert.equal(lib.stats.value.total, 4)
})

check('进度变化会重新派生阅读状态并范围收敛', () => {
  lib.updateProgress('ownroom', 100)
  assert.equal(lib.stats.value.finished, 2)
  lib.updateProgress('ownroom', 250)
  assert.equal(lib.stats.value.finished, 2)
  // 归零后 ownroom 与先前加入的 moon 都回到「想读」
  lib.updateProgress('ownroom', -5)
  assert.equal(lib.stats.value.wishlist, 2)
})

check('新建手记：生成 id、限制类型、写入存储', () => {
  const ok = lib.saveNote({ bookId: 'moon', title: '  夜晚的星球  ', content: ' 一句摘录 ', type: '不存在' })
  assert.equal(ok, true)
  assert.equal(lib.stats.value.notes, 2)
  const note = lib.library.notes[0]
  assert.equal(note.title, '夜晚的星球')
  assert.equal(note.content, '一句摘录')
  assert.equal(note.type, '感想')
  assert.match(note.id, /\w+/)
  assert.equal(lib.toast.value, '新的阅读回响，已收好')
})

check('非法手记被拒绝', () => {
  assert.equal(lib.saveNote({ bookId: 'moon', title: '   ', content: '正文' }), false)
  assert.equal(lib.saveNote({ bookId: 'missing', title: '标题', content: '正文' }), false)
  assert.equal(lib.stats.value.notes, 2)
})

check('编辑手记保持 id 与创建时间', () => {
  const before = lib.library.notes[0]
  lib.saveNote({ ...before, title: '改过的标题' })
  const after = lib.library.notes[0]
  assert.equal(after.id, before.id)
  assert.equal(after.date, before.date)
  assert.equal(after.title, '改过的标题')
  assert.equal(lib.stats.value.notes, 2)
})

check('删除手记', () => {
  lib.deleteNote(lib.library.notes[0].id)
  assert.equal(lib.stats.value.notes, 1)
  assert.equal(lib.toast.value, '手记已删除')
})

check('移出书架不清除手记', () => {
  lib.removeBook('walden')
  assert.equal(lib.stats.value.total, 3)
  assert.equal(lib.stats.value.notes, 1)
  assert.equal(lib.toast.value, '已移出书架，相关手记仍会保留')
  assert.equal(storage.get(STORAGE_KEY).shelf.some((e) => e.bookId === 'walden'), false)
})

check('示例手记与示例藏书互不影响', () => {
  const saved = storage.get(STORAGE_KEY)
  assert.equal(saved.notes.length, 1)
  assert.equal(saved.notes[0].id, 'welcome-note')
})

console.log(`业务逻辑检查通过（${checks.length} 项）：`)
checks.forEach((name) => console.log('  ✔ ' + name))
