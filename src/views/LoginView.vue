<script setup>
import { reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { login } from '../composables/useAuth.js'
import { notify } from '../composables/useToast.js'
import AppIcon from '../components/ui/AppIcon.vue'

const route = useRoute()
const router = useRouter()
const form = reactive({ email: '', password: '' })
const submitting = ref(false)

async function submit() {
  if (!form.email.trim() || !form.password) {
    notify('请填写邮箱和密码', 'error')
    return
  }
  submitting.value = true
  try {
    const user = await login({ email: form.email, password: form.password })
    notify(`欢迎回来，${user.displayName}`)
    router.replace(route.query.redirect || '/')
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    submitting.value = false
  }
}

function useDemo() {
  form.email = 'demo@zhijian.app'
  form.password = 'demo1234'
}
</script>
<template>
  <div class="container auth-page">
    <section class="auth-card">
      <h1>回到纸间</h1>
      <p>书架、手记和读过的每一页，都在等你。</p>
      <form class="auth-form" @submit.prevent="submit">
        <label class="field">
          <span>邮箱</span>
          <input
            v-model="form.email"
            type="email"
            autocomplete="email"
            placeholder="you@example.com"
            required
            data-autofocus
          />
        </label>
        <label class="field">
          <span>密码</span>
          <input
            v-model="form.password"
            type="password"
            autocomplete="current-password"
            placeholder="至少 8 位"
            required
          />
        </label>
        <button class="button" type="submit" :disabled="submitting">
          <AppIcon name="arrow" :size="17" />
          {{ submitting ? '正在登录…' : '登录' }}
        </button>
      </form>
      <div class="demo-accounts">
        想先看看效果？可以用演示账号直接进入。
        <button type="button" @click="useDemo">填写演示账号 demo@zhijian.app / demo1234</button>
      </div>
      <p class="auth-switch">
        还没有账号？
        <RouterLink to="/register">加入纸间</RouterLink>
      </p>
    </section>
  </div>
</template>
