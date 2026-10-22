<script setup>
import BookCover from './BookCover.vue'
import AppIcon from '../ui/AppIcon.vue'
defineProps({ book: { type: Object, required: true }, saved: Boolean })
const emit = defineEmits(['detail', 'save'])
</script>
<template>
  <article class="book-card">
    <div class="book-stage" :class="'stage-' + book.art">
      <button
        class="book-detail-trigger"
        :aria-label="'查看《' + book.title + '》详情'"
        @click="emit('detail', book)"
      >
        <BookCover :book="book" />
      </button>
      <button
        class="save-button"
        :class="{ saved }"
        :disabled="saved"
        :aria-label="saved ? '《' + book.title + '》已在书架' : '收藏《' + book.title + '》'"
        @click="emit('save', book.id)"
      >
        <AppIcon :name="saved ? 'check' : 'plus'" :size="17" />
      </button>
      <span class="book-tag">{{ book.tag }}</span>
    </div>
    <div class="book-meta">
      <span class="category-label">{{ book.category }}</span>
      <h3>
        <button @click="emit('detail', book)">{{ book.title }}</button>
      </h3>
      <p class="book-author">{{ book.author }}</p>
      <p class="book-subtitle">{{ book.subtitle }}</p>
    </div>
  </article>
</template>
