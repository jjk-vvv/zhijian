<script setup>
defineProps({
  name: { type: String, default: 'book' },
  size: { type: [Number, String], default: 20 },
})
const paths = {
  book: 'M12 5c-3-2-6-2-10-1v15c4-1 7-1 10 1 3-2 6-2 10-1V4c-4-1-7-1-10 1Zm0 0v15',
  arrow: 'M4 12h15m-6-6 6 6-6 6',
  'arrow-left': 'M20 12H5m6-6-6 6 6 6',
  search: 'm21 21-5-5M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0',
  bookmark: 'M6 3h12v19l-6-4-6 4V3Z',
  check: 'm5 12 4 4L19 6',
  plus: 'M12 5v14M5 12h14',
  close: 'm6 6 12 12M6 18 18 6',
  chevron: 'm8 5 7 7-7 7',
  down: 'm6 9 6 6 6-6',
  pen: 'm16 3 5 5-12 12-6 1 1-6L16 3Zm-12 12 5 5M13 6l5 5',
  leaf: 'M20 3C8 1 1 8 5 17c9 4 16-3 15-14ZM4 21 16 9',
  trash: 'M3 6h18M9 6V3h6v3M5 6l1 15h12l1-15M10 10v7m4-7v7',
  grid: 'M3 3h7v7H3V3Zm11 0h7v7h-7V3ZM3 14h7v7H3v-7Zm11 0h7v7h-7v-7Z',
  clock: 'M12 8v5l3 2M22 12a10 10 0 1 1-20 0 10 10 0 0 1 20 0',
  heart:
    'M12 20s-7-4.4-7-9a4 4 0 0 1 7-2.6A4 4 0 0 1 19 11c0 4.6-7 9-7 9Z',
  comment: 'M21 11.5a8.4 8.4 0 0 1-8.5 8.4H5l-2 2V11.5A8.5 8.5 0 1 1 21 11.5Z',
  bell: 'M18 9a6 6 0 1 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9M10 21h4',
  users:
    'M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8Zm13 10v-2a4 4 0 0 0-3-3.9M16 3.1a4 4 0 0 1 0 7.8',
  chart: 'M4 20V10m6 10V4m6 16v-7m4 7H2',
  target:
    'M12 22a10 10 0 1 0 0-20 10 10 0 0 0 0 20Zm0-4a6 6 0 1 0 0-12 6 6 0 0 0 0 12Zm0-4a2 2 0 1 0 0-4 2 2 0 0 0 0 4Z',
  list: 'M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01',
  calendar:
    'M7 3v3m10-3v3M3 9h18M5 5h14a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2Z',
  spark:
    'M12 3l1.8 5.2L19 10l-5.2 1.8L12 17l-1.8-5.2L5 10l5.2-1.8L12 3ZM19 16l.8 2.2L22 19l-2.2.8L19 22l-.8-2.2L16 19l2.2-.8L19 16Z',
  logout: 'M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9',
  settings:
    'M12 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6Zm7.4-3a7.4 7.4 0 0 0-.1-1.2l2-1.5-2-3.4-2.4 1a7.6 7.6 0 0 0-2-1.2L14.5 3h-5l-.4 2.7a7.6 7.6 0 0 0-2 1.2l-2.4-1-2 3.4 2 1.5a7.4 7.4 0 0 0 0 2.4l-2 1.5 2 3.4 2.4-1a7.6 7.6 0 0 0 2 1.2l.4 2.7h5l.4-2.7a7.6 7.6 0 0 0 2-1.2l2.4 1 2-3.4-2-1.5c.1-.4.1-.8.1-1.2Z',
  star: 'm12 3 2.6 5.3 5.9.9-4.3 4.1 1 5.8L12 16.4 6.8 19.1l1-5.8L3.5 9.2l5.9-.9L12 3Z',
  quote:
    'M9 11H4a1 1 0 0 1-1-1V6a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v8a4 4 0 0 1-4 4m16-7h-5a1 1 0 0 1-1-1V6a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v8a4 4 0 0 1-4 4',
  user: 'M20 21a8 8 0 0 0-16 0M12 13a4 4 0 1 0 0-8 4 4 0 0 0 0 8Z',
  lock: 'M6 10V7a6 6 0 0 1 12 0v3M5 10h14v10H5V10Zm7 4v3',
  mail: 'M3 5h18v14H3V5Zm0 0 9 7 9-7',
  send: 'm22 2-7 20-4-9-9-4 20-7Z',
  download: 'M12 3v12m-5-5 5 5 5-5M4 21h16',
  upload: 'M12 21V9m-5 5 5-5 5 5M4 3h16',
  flame: 'M12 2s5 5 5 10a5 5 0 0 1-10 0c0-2 1-3 1-3s0 3 2 3c1.5 0 2-1.5 2-3 0-3 0-7 0-7Z',
  filter: 'M4 5h16l-6 7v6l-4 2v-8L4 5Z',
  more: 'M5 12h.01M12 12h.01M19 12h.01',
}
</script>
<template>
  <svg
    :width="size"
    :height="size"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    stroke-width="1.5"
    stroke-linecap="round"
    stroke-linejoin="round"
    aria-hidden="true"
  >
    <path :d="paths[name] || paths.book" />
  </svg>
</template>
