<script setup>
import BookCard from './BookCard.vue'

defineProps({ books: Array, isSaved: Function })
const emit = defineEmits(['detail', 'save'])
</script>

<template>
  <view class="book-grid">
    <BookCard
      v-for="(book, index) in books"
      :key="book.id"
      :book="book"
      :saved="isSaved(book.id)"
      :reverse="index % 2 === 1"
      @detail="emit('detail', $event)"
      @save="emit('save', $event)"
    />
  </view>
</template>
