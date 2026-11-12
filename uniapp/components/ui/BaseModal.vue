<script setup>
import { onBeforeUnmount, onMounted, ref } from 'vue'
import AppIcon from './AppIcon.vue'

defineProps({ title: { type: String, required: true }, wide: Boolean })
const emit = defineEmits(['close'])
const dialog = ref(null)

let previousFocus = null
let previousOverflow = ''

function close() {
  emit('close')
}

// #ifdef H5
function onKey(event) {
  if (event.key === 'Escape') {
    event.preventDefault()
    close()
    return
  }
  if (event.key !== 'Tab') return
  const nodes = Array.prototype.slice
    .call(dialog.value.querySelectorAll('button, input, textarea, [tabindex="0"]'))
    .filter((node) => !node.disabled && node.getClientRects().length)
  if (!nodes.length) return
  const first = nodes[0]
  const last = nodes[nodes.length - 1]
  if (event.shiftKey && document.activeElement === first) {
    event.preventDefault()
    last.focus()
  } else if (!event.shiftKey && document.activeElement === last) {
    event.preventDefault()
    first.focus()
  }
}
// #endif

onMounted(() => {
  // App / 小程序的逻辑层没有 DOM；浏览器焦点与 body 滚动锁仅在 H5 生效。
  // #ifdef H5
  previousFocus = document.activeElement
  previousOverflow = document.body.style.overflow
  document.body.style.overflow = 'hidden'
  document.addEventListener('keydown', onKey)
  // #endif
})

onBeforeUnmount(() => {
  // #ifdef H5
  document.removeEventListener('keydown', onKey)
  document.body.style.overflow = previousOverflow
  if (previousFocus && previousFocus.isConnected) previousFocus.focus()
  // #endif
})
</script>

<template>
  <view class="modal-backdrop" @click="close" @touchmove.stop.prevent>
    <view
      ref="dialog"
      class="modal-panel"
      :class="{ 'modal-wide': wide }"
      @click.stop
      @touchmove.stop
    >
      <view class="modal-header">
        <view class="modal-title">{{ title }}</view>
        <button class="icon-button close-button" aria-label="关闭弹窗" @click="close">
          <AppIcon name="close" :size="20" tone="ink" />
        </button>
      </view>
      <slot />
      <view v-if="$slots.footer" class="modal-footer"><slot name="footer" /></view>
    </view>
  </view>
</template>
