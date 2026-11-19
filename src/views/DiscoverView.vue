<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import { api } from '../api/client.js'
import { useAuth } from '../composables/useAuth.js'
import { useLibrary } from '../composables/useLibrary.js'
import { notify } from '../composables/useToast.js'
import DiscoverHero from '../components/discover/DiscoverHero.vue'
import CategoryTabs from '../components/discover/CategoryTabs.vue'
import SearchToolbar from '../components/discover/SearchToolbar.vue'
import ReadingInvitation from '../components/discover/ReadingInvitation.vue'
import SectionHeading from '../components/ui/SectionHeading.vue'
import EmptyState from '../components/ui/EmptyState.vue'
import AppIcon from '../components/ui/AppIcon.vue'
import BookGrid from '../components/books/BookGrid.vue'

const { currentUser } = useAuth()
const { shelfBooks, addBook, isSaved, refreshShelf } = useLibrary()

const categories = ref([{ name: '全部书籍', count: 0 }])
const books = ref([])
const total = ref(0)
const page = ref(1)
const pageSize = 12
const loading = ref(true)
const category = ref('全部书籍')
const search = ref('')
const sort = ref('curated')
const tag = ref('')
const daily = ref(null)
const topRated = ref([])
const collection = ref(null)

const readingBooks = computed(() => shelfBooks.value.filter((book) => book.status === 'reading').slice(0, 2))
const totalPages = computed(() => Math.max(1, Math.ceil(total.value / pageSize)))
const tags = ['自然', '哲思', '成长', '女性', '旅行', '科学', '生活']

async function loadBooks() {
  loading.value = true
  try {
    const payload = await api.books.list({
      q: search.value.trim() || undefined,
      category: category.value === '全部书籍' ? undefined : category.value,
      tag: tag.value || undefined,
      sort: sort.value,
      page: page.value,
      pageSize,
    })
    books.value = payload.items
    total.value = payload.total
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    loading.value = false
  }
}

let searchTimer
watch(search, () => {
  clearTimeout(searchTimer)
  searchTimer = setTimeout(() => {
    page.value = 1
    loadBooks()
  }, 320)
})
watch([category, sort, tag], () => {
  page.value = 1
  loadBooks()
})

function goPage(next) {
  if (next < 1 || next > totalPages.value || next === page.value) return
  page.value = next
  loadBooks()
  collection.value?.scrollIntoView({ behavior: 'smooth', block: 'start' })
}

function explore() {
  collection.value?.scrollIntoView({ behavior: 'smooth', block: 'start' })
}

function resetFilters() {
  search.value = ''
  category.value = '全部书籍'
  tag.value = ''
  page.value = 1
  loadBooks()
}

