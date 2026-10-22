<script setup>
import { computed, reactive, ref, onMounted } from 'vue'
import { books } from '../../data/books.js'
import BaseModal from '../ui/BaseModal.vue'
import AppIcon from '../ui/AppIcon.vue'
import NotePreview from './NotePreview.vue'
const props = defineProps({ note: Object, initialBook: String })
const emit = defineEmits(['close', 'save'])
const draft = reactive({
  id: props.note?.id,
  bookId:
    props.note?.bookId ||
    (books.some((book) => book.id === props.initialBook) ? props.initialBook : books[0].id),
  title: props.note?.title || '',
  content: props.note?.content || '',
  type: props.note?.type || '感想',
})
const titleInput = ref(null),
  submitted = ref(false)
const errors = computed(() => ({
  title: draft.title.trim() ? '' : '给这篇手记起一个标题吧。',
  content: draft.content.trim() ? '' : '写一点你想留下的文字。',
}))
const wordCount = computed(() => draft.content.length)
// 生命周期与模板引用：编辑器打开后，将焦点放到标题输入框。
onMounted(() => titleInput.value?.focus())
function submit() {
  submitted.value = true
  if (errors.value.title || errors.value.content) {
    ;(errors.value.title ? titleInput.value : document.getElementById('note-content'))?.focus()
    return
  }
  emit('save', { ...draft })
}
</script>
<template>
  <BaseModal :title="note ? '编辑阅读手记' : '写一篇阅读手记'" wide @close="emit('close')">
    <form id="note-form" class="note-editor" novalidate @submit.prevent="submit">
      <div class="note-form-fields">
        <div class="form-row">
          <label for="note-book">
            关于哪本书
            <select id="note-book" v-model="draft.bookId">
              <option v-for="book in books" :key="book.id" :value="book.id">
                {{ book.title }}
              </option>
            </select>
          </label>
          <label for="note-type">
            手记类型
            <select id="note-type" v-model="draft.type">
              <option>感想</option>
              <option>摘录</option>
              <option>书评</option>
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
            :aria-describedby="submitted && errors.title ? 'title-error' : undefined"
            data-autofocus
          />
          <span v-if="submitted && errors.title" id="title-error" class="form-error">
            {{ errors.title }}
          </span>
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
            :aria-describedby="submitted && errors.content ? 'content-error' : 'word-count'"
          ></textarea>
          <span v-if="submitted && errors.content" id="content-error" class="form-error">
            {{ errors.content }}
          </span>
        </label>
        <span id="word-count" class="word-count">{{ wordCount }} / 3000 字</span>
      </div>
      <NotePreview :draft="draft" />
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
