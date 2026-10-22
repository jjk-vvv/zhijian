<script setup>
defineProps({ bookId: String, modelValue: Number })
const emit = defineEmits(['update:modelValue'])
</script>
<template>
  <div class="reading-progress">
    <div>
      <label :for="'progress-' + bookId">阅读进度</label>
      <output :for="'progress-' + bookId">{{ modelValue }}%</output>
    </div>
    <input
      :id="'progress-' + bookId"
      type="range"
      min="0"
      max="100"
      step="1"
      :value="modelValue"
      :style="{ '--progress': modelValue + '%' }"
      @input="emit('update:modelValue', Number($event.target.value))"
    />
    <span class="progress-hint">
      {{
        modelValue === 100
          ? '又读完一本，值得纪念。'
          : modelValue === 0
            ? '从第一页开始新的旅程。'
            : '不必着急，每一页都算数。'
      }}
    </span>
  </div>
</template>
