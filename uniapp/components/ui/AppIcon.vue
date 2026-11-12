<script setup>
import { computed } from 'vue'

// 统一图标组件：Web 版是内联 <svg>，小程序不支持 svg 标签，
// 因此改为按「图形 + 色调」预渲染的 PNG（static/icons/<tone>/<name>.png），
// 三端表现一致，也不依赖外部图标库。
const props = defineProps({
  name: { type: String, default: 'book' },
  size: { type: [Number, String], default: 20 },
  tone: { type: String, default: 'ink' },
})

const icons = [
  'book',
  'arrow',
  'search',
  'bookmark',
  'check',
  'plus',
  'close',
  'chevron',
  'down',
  'pen',
  'leaf',
  'trash',
  'grid',
  'clock',
]

const src = computed(
  () => `/static/icons/${props.tone}/${icons.includes(props.name) ? props.name : 'book'}.png`,
)
const box = computed(() => {
  const size = Number(props.size) || 20
  return `width:${size}px;height:${size}px;`
})
</script>

<template>
  <image class="app-icon" :src="src" :style="box" mode="aspectFit" />
</template>
