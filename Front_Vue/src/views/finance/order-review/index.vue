<template>
  <ArtTableFullScreen>
    <div class="order-review-page" id="table-full-screen">
      <!-- 搜索栏 -->
      <ArtSearchBar
        v-model:filter="formFilters"
        :items="formItems"
        @reset="handleReset"
        @search="handleSearch"
      >
      </ArtSearchBar>

      <ElCard shadow="never" class="art-table-card">
        <!-- 表格头部 -->
        <ArtTableHeader v-model:columns="columnChecks" @refresh="handleRefresh">
          <template #left>
            <div class="flex items-center gap-2">
              <ElTag type="warning">待审核订单</ElTag>
              <span class="text-sm text-gray-500">共 {{ pagination.total }} 条</span>
            </div>
          </template>
        </ArtTableHeader>

        <!-- 表格 -->
        <ArtTable
          ref="tableRef"
          row-key="id"
          :loading="loading"
          :data="tableData"
          :currentPage="pagination.currentPage"
          :pageSize="pagination.pageSize"
          :total="pagination.total"
          :marginTop="10"
          @selection-change="handleSelectionChange"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        >
          <template #default>
            <ElTableColumn v-for="col in columns" :key="col.prop || col.type" v-bind="col" />
          </template>
        </ArtTable>

        <!-- 审核对话框 -->
        <ElDialog
          v-model="reviewDialogVisible"
          :title="reviewType === 'approve' ? '通过' : '不通过'"
          width="500px"
          align-center
        >
          <div class="review-content">
            <div class="order-info mb-4">
              <h4 class="text-lg font-semibold mb-2">订单信息</h4>
              <div class="grid grid-cols-2 gap-4 text-sm">
                <div
                  ><span class="font-medium">订单编号：</span
                  >{{ currentReviewOrder?.orderNumber }}</div
                >
                <div
                  ><span class="font-medium">商品名称：</span
                  >{{ currentReviewOrder?.commodityName }}</div
                >
                <div
                  ><span class="font-medium">供应商：</span
                  >{{ currentReviewOrder?.supplierName }}</div
                >
                <div
                  ><span class="font-medium">总金额：</span>¥{{
                    currentReviewOrder?.totalAmount?.toFixed(2)
                  }}</div
                >
              </div>
            </div>

            <ElForm ref="reviewFormRef" :model="reviewForm" :rules="reviewRules" label-width="80px">
              <ElFormItem label="审核意见" prop="reviewComment">
                <ElInput
                  v-model="reviewForm.reviewComment"
                  type="textarea"
                  :rows="4"
                  :placeholder="
                    reviewType === 'approve'
                      ? '请输入审核通过的意见（可选）'
                      : '请输入审核不通过的原因'
                  "
                />
              </ElFormItem>
            </ElForm>
          </div>

          <template #footer>
            <div class="dialog-footer">
              <ElButton @click="reviewDialogVisible = false">取消</ElButton>
              <ElButton
                :type="reviewType === 'approve' ? 'success' : 'danger'"
                @click="handleReviewSubmit"
              >
                {{ reviewType === 'approve' ? '确认通过' : '确认不通过' }}
              </ElButton>
            </div>
          </template>
        </ElDialog>
      </ElCard>
    </div>
  </ArtTableFullScreen>
</template>

