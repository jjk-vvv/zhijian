<script setup>
import BookCover from '../books/BookCover.vue'
import AppIcon from '../ui/AppIcon.vue'
import ReadingProgress from './ReadingProgress.vue'
import { composeNote } from '../../utils/nav.js'

defineProps({ book: Object })
const emit = defineEmits(['progress', 'remove', 'detail'])
const statuses = { reading: '正在读', wishlist: '想读', finished: '已读完' }
</script>

<template>
  <view class="shelf-book">
    <button
      class="shelf-cover-button"
      :aria-label="'查看《' + book.title + '》详情'"
      @click="emit('detail', book)"
    >
      <BookCover :book="book" variant="shelf" />
    </button>
    <view class="shelf-book-copy">
      <view class="shelf-book-top">
        <text class="status-badge" :class="'status-' + book.status">
          {{ statuses[book.status] }}
        </text>
        <button
          class="icon-button subtle"
          :aria-label="'移出《' + book.title + '》'"
          @click="emit('remove', book)"
        >
          <AppIcon name="trash" :size="17" tone="muted" />
        </button>
      </view>
      <view class="shelf-title">{{ book.title }}</view>
      <view class="book-author">{{ book.author }}</view>
      <ReadingProgress
        :book-id="book.id"
        :model-value="book.progress"
        @update:model-value="emit('progress', { id: book.id, value: $event })"
      />
      <view class="shelf-book-actions">
        <view class="text-link" hover-class="none" @click="composeNote(book.id)">
          <AppIcon class="action-icon" name="pen" :size="15" tone="ink" />
          <text>写手记</text>
        </view>
        <button
          class="text-link"
          @click="emit('progress', { id: book.id, value: book.progress === 100 ? 0 : 100 })"
        >
          <text>{{ book.progress === 100 ? '重新阅读' : '标记读完' }}</text>
          <AppIcon
            class="action-icon"
            :name="book.progress === 100 ? 'book' : 'check'"
            :size="15"
            tone="ink"
          />
        </button>
      </view>
    </view>
  </view>
</template>
