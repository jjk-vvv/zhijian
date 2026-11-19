<script setup>
defineProps({ book: { type: Object, required: true } })
</script>
<template>
  <div
    class="book-cover"
    :class="'cover-' + book.art"
    :style="{ '--cover-color': book.color, '--cover-ink': book.ink }"
    role="img"
    :aria-label="book.title + '概念封面'"
  >
    <span class="cover-top">
      纸间文库<i class="cover-imprint-dot">·</i><span class="cover-imprint-en">ZHIJIAN</span>
    </span>
    <span class="cover-title">{{ book.title }}</span>
    <span class="cover-english">{{ book.english }}</span>
    <div class="cover-art" aria-hidden="true">
      <span class="art-one"></span>
      <span class="art-two"></span>
      <span class="art-three"></span>
      <span class="art-four"></span>
      <span class="art-five"></span>
    </div>
    <span class="cover-author">{{ book.author }}</span>
    <span class="cover-bottom">纸间 · 经典阅读</span>
  </div>
</template>
