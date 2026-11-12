<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { books } from '../../data/books.js'
import BaseModal from '../ui/BaseModal.vue'
import AppIcon from '../ui/AppIcon.vue'
import AppSelect from '../ui/AppSelect.vue'
import NotePreview from './NotePreview.vue'

const props = defineProps({ note: Object, initialBook: String })
const emit = defineEmits(['close', 'save'])

const types = ['感想', '摘录', '书评']

const draft = reactive({
  id: props.note?.id,
  bookId:
    props.note?.bookId ||
    (books.some((book) => book.id === props.initialBook) ? props.initialBook : books[0].id),
  title: props.note?.title || '',
  content: props.note?.content || '',
  type: props.note?.type || '感想',
})

const submitted = ref(false)
const titleFocus = ref(false)

const bookOptions = computed(() => books.map((book) => ({ value: book.id, label: book.title })))
const typeOptions = computed(() => types.map((type) => ({ value: type, label: type })))

const errors = computed(() => ({
  title: draft.title.trim() ? '' : '给这篇手记起一个标题吧。',
  content: draft.content.trim() ? '' : '写一点你想留下的文字。',
}))
const wordCount = computed(() => draft.content.length)

// 与 Web 版一致：编辑器打开后把焦点放到标题输入框。
onMounted(() => {
  titleFocus.value = true
})

function submit() {
  submitted.value = true
  if (errors.value.title || errors.value.content) return
  emit('save', { ...draft })
}
</script>

<template>
  <BaseModal :title="note ? '编辑阅读手记' : '写一篇阅读手记'" wide @close="emit('close')">
    <view class="note-editor">
      <view class="note-form-fields">
        <view class="form-row">
          <view class="field-label">
            <text>关于哪本书</text>
            <AppSelect
              :model-value="draft.bookId"
              :options="bookOptions"
              aria-label="关于哪本书"
              @update:model-value="draft.bookId = $event"
            />
          </view>
          <view class="field-label">
            <text>手记类型</text>
            <AppSelect
              :model-value="draft.type"
              :options="typeOptions"
              aria-label="手记类型"
              @update:model-value="draft.type = $event"
            />
          </view>
        </view>
        <view class="field-label">
          <text>手记标题</text>
          <text class="required-mark">*</text>
          <input
            v-model="draft.title"
            class="field field-input"
            :class="{ 'is-invalid': submitted && !!errors.title }"
            :focus="titleFocus"
            :maxlength="60"
            placeholder="一个念头，也值得被记录"
            placeholder-class="field-placeholder"
            @blur="titleFocus = false"
          />
          <text v-if="submitted && errors.title" class="form-error">{{ errors.title }}</text>
        </view>
        <view class="field-label">
          <text>正文</text>
          <text class="required-mark">*</text>
          <textarea
            v-model="draft.content"
            class="field field-textarea"
            :class="{ 'is-invalid': submitted && !!errors.content }"
            :maxlength="3000"
            placeholder="记录触动你的文字，或此刻真实的感受……"
            placeholder-class="field-placeholder"
          />
          <text v-if="submitted && errors.content" class="form-error">{{ errors.content }}</text>
        </view>
        <text class="word-count">{{ wordCount }} / 3000 字</text>
      </view>
      <NotePreview :draft="draft" />
    </view>
    <template #footer>
      <text class="editor-save-hint">留给以后，再读一遍。</text>
      <button class="button button-secondary modal-btn" @click="emit('close')">取消</button>
      <button class="button modal-btn" @click="submit">
        <AppIcon name="check" :size="17" tone="white" />
        <text>保存手记</text>
      </button>
    </template>
  </BaseModal>
</template>
