<script setup>
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { api } from '../../api/client.js'
import { useAuth } from '../../composables/useAuth.js'
import { notify } from '../../composables/useToast.js'
import { formatRelative } from '../../utils/format.js'
import AppIcon from '../ui/AppIcon.vue'
import Avatar from '../ui/Avatar.vue'

const { currentUser } = useAuth()
const router = useRouter()
const open = ref(false)
const items = ref([])
const unread = ref(0)
const loading = ref(false)
const root = ref(null)

const hasUnread = computed(() => unread.value > 0)

const text = (item) => {
  if (item.type === 'follow') return '关注了你'
  if (item.type === 'like') return '赞了你的书评'
  if (item.type === 'comment') return `评论了你的书评：${item.payload?.excerpt || ''}`
  if (item.type === 'club_post') return `在书友会里发言：${item.payload?.excerpt || ''}`
  return item.payload?.message || '有一条新消息'
}

async function load() {
  if (!currentUser.value) {
    items.value = []
    unread.value = 0
    return
  }
  loading.value = true
  try {
    const payload = await api.notifications.list()
    items.value = payload.items
    unread.value = payload.unreadCount
  } catch {
    // 通知是辅助信息，静默失败即可。
  } finally {
    loading.value = false
  }
}

async function toggle() {
  open.value = !open.value
  if (open.value) await load()
}

async function readAll() {
  try {
    await api.notifications.readAll()
    unread.value = 0
    items.value = items.value.map((item) => ({ ...item, isRead: true }))
  } catch (error) {
    notify(error.message, 'error')
  }
}

async function openItem(item) {
  if (!item.isRead) {
    api.notifications.read(item.id).catch(() => {})
    item.isRead = true
    unread.value = Math.max(0, unread.value - 1)
  }
  open.value = false
  if (item.type === 'club_post' && item.payload?.clubSlug) {
    router.push(`/clubs/${item.payload.clubSlug}`)
  } else if (item.actor?.handle) {
    router.push(`/profile/${item.actor.handle}`)
  }
}

function onClickOutside(event) {
  if (root.value && !root.value.contains(event.target)) open.value = false
}

watch(currentUser, load, { immediate: true })

onMounted(() => document.addEventListener('click', onClickOutside))
onBeforeUnmount(() => document.removeEventListener('click', onClickOutside))
</script>
<template>
  <div ref="root" class="notif-root">
    <button
      class="icon-button notif-button"
      :aria-label="hasUnread ? '通知（有未读）' : '通知'"
      :aria-expanded="open"
      @click.stop="toggle"
    >
      <AppIcon name="bell" :size="19" />
      <span v-if="hasUnread" class="notif-dot" aria-hidden="true"></span>
    </button>
    <Transition name="dropdown">
      <div v-if="open" class="notif-panel">
        <header>
          <strong>通知</strong>
          <button v-if="hasUnread" class="text-link" @click="readAll">全部已读</button>
        </header>
        <p v-if="loading" class="muted small">正在加载…</p>
        <p v-else-if="!items.length" class="muted small">暂时没有新消息。</p>
        <ul v-else>
          <li v-for="item in items" :key="item.id" :class="{ unread: !item.isRead }">
            <button @click="openItem(item)">
              <Avatar :user="item.actor" :size="34" />
              <span>
                <strong>{{ item.actor?.displayName || '纸间' }}</strong>
                {{ text(item) }}
                <small>{{ formatRelative(item.createdAt) }}</small>
              </span>
            </button>
          </li>
        </ul>
      </div>
    </Transition>
  </div>
</template>
