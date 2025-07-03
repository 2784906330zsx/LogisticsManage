<template>
  <div class="card art-custom-card" style="height: 27.8rem">
    <div class="card-header">
      <p class="title">资金流向分析</p>
      <p class="subtitle">本月资金使用情况</p>
    </div>
    <div class="table">
      <el-scrollbar style="height: 21.55rem">
        <art-table
          :data="tableData"
          :pagination="false"
          style="margin-top: 0 !important"
          size="large"
          :border="false"
          :stripe="false"
          :show-header-background="false"
        >
          <template #default>
            <el-table-column label="支出项目" prop="project" width="220px">
              <template #default="scope">
                <div style="display: flex; align-items: center">
                  <div class="project-icon" :class="scope.row.iconClass">
                    <i class="iconfont-sys">{{ scope.row.icon }}</i>
                  </div>
                  <div class="project-info">
                    <div class="project-name">{{ scope.row.name }}</div>
                    <div class="project-category">{{ scope.row.category }}</div>
                  </div>
                </div>
              </template>
            </el-table-column>
            <el-table-column label="金额" prop="amount">
              <template #default="scope">
                <span class="amount">¥{{ scope.row.amount.toLocaleString() }}</span>
              </template>
            </el-table-column>
            <el-table-column label="状态" prop="status">
              <template #default="scope">
                <div class="status-badge" :class="getStatusClass(scope.row.status)">
                  {{ scope.row.status }}
                </div>
              </template>
            </el-table-column>
            <el-table-column label="频次" prop="frequency" />
            <el-table-column label="趋势" width="240">
              <template #default="scope">
                <el-progress
                  :percentage="scope.row.pro"
                  :color="scope.row.color"
                  :stroke-width="4"
                />
              </template>
            </el-table-column>
          </template>
        </art-table>
      </el-scrollbar>
    </div>
  </div>
</template>

<script setup lang="ts">
  import { reactive, onMounted } from 'vue'

  const tableData = reactive([
    {
      name: '原材料采购',
      category: '采购支出',
      amount: 129900,
      status: '正常',
      frequency: 23,
      percentage: 75,
      pro: 0,
      color: 'rgb(var(--art-primary)) !important',
      icon: '&#xe718;',
      iconClass: 'icon-primary'
    },
    {
      name: '员工薪酬',
      category: '人力成本',
      amount: 89200,
      status: '正常',
      frequency: 12,
      percentage: 85,
      pro: 0,
      color: 'rgb(var(--art-success)) !important',
      icon: '&#xe70c;',
      iconClass: 'icon-success'
    },
    {
      name: '设备维护',
      category: '运营支出',
      amount: 15600,
      status: '偏高',
      frequency: 8,
      percentage: 45,
      pro: 0,
      color: 'rgb(var(--art-warning)) !important',
      icon: '&#xe813;',
      iconClass: 'icon-warning'
    },
    {
      name: '办公费用',
      category: '管理费用',
      amount: 8900,
      status: '正常',
      frequency: 15,
      percentage: 30,
      pro: 0,
      color: 'rgb(var(--art-error)) !important',
      icon: '&#xe6fb;',
      iconClass: 'icon-error'
    },
    {
      name: '营销推广',
      category: '市场费用',
      amount: 25600,
      status: '正常',
      frequency: 6,
      percentage: 60,
      pro: 0,
      color: 'rgb(var(--art-info)) !important',
      icon: '&#xe6f2;',
      iconClass: 'icon-info'
    },
    {
      name: '物流运输',
      category: '运营支出',
      amount: 18900,
      status: '正常',
      frequency: 18,
      percentage: 70,
      pro: 0,
      color: 'rgb(var(--art-secondary)) !important',
      icon: '&#xe806;',
      iconClass: 'icon-secondary'
    }
  ])

  // 根据状态获取状态文本
  const getStatusClass = (status: string) => {
    if (status === '正常') return 'status-normal'
    if (status === '偏高') return 'status-high'
    if (status === '偏低') return 'status-low'
    return 'status-normal'
  }

  onMounted(() => {
    addAnimation()
  })

  const addAnimation = () => {
    setTimeout(() => {
      for (let i = 0; i < tableData.length; i++) {
        let item = tableData[i]
        tableData[i].pro = item.percentage
      }
    }, 100)
  }
</script>

<style lang="scss" scoped>
  .table {
    width: 100%;

    .card-header {
      padding-left: 25px !important;
    }

    .project-icon {
      width: 40px;
      height: 40px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 6px;

      &.icon-primary {
        background-color: rgba(var(--art-primary-rgb), 0.1);
        color: rgb(var(--art-primary));
      }

      &.icon-success {
        background-color: rgba(var(--art-success-rgb), 0.1);
        color: rgb(var(--art-success));
      }

      &.icon-warning {
        background-color: rgba(var(--art-warning-rgb), 0.1);
        color: rgb(var(--art-warning));
      }

      &.icon-error {
        background-color: rgba(var(--art-error-rgb), 0.1);
        color: rgb(var(--art-error));
      }

      &.icon-info {
        background-color: rgba(var(--art-info-rgb), 0.1);
        color: rgb(var(--art-info));
      }

      &.icon-secondary {
        background-color: rgba(var(--art-secondary-rgb), 0.1);
        color: rgb(var(--art-secondary));
      }
    }

    .project-info {
      display: flex;
      flex-direction: column;
      margin-left: 12px;
    }

    .project-name {
      font-weight: 500;
    }

    .project-category {
      font-size: 12px;
      color: #64748b;
    }

    .amount {
      font-weight: 600;
    }

    .status-badge {
      display: inline-block;
      padding: 4px 8px;
      font-size: 12px;
      font-weight: 500;
      border-radius: 4px;
    }

    .status-normal {
      color: rgb(var(--art-success));
      background-color: rgba(var(--art-success-rgb), 0.1);
    }

    .status-high {
      color: rgb(var(--art-warning));
      background-color: rgba(var(--art-warning-rgb), 0.1);
    }

    .status-low {
      color: rgb(var(--art-info));
      background-color: rgba(var(--art-info-rgb), 0.1);
    }
  }
</style>
