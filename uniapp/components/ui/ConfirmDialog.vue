<script setup>
import BaseModal from './BaseModal.vue'

defineProps({ title: String, message: String, confirmLabel: { type: String, default: '确认删除' } })
const emit = defineEmits(['confirm', 'cancel'])
</script>

<template>
  <BaseModal :title="title" @close="emit('cancel')">
    <view class="confirm-message">{{ message }}</view>
    <template #footer>
      <button class="button button-secondary modal-btn" @click="emit('cancel')">取消</button>
      <button class="button button-danger modal-btn" @click="emit('confirm')">
        {{ confirmLabel }}
      </button>
    </template>
  </BaseModal>
</template>
