<script setup>
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import { api } from '../../api/client.js'
import { notify } from '../../composables/useToast.js'
import BaseModal from '../ui/BaseModal.vue'
import AppIcon from '../ui/AppIcon.vue'

const props = defineProps({
  books: { type: Array, default: () => [] },
  initialBook: { type: String, default: '' },
})
const emit = defineEmits(['close', 'saved'])

const bookSlug = ref(
  props.books.some((book) => book.slug === props.initialBook)
    ? props.initialBook
    : props.books[0]?.slug || '',
)
const seconds = ref(0)
const running = ref(true)
const minutes = ref(1)
const pages = ref(0)
const note = ref('')
const progress = ref(props.books.find((book) => book.slug === bookSlug.value)?.progress ?? 0)
const saving = ref(false)
let interval

const elapsedLabel = computed(() => {
  const h = Math.floor(seconds.value / 3600)
  const m = Math.floor((seconds.value % 3600) / 60)
  const s = seconds.value % 60
  return [h, m, s].map((value) => String(value).padStart(2, '0')).join(':')
})

const selectedBook = computed(() => props.books.find((book) => book.slug === bookSlug.value))

onMounted(() => {
  interval = setInterval(() => {
    if (!running.value) return
    seconds.value += 1
    if (seconds.value % 60 === 0) minutes.value = Math.max(minutes.value, Math.round(seconds.value / 60))
  }, 1000)
})

onBeforeUnmount(() => clearInterval(interval))

function toggleTimer() {
  running.value = !running.value
}

function onBookChange() {
  progress.value = selectedBook.value?.progress ?? 0
}

async function save() {
  if (!bookSlug.value) {
    notify('先选择一本书', 'error')
    return
  }
  if (!minutes.value || minutes.value < 1) {
    notify('阅读时长至少 1 分钟', 'error')
    return
  }
  saving.value = true
  try {
    await api.sessions.create({
      bookSlug: bookSlug.value,
      minutes: Math.round(minutes.value),
      pages: Number(pages.value) || 0,
      note: note.value.trim(),
      progress: Number(progress.value),
    })
    notify('这段阅读已经收好')
    emit('saved')
    emit('close')
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    saving.value = false
  }
}
</script>
<template>
  <BaseModal title="记录一段阅读" @close="emit('close')">
    <form id="reading-timer-form" class="timer-form" @submit.prevent="save">
      <label>
        正在读哪本书
        <select v-model="bookSlug" @change="onBookChange">
          <option v-for="book in books" :key="book.slug" :value="book.slug">
            《{{ book.title }}》
          </option>
        </select>
      </label>

      <div class="timer-display">
        <span class="timer-clock">{{ elapsedLabel }}</span>
        <button type="button" class="button button-secondary" @click="toggleTimer">
          <AppIcon :name="running ? 'clock' : 'arrow'" :size="16" />
          {{ running ? '暂停计时' : '继续计时' }}
        </button>
      </div>

      <div class="form-row">
        <label>
          阅读分钟
          <input v-model.number="minutes" type="number" min="1" max="1440" required />
        </label>
        <label>
          阅读页数
          <input v-model.number="pages" type="number" min="0" max="5000" />
        </label>
      </div>

      <label v-if="selectedBook">
        更新进度 · {{ progress }}%
        <input v-model.number="progress" type="range" min="0" max="100" step="1" />
      </label>

      <label>
        此刻的一句话（可选）
        <textarea v-model="note" rows="3" maxlength="300" placeholder="今天读到了什么？"></textarea>
      </label>
    </form>
    <template #footer>
      <span class="editor-save-hint">时间会记得你读过的每一页。</span>
      <button class="button button-secondary" @click="emit('close')">取消</button>
      <button class="button" type="submit" form="reading-timer-form" :disabled="saving">
        <AppIcon name="check" :size="17" />
        保存记录
      </button>
    </template>
  </BaseModal>
</template>
