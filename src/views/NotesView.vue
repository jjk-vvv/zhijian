<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { api } from '../api/client.js'
import { useLibrary } from '../composables/useLibrary.js'
import { notify } from '../composables/useToast.js'
import { TYPE_LABELS } from '../utils/format.js'
import AppIcon from '../components/ui/AppIcon.vue'
import EmptyState from '../components/ui/EmptyState.vue'
import ConfirmDialog from '../components/ui/ConfirmDialog.vue'
import NoteEditor from '../components/notes/NoteEditor.vue'
import NotesList from '../components/notes/NotesList.vue'

const { notes, notesLoaded, saveNote, deleteNote, refreshNotes } = useLibrary()
const route = useRoute()
const router = useRouter()

const editorOpen = ref(false)
const editing = ref(null)
const removing = ref(null)
const query = ref('')
const type = ref('all')
const books = ref([])

const types = [
  { key: 'all', label: '全部手记' },
  { key: 'thought', label: TYPE_LABELS.thought },
  { key: 'excerpt', label: TYPE_LABELS.excerpt },
  { key: 'review', label: TYPE_LABELS.review },
]

const bookFilter = computed(() => route.query.book || '')
const filterBookTitle = computed(
  () => notes.value.find((note) => note.book.slug === bookFilter.value)?.book.title || '',
)

const filteredNotes = computed(() => {
  const keyword = query.value.trim().toLocaleLowerCase()
  return notes.value.filter((note) => {
    if (type.value !== 'all' && note.type !== type.value) return false
    if (bookFilter.value && note.book.slug !== bookFilter.value) return false
    if (!keyword) return true
    return `${note.title} ${note.content} ${note.book.title}`.toLocaleLowerCase().includes(keyword)
  })
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
  if (route.query.compose) router.replace({ query: { ...route.query, compose: undefined } })
}

async function submitNote(draft) {
  if (await saveNote(draft)) closeEditor()
}

async function confirmDelete() {
  await deleteNote(removing.value.id)
  removing.value = null
}

function clearBookFilter() {
  const next = { ...route.query }
  delete next.book
  router.replace({ query: next })
}

function resetFilters() {
  query.value = ''
  type.value = 'all'
  clearBookFilter()
}

onMounted(async () => {
  if (!notesLoaded.value) await refreshNotes().catch(() => {})
  const payload = await api.books.list({ pageSize: 100 }).catch(() => ({ items: [] }))
  books.value = payload.items
  if (!books.value.length) notify('书目加载失败，暂时无法新建手记', 'error')
})
</script>
<template>
  <div class="container inner-page">
    <div class="page-heading">
      <div>
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
        {{ notes.length }}
        <small>篇阅读回响</small>
      </span>
    </div>

    <div v-if="bookFilter" class="row-between" style="margin-bottom: 14px">
      <span class="pill">
        只看《{{ filterBookTitle || '这本书' }}》的手记
        <button class="icon-button" aria-label="清除书籍筛选" @click="clearBookFilter">
          <AppIcon name="close" :size="14" />
        </button>
      </span>
    </div>

    <div class="notes-toolbar">
      <div class="category-tabs" role="group" aria-label="手记类型">
        <button
          v-for="item in types"
          :key="item.key"
          :class="{ active: type === item.key }"
          :aria-pressed="type === item.key"
          @click="type = item.key"
        >
          {{ item.label }}
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
      :title="notes.length ? '没有找到相关的手记' : '第一篇手记，从一个念头开始'"
      :description="
        notes.length
          ? '换个关键词或手记类型，再试一次。'
          : '不必写得完美，记录你此刻的真实感受就好。'
      "
      icon="pen"
    >
      <button v-if="notes.length" class="button button-secondary" @click="resetFilters">
        查看全部手记
      </button>
      <button v-else class="button" @click="compose()">写一篇手记</button>
    </EmptyState>

    <p class="data-footnote">手记会保存在你的纸间账号中，换设备登录也能继续写。</p>

    <NoteEditor
      v-if="editorOpen"
      :note="editing"
      :initial-book="route.query.book"
      :books="books"
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
