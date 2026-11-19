<script setup>
import { computed, onMounted, ref } from 'vue'
import { api } from '../api/client.js'
import { notify } from '../composables/useToast.js'
import { formatMinutes } from '../utils/format.js'
import AppIcon from '../components/ui/AppIcon.vue'
import GoalRing from '../components/stats/GoalRing.vue'

const year = new Date().getFullYear()
const loading = ref(true)
const saving = ref(false)
const goal = ref(null)
const progress = ref({ books_finished: 0, minutes: 0, active_days: 0 })
const form = ref({ targetBooks: 24, targetMinutes: 7200 })

const suggestions = computed(() => {
  const finished = progress.value.books_finished
  if (!finished) return '从一个小目标开始，比如每月读完两本。'
  if (finished >= form.value.targetBooks) return '已经完成，甚至超越了目标。要不要提高一点？'
  return `还差 ${Math.max(0, form.value.targetBooks - finished)} 本，按现在的节奏完全来得及。`
})

async function load() {
  loading.value = true
  try {
    const payload = await api.goals.get(year)
    goal.value = payload.goal
    progress.value = payload.progress
    if (payload.goal) {
      form.value.targetBooks = payload.goal.targetBooks
      form.value.targetMinutes = payload.goal.targetMinutes
    }
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    loading.value = false
  }
}

async function save() {
  if (form.value.targetBooks < 1 || form.value.targetMinutes < 60) {
    notify('目标需要是个正整数：书至少 1 本，时长至少 60 分钟', 'error')
    return
  }
  saving.value = true
  try {
    await api.goals.set({
      year,
      targetBooks: Number(form.value.targetBooks),
      targetMinutes: Number(form.value.targetMinutes),
    })
    notify('年度目标已更新')
    await load()
  } catch (error) {
    notify(error.message, 'error')
  } finally {
    saving.value = false
  }
}

onMounted(load)
</script>
<template>
  <div class="container inner-page page-narrow">
    <div class="page-heading">
      <div>
        <h1>
          年度目标
          <span class="heading-dot">。</span>
        </h1>
        <p>目标不是压力，是给这一年留一个方向。</p>
      </div>
      <RouterLink to="/stats" class="text-link">
        查看完整统计
        <AppIcon name="arrow" :size="16" />
      </RouterLink>
    </div>

    <p v-if="loading" class="loading-note">正在读取目标…</p>
    <template v-else>
      <section class="card" style="margin-bottom: 22px">
        <div class="row-between" style="margin-bottom: 18px">
          <h2 style="font-size: 19px">{{ year }} 年 · 我的阅读目标</h2>
          <span class="pill">
            已完成 <strong>{{ progress.books_finished }}</strong> 本 / 阅读
            <strong>{{ formatMinutes(progress.minutes) }}</strong>
          </span>
        </div>
        <div class="goal-progress-block">
          <GoalRing
            :value="progress.books_finished"
            :target="goal?.targetBooks || 0"
            label="读书数量"
            unit="本"
            :size="164"
          />
          <GoalRing
            :value="progress.minutes"
            :target="goal?.targetMinutes || 0"
            label="阅读时长"
            unit="分钟"
            :size="164"
            color="#7a5b3f"
          />
          <p class="muted" style="max-width: 260px; line-height: 1.8; font-size: 13.5px">
            {{ suggestions }}
          </p>
        </div>
      </section>

      <section class="card">
        <h2 style="font-size: 19px; margin-bottom: 18px">调整目标</h2>
        <form class="goal-form" @submit.prevent="save">
          <label class="field">
            <span>今年想读完多少本书</span>
            <input v-model.number="form.targetBooks" type="number" min="1" max="999" required />
          </label>
          <label class="field">
            <span>今年想阅读多少分钟</span>
            <input v-model.number="form.targetMinutes" type="number" min="60" max="1000000" step="60" required />
            <small class="muted small">约 {{ Math.round(form.targetMinutes / 60) }} 小时</small>
          </label>
          <div class="row-between">
            <span class="muted small">目标随时可以调整，重要的是继续读下去。</span>
            <button class="button" type="submit" :disabled="saving">
              <AppIcon name="check" :size="16" />
              {{ saving ? '保存中…' : '保存目标' }}
            </button>
          </div>
        </form>
      </section>

      <p class="data-footnote">今年已有 {{ progress.active_days }} 天留下阅读记录。</p>
    </template>
  </div>
</template>