onMounted(async () => {
  const [categoryResult, topResult] = await Promise.all([
    api.books.categories().catch(() => ({ items: [] })),
    api.books.list({ sort: 'rating', pageSize: 5 }).catch(() => ({ items: [] })),
  ])
  categories.value = [{ name: '全部书籍', count: 0 }, ...categoryResult.items]
  topRated.value = topResult.items
  loadBooks()
  if (currentUser.value) {
    api.highlights.daily().then((payload) => (daily.value = payload.highlight)).catch(() => {})
    refreshShelf().catch(() => {})
  }
})
</script>
<template>
  <div class="container">
    <DiscoverHero @explore="explore" />

    <div class="editorial-strip">
      <span>
        <i></i>
        本期主题：慢下来，读进去
      </span>
      <span>精选经典，常读常新</span>
      <span class="strip-index">第 01 期 · 秋日读书计划</span>
    </div>

    <section v-if="readingBooks.length" class="home-continue">
      <RouterLink
        v-for="book in readingBooks"
        :key="book.slug"
        :to="`/book/${book.slug}`"
        class="continue-card"
      >
        <span class="mini-cover" :style="{ background: book.color, color: book.ink }">
          {{ book.title.slice(0, 1) }}
        </span>
        <div style="flex: 1; min-width: 0">
          <h2>继续读《{{ book.title }}》</h2>
          <p>{{ book.status === 'reading' ? `已读 ${book.progress}%` : '重新翻开也好' }}</p>
          <div class="bar"><i :style="{ width: `${book.progress}%` }"></i></div>
        </div>
        <AppIcon name="arrow" :size="18" />
      </RouterLink>
    </section>

    <div class="home-panels">
      <aside v-if="daily" class="daily-quote">
        <span class="quote-mark" aria-hidden="true">“</span>
        <span class="quote-label">今日划线回顾</span>
        <blockquote>“{{ daily.quote }}”</blockquote>
        <cite>
          —— 《{{ daily.book.title }}》{{ daily.note ? ' · ' + daily.note : '' }}
        </cite>
        <RouterLink to="/highlights" class="text-link">
          收好我的划线
          <AppIcon name="arrow" :size="16" />
        </RouterLink>
      </aside>
      <aside v-else class="daily-quote">
        <span class="quote-mark" aria-hidden="true">“</span>
        <span class="quote-label">今日阅读</span>
        <blockquote>读书是在别人的思想里，建立起自己的思想。</blockquote>
        <cite>—— 愿你今天也有一页安静的时光</cite>
        <RouterLink to="/login" class="text-link">
          登录后记录划线
          <AppIcon name="arrow" :size="16" />
        </RouterLink>
      </aside>

      <aside class="side-card">
        <h2>最近评分最高</h2>
        <ul class="side-list">
          <li v-for="book in topRated" :key="book.slug">
            <RouterLink :to="`/book/${book.slug}`">
              <span class="mini-cover" :style="{ background: book.color, color: book.ink }">
                {{ book.title.slice(0, 1) }}
              </span>
              <span>
                {{ book.title }}
                <small class="muted" style="display: block; font-size: 11.5px">
                  {{ book.ratingAvg.toFixed(1) }} 分 · {{ book.author }}
                </small>
              </span>
            </RouterLink>
          </li>
        </ul>
        <RouterLink to="/stats" class="text-link">
          看看我的阅读统计
          <AppIcon name="arrow" :size="16" />
        </RouterLink>
      </aside>
    </div>

    <section id="collection" ref="collection" class="collection-section">
      <SectionHeading
        title="总有一本，与你此刻有关"
        description="不追赶书单的长度，只在意读进去的时光。"
      >
        <span class="collection-count">共 {{ total }} 本</span>
      </SectionHeading>

      <div class="collection-toolbar">
        <CategoryTabs v-model="category" :categories="categories" />
        <SearchToolbar v-model="search" v-model:sort="sort" />
      </div>

      <div class="tag-strip">
        <button
          class="chip"
          :class="{ active: !tag }"
          @click="tag = ''"
        >
          全部主题
        </button>
        <button
          v-for="item in tags"
          :key="item"
          class="chip"
          :class="{ active: tag === item }"
          @click="tag = tag === item ? '' : item"
        >
          {{ item }}
        </button>
      </div>

      <p v-if="loading" class="loading-note">正在为你整理书页…</p>
      <BookGrid
        v-else-if="books.length"
        :books="books"
        :is-saved="isSaved"
        @save="addBook($event, 'wishlist')"
      />
      <EmptyState
        v-else
        title="还没找到这本书"
        description="换个书名或作者试试，也可以看看其他分类。"
        icon="search"
      >
        <button class="button button-secondary" @click="resetFilters">查看全部书籍</button>
      </EmptyState>

      <nav v-if="totalPages > 1" class="pagination" aria-label="分页">
        <button :disabled="page === 1" @click="goPage(page - 1)">
          <AppIcon name="arrow-left" :size="15" />
        </button>
        <span>第 {{ page }} / {{ totalPages }} 页</span>
        <button :disabled="page === totalPages" @click="goPage(page + 1)">
          <AppIcon name="arrow" :size="15" />
        </button>
      </nav>
    </section>

    <ReadingInvitation />
  </div>
</template>
