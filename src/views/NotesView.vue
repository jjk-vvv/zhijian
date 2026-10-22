<script setup>
import { computed, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getBook } from '../data/books.js'
import { useLibrary } from '../composables/useLibrary.js'
import AppIcon from '../components/ui/AppIcon.vue'
import EmptyState from '../components/ui/EmptyState.vue'
import ConfirmDialog from '../components/ui/ConfirmDialog.vue'
import NoteEditor from '../components/notes/NoteEditor.vue'
import NotesList from '../components/notes/NotesList.vue'
const { library, saveNote, deleteNote } = useLibrary()
const route = useRoute(),
  router = useRouter()
const editorOpen = ref(false),
  editing = ref(null),
  removing = ref(null),
  query = ref(''),
  type = ref('全部手记')
const types = ['全部手记', '感想', '摘录', '书评']
const filteredNotes = computed(() => {
  const search = query.value.trim().toLocaleLowerCase()
  return library.notes
    .filter(
      (note) =>
        (type.value === '全部手记' || note.type === type.value) &&
        `${note.title} ${note.content} ${getBook(note.bookId)?.title}`
          .toLocaleLowerCase()
          .includes(search),
    )
    .toSorted((a, b) => new Date(b.date) - new Date(a.date))
})
watch(
  () => route.query.compose,
  (compose) => {
    if (compose === '1') {
      editing.value = null
      editorOpen.value = true
    }
  },
  { immediate: true },
)
function compose(note = null) {
  editing.value = note
  editorOpen.value = true
}
function closeEditor() {
  editorOpen.value = false
  editing.value = null
  if (route.query.compose) router.replace('/notes')
}
function submitNote(draft) {
  if (saveNote(draft)) closeEditor()
}
function confirmDelete() {
  deleteNote(removing.value.id)
  removing.value = null
}
function resetFilters() {
  query.value = ''
  type.value = '全部手记'
}
</script>
<template>
  <div class="container inner-page">
    <div class="page-heading">
      <div>
        <span class="page-kicker">THOUGHTS BETWEEN THE LINES</span>
        <h1>
          阅读手记
          <span class="heading-dot">。</span>
        </h1>
        <p>书页会合上，触动你的那些想法，可以留下。</p>
      </div>
      <button class="button" @click="compose()">
        <AppIcon name="plus" :size="18" />
        写一篇手记
      </button>
    </div>
    <div class="notes-intro">
      <span class="quote-mark" aria-hidden="true">“</span>
      <p>
        读书的意义，也在于那些
        <br />
        <strong>只属于你的理解。</strong>
      </p>
      <span class="notes-total">
        {{ library.notes.length }}
        <small>篇阅读回响</small>
      </span>
    </div>
    <div class="notes-toolbar">
      <div class="category-tabs" role="group" aria-label="手记类型">
        <button
          v-for="item in types"
          :key="item"
          :class="{ active: type === item }"
          :aria-pressed="type === item"
          @click="type = item"
        >
          {{ item }}
        </button>
      </div>
      <label class="search-box">
        <AppIcon name="search" :size="18" />
        <span class="sr-only">搜索手记</span>
        <input v-model="query" type="search" placeholder="搜索手记或书名…" />
      </label>
    </div>
    <NotesList
      v-if="filteredNotes.length"
      :notes="filteredNotes"
      @edit="compose"
      @delete="removing = $event"
    />
    <EmptyState
      v-else
      :title="library.notes.length ? '没有找到相关的手记' : '第一篇手记，从一个念头开始'"
      :description="
        library.notes.length
          ? '换个关键词或手记类型，再试一次。'
          : '不必写得完美，记录你此刻的真实感受就好。'
      "
      icon="pen"
    >
      <button v-if="library.notes.length" class="button button-secondary" @click="resetFilters">
        查看全部手记
      </button>
      <button v-else class="button" @click="compose()">写一篇手记</button>
    </EmptyState>
    <p class="data-footnote">文字仅保存在当前浏览器，清除浏览器数据会同时移除记录。</p>
    <NoteEditor
      v-if="editorOpen"
      :note="editing"
      :initial-book="route.query.book"
      @close="closeEditor"
      @save="submitNote"
    />
    <ConfirmDialog
      v-if="removing"
      title="删除这篇阅读手记？"
      :message="'《' + removing.title + '》删除后无法恢复。'"
      @cancel="removing = null"
      @confirm="confirmDelete"
    />
  </div>
</template>
