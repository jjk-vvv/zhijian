<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { api } from '../api/client.js'
import { useAuth } from '../composables/useAuth.js'
import { notify } from '../composables/useToast.js'
import { useLibrary } from '../composables/useLibrary.js'
import { STORAGE_KEY } from '../utils/storage.js'
import AppIcon from '../components/ui/AppIcon.vue'
import Avatar from '../components/ui/Avatar.vue'
import ConfirmDialog from '../components/ui/ConfirmDialog.vue'

const router = useRouter()
const { currentUser, updateProfile, refreshUser, logout } = useAuth()
const { refreshAll } = useLibrary()

const tab = ref('profile')
const savingProfile = ref(false)
const savingPassword = ref(false)
const importing = ref(false)
const exporting = ref(false)
const deleting = ref(false)
const exportPreview = ref('')
const legacyCount = ref(null)
const confirmingDelete = ref(false)
const passwordForm = reactive({ currentPassword: '', nextPassword: '', confirm: '' })
const deleteForm = reactive({ password: '' })

const profileForm = reactive({
  displayName: '',
  handle: '',
  bio: '',
  location: '',
  website: '',
  isPrivate: false,
})
const colors = ['#3f5c4a', '#6b7a56', '#8a6f4d', '#7a5b3f', '#5c6b7a', '#6d5f7a', '#8a5a4a']

const initials = computed(() =>
  (profileForm.displayName || currentUser.value?.displayName || '读').slice(0, 1),
)

onMounted(async () => {
  await refreshUser()
  const user = currentUser.value
  if (user) {
    Object.assign(profileForm, {
      displayName: user.displayName,
      handle: user.handle,
      bio: user.bio || '',
      location: user.location || '',
      website: user.website || '',
      isPrivate: user.isPrivate,
    })
  }
  let raw = null
  try {
    raw = localStorage.getItem(STORAGE_KEY)
  } catch {
    raw = null
  }
  if (raw) {
    try {
      const parsed = JSON.parse(raw)
      const shelf = Array.isArray(parsed.shelf) ? parsed.shelf.length : 0
      const notes = Array.isArray(parsed.notes) ? parsed.notes.filter((note) => !note.example).length : 0
      legacyCount.value = { shelf, notes }
    } catch {
      legacyCount.value = null
    }
  }
})

async function saveProfile() {
  if (!profileForm.displayName.trim()) {
    notify('昵称不能为空', 'error')
    return
  }
  savingProfile.value = true
  try {
    await updateProfile({
      displayName: profileForm.displayName.trim(),
      handle: profileForm.handle.trim() || undefined,
      bio: profileForm.bio.trim(),
      location: profileForm.location.trim(),
      website: profileForm.website.trim(),
      isPrivate: profileForm.isPrivate,
      avatarColor: currentUser.value?.avatarColor,
    })
    notify('资料已保存')
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    savingProfile.value = false
  }
}

function pickColor(color) {
  profileForm.avatarColor = color
  api.me.update({ avatarColor: color }).then((payload) => {
    if (currentUser.value) currentUser.value.avatarColor = payload.user.avatarColor
  })
}

async function changePassword() {
  if (passwordForm.nextPassword.length < 8) {
    notify('新密码至少 8 位', 'error')
    return
  }
  if (passwordForm.nextPassword !== passwordForm.confirm) {
    notify('两次输入的新密码不一致', 'error')
    return
  }
  savingPassword.value = true
  try {
    await api.auth.changePassword({
      currentPassword: passwordForm.currentPassword,
      nextPassword: passwordForm.nextPassword,
    })
    Object.assign(passwordForm, { currentPassword: '', nextPassword: '', confirm: '' })
    notify('密码已更新')
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    savingPassword.value = false
  }
}

