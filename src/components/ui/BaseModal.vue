<script setup>
import { ref, onMounted, onBeforeUnmount, nextTick } from 'vue'
import AppIcon from './AppIcon.vue'
defineProps({ title: { type: String, required: true }, wide: Boolean })
const emit = defineEmits(['close'])
const dialog = ref(null)
let previousFocus
let previousOverflow
function onKey(event) {
  if (event.key === 'Escape') {
    event.preventDefault()
    emit('close')
  }
  if (event.key !== 'Tab') return
  const nodes = [
    ...dialog.value.querySelectorAll('button, a[href], input, select, textarea, [tabindex="0"]'),
  ].filter((node) => !node.disabled && node.getClientRects().length)
  const first = nodes[0],
    last = nodes.at(-1)
  if (event.shiftKey && document.activeElement === first) {
    event.preventDefault()
    last?.focus()
  } else if (!event.shiftKey && document.activeElement === last) {
    event.preventDefault()
    first?.focus()
  }
}
onMounted(async () => {
  previousFocus = document.activeElement
  previousOverflow = document.body.style.overflow
  document.body.style.overflow = 'hidden'
  await nextTick()
  const autofocus = dialog.value.querySelector('[data-autofocus]')
  ;(autofocus || dialog.value.querySelector('button'))?.focus()
  document.addEventListener('keydown', onKey)
})
onBeforeUnmount(() => {
  document.removeEventListener('keydown', onKey)
  document.body.style.overflow = previousOverflow
  if (previousFocus?.isConnected) previousFocus.focus()
})
</script>
<template>
  <Teleport to="body">
    <div class="modal-backdrop" @click.self="emit('close')">
      <section
        ref="dialog"
        class="modal-panel"
        :class="{ 'modal-wide': wide }"
        role="dialog"
        aria-modal="true"
        :aria-label="title"
      >
        <header class="modal-header">
          <h2>{{ title }}</h2>
          <button class="icon-button" aria-label="关闭弹窗" @click="emit('close')">
            <AppIcon name="close" />
          </button>
        </header>
        <slot />
        <footer v-if="$slots.footer" class="modal-footer"><slot name="footer" /></footer>
      </section>
    </div>
  </Teleport>
</template>
