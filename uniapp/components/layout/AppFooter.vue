<script setup>
import AppIcon from '../ui/AppIcon.vue'

const year = new Date().getFullYear()
</script>

<template>
  <view class="site-footer container">
    <view class="footer-brand">
      <AppIcon name="book" :size="20" tone="ink" />
      <text class="footer-name">纸间</text>
      <text class="footer-tagline">让阅读，回到生活。</text>
    </view>
    <view class="footer-right">
      <text class="footer-slogan">一本好书，一段属于自己的时间。</text>
      <text class="footer-copy">© {{ year }} 纸间</text>
    </view>
  </view>
</template>
