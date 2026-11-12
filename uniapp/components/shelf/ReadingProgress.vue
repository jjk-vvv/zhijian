<script setup>
import { computed } from 'vue'

const props = defineProps({ bookId: String, modelValue: Number })
const emit = defineEmits(['update:modelValue'])

const hint = computed(() =>
  props.modelValue === 100
    ? '又读完一本，值得纪念。'
    : props.modelValue === 0
      ? '从第一页开始新的旅程。'
      : '不必着急，每一页都算数。',
)

function onChange(event) {
  emit('update:modelValue', Number(event.detail.value))
}
</script>

<template>
  <view class="reading-progress">
    <view class="progress-head">
      <text class="progress-label">阅读进度</text>
      <text class="progress-value">{{ modelValue }}%</text>
    </view>
    <slider
      class="progress-slider"
      :value="modelValue"
      :min="0"
      :max="100"
      :step="1"
      active-color="#6d8555"
      background-color="#e1e5d6"
      block-size="12"
      block-color="#4d6a3f"
      @changing="onChange"
      @change="onChange"
    />
    <text class="progress-hint">{{ hint }}</text>
  </view>
</template>
