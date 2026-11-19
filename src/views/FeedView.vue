<script setup>
import { onMounted, ref, watch } from 'vue'
import { api } from '../api/client.js'
import { useAuth } from '../composables/useAuth.js'
import { notify } from '../composables/useToast.js'
import AppIcon from '../components/ui/AppIcon.vue'
import Avatar from '../components/ui/Avatar.vue'
import ActivityItem from '../components/social/ActivityItem.vue'
import EmptyState from '../components/ui/EmptyState.vue'

const { isAuthed, currentUser } = useAuth()
const scope = ref('global')
const activities = ref([])
const loading = ref(true)
const suggestions = ref([])
const friends = ref([])
const followBusy = ref('')

async function load() {
  loading.value = true
  try {
    const payload = await api.feed({ scope: scope.value })
    activities.value = payload.items
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    loading.value = false
  }
}

watch(scope, load)

async function follow(user) {
  if (!isAuthed.value) {
    notify('登录后可以关注书友', 'error')
    return
  }
  followBusy.value = user.handle
  try {
    const result = await api.follow(user.handle)
    suggestions.value = suggestions.value.filter((item) => item.handle !== user.handle)
    notify(result.following ? `已关注 ${user.displayName}` : '已取消关注')
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    followBusy.value = ''
  }
}

onMounted(async () => {
  await load()
  if (isAuthed.value) {
    const [suggestionPayload, friendsPayload] = await Promise.all([
      api.suggestions().catch(() => ({ items: [] })),
      api.stats.friendsWeekly().catch(() => ({ items: [] })),
    ])
    suggestions.value = suggestionPayload.items
    friends.value = friendsPayload.items
  }
})
</script>
<template>
  <div class="container inner-page">
    <div class="page-heading">
      <div>
        <h1>
          书友动态
          <span class="heading-dot">。</span>
        </h1>
        <p>看看别人正在读什么，也让自己的阅读被看见。</p>
      </div>
      <RouterLink v-if="currentUser" :to="`/profile/${currentUser.handle}`" class="button button-secondary">
        <AppIcon name="user" :size="17" />
        我的主页
      </RouterLink>
    </div>

    <div class="feed-layout">
      <section>
        <div class="feed-tabs">
          <button :class="{ active: scope === 'global' }" @click="scope = 'global'">全站动态</button>
          <button :class="{ active: scope === 'following' }" @click="scope = 'following'">关注的人</button>
        </div>

        <p v-if="loading" class="loading-note">正在收集书友的近况…</p>
        <div v-else-if="activities.length" class="activity-feed">
          <ActivityItem v-for="activity in activities" :key="activity.id" :activity="activity" />
        </div>
        <EmptyState
          v-else
          :title="scope === 'following' ? '还没有关注动态' : '这里还很安静'"
          :description="
            scope === 'following'
              ? '关注几位书友，就能看到他们的阅读近况。'
              : '开始记录阅读，你的动态也会出现在这里。'
          "
          icon="users"
        >
          <button v-if="scope === 'following'" class="button button-secondary" @click="scope = 'global'">
            看看全站动态
          </button>
          <RouterLink v-else to="/" class="button">去读一本书</RouterLink>
        </EmptyState>
      </section>

      <aside class="stack">
        <section v-if="isAuthed" class="side-card">
          <h3>可能认识的读者</h3>
          <p v-if="!suggestions.length" class="muted small">暂时没有推荐，稍后再来看看。</p>
          <div v-for="user in suggestions" :key="user.handle" class="reader-mini">
            <RouterLink :to="`/profile/${user.handle}`">
              <Avatar :user="user" :size="34" />
            </RouterLink>
            <div class="reader-copy">
              <strong>{{ user.displayName }}</strong>
              <small>@{{ user.handle }} · {{ user.booksCount || 0 }} 本藏书</small>
            </div>
            <button class="follow-button" :disabled="followBusy === user.handle" @click="follow(user)">
              关注
            </button>
          </div>
        </section>

        <section v-if="isAuthed" class="side-card">
          <h3>本周阅读榜</h3>
          <ul class="leaderboard">
            <li v-for="(item, index) in friends" :key="item.user.id">
              <span class="rank" :class="{ 'is-me': item.user.handle === currentUser?.handle }">{{ index + 1 }}</span>
              <RouterLink :to="`/profile/${item.user.handle}`">
                <Avatar :user="item.user" :size="28" />
              </RouterLink>
              <span>{{ item.user.displayName }}</span>
              <span class="leader-meta"><strong>{{ item.minutes }} 分钟</strong></span>
            </li>
          </ul>
          <p v-if="!friends.length" class="muted small">开始记录阅读，就能出现在榜单上。</p>
        </section>

        <section v-else class="side-card">
          <h3>加入纸间</h3>
          <p class="muted small" style="line-height: 1.8">
            登录后可以关注书友、参与讨论，并让阅读记录被记住。
          </p>
          <RouterLink to="/login" class="button button-small">登录</RouterLink>
        </section>
      </aside>
    </div>
  </div>
</template>
