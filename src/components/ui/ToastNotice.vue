<script setup>
import AppIcon from './AppIcon.vue'
defineProps({ message: String })
</script>
<template>
  <div class="toast-region" role="status" aria-live="polite">
    <Transition name="toast">
      <div v-if="message" class="toast">
        <AppIcon name="check" :size="18" />
        {{ message }}
      </div>
    </Transition>
  </div>
</template>
