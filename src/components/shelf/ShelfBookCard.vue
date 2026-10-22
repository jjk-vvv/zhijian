<script setup>
import BookCover from '../books/BookCover.vue'
import AppIcon from '../ui/AppIcon.vue'
import ReadingProgress from './ReadingProgress.vue'
defineProps({ book: Object })
const emit = defineEmits(['progress', 'remove', 'detail'])
const statuses = { reading: '正在读', wishlist: '想读', finished: '已读完' }
</script>
<template>
  <article class="shelf-book">
    <button
      class="shelf-cover-button"
      :aria-label="'查看《' + book.title + '》详情'"
      @click="emit('detail', book)"
    >
      <BookCover :book="book" />
    </button>
    <div class="shelf-book-copy">
      <div class="shelf-book-top">
        <span class="status-badge" :class="'status-' + book.status">
          {{ statuses[book.status] }}
        </span>
        <button
          class="icon-button subtle"
          :aria-label="'移出《' + book.title + '》'"
          @click="emit('remove', book)"
        >
          <AppIcon name="trash" :size="17" />
        </button>
      </div>
      <h2>{{ book.title }}</h2>
      <p class="book-author">{{ book.author }}</p>
      <ReadingProgress
        :book-id="book.id"
        :model-value="book.progress"
        @update:model-value="emit('progress', { id: book.id, value: $event })"
      />
      <div class="shelf-book-actions">
        <RouterLink
          :to="{ path: '/notes', query: { compose: '1', book: book.id } }"
          class="text-link"
        >
          <AppIcon name="pen" :size="15" />
          写手记
        </RouterLink>
        <button
          class="text-link"
          @click="emit('progress', { id: book.id, value: book.progress === 100 ? 0 : 100 })"
        >
          {{ book.progress === 100 ? '重新阅读' : '标记读完' }}
          <AppIcon :name="book.progress === 100 ? 'book' : 'check'" :size="15" />
        </button>
      </div>
    </div>
  </article>
</template>
