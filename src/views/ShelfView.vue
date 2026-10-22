<script setup>
import { ref, computed } from 'vue'
import { useLibrary } from '../composables/useLibrary.js'
import ShelfStats from '../components/shelf/ShelfStats.vue'
import ShelfFilters from '../components/shelf/ShelfFilters.vue'
import ShelfBookCard from '../components/shelf/ShelfBookCard.vue'
import AppIcon from '../components/ui/AppIcon.vue'
import EmptyState from '../components/ui/EmptyState.vue'
import ConfirmDialog from '../components/ui/ConfirmDialog.vue'
import BookDetailModal from '../components/books/BookDetailModal.vue'
const { shelfBooks, stats, removeBook, updateProgress, isSaved, addBook } = useLibrary()
const filter = ref('all'),
  removing = ref(null),
  selectedBook = ref(null)
const visibleBooks = computed(() =>
  shelfBooks.value.filter((book) => filter.value === 'all' || book.status === filter.value),
)
function confirmRemove() {
  removeBook(removing.value.id)
  removing.value = null
}
</script>
<template>
  <div class="container inner-page">
    <div class="page-heading">
      <div>
        <span class="page-kicker">MY LITTLE LIBRARY</span>
        <h1>
          我的书架
          <span class="heading-dot">。</span>
        </h1>
        <p>想读的、在读的、读过的，都是生活的一部分。</p>
      </div>
      <RouterLink to="/" class="button button-secondary">
        <AppIcon name="plus" :size="18" />
        发现更多好书
      </RouterLink>
    </div>
    <ShelfStats :stats="stats" />
    <div class="shelf-section-header">
      <ShelfFilters v-model="filter" :stats="stats" />
      <span class="local-data-note">收好每一段阅读时光</span>
    </div>
    <div v-if="visibleBooks.length" class="shelf-grid">
      <ShelfBookCard
        v-for="book in visibleBooks"
        :key="book.id"
        :book="book"
        @progress="updateProgress($event.id, $event.value)"
        @remove="removing = $event"
        @detail="selectedBook = $event"
      />
    </div>
    <EmptyState
      v-else
      title="给下一本好书，留一个位置"
      description="去发现页挑一本想读的书，或者切换阅读状态看看。"
    >
      <RouterLink to="/" class="button">
        去发现好书
        <AppIcon name="arrow" :size="17" />
      </RouterLink>
    </EmptyState>
    <p class="data-footnote">
      首次访问时，我们为你放入了 3 本示例藏书。书架和手记仅保存在当前浏览器，你可以自由修改。
    </p>
    <ConfirmDialog
      v-if="removing"
      title="将这本书移出书架？"
      :message="'《' + removing.title + '》的阅读进度会被清除，已经写下的手记会继续保留。'"
      confirm-label="移出书架"
      @cancel="removing = null"
      @confirm="confirmRemove"
    />
    <BookDetailModal
      v-if="selectedBook"
      :book="selectedBook"
      :saved="isSaved(selectedBook.id)"
      @close="selectedBook = null"
      @save="addBook"
    />
  </div>
</template>
