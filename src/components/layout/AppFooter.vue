<script setup>
import AppIcon from '../ui/AppIcon.vue'
</script>
<template>
  <footer class="site-footer container">
    <div class="footer-brand">
      <AppIcon name="book" :size="20" />
      <strong>纸间</strong>
      <span>让阅读，回到生活。</span>
    </div>
    <div class="footer-right">
      <span>一本好书，一段属于自己的时间。</span>
      <span>© {{ new Date().getFullYear() }} 纸间</span>
    </div>
  </footer>
</template>
