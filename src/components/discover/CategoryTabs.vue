<script setup>
defineProps({ modelValue: String, categories: { type: Array, default: () => [] } })
const emit = defineEmits(['update:modelValue'])
</script>
<template>
  <div class="category-tabs" role="group" aria-label="书籍分类">
    <button
      v-for="category in categories"
      :key="category.name"
      :class="{ active: modelValue === category.name }"
      :aria-pressed="modelValue === category.name"
      @click="emit('update:modelValue', category.name)"
    >
      {{ category.name }}
    </button>
  </div>
</template>