<script setup lang="ts">
  import { h } from 'vue'
  import { FinanceService } from '@/api/financeApi' // 导入新的API服务
  // import { PURCHASE_ORDER_DATA } from '@/mock/formData'
  import { ElDialog, FormInstance, ElTag, ElImage, ElButton } from 'element-plus'
  import { ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import { SearchChangeParams, SearchFormItem } from '@/types'

  defineOptions({ name: 'OrderReview' })

  const loading = ref(false)
  const reviewDialogVisible = ref(false)
  const reviewType = ref<'approve' | 'reject'>('approve')
  const currentReviewOrder = ref<any>(null)

  // 定义表单搜索初始值
  const initialSearchState = {
    orderNumber: '',
    commodityName: '',
    supplierName: '',
    purchaserName: ''
  }

  // 响应式表单数据
  const formFilters = reactive({ ...initialSearchState })

  const pagination = reactive({
    currentPage: 1,
    pageSize: 20,
    total: 0
  })

  // 表格数据
  const tableData = ref<any[]>([])

  // 表格实例引用
  const tableRef = ref()

  // 选中的行数据
  const selectedRows = ref<any[]>([])

  // 审核表单
  const reviewFormRef = ref<FormInstance>()
  const reviewForm = reactive({
    reviewComment: ''
  })

  // 审核表单验证规则
  const reviewRules = reactive<FormRules>({
    reviewComment: [
      {
        validator: (rule: any, value: any, callback: any) => {
          if (reviewType.value === 'reject' && !value.trim()) {
            callback(new Error('审核不通过时必须填写原因'))
          } else {
            callback()
          }
        },
        trigger: 'blur'
      }
    ]
  })

  // 重置表单
  const handleReset = () => {
    Object.assign(formFilters, { ...initialSearchState })
    pagination.currentPage = 1
    getPendingOrderList()
  }

  // 搜索处理
  const handleSearch = () => {
    console.log('搜索参数:', formFilters)
    pagination.currentPage = 1
    getPendingOrderList()
  }

  // 表单项变更处理
  const handleFormChange = (params: SearchChangeParams): void => {
    console.log('表单项变更:', params)
  }

  // 表单配置项
  const formItems: SearchFormItem[] = [
    {
      label: '订单编号',
      prop: 'orderNumber',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '商品名称',
      prop: 'commodityName',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '供应商',
      prop: 'supplierName',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '采购人',
      prop: 'purchaserName',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    }
  ]

  // 显示审核对话框
  const showReviewDialog = (type: 'approve' | 'reject', row: any) => {
    reviewType.value = type
    currentReviewOrder.value = row
    reviewForm.reviewComment = ''
    reviewDialogVisible.value = true

    // 重置表单验证状态
    if (reviewFormRef.value) {
      reviewFormRef.value.resetFields()
    }
  }

  // 获取待审核订单列表数据
  // 获取待审核订单列表数据
  const getPendingOrderList = async () => {
    loading.value = true
    try {
      const { currentPage, pageSize } = pagination

      // 调用真实API - 修改参数名称
      const response = await FinanceService.getPendingOrderList({
        current: currentPage, // 改为 current
        size: pageSize, // 改为 size
        orderNumber: formFilters.orderNumber,
        commodityName: formFilters.commodityName,
        supplierName: formFilters.supplierName,
        purchaserName: formFilters.purchaserName
      })

      if (response.code === 200) {
        tableData.value = response.data.list
        pagination.total = response.data.total
      } else {
        ElMessage.error(response.data.message || '获取订单列表失败')
      }
    } catch (error) {
      console.error('获取待审核订单列表失败:', error)
      ElMessage.error('获取订单列表失败')
    } finally {
      loading.value = false
    }
  }

  // 提交审核
  const handleReviewSubmit = async () => {
    if (!reviewFormRef.value) return

    await reviewFormRef.value.validate(async (valid) => {
      if (valid) {
        try {
          const response = await FinanceService.reviewOrder({
            orderId: currentReviewOrder.value.id,
            action: reviewType.value,
            reviewComment: reviewForm.reviewComment
          })

          if (response.code === 200) {
            const action = reviewType.value === 'approve' ? '通过' : '不通过'
            ElMessage.success(`${action}成功`)
            reviewDialogVisible.value = false
            getPendingOrderList() // 刷新列表
          } else {
            ElMessage.error(response.data.message || '审核失败')
          }
        } catch (error) {
          console.error('审核操作失败:', error)
          ElMessage.error('审核操作失败')
        }
      }
    })
  }

  // 动态列配置
  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection' },
    {
      prop: 'orderNumber',
      label: '订单编号',
      width: 160
    },
    {
      prop: 'image',
      label: '商品信息',
      width: 180,
      formatter: (row: any) => {
        return h('div', { class: 'commodity-info', style: 'display: flex; align-items: center' }, [
          h(ElImage, {
            class: 'commodity-image',
            src: row.commodityImage,
            style: 'width: 60px; height: 60px; border-radius: 6px; margin-right: 12px',
            fit: 'cover',
            lazy: true
          }),
          h('div', {}, [
            h(
              'p',
              {
                class: 'commodity-name',
                style: 'margin: 0; font-weight: 500; color: var(--art-text-gray-800)'
              },
              row.commodityName
            )
          ])
        ])
      }
    },
    {
      prop: 'supplierName',
      label: '供应商',
      minWidth: 200
    },
    {
      prop: 'unitPrice',
      label: '采购单价',
      width: 120,
      formatter: (row: any) => {
        return `¥${row.unitPrice.toFixed(2)}`
      }
    },
    {
      prop: 'quantity',
      label: '采购数量',
      width: 100
    },
    {
      prop: 'totalAmount',
      label: '总金额',
      width: 140,
      formatter: (row: any) => {
        return `¥${row.totalAmount.toFixed(2)}`
      }
    },
    {
      prop: 'orderTime',
      label: '下单时间',
      width: 160,
      sortable: true
    },
    {
      prop: 'purchaser',
      label: '采购人',
      width: 120,
      formatter: (row: any) => {
        return h('div', { style: 'line-height: 1.2;' }, [
          h('div', { style: 'font-weight: bold;' }, row.purchaserName),
          h('div', { style: 'font-size: 12px; color: #999;' }, row.purchaserJobNumber)
        ])
      }
    },
    {
      prop: 'operation',
      label: '操作',
      width: 180,
      formatter: (row: any) => {
        return h('div', { class: 'flex gap-2' }, [
          h(
            ElButton,
            {
              type: 'success',
              size: 'small',
              onClick: () => showReviewDialog('approve', row)
            },
            () => '通过'
          ),
          h(
            ElButton,
            {
              type: 'danger',
              size: 'small',
              onClick: () => showReviewDialog('reject', row)
            },
            () => '不通过'
          )
        ])
      }
    }
  ])

  onMounted(() => {
    getPendingOrderList()
  })

  const handleRefresh = () => {
    getPendingOrderList()
  }

  // 处理表格行选择变化
  const handleSelectionChange = (selection: any[]) => {
    selectedRows.value = selection
  }

  // 处理表格分页变化
  const handleSizeChange = (newPageSize: number) => {
    pagination.pageSize = newPageSize
    getPendingOrderList()
  }

  const handleCurrentChange = (newCurrentPage: number) => {
    pagination.currentPage = newCurrentPage
    getPendingOrderList()
  }
</script>

<style scoped>
  .order-review-page {
    height: 100%;
  }

  .review-content {
    padding: 16px 0;
  }

  .order-info {
    background-color: #f8f9fa;
    padding: 16px;
    border-radius: 8px;
    border: 1px solid #e9ecef;
  }

  .flex {
    display: flex;
  }

  .items-center {
    align-items: center;
  }

  .gap-2 {
    gap: 8px;
  }

  .text-sm {
    font-size: 14px;
  }

  .text-gray-500 {
    color: #6b7280;
  }

  .grid {
    display: grid;
  }

  .grid-cols-2 {
    grid-template-columns: repeat(2, 1fr);
  }

  .gap-4 {
    gap: 16px;
  }

  .mb-2 {
    margin-bottom: 8px;
  }

  .mb-4 {
    margin-bottom: 16px;
  }

  .text-lg {
    font-size: 18px;
  }

  .font-semibold {
    font-weight: 600;
  }

  .font-medium {
    font-weight: 500;
  }
</style>
