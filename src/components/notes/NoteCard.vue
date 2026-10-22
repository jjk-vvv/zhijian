<script setup>
import { computed } from 'vue'
import { getBook } from '../../data/books.js'
import AppIcon from '../ui/AppIcon.vue'
const props = defineProps({ note: Object })
const emit = defineEmits(['edit', 'delete'])
const book = computed(() => getBook(props.note.bookId))
const date = computed(() =>
  new Intl.DateTimeFormat('zh-CN', { year: 'numeric', month: '2-digit', day: '2-digit' }).format(
    new Date(props.note.date),
  ),
)
</script>
<template>
  <article class="note-card">
    <header>
      <span class="note-type">{{ note.type }}</span>
      <span v-if="note.example" class="example-label">示例手记</span>
      <time :datetime="note.date">{{ date }}</time>
    </header>
    <h2>{{ note.title }}</h2>
    <p class="note-content">{{ note.content }}</p>
    <footer>
      <span class="note-book">
        <AppIcon name="book" :size="16" />
        {{ book?.title }}
      </span>
      <div>
        <button
          class="icon-button"
          :aria-label="'编辑手记：' + note.title"
          @click="emit('edit', note)"
        >
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
