<script setup>
import AppIcon from '../ui/AppIcon.vue'
</script>
<template>
  <aside class="reading-invitation">
    <div class="invitation-art" aria-hidden="true">
      <AppIcon name="book" :size="46" />
      <span class="small-leaf"><AppIcon name="leaf" :size="23" /></span>
    </div>
    <div>
      <h2>好书读过，也值得记得。</h2>
      <p>记下一段文字，收好一个念头。让每次阅读，都有回响。</p>
    </div>
    <RouterLink to="/notes" class="text-link">
      翻开阅读手记
      <AppIcon name="arrow" :size="19" />
    </RouterLink>
  </aside>
</template>