async function exportData() {
  exporting.value = true
  try {
    const data = await api.me.export()
    const json = JSON.stringify(data, null, 2)
    exportPreview.value = json.slice(0, 1200)
    const blob = new Blob([json], { type: 'application/json' })
    const url = URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `zhijian-${data.profile.handle}-${new Date().toISOString().slice(0, 10)}.json`
    link.click()
    URL.revokeObjectURL(url)
    notify('数据已导出')
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    exporting.value = false
  }
}

async function importLegacy() {
  let parsed
  try {
    parsed = JSON.parse(localStorage.getItem(STORAGE_KEY))
  } catch {
    notify('没有读到旧版本的本地记录', 'error')
    return
  }
  importing.value = true
  try {
    const result = await api.me.import({
      shelf: parsed.shelf || [],
      notes: (parsed.notes || []).filter((note) => !note.example),
    })
    notify(`已导入 ${result.shelf} 本藏书、${result.notes} 篇手记`)
    await refreshAll()
    legacyCount.value = null
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    importing.value = false
  }
}

async function deleteAccount() {
  if (!deleteForm.password) {
    notify('请输入密码确认', 'error')
    return
  }
  deleting.value = true
  try {
    await api.me.remove({ password: deleteForm.password })
    logout()
    notify('账号已删除')
    router.replace('/')
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    deleting.value = false
    confirmingDelete.value = false
  }
}

