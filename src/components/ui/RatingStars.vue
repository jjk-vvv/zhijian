<script setup>
import { computed } from 'vue'
import AppIcon from './AppIcon.vue'

const props = defineProps({
  rating: { type: Number, default: 0 },
  editable: Boolean,
  size: { type: [Number, String], default: 16 },
  showValue: Boolean,
})
const emit = defineEmits(['update:rating'])

const fillPercent = computed(() => Math.max(0, Math.min(100, (Number(props.rating) / 5) * 100)))
const stars = [1, 2, 3, 4, 5]

function pick(event, index) {
  if (!props.editable) return
  const rect = event.currentTarget.getBoundingClientRect()
  const isLeftHalf = event.clientX - rect.left < rect.width / 2
  emit('update:rating', index + (isLeftHalf ? 0.5 : 1))
}

function onKey(event, index) {
  if (!props.editable) return
  const step = event.key === 'ArrowLeft' ? -0.5 : event.key === 'ArrowRight' ? 0.5 : 0
  if (!step) return
  event.preventDefault()
  emit('update:rating', Math.max(0.5, Math.min(5, (props.rating || 0) + step)))
}
</script>
<template>
  <div class="rating-stars" :class="{ 'is-editable': editable }" :style="{ '--star-size': `${size}px` }">
    <div class="stars-track" aria-hidden="true">
      <AppIcon v-for="star in stars" :key="star" name="star" :size="size" />
    </div>
    <div class="stars-fill" :style="{ width: fillPercent + '%' }" aria-hidden="true">
      <AppIcon v-for="star in stars" :key="star" name="star" :size="size" />
    </div>
    <div v-if="editable" class="stars-hit" role="group" aria-label="选择评分">
      <button
        v-for="star in stars"
        :key="star"
        type="button"
        class="star-hit"
        :aria-label="`评为 ${star} 星`"
        @click="pick($event, star - 1)"
        @keydown="onKey($event, star - 1)"
      ></button>
    </div>
    <span v-if="showValue" class="rating-value">{{ Number(rating || 0).toFixed(1) }}</span>
  </div>
</template>
