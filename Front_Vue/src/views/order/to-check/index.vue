<template>
  <div class="order-to-check-container">
    <div class="page-header">
      <h2>待审核退款订单</h2>
      <p>这里显示需要审核退款的订单列表</p>
    </div>
    <div class="content-placeholder">
      <el-empty description="待审核退款订单功能开发中..." />
    </div>
  </div>
</template>

<script setup lang="ts">
  import { ElEmpty } from 'element-plus'

  // 组件名称
  defineOptions({
    name: 'ToCheckOrder'
  })
</script>

<style scoped>
  .order-to-check-container {
    padding: 20px;
  }

  .page-header {
    margin-bottom: 20px;
  }

  .page-header h2 {
    margin: 0 0 8px 0;
    color: #303133;
  }

  .page-header p {
    margin: 0;
    color: #606266;
    font-size: 14px;
  }

  .content-placeholder {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 400px;
  }
</style>
