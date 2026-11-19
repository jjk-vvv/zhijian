<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import BaseModal from '../ui/BaseModal.vue'
import AppIcon from '../ui/AppIcon.vue'
import NotePreview from './NotePreview.vue'
import { TYPE_LABELS } from '../../utils/format.js'

const props = defineProps({
  note: Object,
  initialBook: String,
  books: { type: Array, default: () => [] },
})
const emit = defineEmits(['close', 'save'])

const draft = reactive({
  id: props.note?.id,
  bookSlug:
    props.note?.book?.slug ||
    (props.books.some((book) => book.slug === props.initialBook)
      ? props.initialBook
      : props.books[0]?.slug || ''),
  title: props.note?.title || '',
  content: props.note?.content || '',
  type: props.note?.type || 'thought',
  page: props.note?.page || '',
  isPrivate: props.note?.isPrivate ?? true,
})
const titleInput = ref(null)
const submitted = ref(false)
const errors = computed(() => ({
  title: draft.title.trim() ? '' : '给这篇手记起一个标题吧。',
  content: draft.content.trim() ? '' : '写一点你想留下的文字。',
  book: draft.bookSlug ? '' : '先选一本书。',
}))
const wordCount = computed(() => draft.content.length)

onMounted(() => titleInput.value?.focus())

function submit() {
  submitted.value = true
  if (errors.value.title || errors.value.content || errors.value.book) {
    ;(errors.value.title ? titleInput.value : document.getElementById('note-content'))?.focus()
    return
  }
  emit('save', {
    ...draft,
    page: draft.page === '' ? null : Number(draft.page),
  })
}
</script>
<template>
  <BaseModal :title="note ? '编辑阅读手记' : '写一篇阅读手记'" wide @close="emit('close')">
    <form id="note-form" class="note-editor" novalidate @submit.prevent="submit">
      <div class="note-form-fields">
        <div class="form-row">
          <label for="note-book">
            关于哪本书
            <select id="note-book" v-model="draft.bookSlug">
              <option v-for="book in books" :key="book.slug" :value="book.slug">
                《{{ book.title }}》
              </option>
            </select>
          </label>
          <label for="note-type">
            手记类型
            <select id="note-type" v-model="draft.type">
              <option v-for="(label, key) in TYPE_LABELS" :key="key" :value="key">{{ label }}</option>
            </select>
          </label>
        </div>
        <label for="note-title">
          手记标题
          <span class="required-mark">*</span>
          <input
            id="note-title"
            ref="titleInput"
            v-model="draft.title"
            maxlength="60"
            placeholder="一个念头，也值得被记录"
            required
            :aria-invalid="submitted && !!errors.title"
            data-autofocus
          />
          <span v-if="submitted && errors.title" class="form-error">{{ errors.title }}</span>
        </label>
        <label for="note-content">
          正文
          <span class="required-mark">*</span>
          <textarea
            id="note-content"
            v-model="draft.content"
            rows="9"
            maxlength="3000"
            placeholder="记录触动你的文字，或此刻真实的感受……"
            required
            :aria-invalid="submitted && !!errors.content"
          ></textarea>
          <span v-if="submitted && errors.content" class="form-error">{{ errors.content }}</span>
        </label>
        <div class="form-row">
          <label for="note-page">
            页码（可选）
            <input id="note-page" v-model="draft.page" type="number" min="1" max="10000" placeholder="如 42" />
          </label>
          <label class="checkbox-line" style="align-self: flex-end; padding-bottom: 10px">
            <input v-model="draft.isPrivate" type="checkbox" />
            仅自己可见
          </label>
        </div>
        <span class="word-count">{{ wordCount }} / 3000 字</span>
      </div>
      <NotePreview :draft="draft" :books="books" />
    </form>
    <template #footer>
      <span class="editor-save-hint">留给以后，再读一遍。</span>
      <button class="button button-secondary" @click="emit('close')">取消</button>
      <button class="button" type="submit" form="note-form">
        <AppIcon name="check" :size="17" />
        保存手记
      </button>
    </template>
  </BaseModal>
</template>
