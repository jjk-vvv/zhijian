<script setup>
import { computed, ref } from 'vue'
import { books } from '../data/books.js'
import { useLibrary } from '../composables/useLibrary.js'
import DiscoverHero from '../components/discover/DiscoverHero.vue'
import CategoryTabs from '../components/discover/CategoryTabs.vue'
import SearchToolbar from '../components/discover/SearchToolbar.vue'
import ReadingInvitation from '../components/discover/ReadingInvitation.vue'
import SectionHeading from '../components/ui/SectionHeading.vue'
import EmptyState from '../components/ui/EmptyState.vue'
import BookGrid from '../components/books/BookGrid.vue'
import BookDetailModal from '../components/books/BookDetailModal.vue'
const { addBook, isSaved } = useLibrary()
const category = ref('全部书籍'),
  search = ref(''),
  sort = ref('curated'),
  selectedBook = ref(null),
  collection = ref(null)
const filteredBooks = computed(() => {
  const query = search.value.trim().toLocaleLowerCase()
  const result = books.filter(
    (book) =>
      (category.value === '全部书籍' || book.category === category.value) &&
      `${book.title} ${book.author} ${book.english}`.toLocaleLowerCase().includes(query),
  )
  if (sort.value === 'title') result.sort((a, b) => a.title.localeCompare(b.title, 'zh-CN'))
  if (sort.value === 'year') result.sort((a, b) => b.year - a.year)
  return result
})
function explore() {
  collection.value?.scrollIntoView({
    behavior: matchMedia('(prefers-reduced-motion: reduce)').matches ? 'auto' : 'smooth',
    block: 'start',
  })
}
function reset() {
  search.value = ''
  category.value = '全部书籍'
}
</script>
<template>
  <div class="container">
    <DiscoverHero @explore="explore" />
    <div class="editorial-strip">
      <span>
        <i></i>
        本期主题：慢下来，读进去
      </span>
      <span>精 选 经 典 · 常 读 常 新</span>
      <span class="strip-index">VOL. 01 / 秋日读书计划</span>
    </div>
    <section id="collection" ref="collection" class="collection-section">
      <SectionHeading
        title="总有一本，与你此刻有关"
        description="不追赶书单的长度，只在意读进去的时光。"
      >
        <span class="collection-count">{{ filteredBooks.length }} 本精选</span>
      </SectionHeading>
      <div class="collection-toolbar">
        <CategoryTabs v-model="category" />
        <SearchToolbar v-model="search" v-model:sort="sort" />
      </div>
      <BookGrid
        v-if="filteredBooks.length"
        :books="filteredBooks"
        :is-saved="isSaved"
        @detail="selectedBook = $event"
        @save="addBook"
      />
      <EmptyState
        v-else
        title="还没找到这本书"
        description="换个书名或作者试试，也可以看看其他分类。"
        icon="search"
      >
        <button class="button button-secondary" @click="reset">查看全部书籍</button>
      </EmptyState>
    </section>
    <ReadingInvitation />
    <BookDetailModal
      v-if="selectedBook"
      :book="selectedBook"
      :saved="isSaved(selectedBook.id)"
      @close="selectedBook = null"
      @save="addBook"
    />
  </div>
</template>
