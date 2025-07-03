<template>
  <ArtDataListCard
    :maxCount="4"
    :list="dataList"
    title="财务活动"
    subtitle="资金流动状态"
    :showMoreButton="true"
    @more="handleMore"
  />
</template>

<script setup lang="ts">
  const dataList = [
    {
      title: '收款 #38291',
      status: '已到账',
      time: '5分钟',
      class: 'bg-primary',
      icon: '&#xe6f2;'
    },
    {
      title: '付款申请 #12845',
      status: '审核中',
      time: '10分钟',
      class: 'bg-secondary',
      icon: '&#xe806;'
    },
    {
      title: '费用报销处理',
      status: '待审核',
      time: '15分钟',
      class: 'bg-warning',
      icon: '&#xe6fb;'
    },
    {
      title: '资金预警提醒',
      status: '紧急',
      time: '20分钟',
      class: 'bg-danger',
      icon: '&#xe813;'
    },
    {
      title: '转账 #29384 已完成',
      status: '已完成',
      time: '20分钟',
      class: 'bg-success',
      icon: '&#xe70c;'
    }
  ]

  const handleMore = () => {}
</script>
