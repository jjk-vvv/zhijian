<script setup>
import AppIcon from './AppIcon.vue'
defineProps({ title: String, description: String, icon: { type: String, default: 'book' } })
</script>
<template>
  <div class="empty-state">
    <span class="empty-icon"><AppIcon :name="icon" :size="30" /></span>
    <h3>{{ title }}</h3>
    <p>{{ description }}</p>
    <slot />
  </div>
</template>
