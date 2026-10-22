<script setup>
import { categories } from '../../data/books.js'
defineProps({ modelValue: String })
const emit = defineEmits(['update:modelValue'])
</script>
<template>
  <div class="category-tabs" role="group" aria-label="书籍分类">
    <button
      v-for="category in categories"
      :key="category"
      :class="{ active: modelValue === category }"
      :aria-pressed="modelValue === category"
      @click="emit('update:modelValue', category)"
    >
      {{ category }}
    </button>
  </div>
</template>
