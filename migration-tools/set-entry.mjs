// 临时把某个页面设为 pages.json 的第一项（仅用于本地截图验证，之后会还原）。
import { readFileSync, writeFileSync } from 'node:fs'

const file = 'D:/zhijian/uniapp/pages.json'
const entry = process.argv[2]
const json = JSON.parse(readFileSync(file, 'utf8'))
const index = json.pages.findIndex((page) => page.path === entry)
if (index < 0) throw new Error(`页面不存在: ${entry}`)
const [page] = json.pages.splice(index, 1)
json.pages.unshift(page)
writeFileSync(file, `${JSON.stringify(json, null, 2)}\n`)
console.log(`entry = ${page.path}`)
