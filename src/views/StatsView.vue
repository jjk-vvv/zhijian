<script setup>
import { computed, onMounted, ref } from 'vue'
import { api } from '../api/client.js'
import { notify } from '../composables/useToast.js'
import { formatMinutes, formatDate, monthLabel } from '../utils/format.js'
import AppIcon from '../components/ui/AppIcon.vue'
import Heatmap from '../components/stats/Heatmap.vue'
import GoalRing from '../components/stats/GoalRing.vue'
import Avatar from '../components/ui/Avatar.vue'

const year = ref(new Date().getFullYear())
const years = computed(() => {
  const current = new Date().getFullYear()
  return [current, current - 1, current - 2]
})
const loading = ref(true)
const overview = ref(null)
const heatmap = ref({ days: [] })
const annual = ref(null)
const goals = ref(null)
const friends = ref([])

const metrics = computed(() => {
  if (!overview.value) return []
  const { books, reading, content } = overview.value
  return [
    { label: '书架藏书', value: books.total, unit: '本', icon: 'book' },
    { label: '已读完', value: books.finished, unit: '本', icon: 'check' },
    {
      label: '累计阅读',
      value: reading.minutes < 60 ? reading.minutes : Number((reading.minutes / 60).toFixed(1)),
      unit: reading.minutes < 60 ? '分钟' : '小时',
      icon: 'clock',
    },
    { label: '连续阅读', value: reading.currentStreak, unit: '天', icon: 'flame' },
    { label: '手记', value: content.notes, unit: '篇', icon: 'pen' },
    { label: '划线', value: content.highlights, unit: '条', icon: 'quote' },
  ]
})

const monthBars = computed(() => {
  const rows = annual.value?.months || []
  const max = Math.max(1, ...rows.map((row) => row.minutes))
  return Array.from({ length: 12 }, (_, index) => {
    const month = index + 1
    const row = rows.find((item) => item.month === month)
    return {
      month,
      minutes: row?.minutes || 0,
      height: row ? Math.max(2, (row.minutes / max) * 100) : 0,
    }
  })
})

const maxCategory = computed(() =>
  Math.max(1, ...(annual.value?.categories || []).map((item) => item.count)),
)

const maxFriendMinutes = computed(() => Math.max(1, ...friends.value.map((item) => item.minutes)))

async function load() {
  loading.value = true
  try {
    const [overviewPayload, heatmapPayload, annualPayload, goalPayload, friendsPayload] =
      await Promise.all([
        api.stats.overview(),
        api.stats.heatmap(year.value),
        api.stats.annual(year.value),
        api.goals.get(year.value),
        api.stats.friendsWeekly(),
      ])
    overview.value = overviewPayload
    heatmap.value = heatmapPayload
    annual.value = annualPayload
    goals.value = goalPayload
    friends.value = friendsPayload.items
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    loading.value = false
  }
}

function selectYear(value) {
  year.value = value
  load()
}

