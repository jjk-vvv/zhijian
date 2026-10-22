<script setup>
import { computed } from 'vue'
import { getBook } from '../../data/books.js'
const props = defineProps({ draft: Object })
const book = computed(() => getBook(props.draft.bookId))
</script>
<template>
  <aside class="note-preview">
    <span class="preview-label">纸间 · 手记预览</span>
    <span class="note-type">{{ draft.type }}</span>
    <h3>{{ draft.title.trim() || '给此刻的想法，起个名字' }}</h3>
    <p class="note-preview-content">
      {{ draft.content.trim() || '书页合上了，思绪还在继续。你写下的文字会出现在这里……' }}
    </p>
    <span class="preview-book">关于《{{ book?.title || '一本好书' }}》</span>
  </aside>
</template>
