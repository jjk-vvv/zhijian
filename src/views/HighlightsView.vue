<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useRoute } from 'vue-router'
import { api } from '../api/client.js'
import { notify } from '../composables/useToast.js'
import { formatDate } from '../utils/format.js'
import AppIcon from '../components/ui/AppIcon.vue'
import EmptyState from '../components/ui/EmptyState.vue'
import BaseModal from '../components/ui/BaseModal.vue'
import ConfirmDialog from '../components/ui/ConfirmDialog.vue'

const route = useRoute()
const items = ref([])
const books = ref([])
const daily = ref(null)
const loading = ref(true)
const query = ref('')
const creating = ref(false)
const removing = ref(null)
const submitting = ref(false)
const form = reactive({ bookSlug: '', quote: '', page: '', note: '', isPrivate: true })

const filtered = computed(() => {
  const keyword = query.value.trim().toLocaleLowerCase()
  const book = route.query.book
  return items.value.filter((item) => {
    if (book && item.book.slug !== book) return false
    if (!keyword) return true
    return `${item.quote} ${item.note} ${item.book.title}`.toLocaleLowerCase().includes(keyword)
  })
})

function openCreate() {
  form.bookSlug =
    route.query.book || books.value[0]?.slug || ''
  form.quote = ''
  form.page = ''
  form.note = ''
  form.isPrivate = true
  creating.value = true
}

async function load() {
  loading.value = true
  try {
    const payload = await api.highlights.list()
    items.value = payload.items
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    loading.value = false
  }
}

async function submit() {
  if (!form.bookSlug || !form.quote.trim()) {
    notify('选一本书，并写下划线内容', 'error')
    return
  }
  submitting.value = true
  try {
    const created = await api.highlights.create({
      bookSlug: form.bookSlug,
      quote: form.quote.trim(),
      page: form.page === '' ? null : Number(form.page),
      note: form.note.trim(),
      isPrivate: form.isPrivate,
    })
    items.value.unshift(created)
    creating.value = false
    notify('这段文字已经收好')
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    submitting.value = false
  }
}

async function confirmDelete() {
  try {
    await api.highlights.remove(removing.value.id)
    items.value = items.value.filter((item) => item.id !== removing.value.id)
    notify('划线已删除')
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    removing.value = null
  }
}

onMounted(async () => {
  const [bookPayload, dailyPayload] = await Promise.all([
    api.books.list({ pageSize: 100 }).catch(() => ({ items: [] })),
    api.highlights.daily().catch(() => ({ highlight: null })),
  ])
  books.value = bookPayload.items
  daily.value = dailyPayload.highlight
  await load()
})
</script>
<template>
  <div class="container inner-page">
    <div class="page-heading">
      <div>
        <h1>
          划线收藏
          <span class="heading-dot">。</span>
        </h1>
        <p>那些让你停顿的句子，值得被单独记住。</p>
      </div>
      <button class="button" @click="openCreate">
        <AppIcon name="plus" :size="18" />
        添加划线
      </button>
    </div>

    <section v-if="daily" class="highlight-daily">
      <span class="quote-label">今日回顾</span>
      <blockquote>“{{ daily.quote }}”</blockquote>
      <cite>
        —— 《{{ daily.book.title }}》{{ daily.page ? ' 第 ' + daily.page + ' 页' : '' }}
        <template v-if="daily.note"> · {{ daily.note }}</template>
      </cite>
    </section>

    <div class="notes-toolbar">
      <label class="search-box">
        <AppIcon name="search" :size="18" />
        <span class="sr-only">搜索划线</span>
        <input v-model="query" type="search" placeholder="搜索划线、批注或书名…" />
      </label>
      <span class="pill"><strong>{{ filtered.length }}</strong> 条划线</span>
    </div>

    <p v-if="loading" class="loading-note">正在整理你的划线…</p>
    <div v-else-if="filtered.length" class="highlights-list">
      <article v-for="item in filtered" :key="item.id" class="highlight-card">
        <blockquote>“{{ item.quote }}”</blockquote>
        <p v-if="item.note" class="hl-note">{{ item.note }}</p>
        <footer>
          <RouterLink :to="`/book/${item.book.slug}`" class="highlight-book">
            <AppIcon name="book" :size="14" />
            {{ item.book.title }}{{ item.page ? ' · p.' + item.page : '' }}
          </RouterLink>
          <span>{{ formatDate(item.createdAt) }}</span>
          <button class="icon-button subtle" aria-label="删除划线" @click="removing = item">
            <AppIcon name="trash" :size="15" />
          </button>
        </footer>
      </article>
    </div>
    <EmptyState
      v-else
      title="还没有划线"
      description="读到喜欢的句子时，把它留在这里吧。"
      icon="quote"
    >
      <button class="button" @click="openCreate">添加第一条划线</button>
    </EmptyState>

    <BaseModal v-if="creating" title="添加一条划线" @close="creating = false">
      <form id="highlight-form" class="stack" @submit.prevent="submit">
        <label class="field">
          <span>来自哪本书</span>
          <select v-model="form.bookSlug">
            <option v-for="book in books" :key="book.slug" :value="book.slug">《{{ book.title }}》</option>
          </select>
        </label>
        <label class="field">
          <span>划线内容</span>
          <textarea v-model="form.quote" rows="4" maxlength="1000" placeholder="摘录让你停顿的那句…" data-autofocus></textarea>
        </label>
        <div class="form-grid">
          <label class="field">
            <span>页码（可选）</span>
            <input v-model="form.page" type="number" min="1" max="10000" />
          </label>
          <label class="field">
            <span>批注（可选）</span>
            <input v-model="form.note" maxlength="1000" placeholder="此刻想到的…" />
          </label>
        </div>
        <label class="checkbox-line">
          <input v-model="form.isPrivate" type="checkbox" />
          仅自己可见
        </label>
      </form>
      <template #footer>
        <button class="button button-secondary" @click="creating = false">取消</button>
        <button class="button" type="submit" form="highlight-form" :disabled="submitting">
          <AppIcon name="check" :size="16" />
          保存划线
        </button>
      </template>
    </BaseModal>

    <ConfirmDialog
      v-if="removing"
      title="删除这条划线？"
      :message="'删除后无法恢复。'"
      @cancel="removing = null"
      @confirm="confirmDelete"
    />
  </div>
</template>
