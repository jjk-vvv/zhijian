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
  <div class="shelf-stats">
    <div v-for="metric in metrics" :key="metric.key" class="stat-item">
      <span class="stat-label">
        <AppIcon :name="metric.icon" :size="17" />
        {{ metric.label }}
      </span>
      <span class="stat-value">
        {{ stats[metric.key] }}
        <small>{{ metric.unit }}</small>
      </span>
    </div>
  </div>
</template>
