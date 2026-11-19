<script setup>
import { onMounted, reactive, ref } from 'vue'
import { api } from '../api/client.js'
import { useAuth } from '../composables/useAuth.js'
import { notify } from '../composables/useToast.js'
import AppIcon from '../components/ui/AppIcon.vue'
import Avatar from '../components/ui/Avatar.vue'
import BaseModal from '../components/ui/BaseModal.vue'
import EmptyState from '../components/ui/EmptyState.vue'

const { isAuthed } = useAuth()
const clubs = ref([])
const books = ref([])
const loading = ref(true)
const creating = ref(false)
const submitting = ref(false)
const form = reactive({ name: '', description: '', bookSlug: '', isPrivate: false })

async function load() {
  loading.value = true
  try {
    const payload = await api.clubs.list()
    clubs.value = payload.items
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    loading.value = false
  }
}

async function openCreate() {
  if (!isAuthed.value) {
    notify('登录后可以发起书友会', 'error')
    return
  }
  const payload = await api.books.list({ pageSize: 100 }).catch(() => ({ items: [] }))
  books.value = payload.items
  Object.assign(form, { name: '', description: '', bookSlug: '', isPrivate: false })
  creating.value = true
}

async function submit() {
  if (!form.name.trim()) {
    notify('给书友会起一个名字吧', 'error')
    return
  }
  submitting.value = true
  try {
    const created = await api.clubs.create({
      name: form.name.trim(),
      description: form.description.trim(),
      bookSlug: form.bookSlug || undefined,
      isPrivate: form.isPrivate,
    })
    creating.value = false
    notify('书友会已创建')
    await load()
    return created
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    submitting.value = false
  }
}

onMounted(load)
</script>
<template>
  <div class="container inner-page">
    <div class="page-heading">
      <div>
        <h1>
          书友会
          <span class="heading-dot">。</span>
        </h1>
        <p>读完一本书，总想找人聊聊。这里有一群同样在读书的人。</p>
      </div>
      <button class="button" @click="openCreate">
        <AppIcon name="plus" :size="18" />
        发起书友会
      </button>
    </div>

    <p v-if="loading" class="loading-note">正在召集书友…</p>
    <div v-else-if="clubs.length" class="clubs-grid">
      <article v-for="club in clubs" :key="club.id" class="club-card">
        <div class="row-between" style="align-items: flex-start">
          <RouterLink :to="`/clubs/${club.slug}`">
            <h2>{{ club.name }}</h2>
          </RouterLink>
          <span v-if="club.joined" class="pill">
            <AppIcon name="check" :size="12" />
            已加入
          </span>
        </div>
        <p>{{ club.description || '这个书友会还没有写下介绍。' }}</p>
        <RouterLink v-if="club.book" :to="`/book/${club.book.slug}`" class="club-book">
          <AppIcon name="book" :size="13" />
          共读《{{ club.book.title }}》
        </RouterLink>
        <div class="club-meta">
          <Avatar :user="club.owner" :size="22" />
          <span>{{ club.owner.displayName }} 发起</span>
          <span style="margin-left: auto">
            <AppIcon name="users" :size="13" />
            {{ club.memberCount }} 人
          </span>
        </div>
        <RouterLink :to="`/clubs/${club.slug}`" class="button button-secondary button-small">
          {{ club.joined ? '进入讨论' : '了解并加入' }}
        </RouterLink>
      </article>
    </div>
    <EmptyState v-else title="还没有书友会" description="发起一个共读小组，从一本书开始聊起。" icon="users">
      <button class="button" @click="openCreate">发起书友会</button>
    </EmptyState>

    <BaseModal v-if="creating" title="发起一个书友会" @close="creating = false">
      <form id="club-form" class="stack" @submit.prevent="submit">
        <label class="field">
          <span>书友会名称</span>
          <input v-model="form.name" maxlength="40" placeholder="如：每周三夜读会" data-autofocus />
        </label>
        <label class="field">
          <span>介绍</span>
          <textarea v-model="form.description" rows="4" maxlength="500" placeholder="你们打算怎么读？聊些什么？"></textarea>
        </label>
        <label class="field">
          <span>共读书目（可选）</span>
          <select v-model="form.bookSlug">
            <option value="">暂不指定</option>
            <option v-for="book in books" :key="book.slug" :value="book.slug">《{{ book.title }}》</option>
          </select>
        </label>
        <label class="checkbox-line">
          <input v-model="form.isPrivate" type="checkbox" />
          私密书友会（仅通过邀请加入）
        </label>
      </form>
      <template #footer>
        <button class="button button-secondary" @click="creating = false">取消</button>
        <button class="button" type="submit" form="club-form" :disabled="submitting">
          <AppIcon name="users" :size="16" />
          创建
        </button>
      </template>
    </BaseModal>
  </div>
</template>
