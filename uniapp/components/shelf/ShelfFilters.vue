<script setup>
defineProps({ modelValue: String, stats: Object })
const emit = defineEmits(['update:modelValue'])
const tabs = [
  { key: 'all', label: '全部藏书', count: 'total' },
  { key: 'reading', label: '正在读', count: 'reading' },
  { key: 'wishlist', label: '想读', count: 'wishlist' },
  { key: 'finished', label: '已读完', count: 'finished' },
]
</script>

<template>
  <view class="shelf-filters">
    <button
      v-for="tab in tabs"
      :key="tab.key"
      class="filter-btn"
      :class="{ active: modelValue === tab.key }"
      :aria-pressed="modelValue === tab.key"
      @click="emit('update:modelValue', tab.key)"
    >
      <text>{{ tab.label }}</text>
      <text class="filter-count">{{ stats[tab.count] }}</text>
    </button>
  </view>
</template>
