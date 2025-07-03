<template>
  <ArtTableFullScreen>
    <div class="delivery-delivering-page" id="table-full-screen">
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
              <ElTag type="warning">配送中运单</ElTag>
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

        <!-- 更新配送状态对话框 -->
        <ElDialog v-model="dialogVisible" title="更新配送状态" width="500px" align-center>
          <ElForm ref="formRef" :model="formData" :rules="rules" label-width="120px">
            <ElFormItem label="运单号">
              <ElInput v-model="currentOrder.orderNumber" disabled />
            </ElFormItem>
            <ElFormItem label="商品信息">
              <div class="commodity-info">
                <ElImage
                  :src="currentOrder.commodityImage"
                  style="width: 50px; height: 50px; border-radius: 4px; margin-right: 10px"
                  fit="cover"
                />
                <div>
                  <div style="font-weight: 500">{{ currentOrder.commodityName }}</div>
                  <div style="font-size: 12px; color: #666"
                    >数量：{{ currentOrder.quantity }} 件</div
                  >
                </div>
              </div>
            </ElFormItem>
            <ElFormItem label="收货人信息">
              <div>
                <div style="margin-bottom: 4px"
                  ><strong>{{ currentOrder.receiverName }}</strong></div
                >
                <div style="font-size: 12px; color: #666; margin-bottom: 2px">{{
                  currentOrder.receiverPhone
                }}</div>
                <div style="font-size: 12px; color: #999">{{ currentOrder.receiverAddress }}</div>
              </div>
            </ElFormItem>
            <ElFormItem label="配送状态" prop="status">
              <ElSelect v-model="formData.status" placeholder="请选择配送状态">
                <ElOption label="已送达" value="5" />
                <ElOption label="配送异常" value="7" />
              </ElSelect>
            </ElFormItem>
            <ElFormItem label="跟踪信息" prop="trackingInfo">
              <ElInput
                v-model="formData.trackingInfo"
                type="textarea"
                :rows="3"
                placeholder="请输入配送跟踪信息"
              />
            </ElFormItem>
          </ElForm>
          <template #footer>
            <div class="dialog-footer">
              <ElButton @click="dialogVisible = false">取消</ElButton>
              <ElButton type="primary" @click="handleUpdateStatus">确认更新</ElButton>
            </div>
          </template>
        </ElDialog>
      </ElCard>
    </div>
  </ArtTableFullScreen>
</template>

