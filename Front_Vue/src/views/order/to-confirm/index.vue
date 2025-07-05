<template>
  <ArtTableFullScreen>
    <div class="order-confirm-page" id="table-full-screen">
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
              <ElTag type="warning">待确认订单</ElTag>
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
          :title="reviewType === 'approve' ? '确认通过' : '确认不通过'"
          width="500px"
          align-center
        >
          <div class="review-content">
            <div class="order-info mb-4">
              <h4 class="text-lg font-semibold mb-2">运单信息</h4>
              <div class="grid grid-cols-2 gap-4 text-sm">
                <div
                  ><span class="font-medium">运单号：</span
                  >{{ currentReviewOrder?.orderNumber }}</div
                >
                <div
                  ><span class="font-medium">商品名称：</span
                  >{{ currentReviewOrder?.commodityName }}</div
                >
                <div
                  ><span class="font-medium">收货人：</span
                  >{{ currentReviewOrder?.receiverName }}</div
                >
                <div
                  ><span class="font-medium">数量：</span>{{ currentReviewOrder?.quantity }} 件</div
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
                      ? '请输入确认通过的意见（可选）'
                      : '请输入确认不通过的原因'
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
  import { SHIPPING_ORDER_DATA } from '@/mock/formData'
  //   import { SHIPPING_ORDER_DATA, COMMODITY_LIST_DATA } from '@/mock/formData'
  import { ElDialog, FormInstance, ElImage, ElTag, ElButton } from 'element-plus'
  import { ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import { SearchChangeParams, SearchFormItem } from '@/types'

  const { width } = useWindowSize()

  defineOptions({ name: 'OrderToConfirm' })

  const loading = ref(false)
  const reviewDialogVisible = ref(false)
  const reviewType = ref<'approve' | 'reject'>('approve')
  const currentReviewOrder = ref<any>(null)

  // 定义表单搜索初始值
  const initialSearchState = {
    orderNumber: '',
    commodityName: '',
    receiverName: ''
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
            callback(new Error('确认不通过时必须填写原因'))
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
      label: '运单号',
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
      label: '收货人',
      prop: 'receiverName',
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

  // 提交审核
  const handleReviewSubmit = async () => {
    if (!reviewFormRef.value) return

    await reviewFormRef.value.validate((valid) => {
      if (valid) {
        const action = reviewType.value === 'approve' ? '确认通过' : '确认不通过'
        const newStatus = reviewType.value === 'approve' ? '3' : '2' // 3: 待配送, 2: 确认未通过

        // 这里应该调用API更新订单状态
        console.log('审核操作:', {
          orderId: currentReviewOrder.value.id,
          action,
          newStatus,
          comment: reviewForm.reviewComment
        })

        ElMessage.success(`${action}成功`)
        reviewDialogVisible.value = false
        getPendingOrderList() // 刷新列表
      }
    })
  }

  // 获取状态标签类型
  const getStatusTagType = (
    status: string
  ): 'primary' | 'success' | 'warning' | 'info' | 'danger' => {
    const statusMap: Record<string, 'primary' | 'success' | 'warning' | 'info' | 'danger'> = {
      '1': 'warning', // 待确认
      '2': 'danger', // 确认未通过
      '3': 'info', // 待配送
      '4': 'primary', // 配送中
      '5': 'success', // 已送达
      '6': 'success', // 已确认收货
      '7': 'info', // 待退货审核
      '8': 'info', // 审核未通过
      '9': 'danger' // 已取消
    }
    return statusMap[status] || 'info'
  }

  // 获取状态文本
  const getStatusText = (status: string) => {
    const statusMap: Record<string, string> = {
      '1': '待确认',
      '2': '确认未通过',
      '3': '待配送',
      '4': '配送中',
      '5': '已送达',
      '6': '已确认收货',
      '7': '待退货审核',
      '8': '审核未通过',
      '9': '已取消'
    }
    return statusMap[status] || '未知状态'
  }

  // 动态列配置
  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection' },
    {
      prop: 'orderNumber',
      label: '运单号',
      width: 160
    },
    {
      prop: 'commodityImage',
      label: '商品信息',
      minWidth: width.value < 500 ? 250 : 280,
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
            ),
            h(
              'p',
              {
                class: 'commodity-quantity',
                style: 'margin: 4px 0 0 0; font-size: 12px; color: var(--art-text-gray-500)'
              },
              `数量：${row.quantity} 件`
            )
          ])
        ])
      }
    },
    {
      prop: 'receiverInfo',
      label: '收货信息',
      minWidth: 300,
      formatter: (row: any) => {
        return h('div', { style: 'line-height: 1.4;' }, [
          h('div', { style: 'font-weight: bold; margin-bottom: 4px;' }, row.receiverName),
          h(
            'div',
            { style: 'font-size: 12px; color: #666; margin-bottom: 2px;' },
            row.receiverPhone
          ),
          h(
            'div',
            {
              style: 'font-size: 12px; color: #999; word-break: break-all; line-height: 1.3;'
            },
            row.receiverAddress
          )
        ])
      }
    },
    {
      prop: 'status',
      label: '订单状态',
      width: 140,
      formatter: (row: any) => {
        return h(ElTag, { type: getStatusTagType(row.status) }, () => getStatusText(row.status))
      }
    },
    {
      prop: 'createTime',
      label: '创建时间',
      sortable: true,
      width: 160
    },
    {
      prop: 'creator',
      label: '创建人',
      width: 120,
      formatter: (row: any) => {
        return h('div', { style: 'line-height: 1.4;' }, [
          h('div', { style: 'font-weight: bold; margin-bottom: 2px;' }, row.creatorName || '-'),
          h('div', { style: 'font-size: 12px; color: #666;' }, row.creatorJobNumber || '-')
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

  // 获取待确认订单列表数据
  const getPendingOrderList = async () => {
    loading.value = true
    try {
      const { currentPage, pageSize } = pagination

      // 模拟API调用
      await new Promise((resolve) => setTimeout(resolve, 500))

      // 只获取状态为'1'（待确认）的订单
      let filteredData = SHIPPING_ORDER_DATA.filter((item) => item.status === '1')

      // 应用搜索过滤
      if (formFilters.orderNumber) {
        filteredData = filteredData.filter((item) =>
          item.orderNumber.toLowerCase().includes(formFilters.orderNumber.toLowerCase())
        )
      }

      if (formFilters.commodityName) {
        filteredData = filteredData.filter((item) =>
          item.commodityName.toLowerCase().includes(formFilters.commodityName.toLowerCase())
        )
      }

      if (formFilters.receiverName) {
        filteredData = filteredData.filter((item) =>
          item.receiverName.toLowerCase().includes(formFilters.receiverName.toLowerCase())
        )
      }

      const total = filteredData.length
      const start = (currentPage - 1) * pageSize
      const end = start + pageSize

      tableData.value = filteredData.slice(start, end)
      pagination.total = total
    } catch (error) {
      console.error('获取待确认订单列表失败:', error)
    } finally {
      loading.value = false
    }
  }

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
  .order-confirm-page {
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

  .commodity-info {
    display: flex;
    align-items: center;
  }

  .commodity-image {
    flex-shrink: 0;
  }
</style>
