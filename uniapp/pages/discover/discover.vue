<script setup>
import { onBackPress } from '@dcloudio/uni-app'
import { computed, ref } from 'vue'
import { books } from '../../data/books.js'
import { useLibrary } from '../../composables/useLibrary.js'
import { usePageTitle } from '../../utils/page-title.js'
import PageShell from '../../components/layout/PageShell.vue'
import DiscoverHero from '../../components/discover/DiscoverHero.vue'
import CategoryTabs from '../../components/discover/CategoryTabs.vue'
import SearchToolbar from '../../components/discover/SearchToolbar.vue'
import ReadingInvitation from '../../components/discover/ReadingInvitation.vue'
import SectionHeading from '../../components/ui/SectionHeading.vue'
import EmptyState from '../../components/ui/EmptyState.vue'
import BookGrid from '../../components/books/BookGrid.vue'
import BookDetailModal from '../../components/books/BookDetailModal.vue'

usePageTitle('纸间 · 在书页之间，遇见自己')

const { addBook, isSaved } = useLibrary()
const category = ref('全部书籍')
const search = ref('')
const sort = ref('curated')
const selectedBook = ref(null)

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

// Web 版用 scrollIntoView；uni-app 三端统一改为选择器查询 + pageScrollTo。
function explore() {
  const query = uni.createSelectorQuery()
  query.select('#collection').boundingClientRect()
  query.selectViewport().scrollOffset()
  query.exec((res) => {
    const rect = res && res[0]
    const viewport = res && res[1]
    if (!rect || !viewport) return
    uni.pageScrollTo({
      scrollTop: Math.max(0, rect.top + viewport.scrollTop - 25),
      duration: 320,
    })
  })
}

function reset() {
  search.value = ''
  category.value = '全部书籍'
}

// Android 返回键：弹窗打开时先关弹窗，避免直接触发「再按一次退出应用」
onBackPress(() => {
  if (selectedBook.value) {
    selectedBook.value = null
    return true
  }
  return false
})
</script>

<template>
  <PageShell active="discover">
    <view class="container">
      <DiscoverHero @explore="explore" />
      <view class="editorial-strip">
        <view class="strip-item strip-theme">
          <view class="strip-dot"></view>
          <text>本期主题：慢下来，读进去</text>
        </view>
        <text class="strip-item strip-slogan">精 选 经 典 · 常 读 常 新</text>
        <text class="strip-index">VOL. 01 / 秋日读书计划</text>
      </view>
      <view id="collection" class="collection-section">
        <SectionHeading
          title="总有一本，与你此刻有关"
          description="不追赶书单的长度，只在意读进去的时光。"
        >
          <text class="collection-count">{{ filteredBooks.length }} 本精选</text>
        </SectionHeading>
        <view class="collection-toolbar">
          <CategoryTabs v-model="category" />
          <SearchToolbar v-model="search" v-model:sort="sort" />
        </view>
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
      </view>
      <ReadingInvitation />
      <BookDetailModal
        v-if="selectedBook"
        :book="selectedBook"
        :saved="isSaved(selectedBook.id)"
        @close="selectedBook = null"
        @save="addBook"
      />
    </view>
  </PageShell>
</template>
