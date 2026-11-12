<script setup>
import BaseModal from '../ui/BaseModal.vue'
import AppIcon from '../ui/AppIcon.vue'
import BookCover from './BookCover.vue'
import { composeNote } from '../../utils/nav.js'

const props = defineProps({ book: Object, saved: Boolean })
const emit = defineEmits(['close', 'save'])

function writeNote() {
  emit('close')
  composeNote(props.book.id)
}
</script>

<template>
  <BaseModal :title="'关于《' + book.title + '》'" wide @close="emit('close')">
    <view class="book-detail-layout">
      <view class="detail-cover"><BookCover :book="book" variant="detail" /></view>
      <view class="detail-copy">
        <text class="category-label">{{ book.category }}</text>
        <view class="detail-title">{{ book.title }}</view>
        <view class="muted detail-meta">{{ book.author }} · 原作 {{ book.year }} 年</view>
        <view class="detail-desc">{{ book.description }}</view>
        <view class="editor-note">
          <view class="editor-note-label">
            <AppIcon name="leaf" :size="16" tone="olive" />
            <text>纸间荐读</text>
          </view>
          <view class="editor-note-text">{{ book.recommendation }}</view>
        </view>
        <view class="muted detail-note">页面展示的是本站概念封面，非特定出版版本。</view>
      </view>
    </view>
    <template #footer>
      <view
        class="button button-secondary modal-btn"
        hover-class="button-secondary-hover"
        @click="writeNote"
      >
        <AppIcon name="pen" :size="16" tone="green" />
        <text>写手记</text>
      </view>
      <button class="button modal-btn" :disabled="saved" @click="emit('save', book.id)">
        <AppIcon :name="saved ? 'check' : 'plus'" :size="17" tone="white" />
        <text>{{ saved ? '已在我的书架' : '加入我的书架' }}</text>
      </button>
    </template>
  </BaseModal>
</template>
