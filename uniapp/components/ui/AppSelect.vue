<script setup>
import { computed, ref } from 'vue'
import AppIcon from './AppIcon.vue'

// 自绘下拉选择：替代 uni-app 的 <picker>。
// uni-app H5 的 picker 弹层带三角形、蓝色选中项，位置由内联样式写死，无法与设计统一，
// 贴到视口右侧时还会被裁切；这里用普通 view 实现，三端表现一致，也不依赖系统弹层。
const props = defineProps({
  modelValue: { type: [String, Number], default: '' },
  options: { type: Array, default: () => [] }, // [{ value, label }]
  variant: { type: String, default: 'field' }, // field：表单里的整宽选择框；inline：工具条里的文字选择
  placeholder: { type: String, default: '请选择' },
  ariaLabel: { type: String, default: '' },
})
const emit = defineEmits(['update:modelValue'])

const open = ref(false)
const current = computed(() => props.options.find((option) => option.value === props.modelValue))
const text = computed(() => (current.value ? current.value.label : props.placeholder))

function toggle() {
  open.value = !open.value
}
function close() {
  open.value = false
}
function pick(option) {
  emit('update:modelValue', option.value)
  open.value = false
}
</script>

<template>
  <view class="select" :class="'select-' + variant">
    <view
      class="select-trigger"
      :class="variant === 'inline' ? 'sort-label' : 'field field-select'"
      :aria-label="ariaLabel || text"
      :aria-expanded="open"
      @click="toggle"
    >
      <text :class="variant === 'inline' ? 'sort-value' : 'field-select-value'">{{ text }}</text>
      <AppIcon
        :class="variant === 'inline' ? 'sort-icon' : 'select-chevron'"
        name="down"
        :size="variant === 'inline' ? 14 : 12"
        tone="olive"
      />
    </view>

    <view v-if="open" class="select-backdrop" @click="close" @touchmove.stop.prevent></view>
    <view
      v-if="open"
      class="select-panel"
      :class="'select-panel-' + variant"
      @touchmove.stop
    >
      <view
        v-for="option in options"
        :key="option.value"
        class="select-option"
        :class="{ 'is-selected': option.value === modelValue }"
        @click.stop="pick(option)"
      >
        <text class="select-option-label">{{ option.label }}</text>
        <AppIcon
          v-if="option.value === modelValue"
          class="select-check"
          name="check"
          :size="14"
          tone="green"
        />
      </view>
    </view>
  </view>
</template>
