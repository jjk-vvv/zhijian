<script setup>
import { computed } from 'vue'

const props = defineProps({
  user: { type: Object, default: null },
  size: { type: [Number, String], default: 40 },
})

const initial = computed(() => {
  const name = props.user?.displayName || props.user?.handle || '读'
  return name.slice(0, 1)
})
const color = computed(() => props.user?.avatarColor || '#294b3c')
</script>
<template>
  <span
    class="avatar"
    :style="{
      background: color,
      width: `${size}px`,
      height: `${size}px`,
      fontSize: `${Math.max(11, Number(size) * 0.38)}px`,
    }"
    :aria-label="user?.displayName || '读者头像'"
    :title="user?.displayName"
  >
    {{ initial }}
  </span>
</template>
