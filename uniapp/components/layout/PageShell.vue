<script setup>
import AppHeader from './AppHeader.vue'
import AppFooter from './AppFooter.vue'
import ToastNotice from '../ui/ToastNotice.vue'
import { useLibrary } from '../../composables/useLibrary.js'

defineProps({ active: { type: String, default: 'discover' } })
const { toast, storageError } = useLibrary()
</script>

<template>
  <view class="page-shell">
    <AppHeader :active="active" />
    <view v-if="storageError" class="storage-alert">{{ storageError }}</view>
    <view class="site-main"><slot /></view>
    <AppFooter />
    <ToastNotice :message="toast" />
  </view>
</template>
