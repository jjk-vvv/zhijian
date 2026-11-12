<script setup>
import { computed, ref } from 'vue'
import { onLoad, onShow, onUnload, onBackPress } from '@dcloudio/uni-app'
import { getBook } from '../../data/books.js'
import { useLibrary } from '../../composables/useLibrary.js'
import { usePageTitle } from '../../utils/page-title.js'
import { COMPOSE_EVENT, takeComposeRequest } from '../../utils/nav.js'
import PageShell from '../../components/layout/PageShell.vue'
import AppIcon from '../../components/ui/AppIcon.vue'
import EmptyState from '../../components/ui/EmptyState.vue'
import ConfirmDialog from '../../components/ui/ConfirmDialog.vue'
import NoteEditor from '../../components/notes/NoteEditor.vue'
import NotesList from '../../components/notes/NotesList.vue'

usePageTitle('阅读手记 · 纸间')

const { library, saveNote, deleteNote } = useLibrary()
const editorOpen = ref(false)
const editing = ref(null)
const removing = ref(null)
const initialBook = ref('')
const query = ref('')
const type = ref('全部手记')
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
    .slice()
    .sort((a, b) => new Date(b.date) - new Date(a.date))
})

function openCompose(bookId) {
  editing.value = null
  initialBook.value = bookId || ''
  editorOpen.value = true
}

// Web / App：靠页面参数打开编辑器。
onLoad((options = {}) => {
  initialBook.value = options.book ? String(options.book) : ''
  if (options.compose === '1') openCompose(initialBook.value)
  // 页头「写手记」在已停留于本页时用事件通知，避免 switchTab 无响应
  uni.$on(COMPOSE_EVENT, openCompose)
})

// 小程序 / App：tabBar 页面无法携带 query，改为在 onShow 里消费一次性标记。
onShow(() => {
  // #ifndef H5
  const request = takeComposeRequest()
  if (request) openCompose(request.bookId)
  // #endif
})

onUnload(() => {
  uni.$off(COMPOSE_EVENT, openCompose)
})

function compose(note = null) {
  editing.value = note
  editorOpen.value = true
}
function closeEditor() {
  editorOpen.value = false
  editing.value = null
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

// Android 返回键：优先关闭编辑器 / 确认框，而不是退出应用
onBackPress(() => {
  if (editorOpen.value) {
    closeEditor()
    return true
  }
  if (removing.value) {
    removing.value = null
    return true
  }
  return false
})
</script>

<template>
  <PageShell active="notes">
    <view class="container inner-page">
      <view class="page-heading">
        <view>
          <text class="page-kicker">THOUGHTS BETWEEN THE LINES</text>
          <view class="page-title">
            阅读手记
            <text class="heading-dot">。</text>
          </view>
          <view class="page-desc">书页会合上，触动你的那些想法，可以留下。</view>
        </view>
        <button class="button" @click="compose()">
          <AppIcon name="plus" :size="18" tone="white" />
          <text>写一篇手记</text>
        </button>
      </view>
      <view class="notes-intro">
        <text class="quote-mark">“</text>
        <view class="intro-copy">
          <view class="intro-line">读书的意义，也在于那些</view>
          <view class="intro-line intro-strong">只属于你的理解。</view>
        </view>
        <view class="notes-total">
          {{ library.notes.length }}
          <text class="notes-unit">篇阅读回响</text>
        </view>
      </view>
      <view class="notes-toolbar">
        <view class="category-tabs">
          <button
            v-for="item in types"
            :key="item"
            class="tab-btn"
            :class="{ active: type === item }"
            :aria-pressed="type === item"
            @click="type = item"
          >
            {{ item }}
          </button>
        </view>
        <view class="search-box">
          <AppIcon name="search" :size="18" tone="olive" />
          <text class="sr-only">搜索手记</text>
          <input
            class="search-input"
            type="text"
            v-model="query"
            placeholder="搜索手记或书名…"
            placeholder-class="field-placeholder"
            confirm-type="search"
          />
        </view>
      </view>
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
      <view class="data-footnote">文字仅保存在当前设备，清除应用数据会同时移除记录。</view>
      <NoteEditor
        v-if="editorOpen"
        :note="editing"
        :initial-book="initialBook"
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
    </view>
  </PageShell>
</template>
