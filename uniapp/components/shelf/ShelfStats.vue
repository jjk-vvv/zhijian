<script setup>
import AppIcon from '../ui/AppIcon.vue'

defineProps({ stats: Object })
const metrics = [
  { key: 'total', label: '书架藏书', icon: 'book', unit: '本' },
  { key: 'reading', label: '正在阅读', icon: 'bookmark', unit: '本' },
  { key: 'finished', label: '已读好书', icon: 'check', unit: '本' },
  { key: 'notes', label: '阅读回响', icon: 'pen', unit: '篇' },
]
</script>

<template>
  <view class="shelf-stats">
    <view v-for="metric in metrics" :key="metric.key" class="stat-item">
      <view class="stat-label">
        <AppIcon class="stat-icon" :name="metric.icon" :size="17" tone="olive" />
        <text>{{ metric.label }}</text>
      </view>
      <view class="stat-value">
        {{ stats[metric.key] }}
        <text class="stat-unit">{{ metric.unit }}</text>
      </view>
    </view>
  </view>
</template>
