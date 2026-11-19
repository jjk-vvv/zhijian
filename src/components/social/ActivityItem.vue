<script setup>
import { ACTIVITY_LABELS } from '../../utils/format.js'
import { formatRelative } from '../../utils/format.js'
import Avatar from '../ui/Avatar.vue'
import AppIcon from '../ui/AppIcon.vue'
import RatingStars from '../ui/RatingStars.vue'

defineProps({ activity: { type: Object, required: true } })
</script>
<template>
  <article class="activity-item">
    <RouterLink :to="`/profile/${activity.user.handle}`">
      <Avatar :user="activity.user" :size="42" />
    </RouterLink>
    <div class="activity-body">
      <p class="activity-line">
        <RouterLink :to="`/profile/${activity.user.handle}`">
          <strong>{{ activity.user.displayName }}</strong>
        </RouterLink>
        <span>{{ ACTIVITY_LABELS[activity.type] || '更新了阅读动态' }}</span>
        <RouterLink v-if="activity.book" :to="`/book/${activity.book.slug}`" class="activity-book">
          《{{ activity.book.title }}》
        </RouterLink>
      </p>

      <p v-if="activity.type === 'review' && activity.payload?.title" class="activity-quote">
        <RatingStars :rating="activity.payload.rating" :size="13" />
        {{ activity.payload.title }}
      </p>
      <p v-else-if="activity.payload?.title && activity.type !== 'list_create'" class="activity-quote">
        {{ activity.payload.title }}
      </p>
      <p v-else-if="activity.type === 'highlight' && activity.payload?.quote" class="activity-quote">
        “{{ activity.payload.quote }}”
      </p>
      <p v-else-if="activity.type === 'goal' && activity.payload?.targetBooks" class="activity-quote">
        今年想读 {{ activity.payload.targetBooks }} 本书
      </p>

      <div class="activity-meta">
        <time :datetime="activity.createdAt">{{ formatRelative(activity.createdAt) }}</time>
        <RouterLink v-if="activity.book" :to="`/book/${activity.book.slug}`" class="activity-link">
          查看书目
          <AppIcon name="arrow" :size="14" />
        </RouterLink>
        <span v-else-if="activity.type === 'club_join' && activity.payload?.title" class="activity-link">
          {{ activity.payload.title }}
        </span>
      </div>
    </div>
  </article>
</template>