onMounted(load)
</script>
<template>
  <div class="container inner-page">
    <div class="page-heading">
      <div>
        <h1>
          阅读统计
          <span class="heading-dot">。</span>
        </h1>
        <p>数字不会替你阅读，但它会替你记住坚持。</p>
      </div>
      <RouterLink to="/goals" class="button button-secondary">
        <AppIcon name="target" :size="17" />
        年度目标
      </RouterLink>
    </div>

    <p v-if="loading" class="loading-note">正在计算你的阅读轨迹…</p>
    <template v-else-if="overview">
      <div class="stats-hero">
        <div v-for="metric in metrics" :key="metric.label" class="metric-card">
          <span class="metric-label">
            <AppIcon :name="metric.icon" :size="15" />
            {{ metric.label }}
          </span>
          <strong>
            {{ metric.value }}
            <small v-if="metric.unit">{{ metric.unit }}</small>
          </strong>
        </div>
      </div>

      <section class="stat-panel">
        <div class="stat-panel-head">
          <h2>{{ year }} 年度目标</h2>
          <div class="year-switch">
            <button
              v-for="item in years"
              :key="item"
              :class="{ active: item === year }"
              @click="selectYear(item)"
            >
              {{ item }}
            </button>
          </div>
        </div>
        <div class="goal-progress-block">
          <GoalRing
            :value="goals?.progress?.books_finished || 0"
            :target="goals?.goal?.targetBooks || 0"
            label="年度读书"
            unit="本"
          />
          <GoalRing
            :value="goals?.progress?.minutes || 0"
            :target="goals?.goal?.targetMinutes || 0"
            label="阅读时长"
            unit="分钟"
            color="#7a5b3f"
          />
          <div class="stack" style="gap: 6px; font-size: 13px; color: var(--muted)">
            <span>今年已读书：<strong>{{ goals?.progress?.books_finished || 0 }}</strong> 本</span>
            <span>累计时长：<strong>{{ formatMinutes(goals?.progress?.minutes || 0) }}</strong></span>
            <span>阅读天数：<strong>{{ goals?.progress?.active_days || 0 }}</strong> 天</span>
            <RouterLink to="/goals" class="text-link" style="margin-top: 6px">
              调整目标
              <AppIcon name="arrow" :size="15" />
            </RouterLink>
          </div>
        </div>
      </section>

      <section class="stat-panel">
        <div class="stat-panel-head">
          <h2>{{ year }} 阅读热力图</h2>
          <span class="muted small">共 {{ heatmap.days.length }} 天有阅读记录</span>
        </div>
        <Heatmap :days="heatmap.days" :year="year" />
      </section>

      <div class="stats-columns">
        <section class="stat-panel">
          <div class="stat-panel-head"><h2>月度阅读时长</h2></div>
          <div class="month-chart">
            <div v-for="bar in monthBars" :key="bar.month" class="bar-column">
              <span class="bar-value">{{ bar.minutes || '' }}</span>
              <div class="bar" :style="{ height: bar.height + '%' }"></div>
              <span>{{ monthLabel(bar.month) }}</span>
            </div>
          </div>
        </section>

        <section class="stat-panel">
          <div class="stat-panel-head">
            <h2>本周书友阅读</h2>
            <span class="muted small">和同好一起读</span>
          </div>
          <ul class="leaderboard">
            <li v-for="(item, index) in friends" :key="item.user.id">
              <span class="rank">{{ index + 1 }}</span>
              <RouterLink :to="`/profile/${item.user.handle}`">
                <Avatar :user="item.user" :size="30" />
              </RouterLink>
              <span>
                <RouterLink :to="`/profile/${item.user.handle}`">{{ item.user.displayName }}</RouterLink>
              </span>
              <span class="leader-meta">
                <strong>{{ item.minutes }} 分钟</strong>
                {{ item.sessions }} 次 · 读完 {{ item.booksCount }} 本
              </span>
            </li>
          </ul>
          <p v-if="!friends.length" class="muted small">还没有关注任何书友，去动态页认识几位吧。</p>
        </section>
      </div>

      <div class="stats-columns">
        <section class="stat-panel">
          <div class="stat-panel-head"><h2>阅读分类</h2></div>
          <div class="category-bars">
            <div v-for="item in annual?.categories || []" :key="item.name" class="cat-row">
              <span>{{ item.name }}</span>
              <span class="track"><i :style="{ width: (item.count / maxCategory) * 100 + '%' }"></i></span>
              <span>{{ item.count }}</span>
            </div>
            <p v-if="!annual?.categories?.length" class="muted small">今年的分类数据还不丰富。</p>
          </div>
        </section>

        <section class="stat-panel">
          <div class="stat-panel-head">
            <h2>{{ year }} 读过的书 · {{ annual?.booksFinished || 0 }} 本</h2>
            <span class="muted small">
              书评 {{ annual?.reviews || 0 }} · 手记 {{ annual?.notes || 0 }} · 最长连续 {{ annual?.longestStreak || 0 }} 天
            </span>
          </div>
          <ul v-if="annual?.books?.length" class="annual-list">
            <li v-for="item in annual.books" :key="item.slug">
              <span class="mini-cover" :style="{ background: item.color, color: item.ink }">
                {{ item.title.slice(0, 1) }}
              </span>
              <span>
                <RouterLink :to="`/book/${item.slug}`">{{ item.title }}</RouterLink>
                <small>{{ item.finishedAt ? formatDate(item.finishedAt) : item.author }}</small>
              </span>
            </li>
          </ul>
          <p v-else class="muted small">今年还没有读完的书，慢慢来。</p>
        </section>
      </div>

      <p class="data-footnote">
        统计只属于你：{{ formatMinutes(overview.reading.minutes) }}，{{ overview.reading.sessions }} 次阅读，
        最长连续 {{ overview.reading.longestStreak }} 天。
      </p>
    </template>
  </div>
</template>
