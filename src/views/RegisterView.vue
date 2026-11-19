<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { register } from '../composables/useAuth.js'
import { notify } from '../composables/useToast.js'
import AppIcon from '../components/ui/AppIcon.vue'

const router = useRouter()
const form = reactive({ email: '', password: '', displayName: '', handle: '' })
const submitting = ref(false)

async function submit() {
  if (!form.email.trim() || form.password.length < 8 || !form.displayName.trim()) {
    notify('请填写昵称、邮箱，并设置至少 8 位密码', 'error')
    return
  }
  submitting.value = true
  try {
    const user = await register({
      email: form.email,
      password: form.password,
      displayName: form.displayName,
      handle: form.handle.trim() || undefined,
    })
    notify(`欢迎你，${user.displayName}`)
    router.replace('/')
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    submitting.value = false
  }
}
</script>
<template>
  <div class="container auth-page">
    <section class="auth-card">
      <h1>加入纸间</h1>
      <p>一个账号，收好你的书架、手记、划线，以及每一段阅读时光。</p>
      <form class="auth-form" @submit.prevent="submit">
        <label class="field">
          <span>昵称</span>
          <input v-model="form.displayName" maxlength="24" placeholder="如何称呼你" required data-autofocus />
        </label>
        <label class="field">
          <span>邮箱</span>
          <input v-model="form.email" type="email" autocomplete="email" placeholder="you@example.com" required />
        </label>
        <label class="field">
          <span>用户名（可选）</span>
          <input v-model="form.handle" placeholder="小写字母、数字或下划线，3–24 位" />
        </label>
        <label class="field">
          <span>密码</span>
          <input
            v-model="form.password"
            type="password"
            autocomplete="new-password"
            placeholder="至少 8 位"
            required
          />
        </label>
        <button class="button" type="submit" :disabled="submitting">
          <AppIcon name="leaf" :size="17" />
          {{ submitting ? '正在创建…' : '创建账号' }}
        </button>
      </form>
      <p class="auth-switch">
        已经有账号？
        <RouterLink to="/login">直接登录</RouterLink>
      </p>
    </section>
  </div>
</template>
