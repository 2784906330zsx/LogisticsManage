<template>
  <div class="card art-custom-card sales-card" style="height: 26rem">
    <div class="card-header">
      <p class="title">支出分类</p>
      <p class="subtitle">按支出类别</p>
    </div>
    <ArtRingChart
      :data="[
        { value: 30, name: '采购支出' },
        { value: 55, name: '运营支出' },
        { value: 36, name: '管理支出' }
      ]"
      :color="['#4C87F3', '#EDF2FF', '#8BD8FC']"
      :radius="['70%', '80%']"
      height="16.5rem"
      :showLabel="false"
      :borderRadius="0"
      centerText="¥300,458"
    />
    <div class="icon-text-widget">
      <div class="item">
        <div class="icon">
          <i class="iconfont-sys">&#xe718;</i>
        </div>
        <div class="content">
          <p>¥500,458</p>
          <span>总支出</span>
        </div>
      </div>
      <div class="item">
        <div class="icon">
          <i class="iconfont-sys">&#xe70c;</i>
        </div>
        <div class="content">
          <p>¥130,580</p>
          <span>净收益</span>
        </div>
      </div>
    </div>
  </div>
</template>
