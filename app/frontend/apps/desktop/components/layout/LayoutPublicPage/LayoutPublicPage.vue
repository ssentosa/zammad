<!-- Copyright (C) 2012-2026 Zammad Foundation, https://zammad-foundation.org/ -->

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'

import CommonLogo from '#shared/components/CommonLogo/CommonLogo.vue'

import LayoutPublicPageBoxActions from './LayoutPublicPageBoxActions.vue'

import type { BoxSizes } from '../types'

export interface Props {
  title?: string
  showLogo?: boolean
  boxSize?: BoxSizes
  hideFooter?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  boxSize: 'medium',
})

const boxSizeMap: Record<BoxSizes, string> = {
  small: 'max-w-md',
  medium: 'max-w-lg',
  large: 'max-w-2xl',
}

const boxSizeClass = computed(() => {
  return boxSizeMap[props.boxSize]
})

const route = useRoute()

// Route-page skin scope: the active route name on the single data-zammad-target hook.
const routeTarget = computed(() => (route.name ? String(route.name) : undefined))
</script>

<template>
  <div
    class="flex min-h-screen flex-col items-center bg-neutral-950 text-stone-200 dark:text-neutral-500"
  >
    <div :class="boxSizeClass" class="m-auto w-full">
      <main
        class="flex flex-col gap-2.5 rounded-3xl bg-neutral-50 p-5 text-contrast dark:bg-gray-500"
        :data-zammad-target="routeTarget"
      >
        <div v-if="showLogo" class="flex justify-center">
          <CommonLogo />
        </div>
        <h1 v-if="title" class="mb-5 text-center text-xl">
          {{ $t(title) }}
        </h1>
        <slot />

        <LayoutPublicPageBoxActions v-if="$slots.boxActions">
          <slot name="boxActions" />
        </LayoutPublicPageBoxActions>
      </main>

      <section
        v-if="$slots.bottomContent"
        :aria-label="$t('Additional information and links')"
        class="flex w-full flex-col items-center justify-center space-y-3 py-3 align-middle text-xs"
      >
        <slot name="bottomContent" />
      </section>
    </div>
  </div>
</template>
