<script setup>
import AppIcon from '../ui/AppIcon.vue'

const emit = defineEmits(['explore'])
</script>

<template>
  <view class="discover-hero">
    <view class="hero-copy">
      <view class="hero-eyebrow">
        <view class="eyebrow-dot"></view>
        <text>一个留给阅读的地方</text>
      </view>
      <view class="hero-title">
        <view class="hero-line">在书页之间，</view>
        <view class="hero-line"><text>遇见</text><view class="hero-emphasis">更大的世界。</view></view>
      </view>
      <view class="hero-desc-group">
        <view class="hero-desc">让脚步慢一点，让思绪走远一点。</view>
        <view class="hero-desc">在这里，找到下一本想读的书。</view>
      </view>
      <button class="button hero-button" hover-class="button-hover" @click="emit('explore')">
        <text>探索精选书单</text>
        <AppIcon name="arrow" :size="18" tone="white" />
      </button>
    </view>
    <view class="hero-visual">
      <image
        class="hero-photo"
        src="/static/reading-still-life.jpg"
        mode="aspectFill"
        aria-label="午后阳光洒在打开的书页、亚麻封面书与茶杯上"
      />
      <view class="hero-caption">
        <text class="hero-caption-en">THE JOY OF SLOW READING</text>
        <text class="hero-caption-zh">给自己，一页的时间</text>
      </view>
      <view class="round-stamp">
        <AppIcon name="leaf" :size="25" tone="olive" />
        <view class="round-stamp-text">
          <text class="stamp-line">READ SLOW</text>
          <text class="stamp-line">LIVE FULLY</text>
        </view>
      </view>
    </view>
  </view>
</template>
