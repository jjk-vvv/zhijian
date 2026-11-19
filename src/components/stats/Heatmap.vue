<script setup>
import { computed } from 'vue'

const props = defineProps({
  days: { type: Array, default: () => [] },
  year: { type: Number, required: true },
})
const emit = defineEmits(['select'])

const MONTHS = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']

const dayMap = computed(() => {
  const map = new Map()
  props.days.forEach((day) => map.set(day.date, day))
  return map
})

const weeks = computed(() => {
  const start = new Date(props.year, 0, 1)
  const end = new Date(props.year, 11, 31)
  const offset = (start.getDay() + 6) % 7 // 周一为一周起点
  const cursor = new Date(start)
  cursor.setDate(cursor.getDate() - offset)
  const result = []
  while (cursor <= end) {
    const week = []
    for (let i = 0; i < 7; i += 1) {
      const date = new Date(cursor)
      const key = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
      const inYear = date.getFullYear() === props.year
      week.push({
        key,
        inYear,
        day: date.getDate(),
        month: date.getMonth() + 1,
        data: dayMap.value.get(key),
      })
      cursor.setDate(cursor.getDate() + 1)
    }
    result.push(week)
  }
  return result
})

const monthMarkers = computed(() => {
  const markers = []
  weeks.value.forEach((week, index) => {
    const first = week.find((cell) => cell.inYear && cell.day <= 7)
    if (first && !markers.some((marker) => marker.month === first.month)) {
      markers.push({ month: first.month, index })
    }
  })
  return markers
})

const level = (cell) => {
  if (!cell.inYear) return 0
  const minutes = cell.data?.minutes || 0
  if (!minutes) return 0
  if (minutes < 15) return 1
  if (minutes < 30) return 2
  if (minutes < 60) return 3
  return 4
}
</script>
<template>
  <div class="heatmap-wrap">
    <div class="heatmap-months">
      <span
        v-for="marker in monthMarkers"
        :key="marker.month"
        :style="{ gridColumnStart: marker.index + 2 }"
      >
        {{ MONTHS[marker.month - 1] }}
      </span>
    </div>
    <div class="heatmap">
      <div class="heatmap-weekdays">
        <span>一</span><span>三</span><span>五</span><span>日</span>
      </div>
      <div class="heatmap-grid">
        <div v-for="(week, index) in weeks" :key="index" class="heatmap-week">
          <button
            v-for="cell in week"
            :key="cell.key"
            type="button"
            class="heatmap-cell"
            :class="`level-${level(cell)}`"
            :disabled="!cell.inYear || !cell.data"
            :title="
              cell.inYear
                ? `${cell.key} · ${cell.data ? cell.data.minutes + ' 分钟 / ' + cell.data.pages + ' 页' : '没有记录'}`
                : ''
            "
            @click="cell.data && emit('select', cell.data)"
          ></button>
        </div>
      </div>
    </div>
    <div class="heatmap-legend">
      <span>少</span>
      <i class="level-0"></i><i class="level-1"></i><i class="level-2"></i><i class="level-3"></i><i class="level-4"></i>
      <span>多</span>
    </div>
  </div>
</template>
