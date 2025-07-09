<template>
  <ArtTableFullScreen>
    <div class="delivery-delivered-page" id="table-full-screen">
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
              <ElTag type="success">已送达运单</ElTag>
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

        <!-- 查看详情对话框 -->
        <ElDialog v-model="dialogVisible" title="运单详情" width="600px" align-center>
          <ElForm label-width="120px">
            <ElFormItem label="运单号">
              <ElInput v-model="currentOrder.orderNumber" disabled />
            </ElFormItem>
            <ElFormItem label="商品信息">
              <div class="commodity-info">
                <ElImage
                  :src="currentOrder.commodityImage"
                  style="width: 60px; height: 60px; border-radius: 4px; margin-right: 15px"
                  fit="cover"
                />
                <div>
                  <div style="font-weight: 500; font-size: 16px; margin-bottom: 5px">{{
                    currentOrder.commodityName
                  }}</div>
                  <div style="font-size: 14px; color: #666"
                    >数量：{{ currentOrder.quantity }} 件</div
                  >
                </div>
              </div>
            </ElFormItem>
            <ElFormItem label="收货人信息">
              <div>
                <div style="margin-bottom: 8px; font-size: 16px"
                  ><strong>{{ currentOrder.receiverName }}</strong></div
                >
                <div style="font-size: 14px; color: #666; margin-bottom: 5px">{{
                  currentOrder.receiverPhone
                }}</div>
                <div style="font-size: 14px; color: #999">{{ currentOrder.receiverAddress }}</div>
              </div>
            </ElFormItem>
            <ElFormItem label="配送信息">
              <div>
                <div style="margin-bottom: 5px"
                  >配送员：{{ currentOrder.deliveryPersonName || '未知' }}</div
                >
                <div style="margin-bottom: 5px"
                  >联系电话：{{ currentOrder.deliveryPersonPhone || '未知' }}</div
                >
                <div>配送车辆：{{ currentOrder.deliveryCarNumber || '未知' }}</div>
              </div>
            </ElFormItem>
            <ElFormItem label="配送线路">
              <div>配送完成</div>
            </ElFormItem>
            <ElFormItem label="跟踪信息">
              <ElInput v-model="currentOrder.trackingInfo" type="textarea" :rows="3" disabled />
            </ElFormItem>
            <ElFormItem label="创建时间">
              <ElInput v-model="currentOrder.createTime" disabled />
            </ElFormItem>
            <ElFormItem label="完成时间" v-if="currentOrder.completeTime">
              <ElInput v-model="currentOrder.completeTime" disabled />
            </ElFormItem>
          </ElForm>
          <template #footer>
            <div class="dialog-footer">
              <ElButton @click="dialogVisible = false">关闭</ElButton>
            </div>
          </template>
        </ElDialog>
      </ElCard>
    </div>
  </ArtTableFullScreen>
</template>

