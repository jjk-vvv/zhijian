<script setup>
import BaseModal from '../ui/BaseModal.vue'
import AppIcon from '../ui/AppIcon.vue'
import BookCover from './BookCover.vue'
defineProps({ book: Object, saved: Boolean })
const emit = defineEmits(['close', 'save'])
</script>
<template>
  <BaseModal :title="'关于《' + book.title + '》'" wide @close="emit('close')">
    <div class="book-detail-layout">
      <div class="detail-cover"><BookCover :book="book" /></div>
      <div class="detail-copy">
        <span class="category-label">{{ book.category }}</span>
        <h3>{{ book.title }}</h3>
        <p class="muted">{{ book.author }} · 原作 {{ book.year }} 年</p>
        <p>{{ book.description }}</p>
        <div class="editor-note">
          <strong>
            <AppIcon name="leaf" :size="16" />
            纸间荐读
          </strong>
          <p>{{ book.recommendation }}</p>
        </div>
        <small class="muted">页面展示的是本站概念封面，非特定出版版本。</small>
      </div>
    </div>
    <template #footer>
      <RouterLink
        :to="{ path: '/notes', query: { compose: '1', book: book.id } }"
        class="button button-secondary"
        @click="emit('close')"
      >
        <AppIcon name="pen" :size="16" />
        写手记
      </RouterLink>
      <button class="button" :disabled="saved" @click="emit('save', book.id)">
        <AppIcon :name="saved ? 'check' : 'plus'" :size="17" />
        {{ saved ? '已在我的书架' : '加入我的书架' }}
      </button>
    </template>
  </BaseModal>
</template>
