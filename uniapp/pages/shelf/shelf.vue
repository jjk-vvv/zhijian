<script setup>
import { onBackPress } from '@dcloudio/uni-app'
import { computed, ref } from 'vue'
import { useLibrary } from '../../composables/useLibrary.js'
import { goTab } from '../../utils/nav.js'
import { usePageTitle } from '../../utils/page-title.js'
import PageShell from '../../components/layout/PageShell.vue'
import ShelfStats from '../../components/shelf/ShelfStats.vue'
import ShelfFilters from '../../components/shelf/ShelfFilters.vue'
import ShelfBookCard from '../../components/shelf/ShelfBookCard.vue'
import AppIcon from '../../components/ui/AppIcon.vue'
import EmptyState from '../../components/ui/EmptyState.vue'
import ConfirmDialog from '../../components/ui/ConfirmDialog.vue'
import BookDetailModal from '../../components/books/BookDetailModal.vue'

usePageTitle('我的书架 · 纸间')

const { shelfBooks, stats, removeBook, updateProgress, isSaved, addBook } = useLibrary()
const filter = ref('all')
const removing = ref(null)
const selectedBook = ref(null)

const visibleBooks = computed(() =>
  shelfBooks.value.filter((book) => filter.value === 'all' || book.status === filter.value),
)

function confirmRemove() {
  removeBook(removing.value.id)
  removing.value = null
}

// Android 返回键：优先关闭弹层（确认框 > 详情），而不是退出应用
onBackPress(() => {
  if (removing.value) {
    removing.value = null
    return true
  }
  if (selectedBook.value) {
    selectedBook.value = null
    return true
  }
  return false
})
</script>

<template>
  <PageShell active="shelf">
    <view class="container inner-page">
      <view class="page-heading">
        <view>
          <text class="page-kicker">MY LITTLE LIBRARY</text>
          <view class="page-title">
            我的书架
            <text class="heading-dot">。</text>
          </view>
          <view class="page-desc">想读的、在读的、读过的，都是生活的一部分。</view>
        </view>
        <view
          class="button button-secondary"
          hover-class="button-secondary-hover"
          @click="goTab('/pages/discover/discover')"
        >
          <AppIcon name="plus" :size="18" tone="green" />
          <text>发现更多好书</text>
        </view>
      </view>
      <ShelfStats :stats="stats" />
      <view class="shelf-section-header">
        <ShelfFilters v-model="filter" :stats="stats" />
        <text class="local-data-note">收好每一段阅读时光</text>
      </view>
      <view v-if="visibleBooks.length" class="shelf-grid">
        <ShelfBookCard
          v-for="book in visibleBooks"
          :key="book.id"
          :book="book"
          @progress="updateProgress($event.id, $event.value)"
          @remove="removing = $event"
          @detail="selectedBook = $event"
        />
      </view>
      <EmptyState
        v-else
        title="给下一本好书，留一个位置"
        description="去发现页挑一本想读的书，或者切换阅读状态看看。"
      >
        <view class="button" hover-class="button-hover" @click="goTab('/pages/discover/discover')">
          <text>去发现好书</text>
          <AppIcon name="arrow" :size="17" tone="white" />
        </view>
      </EmptyState>
      <view class="data-footnote">
        首次访问时，我们为你放入了 3 本示例藏书。书架和手记仅保存在当前设备，你可以自由修改。
      </view>
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
    </view>
  </PageShell>
</template>
