<script setup>
import { useAuth } from '../../composables/useAuth.js'
import { useLibrary } from '../../composables/useLibrary.js'
import AppIcon from '../ui/AppIcon.vue'
import Avatar from '../ui/Avatar.vue'
import NotificationBell from './NotificationBell.vue'

const { currentUser, isAuthed, logout } = useAuth()
const { stats } = useLibrary()

const navItems = [
  { to: '/', label: '发现好书', exact: true },
  { to: '/shelf', label: '我的书架', count: true },
  { to: '/notes', label: '阅读手记' },
  { to: '/highlights', label: '划线收藏' },
  { to: '/stats', label: '阅读统计' },
  { to: '/feed', label: '书友动态' },
  { to: '/clubs', label: '书友会' },
  { to: '/lists', label: '主题书单' },
]
</script>
<template>
  <header class="site-header">
    <div class="header-inner container">
      <RouterLink to="/" class="brand" aria-label="纸间首页">
        <span class="brand-mark"><AppIcon name="book" :size="25" /></span>
        <span class="brand-name">
          纸间
          <span>阅读与手记</span>
        </span>
      </RouterLink>

      <nav class="main-nav" aria-label="主导航">
        <RouterLink
          v-for="item in navItems"
          :key="item.to"
          :to="item.to"
          :exact-active-class="item.exact ? 'is-active' : ''"
          :active-class="item.exact ? '' : 'is-active'"
        >
          {{ item.label }}
          <span v-if="item.count && isAuthed" class="nav-count">{{ stats.total }}</span>
        </RouterLink>
      </nav>

      <div class="header-actions">
        <NotificationBell v-if="isAuthed" />
        <RouterLink v-if="isAuthed" to="/notes?compose=1" class="header-write">
          <AppIcon name="pen" :size="16" />
          <span>写手记</span>
        </RouterLink>
        <template v-if="isAuthed">
          <RouterLink :to="`/profile/${currentUser.handle}`" class="header-user">
            <Avatar :user="currentUser" :size="34" />
            <span>{{ currentUser.displayName }}</span>
          </RouterLink>
          <RouterLink to="/settings" class="icon-button" aria-label="账号设置">
            <AppIcon name="settings" :size="18" />
          </RouterLink>
          <button class="icon-button" aria-label="退出登录" @click="logout">
            <AppIcon name="logout" :size="18" />
          </button>
        </template>
        <template v-else>
          <RouterLink to="/login" class="button button-secondary header-login">登录</RouterLink>
          <RouterLink to="/register" class="button header-register">加入纸间</RouterLink>
        </template>
      </div>
    </div>

    <nav class="mobile-nav" aria-label="移动端主导航">
      <RouterLink
        v-for="item in navItems"
        :key="item.to"
        :to="item.to"
        :exact-active-class="item.exact ? 'is-active' : ''"
        :active-class="item.exact ? '' : 'is-active'"
      >
        {{ item.label }}
      </RouterLink>
    </nav>
  </header>
</template>