<script setup lang="ts">
  import { h } from 'vue'
  import { SHIPPING_ORDER_DATA } from '@/mock/temp/formData'
  // import { SHIPPING_ORDER_DATA, VEHICLE_LIST_DATA } from '@/mock/temp/formData'
  import { ElDialog, FormInstance, ElImage, ElTag, ElButton } from 'element-plus'
  import { ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { SearchChangeParams, SearchFormItem } from '@/types'

  // const { width } = useWindowSize()

  defineOptions({ name: 'DeliveryDelivering' })

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

  // 表单数据
  const formRef = ref<FormInstance>()
  const formData = reactive({
    status: '',
    trackingInfo: ''
  })

  // 重置表单
  const handleReset = () => {
    Object.assign(formFilters, { ...initialSearchState })
    pagination.currentPage = 1
    getDeliveringOrderList()
  }

  // 搜索处理
  const handleSearch = () => {
    console.log('搜索参数:', formFilters)
    pagination.currentPage = 1
    getDeliveringOrderList()
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

  // 获取配送车辆信息
  const getVehicleInfo = (orderNumber: string) => {
    // 模拟根据运单号获取配送车辆信息
    const vehicleMap: { [key: string]: any } = {
      SO202501160002: { id: 2, plateNumber: '沪B67890' },
      SO202501180004: { id: 4, plateNumber: '沪D22222' }
    }
    return vehicleMap[orderNumber] || { id: '', plateNumber: '' }
  }

  // 获取配送线路信息
  const getRouteInfo = (orderNumber: string) => {
    const routeMap: { [key: string]: string } = {
      SO202501160002: '上海市浦东新区总部 → 浙江省杭州市西湖区分部',
      SO202501180004: '上海市浦东新区总部 → 北京市朝阳区分部'
    }
    return routeMap[orderNumber] || '短途配送无固定线路'
  }

  // 显示更新状态对话框
  const showUpdateDialog = (row: any) => {
    currentOrder.value = { ...row }
    formData.status = ''
    formData.trackingInfo = row.trackingInfo || ''
    dialogVisible.value = true

    // 重置表单验证状态
    if (formRef.value) {
      formRef.value.clearValidate()
    }
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
      width: 280,
      formatter: (row: any) => {
        return h('div', { class: 'flex items-center' }, [
          h(ElImage, {
            src: row.commodityImage,
            style: 'width: 40px; height: 40px; border-radius: 4px; margin-right: 10px',
            fit: 'cover'
          }),
          h('div', [
            h('div', { style: 'font-weight: 500; margin-bottom: 2px' }, row.commodityName),
            h('div', { style: 'font-size: 12px; color: #666' }, `数量：${row.quantity} 件`)
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
      width: 150,
      formatter: (row: any) => {
        const vehicle = getVehicleInfo(row.orderNumber)
        return h('div', [
          h('div', { style: 'font-weight: 500; margin-bottom: 2px' }, `车辆ID: ${vehicle.id}`),
          h('div', { style: 'font-size: 12px; color: #666' }, `车牌: ${vehicle.plateNumber}`)
        ])
      }
    },
    {
      prop: 'route',
      label: '配送线路',
      width: 250,
      formatter: (row: any) => {
        return getRouteInfo(row.orderNumber)
      }
    },
    {
      prop: 'status',
      label: '订单状态',
      width: 100
      // formatter: (row: any) => {
      //   return h(ElTag, { type: 'warning' }, () => '配送中')
      // }
    },
    {
      prop: 'deliveryPersonName',
      label: '配送员',
      width: 120
    },
    {
      prop: 'trackingInfo',
      label: '跟踪信息',
      width: 200
    },
    {
      prop: 'createTime',
      label: '创建时间',
      sortable: true,
      width: 160
    },
    {
      prop: 'operation',
      label: '操作',
      width: 120,
      fixed: 'right',
      formatter: (row: any) => {
        return h('div', [
          h(ArtButtonTable, {
            type: 'edit',
            text: '更新状态',
            onClick: () => showUpdateDialog(row)
          })
        ])
      }
    }
  ])

  onMounted(() => {
    getDeliveringOrderList()
  })

  // 获取配送中运单列表数据
  const getDeliveringOrderList = async () => {
    loading.value = true
    try {
      // 模拟API调用
      await new Promise((resolve) => setTimeout(resolve, 500))

      // 过滤配送中的运单（status='4'）
      let filteredData = SHIPPING_ORDER_DATA.filter((item) => item.status === '4')

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

      if (formFilters.plateNumber) {
        filteredData = filteredData.filter((item) => {
          const vehicle = getVehicleInfo(item.orderNumber)
          return vehicle.plateNumber.toLowerCase().includes(formFilters.plateNumber.toLowerCase())
        })
      }

      // 分页处理
      const startIndex = (pagination.currentPage - 1) * pagination.pageSize
      const endIndex = startIndex + pagination.pageSize
      tableData.value = filteredData.slice(startIndex, endIndex)
      pagination.total = filteredData.length

      console.log('配送中运单列表:', tableData.value)
    } catch (error) {
      console.error('获取配送中运单列表失败:', error)
    } finally {
      loading.value = false
    }
  }

  const handleRefresh = () => {
    getDeliveringOrderList()
  }

  // 处理表格行选择变化
  const handleSelectionChange = (selection: any[]) => {
    selectedRows.value = selection
  }

  // 处理分页大小变化
  const handleSizeChange = (newPageSize: number) => {
    pagination.pageSize = newPageSize
    pagination.currentPage = 1
    getDeliveringOrderList()
  }

  // 处理当前页变化
  const handleCurrentChange = (newCurrentPage: number) => {
    pagination.currentPage = newCurrentPage
    getDeliveringOrderList()
  }

  // 表单验证规则
  const rules = reactive<FormRules>({
    status: [{ required: true, message: '请选择配送状态', trigger: 'change' }],
    trackingInfo: [{ required: true, message: '请输入跟踪信息', trigger: 'blur' }]
  })

  // 更新配送状态
  const handleUpdateStatus = () => {
    if (!formRef.value) return

    formRef.value.validate((valid) => {
      if (valid) {
        // 模拟API调用
        console.log('更新配送状态:', {
          orderId: currentOrder.value.id,
          status: formData.status,
          trackingInfo: formData.trackingInfo
        })

        ElMessage.success('配送状态更新成功')
        dialogVisible.value = false
        getDeliveringOrderList()
      }
    })
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
