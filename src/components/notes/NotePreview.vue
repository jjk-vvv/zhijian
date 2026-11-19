<script setup>
import { computed } from 'vue'
import { TYPE_LABELS } from '../../utils/format.js'

const props = defineProps({ draft: Object, books: { type: Array, default: () => [] } })
const book = computed(() => props.books.find((item) => item.slug === props.draft.bookSlug))
</script>
<template>
  <aside class="note-preview">
    <span class="preview-label">纸间 · 手记预览</span>
    <span class="note-type">{{ TYPE_LABELS[draft.type] || '感想' }}</span>
    <h3>{{ draft.title.trim() || '给此刻的想法，起个名字' }}</h3>
    <p class="note-preview-content">
      {{ draft.content.trim() || '书页合上了，思绪还在继续。你写下的文字会出现在这里……' }}
    </p>
    <span class="preview-book">
      关于《{{ book?.title || '一本好书' }}》{{ draft.isPrivate ? ' · 仅自己可见' : '' }}
    </span>
  </aside>
</template>
