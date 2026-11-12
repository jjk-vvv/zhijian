import App from './App.vue'
import { createSSRApp } from 'vue'

// uni-app（Vue 3）入口：必须导出 createApp，由框架接管页面与路由。
export function createApp() {
  const app = createSSRApp(App)
  return { app }
}
