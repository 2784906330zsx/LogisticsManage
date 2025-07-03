<template>
  <ArtTimelineListCard :list="timelineData" title="资金流水" subtitle="今日资金动态" />
</template>

<script setup lang="ts">
  const timelineData = [
    {
      time: '上午 09:30',
      status: 'rgb(73, 190, 255)',
      content: '收到客户付款 ¥38,590'
    },
    {
      time: '上午 10:00',
      status: 'rgb(54, 158, 255)',
      content: '银行利息收入 ¥245'
    },
    {
      time: '上午 12:00',
      status: 'rgb(255, 105, 105)',
      content: '支付供应商货款 ¥64,950'
    },
    {
      time: '下午 14:30',
      status: 'rgb(255, 193, 7)',
      content: '员工工资发放 ¥125,800'
    },
    {
      time: '下午 15:45',
      status: 'rgb(255, 105, 105)',
      content: '办公费用支出 ¥3,200'
    },
    {
      time: '下午 17:00',
      status: 'rgb(103, 232, 207)',
      content: '完成日资金报表'
    }
  ]
</script>
