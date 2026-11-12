<script setup>
import { computed } from 'vue'
import { getBook } from '../../data/books.js'

const props = defineProps({ draft: Object })
const book = computed(() => getBook(props.draft.bookId))
</script>

<template>
  <view class="note-preview">
    <text class="preview-label">纸间 · 手记预览</text>
    <text class="note-type">{{ draft.type }}</text>
    <view class="preview-title">{{ draft.title.trim() || '给此刻的想法，起个名字' }}</view>
    <view class="note-preview-content">
      {{ draft.content.trim() || '书页合上了，思绪还在继续。你写下的文字会出现在这里……' }}
    </view>
    <text class="preview-book">关于《{{ book?.title || '一本好书' }}》</text>
  </view>
</template>
