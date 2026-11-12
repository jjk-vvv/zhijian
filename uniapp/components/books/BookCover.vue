<script setup>
defineProps({
  book: { type: Object, required: true },
  // default：书卡里的展示封面；detail：详情弹窗里的封面
  variant: { type: String, default: 'default' },
})
</script>

<template>
  <view class="book-cover" :class="['cover-' + book.art, 'is-' + variant]">
    <text class="cover-top">THE BETWEEN PAGES COLLECTION</text>
    <text class="cover-title">{{ book.title }}</text>
    <text class="cover-english">{{ book.english }}</text>
    <view class="cover-art">
      <view class="art art-one"></view>
      <view class="art art-two"></view>
      <view class="art art-three"></view>
      <view class="art art-four"></view>
      <view class="art art-five"></view>
    </view>
    <text class="cover-author">{{ book.author }}</text>
    <text class="cover-bottom">纸 间 · 经 典 阅 读</text>
  </view>
</template>
