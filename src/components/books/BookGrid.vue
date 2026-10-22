<script setup>
import BookCard from './BookCard.vue'
defineProps({ books: Array, isSaved: Function })
const emit = defineEmits(['detail', 'save'])
</script>
<template>
  <div class="book-grid">
    <BookCard
      v-for="book in books"
      :key="book.id"
      :book="book"
      :saved="isSaved(book.id)"
      @detail="emit('detail', $event)"
      @save="emit('save', $event)"
    />
  </div>
</template>
