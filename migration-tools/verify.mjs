// uni-app 迁移静态校验：
// 1. 用 @vue/compiler-sfc 编译每个 SFC（等效于构建时的模板/脚本/样式解析）
// 2. 校验 manifest.json / pages.json 结构，并确认 pages.json 指向的文件存在
// 3. CSS class 与模板 class 双向对账，抓出「选择器改名遗漏 / 模板漏加 class」
// 4. 扫描小程序端不支持的标签与浏览器 API
// 5. 确认 AppIcon 用到的每个 (tone, name) 组合都有 PNG
import { readFileSync, readdirSync, statSync, existsSync } from 'node:fs'
import { join, relative, dirname } from 'node:path'
import { parse, compileScript, compileTemplate, compileStyle } from '@vue/compiler-sfc'

const ROOT = 'D:/zhijian/uniapp'
const problems = []
const notes = []

const walk = (dir) => {
  const out = []
  for (const entry of readdirSync(dir)) {
    // unpackage 是 HBuilderX 构建产物，不参与源码校验
    if (entry === 'node_modules' || entry === 'unpackage' || entry.startsWith('.')) continue
    const full = join(dir, entry)
    if (statSync(full).isDirectory()) out.push(...walk(full))
    else out.push(full)
  }
  return out
}

const files = walk(ROOT)
const vueFiles = files.filter((file) => file.endsWith('.vue'))
const cssFile = join(ROOT, 'styles/main.css')
const css = readFileSync(cssFile, 'utf8')
const relPath = (file) => relative(ROOT, file).split('\\').join('/')

// ---------------------------------------------------------------- 1. SFC 编译
const templates = new Map()
for (const file of vueFiles) {
  const source = readFileSync(file, 'utf8')
  const rel = relPath(file)
  const { descriptor, errors } = parse(source, { filename: file })
  if (errors.length) {
    problems.push(`${rel}: SFC 解析失败 → ${errors.map((e) => e.message).join('; ')}`)
    continue
  }
  const id = rel.replace(/[^\w-]/g, '_')
  try {
    if (descriptor.script || descriptor.scriptSetup) compileScript(descriptor, { id })
  } catch (error) {
    problems.push(`${rel}: <script> 编译失败 → ${error.message}`)
  }
  if (descriptor.template) {
    const result = compileTemplate({
      source: descriptor.template.content,
      filename: file,
      id,
      isProd: false,
    })
    if (result.errors.length) {
      problems.push(
        `${rel}: 模板编译失败 → ${result.errors.map((e) => e.message || e).join('; ')}`,
      )
    }
    templates.set(rel, descriptor.template.content)
  }
  for (const style of descriptor.styles) {
    const result = compileStyle({
      source: style.content,
      filename: file,
      id,
      scoped: false,
      preprocessLang: style.lang,
    })
    if (result.errors.length) {
      problems.push(`${rel}: <style> 编译失败 → ${result.errors.map((e) => e.message).join('; ')}`)
    }
  }
}

