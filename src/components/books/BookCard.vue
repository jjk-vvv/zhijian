<script setup>
import BookCover from './BookCover.vue'
import AppIcon from '../ui/AppIcon.vue'
import RatingStars from '../ui/RatingStars.vue'

defineProps({ book: { type: Object, required: true }, saved: Boolean })
const emit = defineEmits(['save'])
</script>
<template>
  <article class="book-card">
    <div class="book-stage" :class="'stage-' + book.art">
      <RouterLink
        class="book-detail-trigger"
        :to="`/book/${book.slug}`"
        :aria-label="'查看《' + book.title + '》详情'"
      >
        <BookCover :book="book" />
      </RouterLink>
      <button
        class="save-button"
        :class="{ saved }"
        :disabled="saved"
        :aria-label="saved ? '《' + book.title + '》已在书架' : '收藏《' + book.title + '》'"
        @click="emit('save', book.slug)"
      >
        <AppIcon :name="saved ? 'check' : 'plus'" :size="17" />
      </button>
      <span class="book-tag">{{ book.tag }}</span>
    </div>
    <div class="book-meta">
      <h3>
        <RouterLink :to="`/book/${book.slug}`">{{ book.title }}</RouterLink>
      </h3>
      <p class="book-author">{{ book.author }}</p>
      <p class="book-subtitle">{{ book.subtitle }}</p>
      <div v-if="book.ratingCount" class="book-rating">
        <RatingStars :rating="book.ratingAvg" :size="12" />
        <span>{{ book.ratingAvg.toFixed(1) }} · {{ book.ratingCount }} 人评分</span>
      </div>
    </div>
  </article>
</template>
