<script setup>
import AppIcon from '../ui/AppIcon.vue'
import AppSelect from '../ui/AppSelect.vue'

defineProps({ modelValue: String, sort: String })
const emit = defineEmits(['update:modelValue', 'update:sort'])

const sortOptions = [
  { value: 'curated', label: '编辑精选' },
  { value: 'title', label: '书名排序' },
  { value: 'year', label: '出版时间' },
]
</script>

<template>
  <view class="search-toolbar">
    <view class="search-box">
      <AppIcon name="search" :size="18" tone="olive" />
      <text class="sr-only">搜索书名或作者</text>
      <input
        class="search-input"
        type="text"
        :value="modelValue"
        placeholder="搜索书名、作者…"
        placeholder-class="field-placeholder"
        confirm-type="search"
        @input="emit('update:modelValue', $event.detail.value)"
      />
    </view>
    <AppSelect
      class="sort-picker"
      variant="inline"
      :model-value="sort"
      :options="sortOptions"
      aria-label="书籍排序"
      @update:model-value="emit('update:sort', $event)"
    />
  </view>
</template>
