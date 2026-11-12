// 用 lightningcss（Vite 依赖）解析迁移后的样式表，确认没有语法错误或括号不配对。
import { readFileSync } from 'node:fs'
import { transform } from 'lightningcss'

const file = 'D:/zhijian/uniapp/styles/main.css'
const code = Buffer.from(readFileSync(file, 'utf8'))
const open = (code.toString().match(/{/g) || []).length
const close = (code.toString().match(/}/g) || []).length
console.log(`花括号：{ ${open} 个，} ${close} 个`)

try {
  const result = transform({
    filename: 'main.css',
    code,
    minify: false,
    errorRecovery: false,
  })
  console.log(`解析通过，输出 ${(result.code.length / 1024).toFixed(1)} KB`)
} catch (error) {
  console.log('解析失败：', error.message)
  if (error.loc) console.log('位置：', JSON.stringify(error.loc))
  process.exitCode = 1
}
