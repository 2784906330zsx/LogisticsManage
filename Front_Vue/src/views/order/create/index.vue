<template>
  <div class="order-create-container">
    <div class="page-header">
      <h2>创建订单</h2>
      <p>在这里可以创建新的订单</p>
    </div>
    <div class="content-placeholder">
      <el-empty description="订单创建功能开发中..." />
    </div>
  </div>
</template>

<script setup lang="ts">
  import { ElEmpty } from 'element-plus'

  // 组件名称
  defineOptions({
    name: 'CreateOrder'
  })
</script>

<style scoped>
  .order-create-container {
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
