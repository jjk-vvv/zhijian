<script setup>
import EmptyState from '../components/ui/EmptyState.vue'
</script>
<template>
  <div class="container inner-page">
    <EmptyState
      title="这一页，暂时还没有写下"
      description="你访问的页面不存在，回到首页继续发现好书吧。"
    >
      <RouterLink to="/" class="button">返回首页</RouterLink>
    </EmptyState>
  </div>
</template>
