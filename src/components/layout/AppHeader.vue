<script setup>
import { useLibrary } from '../../composables/useLibrary.js'
import AppIcon from '../ui/AppIcon.vue'
const { stats } = useLibrary()
</script>
<template>
  <header class="site-header">
    <div class="header-inner container">
      <RouterLink to="/" class="brand" aria-label="纸间首页">
        <span class="brand-mark"><AppIcon name="book" :size="25" /></span>
        <span class="brand-name">
          纸间
          <span>BETWEEN PAGES</span>
        </span>
      </RouterLink>
      <nav class="main-nav" aria-label="主导航">
        <RouterLink to="/" exact-active-class="is-active">发现好书</RouterLink>
        <RouterLink to="/shelf" active-class="is-active">
          我的书架
          <span class="nav-count">{{ stats.total }}</span>
        </RouterLink>
        <RouterLink to="/notes" active-class="is-active">阅读手记</RouterLink>
      </nav>
      <RouterLink to="/notes?compose=1" class="header-write">
        <AppIcon name="pen" :size="16" />
        <span>写一篇手记</span>
      </RouterLink>
    </div>
  </header>
</template>
