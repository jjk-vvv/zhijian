<script setup>
import { computed, onMounted, ref } from 'vue'
import { useLibrary } from '../composables/useLibrary.js'
import ShelfStats from '../components/shelf/ShelfStats.vue'
import ShelfFilters from '../components/shelf/ShelfFilters.vue'
import ShelfBookCard from '../components/shelf/ShelfBookCard.vue'
import ReadingTimer from '../components/shelf/ReadingTimer.vue'
import AppIcon from '../components/ui/AppIcon.vue'
import EmptyState from '../components/ui/EmptyState.vue'
import ConfirmDialog from '../components/ui/ConfirmDialog.vue'

const { shelfBooks, stats, removeBook, updateProgress, refreshShelf, refreshNotes, loading } = useLibrary()
const filter = ref('all')
const removing = ref(null)
const timerBook = ref('')
const timerOpen = ref(false)

const visibleBooks = computed(() =>
  shelfBooks.value.filter((book) => filter.value === 'all' || book.status === filter.value),
)

function openTimer(book) {
  timerBook.value = book?.slug || shelfBooks.value.find((item) => item.status === 'reading')?.slug || ''
  timerOpen.value = true
}

function finish({ slug, value }) {
  updateProgress(slug, value)
}

async function afterTimer() {
  await Promise.all([refreshShelf(), refreshNotes()])
}

function confirmRemove() {
  removeBook(removing.value.slug)
  removing.value = null
}

onMounted(() => refreshShelf().catch(() => {}))
</script>
<template>
  <div class="container inner-page">
    <div class="page-heading">
      <div>
        <h1>
          我的书架
          <span class="heading-dot">。</span>
        </h1>
        <p>想读的、在读的、读过的，都是生活的一部分。</p>
      </div>
      <div class="notes-actions">
        <button class="button button-secondary" @click="openTimer()">
          <AppIcon name="clock" :size="17" />
          记录阅读
        </button>
        <RouterLink to="/" class="button">
          <AppIcon name="plus" :size="17" />
          发现好书
        </RouterLink>
      </div>
    </div>

    <ShelfStats :stats="stats" />

    <div class="shelf-section-header">
      <ShelfFilters v-model="filter" :stats="stats" />
      <span class="local-data-note">收藏、进度与手记都会同步到你的账号</span>
    </div>

    <p v-if="loading && !shelfBooks.length" class="loading-note">正在整理你的书架…</p>
    <div v-else-if="visibleBooks.length" class="shelf-grid">
      <ShelfBookCard
        v-for="book in visibleBooks"
        :key="book.slug"
        :book="book"
        @progress="updateProgress($event.slug, $event.value)"
        @finish="finish"
        @remove="removing = $event"
        @timer="openTimer"
      />
    </div>
    <EmptyState
      v-else
      :title="filter === 'all' ? '给下一本好书，留一个位置' : '这个状态下还没有书'"
      description="去发现页挑一本想读的书，或者切换阅读状态看看。"
    >
      <RouterLink to="/" class="button">
        去发现好书
        <AppIcon name="arrow" :size="17" />
      </RouterLink>
    </EmptyState>

    <ConfirmDialog
      v-if="removing"
      title="将这本书移出书架？"
      :message="'《' + removing.title + '》的阅读进度会被清除，已经写下的手记会继续保留。'"
      confirm-label="移出书架"
      @cancel="removing = null"
      @confirm="confirmRemove"
    />

    <ReadingTimer
      v-if="timerOpen"
      :books="shelfBooks"
      :initial-book="timerBook"
      @close="timerOpen = false"
      @saved="afterTimer"
    />
  </div>
</template>
