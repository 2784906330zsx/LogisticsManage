<!-- 顶部快速入口面板 -->
<template>
  <ElPopover
    ref="popoverRef"
    :width="700"
    trigger="hover"
    popper-class="fast-enter-popover"
    :show-arrow="false"
    placement="bottom-start"
    :offset="0"
    :popper-style="{
      border: '1px solid var(--art-border-dashed-color)',
      borderRadius: 'calc(var(--custom-radius) / 2 + 4px)'
    }"
  >
    <template #reference>
      <div class="fast-enter-trigger">
        <div class="btn">
          <i class="iconfont-sys">&#xe81a;</i>
          <span class="red-dot"></span>
        </div>
      </div>
    </template>

    <div class="fast-enter">
      <div class="apps-section">
        <div class="apps-grid">
          <!-- 应用列表 -->
          <div
            v-for="application in applicationList"
            :key="application.name"
            class="app-item"
            @click="handleNavigate(application.path)"
          >
            <div class="app-icon">
              <i
                class="iconfont-sys"
                v-html="application.icon"
                :style="{ color: application.iconColor }"
              />
            </div>
            <div class="app-info">
              <h3>{{ application.name }}</h3>
              <p>{{ application.description }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </ElPopover>
</template>

<script setup lang="ts">
  import { RoutesAlias } from '@/router/routesAlias'

  defineOptions({ name: 'ArtFastEnter' })

  interface ApplicationItem {
    /** 应用名称 */
    name: string
    /** 应用描述 */
    description: string
    /** 图标代码 */
    icon: string
    /** 图标颜色 */
    iconColor: string
    /** 跳转路径 */
    path: string
  }

  const router = useRouter()
  const popoverRef = ref()

  const applicationList: ApplicationItem[] = [
    {
      name: '工作台',
      description: '系统概览与数据统计',
      icon: '&#xe721;',
      iconColor: '#377dff',
      path: RoutesAlias.Dashboard
    },
    {
      name: '分析页',
      description: '数据分析与可视化',
      icon: '&#xe812;',
      iconColor: '#ff3b30',
      path: RoutesAlias.Analysis
    }
  ]

  const isExternalLink = (path: string): boolean => path.startsWith('http')

  const handleNavigate = (path: string): void => {
    if (isExternalLink(path)) {
      window.open(path, '_blank')
    } else {
      router.push(path)
    }
    popoverRef.value?.hide()
  }
</script>

<style lang="scss" scoped>
  @use './style';
</style>
