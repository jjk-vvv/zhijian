<script setup>
import AppIcon from '../ui/AppIcon.vue'
defineProps({ modelValue: String, sort: String })
const emit = defineEmits(['update:modelValue', 'update:sort'])
</script>
<template>
  <div class="search-toolbar">
    <label class="search-box">
      <AppIcon name="search" :size="18" />
      <span class="sr-only">搜索书名或作者</span>
      <input
        type="search"
        placeholder="搜索书名、作者…"
        :value="modelValue"
        @input="emit('update:modelValue', $event.target.value)"
      />
    </label>
    <label class="sort-label">
      <span class="sr-only">书籍排序</span>
      <select :value="sort" @change="emit('update:sort', $event.target.value)">
        <option value="curated">编辑精选</option>
        <option value="rating">评分最高</option>
        <option value="popular">最多人评</option>
        <option value="title">书名排序</option>
        <option value="year">出版时间</option>
      </select>
      <AppIcon name="down" :size="14" />
    </label>
  </div>
</template>
