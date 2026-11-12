<script setup>
import { computed } from 'vue'
import { getBook } from '../../data/books.js'
import { formatDate } from '../../utils/format.js'
import AppIcon from '../ui/AppIcon.vue'

const props = defineProps({ note: Object })
const emit = defineEmits(['edit', 'delete'])
const book = computed(() => getBook(props.note.bookId))
const date = computed(() => formatDate(props.note.date))
</script>

<template>
  <view class="note-card">
    <view class="note-card-head">
      <text class="note-type">{{ note.type }}</text>
      <text v-if="note.example" class="example-label">示例手记</text>
      <text class="note-date">{{ date }}</text>
    </view>
    <view class="note-title">{{ note.title }}</view>
    <view class="note-content">{{ note.content }}</view>
    <view class="note-card-foot">
      <view class="note-book">
        <AppIcon name="book" :size="16" tone="olive" />
        <text>{{ book?.title }}</text>
      </view>
      <view class="note-actions">
        <button class="icon-button" :aria-label="'编辑手记：' + note.title" @click="emit('edit', note)">
          <AppIcon name="pen" :size="17" tone="ink" />
        </button>
        <button
          class="icon-button subtle"
          :aria-label="'删除手记：' + note.title"
          @click="emit('delete', note)"
        >
          <AppIcon name="trash" :size="17" tone="muted" />
        </button>
      </view>
    </view>
  </view>
</template>
