<script setup>
defineProps({ modelValue: String, stats: Object })
const emit = defineEmits(['update:modelValue'])
const tabs = [
  { key: 'all', label: '全部藏书', count: 'total' },
  { key: 'reading', label: '正在读', count: 'reading' },
  { key: 'wishlist', label: '想读', count: 'wishlist' },
  { key: 'finished', label: '已读完', count: 'finished' },
  { key: 'dnf', label: '已弃读', count: 'dnf' },
]
</script>
<template>
  <div class="shelf-filters" role="group" aria-label="阅读状态">
    <button
      v-for="tab in tabs"
      :key="tab.key"
      :class="{ active: modelValue === tab.key }"
      :aria-pressed="modelValue === tab.key"
      @click="emit('update:modelValue', tab.key)"
    >
      {{ tab.label }}
      <span>{{ stats[tab.count] }}</span>
    </button>
  </div>
</template>
