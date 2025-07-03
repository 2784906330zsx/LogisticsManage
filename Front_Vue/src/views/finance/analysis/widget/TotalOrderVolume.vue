<template>
  <div class="card art-custom-card" style="height: 13.3rem">
    <div class="card-header">
      <p class="title" style="font-size: 24px">8,216</p>
      <p class="subtitle">总交易笔数</p>
    </div>
    <ArtRingChart
      :data="[
        { value: 45, name: '收入交易' },
        { value: 30, name: '支出交易' },
        { value: 25, name: '转账交易' }
      ]"
      :color="['#4C87F3', '#93F1B4', '#8BD8FC']"
      :radius="['56%', '76%']"
      height="7rem"
      :showLabel="false"
      :borderRadius="0"
    />
  </div>
</template>
