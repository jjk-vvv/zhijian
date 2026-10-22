<script setup>
import NoteCard from './NoteCard.vue'
defineProps({ notes: Array })
const emit = defineEmits(['edit', 'delete'])
</script>
<template>
  <div class="notes-grid">
    <NoteCard
      v-for="note in notes"
      :key="note.id"
      :note="note"
      @edit="emit('edit', $event)"
      @delete="emit('delete', $event)"
    />
  </div>
</template>
