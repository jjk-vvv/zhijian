<script setup>
import { onMounted, reactive, ref, watch } from 'vue'
import { api } from '../api/client.js'
import { useAuth } from '../composables/useAuth.js'
import { notify } from '../composables/useToast.js'
import { formatRelative } from '../utils/format.js'
import AppIcon from '../components/ui/AppIcon.vue'
import Avatar from '../components/ui/Avatar.vue'
import BaseModal from '../components/ui/BaseModal.vue'
import EmptyState from '../components/ui/EmptyState.vue'

const { isAuthed, currentUser } = useAuth()
const scope = ref('public')
const lists = ref([])
const loading = ref(true)
const creating = ref(false)
const submitting = ref(false)
const form = reactive({ title: '', description: '', isPublic: true })

async function load() {
  loading.value = true
  try {
    const payload = await api.lists.list(scope.value === 'mine' ? { mine: 1 } : { limit: 40 })
    lists.value = payload.items
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    loading.value = false
  }
}

watch(scope, load)

function openCreate() {
  if (!isAuthed.value) {
    notify('登录后可以创建书单', 'error')
    return
  }
  form.title = ''
  form.description = ''
  form.isPublic = true
  creating.value = true
}

async function submit() {
  if (!form.title.trim()) {
    notify('给书单起个名字吧', 'error')
    return
  }
  submitting.value = true
  try {
    const created = await api.lists.create({
      title: form.title.trim(),
      description: form.description.trim(),
      isPublic: form.isPublic,
    })
    creating.value = false
    notify('书单已创建，去添加几本书吧')
    if (scope.value === 'public') scope.value = 'mine'
    else await load()
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
          主题书单
          <span class="heading-dot">。</span>
        </h1>
        <p>把书按心情、主题或季节放在一起，也是一种阅读。</p>
      </div>
      <button class="button" @click="openCreate">
        <AppIcon name="plus" :size="18" />
        创建书单
      </button>
    </div>

    <div class="feed-tabs">
      <button :class="{ active: scope === 'public' }" @click="scope = 'public'">公开书单</button>
      <button :class="{ active: scope === 'mine' }" @click="scope = 'mine'">我的书单</button>
    </div>

    <p v-if="loading" class="loading-note">正在整理书单…</p>
    <div v-else-if="lists.length" class="lists-grid">
      <RouterLink v-for="list in lists" :key="list.id" :to="`/lists/${list.id}`" class="list-card">
        <div class="row-between">
          <h2>{{ list.title }}</h2>
          <span v-if="!list.isPublic" class="pill">
            <AppIcon name="lock" :size="12" />
            私密
          </span>
        </div>
        <p>{{ list.description || '这份书单还没有写下说明。' }}</p>
        <div v-if="list.preview.length" class="list-preview">
          <span
            v-for="book in list.preview"
            :key="book.slug"
            :style="{ background: book.color, color: book.ink }"
            :title="book.title"
          >
            {{ book.title.slice(0, 1) }}
          </span>
        </div>
        <div class="list-meta">
          <Avatar :user="list.user" :size="22" />
          <span>{{ list.user.displayName }}</span>
          <span>·</span>
          <span>{{ list.bookCount }} 本书</span>
          <span style="margin-left: auto">{{ formatRelative(list.updatedAt) }}</span>
        </div>
      </RouterLink>
    </div>
    <EmptyState
      v-else
      :title="scope === 'mine' ? '还没有自己的书单' : '暂时还没有公开书单'"
      description="挑几本同主题的书，给它起一个名字。"
      icon="list"
    >
      <button class="button" @click="openCreate">创建第一份书单</button>
    </EmptyState>

    <BaseModal v-if="creating" title="创建一份书单" @close="creating = false">
      <form id="list-form" class="stack" @submit.prevent="submit">
        <label class="field">
          <span>书单标题</span>
          <input v-model="form.title" maxlength="60" placeholder="如：适合秋天读的七本书" data-autofocus />
        </label>
        <label class="field">
          <span>书单说明（可选）</span>
          <textarea v-model="form.description" rows="4" maxlength="500" placeholder="为什么把它们放在一起？"></textarea>
        </label>
        <label class="checkbox-line">
          <input v-model="form.isPublic" type="checkbox" />
          公开书单（其他人可以看到）
        </label>
      </form>
      <template #footer>
        <button class="button button-secondary" @click="creating = false">取消</button>
        <button class="button" type="submit" form="list-form" :disabled="submitting">
          <AppIcon name="check" :size="16" />
          创建书单
        </button>
      </template>
    </BaseModal>
  </div>
</template>
