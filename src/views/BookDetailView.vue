<script setup>
import { computed, reactive, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { api } from '../api/client.js'
import { useAuth } from '../composables/useAuth.js'
import { useLibrary } from '../composables/useLibrary.js'
import { notify } from '../composables/useToast.js'
import { formatDate, STATUS_LABELS } from '../utils/format.js'
import BookCover from '../components/books/BookCover.vue'
import AppIcon from '../components/ui/AppIcon.vue'
import EmptyState from '../components/ui/EmptyState.vue'
import SectionHeading from '../components/ui/SectionHeading.vue'
import RatingStars from '../components/ui/RatingStars.vue'
import ReviewCard from '../components/reviews/ReviewCard.vue'
import ReadingTimer from '../components/shelf/ReadingTimer.vue'

const route = useRoute()
const router = useRouter()
const { currentUser, isAuthed } = useAuth()
const { shelfBooks, shelf, addBook, setStatus, updateProgress, refreshShelf, refreshNotes } = useLibrary()

const detail = ref(null)
const distribution = ref([])
const reviews = ref([])
const loading = ref(true)
const savingReview = ref(false)
const timerOpen = ref(false)
const revealSpoilers = ref(false)
const form = reactive({ rating: 0, title: '', content: '', containsSpoilers: false })

const book = computed(() => detail.value?.book)
const myShelf = computed(() => shelf.value.find((item) => item.slug === route.params.slug) || detail.value?.myShelf)
const myReview = computed(() => detail.value?.myReview)
const totalRatings = computed(() => distribution.value.reduce((sum, item) => sum + item.count, 0))
const statuses = ['wishlist', 'reading', 'finished', 'dnf']

async function load(slug) {
  loading.value = true
  try {
    const [detailPayload, distributionPayload, reviewPayload] = await Promise.all([
      api.books.detail(slug),
      api.books.distribution(slug).catch(() => ({ items: [] })),
      api.books.reviews(slug, { pageSize: 8 }).catch(() => ({ items: [] })),
    ])
    detail.value = detailPayload
    distribution.value = distributionPayload.items
    reviews.value = reviewPayload.items
    revealSpoilers.value = false
    if (detailPayload.myReview) {
      Object.assign(form, {
        rating: detailPayload.myReview.rating,
        title: detailPayload.myReview.title || '',
        content: detailPayload.myReview.content || '',
        containsSpoilers: detailPayload.myReview.containsSpoilers,
      })
    } else {
      Object.assign(form, { rating: 0, title: '', content: '', containsSpoilers: false })
    }
  } catch (error) {
    detail.value = null
    notify(error.message, 'error')
  } finally {
    loading.value = false
  }
}

watch(() => route.params.slug, (slug) => slug && load(slug), { immediate: true })

async function changeStatus(status) {
  if (!isAuthed.value) {
    router.push({ path: '/login', query: { redirect: route.fullPath } })
    return
  }
  const ok = await setStatus(route.params.slug, status)
  if (ok !== false) {
    await load(route.params.slug)
    await refreshNotes()
  }
}

async function submitReview() {
  if (!isAuthed.value) {
    router.push({ path: '/login', query: { redirect: route.fullPath } })
    return
  }
  if (!form.rating) {
    notify('先选一个评分吧', 'error')
    return
  }
  savingReview.value = true
  try {
    await api.books.saveReview(route.params.slug, {
      rating: form.rating,
      title: form.title.trim() || undefined,
      content: form.content.trim() || undefined,
      containsSpoilers: form.containsSpoilers,
    })
    notify('书评已保存')
    await load(route.params.slug)
    await refreshShelf()
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    savingReview.value = false
  }
}

function scrollToReviews() {
  document.getElementById('reviews')?.scrollIntoView({ behavior: 'smooth', block: 'start' })
}

function barPercent(count) {
  return totalRatings.value ? (count / totalRatings.value) * 100 : 0
}
</script>
<template>
  <div class="container inner-page">
    <p v-if="loading" class="loading-note">正在翻开这本书…</p>
    <EmptyState v-else-if="!book" title="没有找到这本书" description="它可能不在书库中，回发现页看看吧。">
      <RouterLink to="/" class="button">返回发现页</RouterLink>
    </EmptyState>
    <template v-else>
      <RouterLink to="/" class="text-link" style="font-size: 13px">
        <AppIcon name="arrow-left" :size="15" />
        返回书目
      </RouterLink>

      <article class="book-detail">
        <div class="book-detail-cover"><BookCover :book="book" /></div>
        <div>
          <div class="book-detail-head">
            <h1>{{ book.title }}</h1>
            <p class="en">{{ book.english }}</p>
            <div class="detail-meta">
              <span>{{ book.category }}</span>
              <span>{{ book.author }}</span>
              <span v-if="book.year">原作 {{ book.year }} 年</span>
              <span v-if="book.pages">{{ book.pages }} 页</span>
              <span>{{ detail.readers }} 人收藏 · {{ detail.finished }} 人读完</span>
            </div>
            <div class="detail-meta">
              <RatingStars :rating="book.ratingAvg" :size="17" show-value />
              <span>{{ book.ratingCount }} 人评分</span>
            </div>
          </div>

          <p class="detail-desc">{{ book.description }}</p>

          <div class="editor-note">
            <strong>
              <AppIcon name="leaf" :size="16" />
              纸间荐读
            </strong>
            <p>{{ book.recommendation }}</p>
          </div>

          <div class="chip-row" style="margin-top: 16px">
            <span v-for="item in book.tags" :key="item.kind + item.name" class="chip">{{ item.name }}</span>
          </div>

          <div class="detail-actions">
            <template v-if="myShelf">
              <div class="status-switch" role="group" aria-label="阅读状态">
                <button
                  v-for="status in statuses"
                  :key="status"
                  :class="{ active: myShelf.status === status }"
                  @click="changeStatus(status)"
                >
                  {{ STATUS_LABELS[status] }}
                </button>
              </div>
              <button class="button button-secondary" @click="timerOpen = true">
                <AppIcon name="clock" :size="16" />
                记录阅读
              </button>
            </template>
            <template v-else>
              <button class="button" @click="changeStatus('wishlist')">
                <AppIcon name="plus" :size="17" />
                想读
              </button>
              <button class="button button-secondary" @click="changeStatus('reading')">
                开始读
              </button>
            </template>
            <RouterLink
              v-if="isAuthed"
              :to="{ path: '/notes', query: { compose: '1', book: book.slug } }"
              class="button button-secondary"
            >
              <AppIcon name="pen" :size="16" />
              写手记
            </RouterLink>
            <RouterLink v-else to="/login" class="button button-secondary">登录后收藏</RouterLink>
          </div>

          <div v-if="myShelf && myShelf.status !== 'wishlist'" class="reading-progress" style="margin-top: 10px">
            <div>
              <label for="detail-progress">阅读进度</label>
              <output for="detail-progress">{{ myShelf.progress }}%</output>
            </div>
            <input
              id="detail-progress"
              type="range"
              min="0"
              max="100"
              step="1"
              :value="myShelf.progress"
              :style="{ '--progress': myShelf.progress + '%' }"
              @change="updateProgress(book.slug, $event.target.value)"
            />
            <span class="progress-hint">{{ myShelf.progress === 100 ? '已读完，去写点什么吧。' : '每一页都算数。' }}</span>
          </div>

          <div class="rating-summary">
            <div class="score">
              <strong>{{ book.ratingAvg.toFixed(1) }}</strong>
              <RatingStars :rating="book.ratingAvg" :size="13" />
              <small>{{ totalRatings }} 条评分</small>
            </div>
            <div class="rating-bars">
              <div v-for="star in [5, 4, 3, 2, 1]" :key="star" class="rating-bar">
                <span>{{ star }} 星</span>
                <span class="track">
                  <i :style="{ width: barPercent(distribution.find((d) => d.rating === star)?.count || 0) + '%' }"></i>
                </span>
                <span>{{ distribution.find((d) => d.rating === star)?.count || 0 }}</span>
              </div>
            </div>
          </div>
        </div>
      </article>

      <div class="detail-columns">
        <section id="reviews">
          <SectionHeading :title="`读者书评 · ${reviews.length}`" description="读过的人，留下了他们的回声。">
            <button class="text-link" @click="scrollToReviews">
              写一篇
              <AppIcon name="arrow" :size="15" />
            </button>
          </SectionHeading>

          <form class="review-form" @submit.prevent="submitReview">
            <strong style="font-family: var(--serif); font-size: 15px">
              {{ myReview ? '修改我的书评' : '写下我的书评' }}
            </strong>
            <div class="form-row">
              <span style="font-size: 13px; color: var(--muted)">我的评分</span>
              <RatingStars v-model:rating="form.rating" editable :size="22" />
              <span v-if="form.rating" class="muted small">{{ form.rating }} 星</span>
            </div>
            <input v-model="form.title" type="text" maxlength="80" placeholder="一句话概括（可选）" />
            <textarea v-model="form.content" rows="5" maxlength="5000" placeholder="这本书给你留下了什么？"></textarea>
            <label class="checkbox-line">
              <input v-model="form.containsSpoilers" type="checkbox" />
              这篇书评包含剧透
            </label>
            <div class="row-between">
              <span class="muted small">保存后会自动把这本书标记为读完。</span>
              <button class="button button-small" type="submit" :disabled="savingReview">
                <AppIcon name="check" :size="15" />
                {{ savingReview ? '保存中…' : myReview ? '更新书评' : '发布书评' }}
              </button>
            </div>
          </form>

          <div v-if="reviews.length" class="review-list">
            <ReviewCard v-for="review in reviews" :key="review.id" :review="review" @changed="load(route.params.slug)" />
          </div>
          <p v-else class="muted small">还没有人写下书评，你可以成为第一个。</p>
        </section>

        <aside class="stack">
          <div class="sidebar-block">
            <h3>你可能也喜欢</h3>
            <ul class="related-list">
              <li v-for="item in detail.related" :key="item.slug">
                <RouterLink :to="`/book/${item.slug}`">
                  <span class="mini-cover" :style="{ background: item.color, color: item.ink }">
                    {{ item.title.slice(0, 1) }}
                  </span>
                  <span>
                    <p>{{ item.title }}</p>
                    <small>{{ item.author }}</small>
                  </span>
                </RouterLink>
              </li>
            </ul>
          </div>
          <div class="sidebar-block">
            <h3>阅读工具</h3>
            <RouterLink :to="`/highlights?book=${book.slug}`" class="text-link">
              <AppIcon name="quote" :size="15" />
              这本书的划线
            </RouterLink>
            <RouterLink :to="`/notes?book=${book.slug}`" class="text-link">
              <AppIcon name="pen" :size="15" />
              这本书的手记
            </RouterLink>
            <RouterLink to="/lists" class="text-link">
              <AppIcon name="list" :size="15" />
              加入一份书单
            </RouterLink>
          </div>
        </aside>
      </div>
    </template>

    <ReadingTimer
      v-if="timerOpen"
      :books="shelfBooks.length ? shelfBooks : [book]"
      :initial-book="book?.slug"
      @close="timerOpen = false"
      @saved="load(route.params.slug)"
    />
  </div>
</template>
