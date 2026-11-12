<script setup>
import { useLibrary } from '../../composables/useLibrary.js'
import { composeNote, goTab } from '../../utils/nav.js'
import AppIcon from '../ui/AppIcon.vue'

defineProps({ active: { type: String, default: 'discover' } })
const { stats } = useLibrary()
</script>

<template>
  <view class="site-header">
    <view class="header-inner container">
      <view
        class="brand"
        hover-class="none"
        aria-label="纸间首页"
        @click="goTab('/pages/discover/discover')"
      >
        <view class="brand-mark"><AppIcon class="brand-icon" name="book" :size="25" tone="ink" /></view>
        <view class="brand-name">
          <text>纸间</text>
          <text class="brand-sub">BETWEEN PAGES</text>
        </view>
      </view>
      <view class="main-nav">
        <view
          class="nav-link"
          :class="{ 'is-active': active === 'discover' }"
          hover-class="none"
          @click="goTab('/pages/discover/discover')"
        >
          <text>发现好书</text>
        </view>
        <view
          class="nav-link"
          :class="{ 'is-active': active === 'shelf' }"
          hover-class="none"
          @click="goTab('/pages/shelf/shelf')"
        >
          <text>我的书架</text>
          <view class="nav-count">{{ stats.total }}</view>
        </view>
        <view
          class="nav-link"
          :class="{ 'is-active': active === 'notes' }"
          hover-class="none"
          @click="goTab('/pages/notes/notes')"
        >
          <text>阅读手记</text>
        </view>
      </view>
      <view class="header-write" hover-class="none" @click="composeNote()">
        <AppIcon name="pen" :size="16" tone="ink" />
        <text>写一篇手记</text>
      </view>
    </view>
  </view>
</template>
