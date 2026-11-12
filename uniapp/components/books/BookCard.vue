<script setup>
import BookCover from './BookCover.vue'
import AppIcon from '../ui/AppIcon.vue'

defineProps({ book: { type: Object, required: true }, saved: Boolean, reverse: Boolean })
const emit = defineEmits(['detail', 'save'])
</script>

<template>
  <view class="book-card" :class="{ 'is-reverse': reverse }">
    <view class="book-stage" :class="'stage-' + book.art">
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
        hover-class="save-button-hover"
        @click="emit('save', book.id)"
      >
        <AppIcon class="save-icon" :name="saved ? 'check' : 'plus'" :size="17" tone="pine" />
      </button>
      <text class="book-tag">{{ book.tag }}</text>
    </view>
    <view class="book-meta">
      <text class="category-label">{{ book.category }}</text>
      <view class="book-title">
        <button class="book-title-btn" @click="emit('detail', book)">{{ book.title }}</button>
      </view>
      <view class="book-author">{{ book.author }}</view>
      <view class="book-subtitle">{{ book.subtitle }}</view>
    </view>
  </view>
</template>
