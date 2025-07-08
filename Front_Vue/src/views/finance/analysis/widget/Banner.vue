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
        <p class="title">¥{{ formatNumber(financeData.balance) }}</p>
        <p class="subtitle">账户总余额</p>
      </div>
      <div class="item">
        <p class="title">¥{{ formatNumber(financeData.todayIncome) }}</p>
        <p class="subtitle">今日收入</p>
      </div>
      <div class="item">
        <p class="title">¥{{ formatNumber(financeData.todayExpenditure) }}</p>
        <p class="subtitle">今日支出</p>
      </div>
    </div>
  </ArtBasicBanner>
</template>

<script setup lang="ts">
  import { ref, onMounted } from 'vue'
  import bannerCover from '@imgs/login/lf_icon2.webp'
  import { FinanceService } from '@/api/financeApi'
  import { ElMessage } from 'element-plus'

  // 财务数据
  const financeData = ref({
    balance: 0,
    todayIncome: 0,
    todayExpenditure: 0,
    totalIncome: 0,
    totalExpenditure: 0,
    netProfit: 0
  })

  // 格式化数字显示
  const formatNumber = (num: number): string => {
    return num.toLocaleString('zh-CN', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 2
    })
  }

  // 获取财务统计数据
  const fetchFinanceData = async () => {
    try {
      const response = await FinanceService.getFinanceStatistics()
      if (response.code === 200) {
        financeData.value = response.data
      } else {
        ElMessage.error(response.msg || '获取财务数据失败')
      }
    } catch (error) {
      console.error('获取财务数据失败:', error)
      ElMessage.error('获取财务数据失败')
    }
  }

  // 点击事件处理
  const handleBannerClick = () => {}

  // 组件挂载时获取数据
  onMounted(() => {
    fetchFinanceData()
  })
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
