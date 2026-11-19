<script setup>
const emit = defineEmits(['explore'])
</script>
<template>
  <section class="discover-hero">
    <div class="hero-copy">
      <h1>
        在书页之间，
        <br />
        遇见<span class="hero-emphasis">更大的世界。</span>
      </h1>
      <p>
        让脚步慢一点，让思绪走远一点。
        <br />
        在这里，找到下一本想读的书。
      </p>
      <button class="button hero-button" @click="emit('explore')">
        探索精选书单
        <AppIcon name="arrow" :size="18" />
      </button>
    </div>
    <div class="hero-visual">
      <img
        class="hero-photo"
        src="/reading-still-life.jpg"
        alt="午后阳光洒在打开的书页、亚麻封面书与茶杯上"
        width="1536"
        height="1024"
        fetchpriority="high"
      />
      <div class="hero-caption">
        <span>慢读 · 静观</span>
        <span>给自己，一页的时间</span>
      </div>
    </div>
  </section>
</template>
