import { createRouter, createWebHashHistory } from 'vue-router'
import DiscoverView from '../views/DiscoverView.vue'
import { ensureReady } from '../composables/useAuth.js'

// Hash 路由支持普通静态空间部署，刷新任意页面也可访问。
const router = createRouter({
  history: createWebHashHistory(),
  routes: [
    { path: '/', name: 'discover', component: DiscoverView, meta: { title: '发现好书' } },
    {
      path: '/book/:slug',
      name: 'book-detail',
      component: () => import('../views/BookDetailView.vue'),
      meta: { title: '书籍详情' },
    },
    {
      path: '/shelf',
      name: 'shelf',
      component: () => import('../views/ShelfView.vue'),
      meta: { title: '我的书架', requiresAuth: true },
    },
    {
      path: '/notes',
      name: 'notes',
      component: () => import('../views/NotesView.vue'),
      meta: { title: '阅读手记', requiresAuth: true },
    },
    {
      path: '/highlights',
      name: 'highlights',
      component: () => import('../views/HighlightsView.vue'),
      meta: { title: '划线收藏', requiresAuth: true },
    },
    {
      path: '/stats',
      name: 'stats',
      component: () => import('../views/StatsView.vue'),
      meta: { title: '阅读统计', requiresAuth: true },
    },
    {
      path: '/goals',
      name: 'goals',
      component: () => import('../views/GoalsView.vue'),
      meta: { title: '年度目标', requiresAuth: true },
    },
    {
      path: '/lists',
      name: 'lists',
      component: () => import('../views/ListsView.vue'),
      meta: { title: '主题书单' },
    },
    {
      path: '/lists/:id',
      name: 'list-detail',
      component: () => import('../views/ListDetailView.vue'),
      meta: { title: '书单详情' },
    },
    {
      path: '/feed',
      name: 'feed',
      component: () => import('../views/FeedView.vue'),
      meta: { title: '书友动态' },
    },
    {
      path: '/clubs',
      name: 'clubs',
      component: () => import('../views/ClubsView.vue'),
      meta: { title: '书友会' },
    },
    {
      path: '/clubs/:slug',
      name: 'club-detail',
      component: () => import('../views/ClubDetailView.vue'),
      meta: { title: '书友会' },
    },
    {
      path: '/profile/:handle',
      name: 'profile',
      component: () => import('../views/ProfileView.vue'),
      meta: { title: '读者主页' },
    },
    {
      path: '/settings',
      name: 'settings',
      component: () => import('../views/SettingsView.vue'),
      meta: { title: '账号设置', requiresAuth: true },
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('../views/LoginView.vue'),
      meta: { title: '登录' },
    },
    {
      path: '/register',
      name: 'register',
      component: () => import('../views/RegisterView.vue'),
      meta: { title: '加入纸间' },
    },
    {
      path: '/:pathMatch(.*)*',
      name: 'not-found',
      component: () => import('../views/NotFoundView.vue'),
      meta: { title: '页面未找到' },
    },
  ],
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) return savedPosition
    // 等旧页面淡出后再回到顶部，避免切换时页面“先跳一下”
    return new Promise((resolve) => setTimeout(() => resolve({ top: 0 }), 160))
  },
})

router.beforeEach(async (to) => {
  const user = await ensureReady()
  if (to.meta.requiresAuth && !user) {
    return { path: '/login', query: { redirect: to.fullPath } }
  }
  if ((to.name === 'login' || to.name === 'register') && user) {
    return { path: '/' }
  }
  return true
})

router.afterEach((to) => {
  document.title = `${to.meta.title} · 纸间`
})

export default router
