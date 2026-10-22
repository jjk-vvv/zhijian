<script setup>
defineProps({ title: String, description: String })
</script>
<template>
  <div class="section-heading">
    <div>
      <h2>{{ title }}</h2>
      <p v-if="description">{{ description }}</p>
    </div>
    <div class="section-actions"><slot /></div>
  </div>
</template>