<script setup lang="ts">
  import { h } from 'vue'
  // 修改导入：从 orderApi 改为 deliveryApi
  import { DeliveryService } from '@/api/deliveryApi'
  import { ElDialog, ElImage, ElTag, ElButton } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { SearchChangeParams, SearchFormItem } from '@/types'

  defineOptions({ name: 'DeliveryDelivered' })

  const dialogVisible = ref(false)
  const loading = ref(false)

  // 定义表单搜索初始值
  const initialSearchState = {
    orderNumber: '',
    commodityName: '',
    receiverName: '',
    plateNumber: ''
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

  // 当前操作的订单
  const currentOrder = ref<any>({})

  // 重置表单
  const handleReset = () => {
    Object.assign(formFilters, { ...initialSearchState })
    pagination.currentPage = 1
    getDeliveredOrderList()
  }

  // 搜索处理
  const handleSearch = () => {
    console.log('搜索参数:', formFilters)
    pagination.currentPage = 1
    getDeliveredOrderList()
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
    },
    {
      label: '车牌号',
      prop: 'plateNumber',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    }
  ]

  // 显示详情对话框
  const showDetailDialog = (row: any) => {
    currentOrder.value = { ...row }
    dialogVisible.value = true
  }

  // 动态列配置
  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection' },
    {
      prop: 'orderNumber',
      label: '运单号',
      width: 160,
      fixed: 'left'
    },
    {
      prop: 'commodityInfo',
      label: '商品信息',
      width: 200,
      formatter: (row: any) => {
        return h('div', { class: 'commodity-info', style: 'display: flex; align-items: center' }, [
          h(ElImage, {
            class: 'commodity-image',
            src: row.commodityImage,
            style: 'width: 60px; height: 60px; border-radius: 6px; margin-right: 12px',
            fit: 'cover',
            lazy: true,
            // 添加错误处理
            onError: () => {
              // 图片加载失败时的处理
              console.warn('商品图片加载失败:', row.commodityImage)
            },
            // 添加占位图片
            placeholder: '/default-commodity.png'
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
      label: '收货人信息',
      width: 200,
      formatter: (row: any) => {
        return h('div', [
          h('div', { style: 'font-weight: 500; margin-bottom: 2px' }, row.receiverName),
          h(
            'div',
            { style: 'font-size: 12px; color: #666; margin-bottom: 2px' },
            row.receiverPhone
          ),
          h('div', { style: 'font-size: 12px; color: #999' }, row.receiverAddress)
        ])
      }
    },
    {
      prop: 'vehicleInfo',
      label: '配送车辆',
      width: 180,
      formatter: (row: any) => {
        return h('div', [
          h(
            'div',
            { style: 'font-weight: 500; margin-bottom: 2px' },
            `车牌号: ${row.deliveryCarNumber || '未知'}`
          ),
          h(
            'div',
            { style: 'font-size: 12px; color: #666; margin-bottom: 2px' },
            `配送员: ${row.deliveryPersonName || '未知'}`
          ),
          h(
            'div',
            { style: 'font-size: 12px; color: #999' },
            `联系电话: ${row.deliveryPersonPhone || '未知'}`
          )
        ])
      }
    },
    {
      prop: 'route',
      label: '配送线路',
      width: 200,
      formatter: (row: any) => {
        // 显示实际的配送线路信息
        return row.deliveryRoute || '线路信息不可用'
      }
    },
    {
      prop: 'createTime',
      label: '创建时间',
      sortable: true,
      width: 160
    },
    {
      prop: 'completeTime',
      label: '送达时间',
      sortable: true,
      width: 160
    }
  ])

  onMounted(() => {
    getDeliveredOrderList()
  })

  // 获取已送达运单列表数据
  const getDeliveredOrderList = async () => {
    loading.value = true
    try {
      const { currentPage, pageSize } = pagination

      const params = {
        current: currentPage,
        size: pageSize,
        orderNumber: formFilters.orderNumber || undefined,
        deliveryStatus: '5' // 使用 deliveryStatus 参数查询已送达状态
      }

      // 调用配送系统的API
      const response = await DeliveryService.getDeliveryOrderList(params)

      if (response.code === 200) {
        tableData.value = response.data.list.map((item: any) => ({
          ...item,
          commodityImage: item.commodityImage || '/default-commodity.png'
        }))
        pagination.total = response.data.total
        pagination.currentPage = response.data.current
        pagination.pageSize = response.data.size
      } else {
        ElMessage.error(response.msg || '获取已送达运单列表失败')
        tableData.value = []
        pagination.total = 0
      }
    } catch (error) {
      console.error('获取已送达运单列表失败:', error)
      ElMessage.error('获取已送达运单列表失败，请稍后重试')
      tableData.value = []
      pagination.total = 0
    } finally {
      loading.value = false
    }
  }

  const handleRefresh = () => {
    getDeliveredOrderList()
  }

  // 处理表格行选择变化
  const handleSelectionChange = (selection: any[]) => {
    selectedRows.value = selection
  }

  // 处理分页大小变化
  const handleSizeChange = (newPageSize: number) => {
    pagination.pageSize = newPageSize
    pagination.currentPage = 1
    getDeliveredOrderList()
  }

  // 处理当前页变化
  const handleCurrentChange = (newCurrentPage: number) => {
    pagination.currentPage = newCurrentPage
    getDeliveredOrderList()
  }
</script>

<style scoped>
  .commodity-info {
    display: flex;
    align-items: center;
  }

  .dialog-footer {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
  }
</style>
