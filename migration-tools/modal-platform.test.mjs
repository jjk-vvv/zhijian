// 使用 HBuilderX 自带的条件编译器，验证弹窗在真实平台分支中的生命周期。
import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { createRequire } from 'node:module'
import { join } from 'node:path'
import { test } from 'node:test'
import { runInNewContext } from 'node:vm'
import { compileScript, parse } from '@vue/compiler-sfc'

const hbxRoot = process.env.HBUILDERX_ROOT || 'D:/HBuilderX.5.24.2026081301/HBuilderX'
const requireCompiler = createRequire(join(hbxRoot, 'plugins/uniapp-cli-vite/package.json'))
const { initPreContext, preJs } = requireCompiler('@dcloudio/uni-cli-shared/dist/preprocess/index.js')
const source = readFileSync(new URL('../uniapp/components/ui/BaseModal.vue', import.meta.url), 'utf8')

function mountModal(platform, document) {
  initPreContext(platform)
  const { descriptor } = parse(preJs(source))
  const compiled = compileScript(descriptor, { id: 'modal-platform' }).content
    .replace(/^import .*$/gm, '')
    .replace('export default', 'globalThis.component =')
  const mounted = []
  const unmounting = []
  const events = []
  const context = {
    AppIcon: {},
    ref: (value) => ({ value }),
    onMounted: (callback) => mounted.push(callback),
    onBeforeUnmount: (callback) => unmounting.push(callback),
  }
  if (document) context.document = document
  runInNewContext(compiled, context)
  context.component.setup({}, { expose() {}, emit: (event) => events.push(event) })
  mounted.forEach((callback) => callback())
  return { events, unmount: () => unmounting.forEach((callback) => callback()) }
}

for (const platform of ['app-plus', 'mp-weixin']) {
  test(`${platform}：无 document 的逻辑层能挂载和卸载弹窗`, () => {
    const modal = mountModal(platform)
    modal.unmount()
    assert.deepEqual(modal.events, [])
  })
}

test('H5：滚动锁、Escape 关闭、监听清理与关闭后回焦', () => {
  const listeners = new Map()
  let focusRestored = false
  const document = {
    activeElement: { isConnected: true, focus: () => { focusRestored = true } },
    body: { style: { overflow: 'auto' } },
    addEventListener: (name, listener) => listeners.set(name, listener),
    removeEventListener: (name, listener) => {
      assert.equal(listeners.get(name), listener)
      listeners.delete(name)
    },
  }
  const modal = mountModal('h5', document)
  assert.equal(document.body.style.overflow, 'hidden')
  let prevented = false
  listeners.get('keydown')({ key: 'Escape', preventDefault: () => { prevented = true } })
  assert.equal(prevented, true)
  assert.deepEqual(modal.events, ['close'])
  modal.unmount()
  assert.equal(document.body.style.overflow, 'auto')
  assert.equal(listeners.size, 0)
  assert.equal(focusRestored, true)
})
