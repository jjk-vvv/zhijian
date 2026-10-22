<script setup>
import BaseModal from './BaseModal.vue'
defineProps({ title: String, message: String, confirmLabel: { type: String, default: '确认删除' } })
const emit = defineEmits(['confirm', 'cancel'])
</script>
<template>
  <BaseModal :title="title" @close="emit('cancel')">
    <p class="confirm-message">{{ message }}</p>
    <template #footer>
      <button class="button button-secondary" @click="emit('cancel')">取消</button>
      <button class="button button-danger" @click="emit('confirm')">
        {{ confirmLabel }}
      </button>
    </template>
  </BaseModal>
</template>
