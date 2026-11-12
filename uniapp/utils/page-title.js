import { onShow } from '@dcloudio/uni-app'

// 与 Web 版 router.afterEach 设置 document.title 的行为保持一致；
// App 与小程序使用 pages.json 中的 navigationBarTitleText，无需重复设置。
export function usePageTitle(title) {
  // #ifdef H5
  onShow(() => {
    document.title = title
  })
  // #endif
}
