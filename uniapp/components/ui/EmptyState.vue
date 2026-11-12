<script setup>
import AppIcon from './AppIcon.vue'

defineProps({ title: String, description: String, icon: { type: String, default: 'book' } })
</script>

<template>
  <view class="empty-state">
    <view class="empty-icon"><AppIcon :name="icon" :size="30" tone="sage" /></view>
    <view class="empty-title">{{ title }}</view>
    <view class="empty-desc">{{ description }}</view>
    <slot />
  </view>
</template>
