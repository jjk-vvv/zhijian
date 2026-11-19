<script setup>
import AppIcon from './AppIcon.vue'
defineProps({ message: String, tone: { type: String, default: 'success' } })
</script>
<template>
  <div class="toast-region" role="status" aria-live="polite">
    <Transition name="toast">
      <div v-if="message" class="toast" :class="`toast-${tone}`">
        <AppIcon :name="tone === 'error' ? 'close' : 'check'" :size="18" />
        {{ message }}
      </div>
    </Transition>
  </div>
</template>