function signOut() {
  logout()
  notify('已退出登录')
  router.replace('/')
}
</script>
<template>
  <div class="container inner-page">
    <div class="page-heading">
      <div>
        <h1>
          账号设置
          <span class="heading-dot">。</span>
        </h1>
        <p>管理你的资料、密码与阅读数据。</p>
      </div>
      <RouterLink v-if="currentUser" :to="`/profile/${currentUser.handle}`" class="button button-secondary">
        <AppIcon name="user" :size="16" />
        查看主页
      </RouterLink>
    </div>

    <div class="settings-grid">
      <nav class="settings-nav">
        <button :class="{ active: tab === 'profile' }" @click="tab = 'profile'">个人资料</button>
        <button :class="{ active: tab === 'security' }" @click="tab = 'security'">账号安全</button>
        <button :class="{ active: tab === 'data' }" @click="tab = 'data'">数据管理</button>
        <button :class="{ active: tab === 'account' }" @click="tab = 'account'">危险操作</button>
      </nav>

      <section v-if="tab === 'profile'" class="settings-panel">
        <div class="row-between">
          <div style="display: flex; align-items: center; gap: 14px">
            <Avatar :user="{ displayName: initials, avatarColor: profileForm.avatarColor || currentUser?.avatarColor }" :size="56" />
            <div>
              <strong style="display: block">{{ currentUser?.displayName }}</strong>
              <span class="muted small">@{{ currentUser?.handle }}</span>
            </div>
          </div>
          <div class="chip-row">
            <button
              v-for="color in colors"
              :key="color"
              class="color-dot"
              :style="{ background: color }"
              :aria-label="'选择头像颜色'"
              @click="pickColor(color)"
            ></button>
          </div>
        </div>
        <form class="form-grid" @submit.prevent="saveProfile">
          <label class="field">
            <span>昵称</span>
            <input v-model="profileForm.displayName" maxlength="24" />
          </label>
          <label class="field">
            <span>用户名</span>
            <input v-model="profileForm.handle" maxlength="24" />
          </label>
          <label class="field span-2">
            <span>自我介绍</span>
            <textarea v-model="profileForm.bio" rows="3" maxlength="300" placeholder="喜欢读什么？最近在读什么？"></textarea>
          </label>
          <label class="field">
            <span>所在地</span>
            <input v-model="profileForm.location" maxlength="40" />
          </label>
          <label class="field">
            <span>个人网站</span>
            <input v-model="profileForm.website" maxlength="120" placeholder="https://" />
          </label>
          <label class="checkbox-line span-2">
            <input v-model="profileForm.isPrivate" type="checkbox" />
            私密账号：只有关注者能看到我的书架与动态
          </label>
          <div class="span-2 row-between">
            <span class="muted small">邮箱：{{ currentUser?.email }}</span>
            <button class="button" type="submit" :disabled="savingProfile">
              <AppIcon name="check" :size="16" />
              {{ savingProfile ? '保存中…' : '保存资料' }}
            </button>
          </div>
        </form>
      </section>

      <section v-else-if="tab === 'security'" class="settings-panel">
        <h2>修改密码</h2>
        <form class="form-grid" @submit.prevent="changePassword">
          <label class="field span-2">
            <span>当前密码</span>
            <input v-model="passwordForm.currentPassword" type="password" autocomplete="current-password" />
          </label>
          <label class="field">
            <span>新密码</span>
            <input v-model="passwordForm.nextPassword" type="password" autocomplete="new-password" />
          </label>
          <label class="field">
            <span>确认新密码</span>
            <input v-model="passwordForm.confirm" type="password" autocomplete="new-password" />
          </label>
          <div class="span-2 row-between">
            <span class="muted small">建议使用 8 位以上、包含字母与数字的密码。</span>
            <button class="button" type="submit" :disabled="savingPassword">
              <AppIcon name="lock" :size="16" />
              {{ savingPassword ? '更新中…' : '更新密码' }}
            </button>
          </div>
        </form>
        <hr class="divider" />
        <div class="row-between">
          <div>
            <strong style="display: block">退出登录</strong>
            <span class="muted small">在这台设备上结束当前会话。</span>
          </div>
          <button class="button button-secondary" @click="signOut">
            <AppIcon name="logout" :size="16" />
            退出
          </button>
        </div>
      </section>

      <section v-else-if="tab === 'data'" class="settings-panel">
        <h2>导出我的数据</h2>
        <p>包括书架、手记、划线、书评、阅读会话、目标与书单，导出为 JSON 文件。</p>
        <div class="row-between">
          <button class="button button-secondary" :disabled="exporting" @click="exportData">
            <AppIcon name="download" :size="16" />
            {{ exporting ? '导出中…' : '导出 JSON' }}
          </button>
          <span v-if="exportPreview" class="muted small">已生成预览</span>
        </div>
        <pre v-if="exportPreview" class="export-preview">{{ exportPreview }}…</pre>

        <hr class="divider" />
        <h2>导入旧版本记录</h2>
        <p>
          如果你在旧版纸间（纯本地版本）记录过书架和手记，可以把它们带到账号里。
          <template v-if="legacyCount">
            检测到本地有 {{ legacyCount.shelf }} 本藏书、{{ legacyCount.notes }} 篇手记。
          </template>
          <template v-else>当前浏览器中未检测到旧版本记录。</template>
        </p>
        <button class="button" :disabled="!legacyCount || importing" @click="importLegacy">
          <AppIcon name="upload" :size="16" />
          {{ importing ? '导入中…' : '导入本地记录' }}
        </button>
      </section>

      <section v-else class="settings-panel">
        <h2>危险操作</h2>
        <div class="danger-zone">
          <h3>删除账号</h3>
          <p class="muted small">
            删除后，你的书架、手记、划线、书评和书单都会被永久移除，且无法恢复。建议先导出数据。
          </p>
          <label class="field" style="max-width: 320px">
            <span>输入密码确认</span>
            <input v-model="deleteForm.password" type="password" autocomplete="current-password" />
          </label>
          <div>
            <button class="button button-danger" :disabled="deleting" @click="confirmingDelete = true">
              <AppIcon name="trash" :size="16" />
              永久删除账号
            </button>
          </div>
        </div>
      </section>
    </div>

    <ConfirmDialog
      v-if="confirmingDelete"
      title="确定永久删除账号？"
      message="此操作不可撤销，所有阅读记录将一并删除。"
      confirm-label="确认删除"
      @cancel="confirmingDelete = false"
      @confirm="deleteAccount"
    />
  </div>
</template>
