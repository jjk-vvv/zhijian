<script setup>
defineProps({ title: String, description: String })
</script>

<template>
  <view class="section-heading">
    <view>
      <view class="section-title">{{ title }}</view>
      <view v-if="description" class="section-desc">{{ description }}</view>
    </view>
    <view class="section-actions"><slot /></view>
  </view>
</template>
