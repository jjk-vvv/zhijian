<script setup>
import { computed, ref } from 'vue'
import { api } from '../../api/client.js'
import { useAuth } from '../../composables/useAuth.js'
import { notify } from '../../composables/useToast.js'
import { formatRelative, formatDate } from '../../utils/format.js'
import AppIcon from '../ui/AppIcon.vue'
import Avatar from '../ui/Avatar.vue'
import RatingStars from '../ui/RatingStars.vue'

const props = defineProps({
  review: { type: Object, required: true },
  showBook: Boolean,
  compact: Boolean,
})
const emit = defineEmits(['changed'])

const { currentUser } = useAuth()
const likes = ref(props.review.likesCount || 0)
const liked = ref(Boolean(props.review.liked))
const liking = ref(false)
const spoilerOpen = ref(!props.review.containsSpoilers)
const commentsOpen = ref(false)
const comments = ref([])
const commentsLoading = ref(false)
const commentsCount = ref(props.review.commentsCount || 0)
const draft = ref('')
const sending = ref(false)

const isOwn = computed(() => currentUser.value?.handle === props.review.user?.handle)

async function toggleLike() {
  if (!currentUser.value) {
    notify('登录后可以为书评点赞', 'error')
    return
  }
  if (liking.value) return
  liking.value = true
  try {
    const result = await api.reviews.like(props.review.id)
    liked.value = result.liked
    likes.value = result.likesCount
    emit('changed')
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    liking.value = false
  }
}

async function openComments() {
  commentsOpen.value = !commentsOpen.value
  if (!commentsOpen.value || comments.value.length) return
  commentsLoading.value = true
  try {
    const payload = await api.reviews.comments(props.review.id)
    comments.value = payload.items
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    commentsLoading.value = false
  }
}

async function sendComment() {
  if (!currentUser.value) {
    notify('登录后可以参与讨论', 'error')
    return
  }
  if (!draft.value.trim() || sending.value) return
  sending.value = true
  try {
    const created = await api.reviews.comment(props.review.id, { content: draft.value.trim() })
    comments.value.push(created)
    commentsCount.value = created.commentsCount
    draft.value = ''
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    sending.value = false
  }
}
</script>
<template>
  <article class="review-card" :class="{ 'is-compact': compact }">
    <header class="review-head">
      <RouterLink :to="`/profile/${review.user?.handle}`" class="review-user">
        <Avatar :user="review.user" :size="40" />
        <span>
          <strong>{{ review.user?.displayName }}</strong>
          <small>@{{ review.user?.handle }} · {{ formatRelative(review.createdAt) }}</small>
        </span>
      </RouterLink>
      <div class="review-rating">
        <RatingStars :rating="review.rating" :size="14" />
        <span>{{ Number(review.rating).toFixed(1) }}</span>
      </div>
    </header>

    <RouterLink v-if="showBook && review.book" :to="`/book/${review.book.slug}`" class="review-book">
      <span class="mini-cover" :style="{ background: review.book.color, color: review.book.ink }">
        {{ review.book.title.slice(0, 1) }}
      </span>
      <span>
        <strong>{{ review.book.title }}</strong>
        <small>{{ review.book.author }}</small>
      </span>
    </RouterLink>

    <h3 v-if="review.title" class="review-title">{{ review.title }}</h3>

    <template v-if="review.containsSpoilers && !spoilerOpen">
      <button class="spoiler-toggle" @click="spoilerOpen = true">
        <AppIcon name="filter" :size="16" />
        这篇书评含有剧透，点击展开
      </button>
    </template>
    <p v-else-if="review.content" class="review-content">{{ review.content }}</p>

    <footer class="review-actions">
      <button :class="{ active: liked }" :aria-pressed="liked" @click="toggleLike">
        <AppIcon name="heart" :size="17" />
        {{ likes || '赞' }}
      </button>
      <button :class="{ active: commentsOpen }" @click="openComments">
        <AppIcon name="comment" :size="17" />
        {{ commentsCount || '评论' }}
      </button>
      <span v-if="isOwn" class="own-mark">我的书评</span>
      <time :datetime="review.createdAt">{{ formatDate(review.createdAt) }}</time>
    </footer>

    <section v-if="commentsOpen" class="review-comments">
      <p v-if="commentsLoading" class="muted small">正在加载评论…</p>
      <p v-else-if="!comments.length" class="muted small">还没有评论，来说第一句吧。</p>
      <ul v-else>
        <li v-for="comment in comments" :key="comment.id">
          <Avatar :user="comment.user" :size="28" />
          <div>
            <p>
              <RouterLink :to="`/profile/${comment.user.handle}`">
                <strong>{{ comment.user.displayName }}</strong>
              </RouterLink>
              <span class="muted small">{{ formatRelative(comment.createdAt) }}</span>
            </p>
            <p>{{ comment.content }}</p>
          </div>
        </li>
      </ul>
      <form class="comment-form" @submit.prevent="sendComment">
        <input
          v-model="draft"
          type="text"
          maxlength="500"
          placeholder="写下你的回应…"
          aria-label="写评论"
        />
        <button class="button button-secondary" type="submit" :disabled="!draft.trim() || sending">
          发送
        </button>
      </form>
    </section>
  </article>
</template>
