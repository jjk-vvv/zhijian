<script setup>
import { nextTick, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import AppHeader from './components/layout/AppHeader.vue'
import AppFooter from './components/layout/AppFooter.vue'
import ToastNotice from './components/ui/ToastNotice.vue'
import { useLibrary } from './composables/useLibrary.js'
const { toast, storageError } = useLibrary()
const main = ref(null),
  route = useRoute()
watch(
  () => route.path,
  async () => {
    await nextTick()
    if (!document.querySelector('[aria-modal="true"]')) main.value?.focus({ preventScroll: true })
  },
)
</script>
<template>
  <a class="skip-link" href="#main-content">跳到主要内容</a>
  <AppHeader />
  <div v-if="storageError" class="storage-alert" role="alert">{{ storageError }}</div>
  <main id="main-content" ref="main" tabindex="-1"><RouterView /></main>
  <AppFooter />
  <ToastNotice :message="toast" />
</template>
