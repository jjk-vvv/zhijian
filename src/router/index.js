import { createRouter, createWebHashHistory } from 'vue-router'
import DiscoverView from '../views/DiscoverView.vue'

// Hash 路由支持普通静态空间和 Netlify 拖拽部署，刷新任意页面也可访问。
const router = createRouter({
  history: createWebHashHistory(),
  routes: [
    { path: '/', name: 'discover', component: DiscoverView, meta: { title: '发现好书' } },
    {
      path: '/shelf',
      name: 'shelf',
      component: () => import('../views/ShelfView.vue'),
      meta: { title: '我的书架' },
    },
    {
      path: '/notes',
      name: 'notes',
      component: () => import('../views/NotesView.vue'),
      meta: { title: '阅读手记' },
    },
    {
      path: '/:pathMatch(.*)*',
      name: 'not-found',
      component: () => import('../views/NotFoundView.vue'),
      meta: { title: '页面未找到' },
    },
  ],
  scrollBehavior: () => ({ top: 0 }),
})
router.afterEach((to) => {
  document.title = `${to.meta.title} · 纸间`
})
export default router
