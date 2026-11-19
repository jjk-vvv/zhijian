<script setup>
import { computed, nextTick, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import router from './router/index.js'
import AppHeader from './components/layout/AppHeader.vue'
import AppFooter from './components/layout/AppFooter.vue'
import ToastNotice from './components/ui/ToastNotice.vue'
import { useAuth } from './composables/useAuth.js'
import { useLibrary } from './composables/useLibrary.js'
import { useToast } from './composables/useToast.js'

const { toast, tone } = useToast()
const { currentUser, ensureReady } = useAuth()
const { refreshAll } = useLibrary()
const main = ref(null)
const route = useRoute()
const transitionName = ref('page-fade')

const pageKey = computed(() => route.path)

function prefetchRoutes() {
  router.getRoutes().forEach((record) => {
    const component = record.components?.default
    if (typeof component === 'function') component().catch(() => {})
  })
}

onMounted(async () => {
  await ensureReady()
  await refreshAll()

  // 空闲时预取其余页面，切换时不再等待按需加载
  if ('requestIdleCallback' in window) {
    window.requestIdleCallback(prefetchRoutes, { timeout: 2500 })
  } else {
    setTimeout(prefetchRoutes, 1200)
  }
})

watch(currentUser, async (user) => {
  if (user) await refreshAll()
  else await refreshAll()
})

watch(
  () => route.path,
  async (path, previous) => {
    // 只有进入下级页面 / 返回上级页面时才横向滑动，同级导航保持淡入淡出
    if (previous && path.startsWith(`${previous}/`)) transitionName.value = 'page-forward'
    else if (previous && previous.startsWith(`${path}/`)) transitionName.value = 'page-back'
    else transitionName.value = 'page-fade'
    await nextTick()
    if (!document.querySelector('[aria-modal="true"]')) main.value?.focus({ preventScroll: true })
  },
)
</script>
<template>
  <a class="skip-link" href="#main-content">跳到主要内容</a>
  <AppHeader />
  <main id="main-content" ref="main" tabindex="-1">
    <RouterView v-slot="{ Component }">
      <Transition :name="transitionName" mode="out-in">
        <component :is="Component" :key="pageKey" />
      </Transition>
    </RouterView>
  </main>
  <AppFooter />
  <ToastNotice :message="toast" :tone="tone" />
</template>

