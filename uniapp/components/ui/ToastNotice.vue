<script setup>
import AppIcon from './AppIcon.vue'

defineProps({ message: String })
</script>

<template>
  <view class="toast-region">
    <view v-if="message" class="toast">
      <AppIcon name="check" :size="18" tone="white" />
      <text class="toast-text">{{ message }}</text>
    </view>
  </view>
</template>
