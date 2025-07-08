<template>
  <ArtBasicBanner
    class="banner"
    height="13.3rem"
    :title="`账目总览`"
    backgroundColor="var(--el-color-primary-light-9)"
    titleColor="var(--art-gray-900)"
    :decoration="false"
    :meteorConfig="{
      enabled: true,
      count: 10
    }"
    :buttonConfig="{
      show: false,
      text: ''
    }"
    :imageConfig="{
      src: bannerCover,
      width: '18rem',
      bottom: '-7.5rem'
    }"
    @click="handleBannerClick"
  >
    <div class="banner-slot">
      <div class="item">
        <p class="title">¥1,258,340</p>
        <p class="subtitle">账户总余额</p>
      </div>
      <div class="item">
        <p class="title">¥45,680</p>
        <p class="subtitle">今日收入</p>
      </div>
      <div class="item">
        <p class="title">¥12,450</p>
        <p class="subtitle">今日支出</p>
      </div>
    </div>
  </ArtBasicBanner>
</template>

<script setup lang="ts">
  import bannerCover from '@imgs/login/lf_icon2.webp'
  // import { useUserStore } from '@/store/modules/user'
  // const userStore = useUserStore()

  // const userInfo = computed(() => userStore.getUserInfo)

  const handleBannerClick = () => {}
</script>

<style lang="scss" scoped>
  .banner {
    justify-content: center;

    .banner-slot {
      display: flex;
      margin-top: 24px;

      .item {
        margin-right: 30px;

        &:not(:last-child) {
          padding-right: 30px;
          border-right: 1px solid var(--art-gray-300);
        }

        .title {
          font-size: 24px;
          color: var(--art-gray-900) !important;

          i {
            position: relative;
            top: -8px;
            margin-left: 8px;
            font-size: 14px;
          }
        }

        .subtitle {
          margin-top: 4px;
          font-size: 14px;
          color: var(--art-gray-700) !important;
        }
      }
    }
  }
</style>
