// 对比原 Web 样式表与迁移后样式表的「声明值」分布，
// 确认迁移过程没有意外改动颜色、字号、间距等视觉数值。
import { readFileSync } from 'node:fs'

const normalize = (text) =>
  text
    .replace(/\/\*[\s\S]*?\*\//g, '')
    .replace(/url\([^)]*\)/g, 'url()')
    .replace(/\s+/g, ' ')

const declarations = (text) => {
  const result = new Map()
  for (const match of normalize(text).matchAll(/([-a-z]+)\s*:\s*([^;{}]+);/g)) {
    const key = `${match[1]}: ${match[2].trim().replace(/\s+/g, ' ')}`
    result.set(key, (result.get(key) || 0) + 1)
  }
  return result
}

const before = declarations(readFileSync('D:/zhijian/src/styles.css', 'utf8'))
const after = declarations(readFileSync('D:/zhijian/uniapp/styles/main.css', 'utf8'))

const changed = []
for (const [key, count] of before) {
  if (!after.has(key)) changed.push(`- ${key}   ×${count}`)
}
const added = []
for (const [key, count] of after) {
  if (!before.has(key)) added.push(`+ ${key}   ×${count}`)
}

console.log(`原样式声明种类：${before.size}，迁移后：${after.size}`)
console.log(`\n原样式独有的声明（${changed.length}）——应全部是已知的跨端替换：`)
changed.forEach((line) => console.log('  ' + line))
console.log(`\n迁移后新增的声明（${added.length}）：`)
added.forEach((line) => console.log('  ' + line))
