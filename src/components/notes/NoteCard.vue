<script setup>
import { computed } from 'vue'
import { TYPE_LABELS, formatDate } from '../../utils/format.js'
import AppIcon from '../ui/AppIcon.vue'

const props = defineProps({ note: Object })
const emit = defineEmits(['edit', 'delete'])
const date = computed(() => formatDate(props.note.createdAt))
</script>
<template>
  <article class="note-card">
    <header>
      <span class="note-type">{{ TYPE_LABELS[note.type] || '感想' }}</span>
      <span v-if="note.isPrivate" class="note-private">
        <AppIcon name="lock" :size="13" />
        仅自己
      </span>
      <time :datetime="note.createdAt">{{ date }}</time>
    </header>
    <h2>{{ note.title }}</h2>
    <p class="note-content">{{ note.content }}</p>
    <footer>
      <RouterLink :to="`/book/${note.book.slug}`" class="note-book">
        <AppIcon name="book" :size="16" />
        {{ note.book.title }}
      </RouterLink>
      <div>
        <button class="icon-button" :aria-label="'编辑手记：' + note.title" @click="emit('edit', note)">
          <AppIcon name="pen" :size="17" />
        </button>
        <button
          class="icon-button subtle"
          :aria-label="'删除手记：' + note.title"
          @click="emit('delete', note)"
        >
          <AppIcon name="trash" :size="17" />
        </button>
      </div>
    </footer>
  </article>
</template>
