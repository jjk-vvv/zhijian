import { readonly, ref } from 'vue'

const message = ref('')
const tone = ref('success')
let timer

export function notify(text, type = 'success') {
  clearTimeout(timer)
  message.value = text
  tone.value = type
  timer = setTimeout(() => {
    message.value = ''
  }, 3600)
}

export function useToast() {
  return { toast: readonly(message), tone: readonly(tone), notify }
}
