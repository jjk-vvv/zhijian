<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { api } from '../api/client.js'
import { useAuth } from '../composables/useAuth.js'
import { notify } from '../composables/useToast.js'
import { formatMinutes, formatDate } from '../utils/format.js'
import AppIcon from '../components/ui/AppIcon.vue'
import Avatar from '../components/ui/Avatar.vue'
import EmptyState from '../components/ui/EmptyState.vue'
import BookCover from '../components/books/BookCover.vue'
import ReviewCard from '../components/reviews/ReviewCard.vue'

const route = useRoute()
const { currentUser } = useAuth()
const profile = ref(null)
const shelf = ref([])
const lists = ref([])
const reviews = ref([])
const tab = ref('shelf')
const loading = ref(true)
const busy = ref(false)

const isMe = computed(() => profile.value?.isSelf)
const statusLabel = { reading: '在读', wishlist: '想读', finished: '读完' }

async function load() {
  loading.value = true
  tab.value = 'shelf'
  try {
    const payload = await api.profile(route.params.handle)
    profile.value = payload
    if (!payload.restricted) {
      const [shelfPayload, listPayload, reviewPayload] = await Promise.all([
        api.profileShelf(route.params.handle).catch(() => ({ items: [] })),
        api.profileContent(route.params.handle, 'lists').catch(() => ({ items: [] })),
        api.profileContent(route.params.handle, 'reviews').catch(() => ({ items: [] })),
      ])
      shelf.value = shelfPayload.items
      lists.value = listPayload.items
      reviews.value = reviewPayload.items
    }
  } catch (error) {
    notify(error.message, 'error')
    profile.value = null
  } finally {
    loading.value = false
  }
}

async function toggleFollow() {
  if (!profile.value) return
  busy.value = true
  try {
    const result = await api.follow(profile.value.user.handle)
    profile.value.isFollowing = result.following
    profile.value.stats.followers += result.following ? 1 : -1
    notify(result.following ? '已关注' : '已取消关注')
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    busy.value = false
  }
}

watch(() => route.params.handle, (handle) => handle && load(), { immediate: true })
onMounted(() => {})
</script>
<template>
  <div class="container inner-page">
    <p v-if="loading" class="loading-note">正在打开读者主页…</p>
    <EmptyState v-else-if="!profile" title="找不到这位读者" description="检查一下用户名是否正确。">
      <RouterLink to="/feed" class="button">去书友动态</RouterLink>
    </EmptyState>
    <template v-else>
      <header class="profile-head">
        <Avatar :user="profile.user" :size="82" />
        <div style="flex: 1; min-width: 240px">
          <h1>{{ profile.user.displayName }}</h1>
          <p class="profile-handle">
            @{{ profile.user.handle }}
            <span v-if="profile.user.location"> · {{ profile.user.location }}</span>
          </p>
          <p class="profile-bio">
            {{ profile.user.bio || '这位读者还没有写下自我介绍。' }}
          </p>
          <div class="profile-stats">
            <div><strong>{{ profile.stats.books }}</strong><small>藏书</small></div>
            <div><strong>{{ profile.stats.finished }}</strong><small>读完</small></div>
            <div><strong>{{ profile.stats.reviews }}</strong><small>书评</small></div>
            <div><strong>{{ profile.stats.followers }}</strong><small>关注者</small></div>
            <div><strong>{{ profile.stats.following }}</strong><small>关注中</small></div>
            <div><strong>{{ formatMinutes(profile.stats.minutes) }}</strong><small>阅读时长</small></div>
          </div>
        </div>
        <div class="notes-actions">
          <RouterLink v-if="isMe" to="/settings" class="button button-secondary">
            <AppIcon name="settings" :size="16" />
            编辑资料
          </RouterLink>
          <button v-else-if="currentUser" class="button" :class="{ 'button-secondary': profile.isFollowing }" :disabled="busy" @click="toggleFollow">
            <AppIcon :name="profile.isFollowing ? 'check' : 'plus'" :size="16" />
            {{ profile.isFollowing ? '已关注' : '关注' }}
          </button>
          <RouterLink v-else :to="{ path: '/login', query: { redirect: route.fullPath } }" class="button">
            登录后关注
          </RouterLink>
        </div>
      </header>

      <div v-if="profile.restricted" class="empty-state">
        <span class="empty-icon"><AppIcon name="lock" :size="30" /></span>
        <h3>这是一位注重隐私的读者</h3>
        <p>关注对方后，才能看到 Ta 的书架与文字。</p>
      </div>

      <template v-else>
        <div class="profile-tabs">
          <button :class="{ active: tab === 'shelf' }" @click="tab = 'shelf'">书架 · {{ shelf.length }}</button>
          <button :class="{ active: tab === 'reviews' }" @click="tab = 'reviews'">书评 · {{ reviews.length }}</button>
          <button :class="{ active: tab === 'lists' }" @click="tab = 'lists'">书单 · {{ lists.length }}</button>
        </div>

        <div v-if="tab === 'shelf'">
          <div v-if="shelf.length" class="book-grid">
            <article v-for="book in shelf" :key="book.slug" class="book-card">
              <div class="book-stage" :class="'stage-' + book.art">
                <RouterLink :to="`/book/${book.slug}`">
                  <BookCover :book="book" />
                </RouterLink>
                <span class="book-tag">{{ statusLabel[book.status] }}</span>
              </div>
              <div class="book-meta">
                <h3><RouterLink :to="`/book/${book.slug}`">{{ book.title }}</RouterLink></h3>
                <p class="book-author">{{ book.author }}</p>
                <p class="book-rating">{{ book.status === 'finished' ? '已读完' : book.progress + '%' }}</p>
              </div>
            </article>
          </div>
          <EmptyState v-else title="书架还是空的" description="读过或想读的书，都会出现在这里。" icon="book" />
        </div>

        <div v-else-if="tab === 'reviews'">
          <div v-if="reviews.length" class="review-list">
            <ReviewCard v-for="review in reviews" :key="review.id" :review="review" show-book />
          </div>
          <EmptyState v-else title="还没有书评" description="读完一本书，写下几句话吧。" icon="pen" />
        </div>

        <div v-else>
          <div v-if="lists.length" class="lists-grid">
            <RouterLink v-for="list in lists" :key="list.id" :to="`/lists/${list.id}`" class="list-card">
              <h2>{{ list.title }}</h2>
              <p>{{ list.description || '这份书单还没有说明。' }}</p>
              <div v-if="list.preview.length" class="list-preview">
                <span
                  v-for="book in list.preview"
                  :key="book.slug"
                  :style="{ background: book.color, color: book.ink }"
                >
                  {{ book.title.slice(0, 1) }}
                </span>
              </div>
              <div class="list-meta">
                <span>{{ list.bookCount }} 本书</span>
                <span style="margin-left: auto">{{ formatDate(list.updatedAt) }}</span>
              </div>
            </RouterLink>
          </div>
          <EmptyState v-else title="还没有书单" description="把同主题的书收在一起。" icon="list" />
        </div>
      </template>
    </template>
  </div>
</template>
