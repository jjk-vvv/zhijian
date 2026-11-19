<script setup>
import BookCard from './BookCard.vue'
defineProps({ books: Array, isSaved: Function })
const emit = defineEmits(['save'])
</script>
<template>
  <div class="book-grid">
    <BookCard
      v-for="book in books"
      :key="book.slug"
      :book="book"
      :saved="isSaved(book.slug)"
      @save="emit('save', $event)"
    />
  </div>
</template>
