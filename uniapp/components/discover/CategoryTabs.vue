<script setup>
import { categories } from '../../data/books.js'

defineProps({ modelValue: String })
const emit = defineEmits(['update:modelValue'])
</script>

<template>
  <view class="category-tabs">
    <button
      v-for="category in categories"
      :key="category"
      class="tab-btn"
      :class="{ active: modelValue === category }"
      :aria-pressed="modelValue === category"
      hover-class="tab-btn-hover"
      @click="emit('update:modelValue', category)"
    >
      {{ category }}
    </button>
  </view>
</template>
