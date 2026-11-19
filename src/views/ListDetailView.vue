<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { api } from '../api/client.js'
import { useAuth } from '../composables/useAuth.js'
import { notify } from '../composables/useToast.js'
import { formatDate } from '../utils/format.js'
import AppIcon from '../components/ui/AppIcon.vue'
import Avatar from '../components/ui/Avatar.vue'
import ConfirmDialog from '../components/ui/ConfirmDialog.vue'
import EmptyState from '../components/ui/EmptyState.vue'

const route = useRoute()
const router = useRouter()
const { currentUser } = useAuth()

const list = ref(null)
const items = ref([])
const books = ref([])
const loading = ref(true)
const addSlug = ref('')
const addNote = ref('')
const adding = ref(false)
const removingItem = ref(null)
const removingList = ref(false)
const editing = ref(false)
const editForm = ref({ title: '', description: '', isPublic: true })

const isOwner = computed(() => currentUser.value?.handle === list.value?.user?.handle)

async function load() {
  loading.value = true
  try {
    const payload = await api.lists.get(route.params.id)
    list.value = payload.list
    items.value = payload.items
    editForm.value = {
      title: payload.list.title,
      description: payload.list.description || '',
      isPublic: payload.list.isPublic,
    }
    if (currentUser.value?.handle === payload.list.user.handle) {
      const bookPayload = await api.books.list({ pageSize: 100 }).catch(() => ({ items: [] }))
      books.value = bookPayload.items
    }
  } catch (error) {
    notify(error.message, 'error')
    list.value = null
  } finally {
    loading.value = false
  }
}

async function addBook() {
  if (!addSlug.value) {
    notify('先选一本书', 'error')
    return
  }
  adding.value = true
  try {
    await api.lists.addItem(list.value.id, { bookSlug: addSlug.value, note: addNote.value.trim() })
    addNote.value = ''
    addSlug.value = ''
    notify('已加入书单')
    await load()
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    adding.value = false
  }
}

async function confirmRemoveItem() {
  try {
    await api.lists.removeItem(list.value.id, removingItem.value.slug)
    items.value = items.value.filter((item) => item.slug !== removingItem.value.slug)
    notify('已从书单移除')
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    removingItem.value = null
  }
}

async function saveEdit() {
  try {
    await api.lists.update(list.value.id, {
      title: editForm.value.title,
      description: editForm.value.description,
      isPublic: editForm.value.isPublic,
    })
    editing.value = false
    notify('书单已更新')
    await load()
  } catch (error) {
    notify(error.message, 'error')
  }
}

async function deleteList() {
  try {
    await api.lists.remove(list.value.id)
    notify('书单已删除')
    router.replace('/lists')
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    removingList.value = false
  }
}

onMounted(load)
</script>
<template>
  <div class="container inner-page page-narrow">
    <p v-if="loading" class="loading-note">正在打开书单…</p>
    <EmptyState v-else-if="!list" title="书单不存在或不可见" description="它可能已被删除，或者是一份私密书单。">
      <RouterLink to="/lists" class="button">返回书单</RouterLink>
    </EmptyState>
    <template v-else>
      <RouterLink to="/lists" class="text-link" style="font-size: 13px">
        <AppIcon name="arrow-left" :size="15" />
        全部书单
      </RouterLink>

      <div class="list-detail-head" style="margin-top: 16px">
        <div>
          <h1>{{ list.title }}</h1>
          <p class="muted" style="margin-top: 8px; line-height: 1.8; max-width: 560px">
            {{ list.description || '这份书单还没有写下说明。' }}
          </p>
          <div class="list-meta" style="margin-top: 12px">
            <Avatar :user="list.user" :size="24" />
            <span>{{ list.user.displayName }}</span>
            <span>· {{ items.length }} 本书 · 更新于 {{ formatDate(list.updatedAt) }}</span>
            <span v-if="!list.isPublic" class="pill">
              <AppIcon name="lock" :size="12" />
              私密
            </span>
          </div>
        </div>
        <div v-if="isOwner" class="notes-actions">
          <button class="button button-secondary button-small" @click="editing = !editing">
            <AppIcon name="pen" :size="15" />
            {{ editing ? '取消编辑' : '编辑书单' }}
          </button>
          <button class="button button-danger button-small" @click="removingList = true">
            <AppIcon name="trash" :size="15" />
            删除
          </button>
        </div>
      </div>

      <form v-if="isOwner && editing" class="card stack" style="margin-top: 18px" @submit.prevent="saveEdit">
        <label class="field">
          <span>标题</span>
          <input v-model="editForm.title" maxlength="60" />
        </label>
        <label class="field">
          <span>说明</span>
          <textarea v-model="editForm.description" rows="3" maxlength="500"></textarea>
        </label>
        <div class="row-between">
          <label class="checkbox-line">
            <input v-model="editForm.isPublic" type="checkbox" />
            公开书单
          </label>
          <button class="button button-small" type="submit">保存修改</button>
        </div>
      </form>

      <form v-if="isOwner" class="card stack" style="margin-top: 18px" @submit.prevent="addBook">
        <h2 style="font-size: 16px">往书单里加一本书</h2>
        <div class="form-grid">
          <label class="field">
            <span>选择书目</span>
            <select v-model="addSlug">
              <option value="">请选择</option>
              <option v-for="book in books" :key="book.slug" :value="book.slug">《{{ book.title }}》· {{ book.author }}</option>
            </select>
          </label>
          <label class="field">
            <span>推荐语（可选）</span>
            <input v-model="addNote" maxlength="300" placeholder="为什么推荐这本书？" />
          </label>
        </div>
        <div class="row-between">
          <span class="muted small">书单会按加入顺序展示。</span>
          <button class="button button-small" type="submit" :disabled="adding">
            <AppIcon name="plus" :size="15" />
            加入书单
          </button>
        </div>
      </form>

      <div v-if="items.length" class="list-items">
        <article v-for="(item, index) in items" :key="item.slug" class="list-item">
          <span class="rank muted" style="width: 20px">{{ index + 1 }}</span>
          <span class="mini-cover" :style="{ background: item.color, color: item.ink }">
            {{ item.title.slice(0, 1) }}
          </span>
          <div class="list-item-copy">
            <h3><RouterLink :to="`/book/${item.slug}`">《{{ item.title }}》</RouterLink></h3>
            <p>{{ item.author }}{{ item.ratingCount ? ' · ' + item.ratingAvg.toFixed(1) + ' 分' : '' }}</p>
            <p v-if="item.itemNote" class="list-item-note">{{ item.itemNote }}</p>
          </div>
          <button
            v-if="isOwner"
            class="icon-button subtle"
            :aria-label="'从书单移除'"
            @click="removingItem = item"
          >
            <AppIcon name="close" :size="16" />
          </button>
        </article>
      </div>
      <EmptyState v-else title="这份书单还是空的" description="加几本同主题的书，让它慢慢长出来。" icon="list">
        <RouterLink to="/" class="button">去发现好书</RouterLink>
      </EmptyState>
    </template>

    <ConfirmDialog
      v-if="removingItem"
      title="从书单移除这本书？"
      :message="'《' + removingItem.title + '》会从这份书单中移除，书架上的书不受影响。'"
      confirm-label="移除"
      @cancel="removingItem = null"
      @confirm="confirmRemoveItem"
    />
    <ConfirmDialog
      v-if="removingList"
      title="删除这份书单？"
      message="书单和其中的条目都会被删除，书架上的书不受影响。"
      confirm-label="删除书单"
      @cancel="removingList = false"
      @confirm="deleteList"
    />
  </div>
</template>
