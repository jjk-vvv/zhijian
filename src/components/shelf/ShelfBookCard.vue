<script setup>
import BookCover from '../books/BookCover.vue'
import AppIcon from '../ui/AppIcon.vue'
import ReadingProgress from './ReadingProgress.vue'

defineProps({ book: Object })
const emit = defineEmits(['progress', 'remove', 'finish', 'timer'])
const statuses = { reading: '正在读', wishlist: '想读', finished: '已读完', dnf: '已弃读' }
</script>
<template>
  <article class="shelf-book">
    <RouterLink
      class="shelf-cover-button"
      :to="`/book/${book.slug}`"
      :aria-label="'查看《' + book.title + '》详情'"
    >
      <BookCover :book="book" />
    </RouterLink>
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
      <h2>
        <RouterLink :to="`/book/${book.slug}`">{{ book.title }}</RouterLink>
      </h2>
      <p class="book-author">{{ book.author }}</p>
      <ReadingProgress
        v-if="book.status !== 'dnf'"
        :book-id="book.slug"
        :model-value="book.progress"
        @update:model-value="emit('progress', { slug: book.slug, value: $event })"
      />
      <p v-else class="status-dnf-note">这本书停在了第 {{ book.progress }}%，也算一段经历。</p>
      <div class="shelf-book-actions">
        <RouterLink
          :to="{ path: '/notes', query: { compose: '1', book: book.slug } }"
          class="text-link"
        >
          <AppIcon name="pen" :size="15" />
          写手记
        </RouterLink>
        <button class="text-link" @click="emit('timer', book)">
          <AppIcon name="clock" :size="15" />
          记录阅读
        </button>
        <button class="text-link" @click="emit('finish', { slug: book.slug, value: book.progress === 100 ? 0 : 100 })">
          {{ book.progress === 100 ? '重新阅读' : '标记读完' }}
          <AppIcon :name="book.progress === 100 ? 'book' : 'check'" :size="15" />
        </button>
      </div>
    </div>
  </article>
</template>
