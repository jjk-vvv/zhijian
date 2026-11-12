// 小程序 JS 运行时没有 Intl.DateTimeFormat，这里用固定格式输出与原站点一致的「YYYY/MM/DD」。
export function formatDate(value) {
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return ''
  const pad = (number) => String(number).padStart(2, '0')
  return `${date.getFullYear()}/${pad(date.getMonth() + 1)}/${pad(date.getDate())}`
}
