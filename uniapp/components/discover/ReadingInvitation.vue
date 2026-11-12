<script setup>
import AppIcon from '../ui/AppIcon.vue'
import { goTab } from '../../utils/nav.js'
</script>

<template>
  <view class="reading-invitation">
    <view class="invitation-art">
      <AppIcon class="invitation-icon" name="book" :size="46" tone="sage" />
      <view class="small-leaf">
        <AppIcon class="small-leaf-icon" name="leaf" :size="23" tone="sage" />
      </view>
    </view>
    <view>
      <view class="invitation-title">好书读过，也值得记得。</view>
      <view class="invitation-desc">记下一段文字，收好一个念头。让每次阅读，都有回响。</view>
    </view>
    <view
      class="text-link invitation-link"
      hover-class="none"
      @click="goTab('/pages/notes/notes')"
    >
      <text>翻开阅读手记</text>
      <AppIcon name="arrow" :size="19" tone="green" />
    </view>
  </view>
</template>
