<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { api } from '../api/client.js'
import { useAuth } from '../composables/useAuth.js'
import { notify } from '../composables/useToast.js'
import { formatRelative } from '../utils/format.js'
import AppIcon from '../components/ui/AppIcon.vue'
import Avatar from '../components/ui/Avatar.vue'
import EmptyState from '../components/ui/EmptyState.vue'

const route = useRoute()
const { currentUser, isAuthed } = useAuth()

const club = ref(null)
const members = ref([])
const posts = ref([])
const loading = ref(true)
const posting = ref(false)
const content = ref('')
const page = ref('')
const joined = computed(() => club.value?.joined)

async function load() {
  loading.value = true
  try {
    const payload = await api.clubs.get(route.params.slug)
    club.value = payload.club
    members.value = payload.members
    posts.value = payload.posts
  } catch (error) {
    notify(error.message, 'error')
    club.value = null
  } finally {
    loading.value = false
  }
}

async function toggleJoin() {
  if (!isAuthed.value) {
    notify('登录后才能加入书友会', 'error')
    return
  }
  try {
    const result = await api.clubs.join(club.value.slug)
    club.value.joined = result.joined
    club.value.memberCount += result.joined ? 1 : -1
    notify(result.joined ? '已加入书友会' : '已退出书友会')
    await load()
  } catch (error) {
    notify(error.message, 'error')
  }
}

async function submitPost() {
  if (!content.value.trim()) {
    notify('写点什么再发布吧', 'error')
    return
  }
  posting.value = true
  try {
    const created = await api.clubs.post(club.value.slug, {
      content: content.value.trim(),
      page: page.value === '' ? null : Number(page.value),
    })
    posts.value.unshift(created)
    content.value = ''
    page.value = ''
    notify('已发布到书友会')
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    posting.value = false
  }
}

async function removePost(post) {
  try {
    await api.clubs.removePost(club.value.slug, post.id)
    posts.value = posts.value.filter((item) => item.id !== post.id)
    notify('帖子已删除')
  } catch (error) {
    notify(error.message, 'error')
  }
}

onMounted(load)
</script>
<template>
  <div class="container inner-page page-narrow">
    <p v-if="loading" class="loading-note">正在进入书友会…</p>
    <EmptyState v-else-if="!club" title="书友会不存在" description="它可能已被解散，或者是一间私密书友会。">
      <RouterLink to="/clubs" class="button">返回书友会</RouterLink>
    </EmptyState>
    <template v-else>
      <RouterLink to="/clubs" class="text-link" style="font-size: 13px">
        <AppIcon name="arrow-left" :size="15" />
        全部书友会
      </RouterLink>

      <header class="club-detail-head" style="margin-top: 16px">
        <div>
          <h1>{{ club.name }}</h1>
          <p>{{ club.description || '这个书友会还没有写下介绍。' }}</p>
          <div class="club-meta" style="margin-top: 14px">
            <Avatar :user="club.owner" :size="24" />
            <span>{{ club.owner.displayName }} 发起</span>
            <span>· {{ club.memberCount }} 位成员</span>
            <RouterLink v-if="club.book" :to="`/book/${club.book.slug}`" class="club-book">
              共读《{{ club.book.title }}》
            </RouterLink>
          </div>
        </div>
        <button
          v-if="currentUser?.handle !== club.owner.handle"
          class="button"
          :class="{ 'button-secondary': joined }"
          :disabled="club.isPrivate && !joined"
          @click="toggleJoin"
        >
          <AppIcon :name="joined ? 'check' : 'plus'" :size="16" />
          {{ joined ? '已加入 · 退出' : club.isPrivate ? '私密书友会' : '加入书友会' }}
        </button>
      </header>

      <div class="club-layout">
        <section>
          <form v-if="joined" class="club-post-form" @submit.prevent="submitPost">
            <textarea
              v-model="content"
              rows="3"
              maxlength="2000"
              placeholder="分享一个想法、一段原文，或读到第几页了…"
            ></textarea>
            <div class="row-between">
              <label class="muted small" style="display: inline-flex; align-items: center; gap: 8px">
                读到第
                <input v-model="page" type="number" min="1" max="10000" placeholder="页码" />
                页
              </label>
              <button class="button button-small" type="submit" :disabled="posting">
                <AppIcon name="send" :size="15" />
                {{ posting ? '发布中…' : '发布' }}
              </button>
            </div>
          </form>
          <p v-else-if="!club.isPrivate" class="muted small" style="margin-bottom: 16px">
            加入书友会后，就可以参与讨论。
          </p>

          <div v-if="posts.length" class="post-list">
            <article v-for="post in posts" :key="post.id" class="post-item">
              <div class="post-head">
                <Avatar :user="post.user" :size="30" />
                <strong>{{ post.user.displayName }}</strong>
                <small>{{ formatRelative(post.createdAt) }}</small>
                <button
                  v-if="post.user.handle === currentUser?.handle"
                  aria-label="删除帖子"
                  @click="removePost(post)"
                >
                  删除
                </button>
              </div>
              <p>{{ post.content }}</p>
              <span v-if="post.page" class="post-page">读到第 {{ post.page }} 页</span>
            </article>
          </div>
          <EmptyState
            v-else
            title="还没有人开口"
            description="从一句“我读到第几页了”开始，讨论就活起来了。"
            icon="comment"
          />
        </section>

        <aside class="side-card">
          <h3>成员 · {{ club.memberCount }}</h3>
          <ul class="member-list">
            <li v-for="member in members" :key="member.id">
              <RouterLink :to="`/profile/${member.handle}`">
                <Avatar :user="member" :size="26" />
              </RouterLink>
              <span>{{ member.displayName }}</span>
              <span class="member-role">{{ member.role === 'owner' ? '发起人' : '' }}</span>
            </li>
          </ul>
          <p v-if="club.memberCount > members.length" class="muted small">
            还有 {{ club.memberCount - members.length }} 位成员
          </p>
        </aside>
      </div>
    </template>
  </div>
</template>