// ------------------------------------------------------------ 2. JSON 与页面
// pages.json 允许注释与条件编译（// #ifdef MP），这里先剥掉注释再解析
const stripJsonComments = (text) =>
  text.replace(/\/\*[\s\S]*?\*\//g, '').replace(/(^|[^:])\/\/[^\n]*/g, '')
const manifest = JSON.parse(readFileSync(join(ROOT, 'manifest.json'), 'utf8'))
const pages = JSON.parse(stripJsonComments(readFileSync(join(ROOT, 'pages.json'), 'utf8')))
if (manifest.vueVersion !== '3') problems.push('manifest.json: vueVersion 必须为 "3"')
if (manifest.transformPx !== false) problems.push('manifest.json: transformPx 必须为 false（保留 px）')
if (pages.globalStyle?.navigationStyle !== 'custom')
  problems.push('pages.json: 需要 navigationStyle=custom（页面自带页头）')
for (const page of pages.pages) {
  const file = join(ROOT, `${page.path}.vue`)
  if (!existsSync(file)) problems.push(`pages.json: 缺少页面文件 ${page.path}.vue`)
  else if (!templates.has(`${page.path}.vue`)) problems.push(`pages.json: ${page.path} 未被编译`)
}
// 小程序 tabBar：页面与图标必须存在，否则运行时会直接报错
const tabBar = pages.tabBar
if (tabBar) {
  const pagePaths = new Set(pages.pages.map((page) => page.path))
  for (const item of tabBar.list || []) {
    if (!pagePaths.has(item.pagePath)) problems.push(`tabBar 指向不存在的页面 ${item.pagePath}`)
    for (const key of ['iconPath', 'selectedIconPath']) {
      if (item[key] && !existsSync(join(ROOT, item[key])))
        problems.push(`tabBar 缺少图标 ${item[key]}`)
    }
  }
  if ((tabBar.list || []).length < 2) problems.push('tabBar 至少需要 2 个页面')
} else {
  notes.push('未配置 tabBar（H5/App 仍使用页头导航）')
}

for (const page of pages.pages) {
  if (page.style?.navigationBarTitleText) {
    notes.push(`页面标题：${page.path} → ${page.style.navigationBarTitleText}`)
  }
}

// ------------------------------------------------------- 3. class 双向对账
const stripCss = css
  .replace(/\/\*[\s\S]*?\*\//g, '')
  .replace(/url\([^)]*\)/g, '')
const cssClasses = new Set()
for (const match of stripCss.matchAll(/\.(-?[_a-zA-Z][\w-]*)/g)) cssClasses.add(match[1])

const usedClasses = new Set()
const isClassToken = (value) => /^[\w-]+$/.test(value)
for (const [rel, content] of templates) {
  for (const match of content.matchAll(/(?<![:-\w])class="([^"]*)"/g)) {
    match[1]
      .split(/\s+/)
      .filter(isClassToken)
      .forEach((name) => usedClasses.add(name))
  }
  for (const match of content.matchAll(/:class="([^"]*)"/g)) {
    // 去掉 === / !== 比较里的字符串（那是状态值，不是 class 名）
    const expression = match[1]
      .replace(/(['"][\w-]+['"])\s*[!=]==/g, '')
      .replace(/[!=]==\s*(['"][\w-]+['"])/g, '')
    for (const literal of expression.matchAll(/'([\w-]+)'/g)) usedClasses.add(literal[1])
    for (const key of expression.matchAll(/(?:^|[{,\s])([a-zA-Z][\w-]*)\s*:/g)) usedClasses.add(key[1])
  }
  void rel
}

const dynamicPrefixes = ['stage-', 'cover-', 'status-', 'is-']
for (const name of cssClasses) {
  if (dynamicPrefixes.some((prefix) => name.startsWith(prefix))) usedClasses.add(name)
}

const unusedCss = [...cssClasses].filter((name) => !usedClasses.has(name)).sort()
// 这些 class 只是结构锚点：Web 版的样式挂在子元素或直接由标签默认行为决定，不需要对应规则。
const structuralClasses = new Set([
  'hero-line',
  'detail-copy',
  'footer-copy',
  'section-actions',
  'strip-item',
  'progress-label',
  'sort-value',
  'note-form-fields',
  'close-button',
])
const missingCss = [...usedClasses]
  .filter(
    (name) =>
      !cssClasses.has(name) && !structuralClasses.has(name) && !dynamicPrefixes.includes(`${name}-`),
  )
  .filter((name) => !name.endsWith('-'))
  .sort()

if (missingCss.length) problems.push(`模板用到但 CSS 中不存在的 class：${missingCss.join(', ')}`)
if (unusedCss.length) notes.push(`CSS 中存在但模板未使用的 class：${unusedCss.join(', ')}`)

// -------------------------------------------- 4. 不支持的标签 / 浏览器 API
const forbiddenTags = [
  ['<select', 'select 标签（小程序不支持，需用 picker）'],
  ['<option', 'option 标签（小程序不支持）'],
  ['<svg', 'svg 标签（小程序不支持，需用 image+PNG）'],
  ['<br', 'br 标签（小程序不支持，需拆成 view）'],
  ['<img', 'img 标签（需用 image）'],
  ['<a ', 'a 标签（需用 navigator）'],
  ['RouterLink', 'vue-router 组件'],
  ['<Teleport', 'Teleport（小程序不支持）'],
  ['<Transition', 'Transition（小程序不支持）'],
]
for (const [rel, content] of templates) {
  for (const [token, label] of forbiddenTags) {
    if (content.includes(token)) problems.push(`${rel}: 出现 ${label}`)
  }
}

const forbiddenApis = [
  ['window.localStorage', 'localStorage（需用 uni.setStorageSync）'],
  ['document.querySelector', 'document.querySelector'],
  ['document.getElementById', 'document.getElementById'],
  ['document.activeElement', 'document.activeElement'],
  ['document.body', 'document.body'],
  ['matchMedia', 'matchMedia'],
  ['scrollIntoView', 'scrollIntoView'],
  ['crypto.randomUUID', 'crypto.randomUUID'],
  ['toSorted', 'Array.toSorted'],
  ['Intl.', 'Intl 国际化 API'],
  ['new Intl', 'Intl 国际化 API'],
]
// 这些文件内部已有等价实现或显式能力探测，允许出现对应 token。
const apiAllowlist = new Set(['utils/id.js'])
for (const file of [...vueFiles, ...files.filter((f) => f.endsWith('.js'))]) {
  const rel = relative(ROOT, file)
  if (rel.startsWith('scripts/') || apiAllowlist.has(rel.split('\\').join('/'))) continue
  const source = readFileSync(file, 'utf8')
  for (const [token, label] of forbiddenApis) {
    let index = source.indexOf(token)
    while (index !== -1) {
      const lineStart = source.lastIndexOf('\n', index) + 1
      const lineEnd = source.indexOf('\n', index)
      const line = source.slice(lineStart, lineEnd === -1 ? undefined : lineEnd)
      // #ifdef 条件编译块里的 H5/App 专用代码、或注释里的说明是允许的
      const head = source.slice(0, index)
      const lastIfdef = head.lastIndexOf('#ifdef')
      const lastEndif = head.lastIndexOf('#endif')
      const guarded = lastIfdef > lastEndif || line.trimStart().startsWith('//')
      if (!guarded) {
        problems.push(`${rel}:${source.slice(0, index).split('\n').length}: 使用了 ${label}`)
      }
      index = source.indexOf(token, index + 1)
    }
  }
}

// ------------------------------------------------- 5. 图标资源存在性
const iconDir = join(ROOT, 'static/icons')
const tones = readdirSync(iconDir).filter((entry) => statSync(join(iconDir, entry)).isDirectory())
const toneSet = new Set(tones)
const iconSet = new Set(readdirSync(join(iconDir, tones[0])).map((f) => f.replace('.png', '')))
const required = new Set()
for (const [rel, content] of templates) {
  // <AppIcon name="x" tone="y" />  或  :name="'a' : 'b'" / tone 省略
  for (const match of content.matchAll(/<AppIcon\b[^>]*>/g)) {
    const tag = match[0]
    const tone = /tone="([\w-]+)"/.exec(tag)?.[1] || 'ink'
    if (!toneSet.has(tone)) problems.push(`${rel}: AppIcon 使用了不存在的色调 ${tone}`)
    const literalNames = [...tag.matchAll(/'([\w-]+)'/g)].map((m) => m[1])
    const direct = /(?:^|\s)name="([\w-]+)"/.exec(tag)?.[1]
    const candidates = direct ? [direct] : literalNames
    if (!candidates.length) {
      notes.push(`${rel}: AppIcon 名称是动态的，已跳过资源检查 → ${tag.trim()}`)
      continue
    }
    for (const name of candidates) {
      if (!iconSet.has(name)) problems.push(`${rel}: 缺少图标 PNG ${tone}/${name}.png`)
      else required.add(`${tone}/${name}`)
    }
  }
}

// 动态图标名（来自数据数组或 props）无法从模板字面量推断，这里显式登记。
const dynamicIcons = [
  ['olive', ['book', 'bookmark', 'check', 'pen']], // ShelfStats 的 metrics
  ['sage', ['book', 'search', 'pen']], // EmptyState 的 icon（默认 book / 搜索 / 手记）
]
for (const [tone, names] of dynamicIcons) {
  for (const name of names) {
    if (!iconSet.has(name) || !toneSet.has(tone)) problems.push(`缺少图标 PNG ${tone}/${name}.png`)
    else required.add(`${tone}/${name}`)
  }
}

// --------------------------------------------------------------- 6. 其他资源
// HBuilderX 5.x 的 Vue3 工程必须在根目录提供 index.html，且要保留 app-html / main.js 标记，
// 否则运行 H5 会直接报「根目录缺少 index.html」并停止。
const h5Template = join(ROOT, 'index.html')
if (!existsSync(h5Template)) {
  problems.push('缺少根目录 index.html（HBuilderX 运行 H5 必需）')
} else {
  const html = readFileSync(h5Template, 'utf8')
  if (!html.includes('<!--app-html-->')) problems.push('index.html 缺少 <!--app-html--> 占位')
  if (!html.includes('src="/main.js"')) problems.push('index.html 缺少 <script src="/main.js">')
  if (!html.includes('viewport')) problems.push('index.html 缺少 viewport meta')
}

const staticChecks = [
  ['static/favicon.svg', 'static/favicon.svg'],
  ['static/reading-still-life.jpg', 'static/reading-still-life.jpg'],
]
for (const [file, label] of staticChecks) {
  if (!existsSync(join(ROOT, file))) problems.push(`缺少静态资源 ${label}`)
}
for (const match of stripCss.matchAll(/url\('(\/static\/[^']+)'\)/g)) {
  const target = join(ROOT, match[1].replace('/static/', 'static/'))
  if (!existsSync(target)) problems.push(`CSS 引用了不存在的资源 ${match[1]}`)
}

// ------------------------------------------------------------------- 输出
console.log(`检查 SFC：${vueFiles.length} 个`)
console.log(`图标资源：${iconSet.size} 个图形 × ${toneSet.size} 个色调，模板直接引用 ${required.size} 个组合`)
console.log(`CSS class：${cssClasses.size} 个，模板使用 ${[...usedClasses].filter((c) => cssClasses.has(c)).length} 个`)
if (notes.length) {
  console.log('\n提示：')
  notes.forEach((note) => console.log('  · ' + note))
}
if (problems.length) {
  console.log(`\n发现 ${problems.length} 个问题：`)
  problems.forEach((problem) => console.log('  ✗ ' + problem))
  process.exitCode = 1
} else {
  console.log('\n全部检查通过。')
}
