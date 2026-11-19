<script setup>
import { computed } from 'vue'

const props = defineProps({
  value: { type: Number, default: 0 },
  target: { type: Number, default: 0 },
  label: { type: String, default: '' },
  unit: { type: String, default: '' },
  size: { type: Number, default: 148 },
  color: { type: String, default: '#294b3c' },
})

const radius = computed(() => props.size / 2 - 9)
const circumference = computed(() => 2 * Math.PI * radius.value)
const ratio = computed(() => (props.target ? Math.min(1, props.value / props.target) : 0))
const dash = computed(() => `${circumference.value * ratio.value} ${circumference.value}`)
</script>
<template>
  <div class="goal-ring" :style="{ width: `${size}px`, height: `${size}px` }">
    <svg :width="size" :height="size" :viewBox="`0 0 ${size} ${size}`" aria-hidden="true">
      <circle
        class="ring-track"
        :cx="size / 2"
        :cy="size / 2"
        :r="radius"
        fill="none"
        stroke-width="6"
      />
      <circle
        class="ring-value"
        :cx="size / 2"
        :cy="size / 2"
        :r="radius"
        fill="none"
        :stroke="color"
        stroke-width="6"
        stroke-linecap="round"
        :stroke-dasharray="dash"
        :transform="`rotate(-90 ${size / 2} ${size / 2})`"
      />
    </svg>
    <div class="goal-ring-text">
      <strong>{{ Math.round(ratio * 100) }}<small>%</small></strong>
      <span>{{ label }}</span>
      <em v-if="target">{{ value }} / {{ target }} {{ unit }}</em>
    </div>
  </div>
</template>
