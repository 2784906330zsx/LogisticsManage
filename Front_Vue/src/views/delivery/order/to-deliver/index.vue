<template>
  <ArtTableFullScreen>
    <div class="delivery-to-deliver">
      <ElCard>
        <ArtTable
          ref="tableRef"
          :data="tableData"
          :loading="loading"
          :columns="columns"
          :column-checks="columnChecks"
          :form-items="formItems"
          :form-filters="formFilters"
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

        <!-- 分配配送车辆和路线对话框 -->
        <ElDialog v-model="dialogVisible" title="分配配送车辆和路线" width="500px" align-center>
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
            <ElFormItem label="配送车辆" prop="vehicleId">
              <ElSelect
                v-model="formData.vehicleId"
                placeholder="请选择配送车辆"
                @change="handleVehicleChange"
                :loading="vehicleLoading"
              >
                <ElOption
                  v-for="vehicle in availableVehicles"
                  :key="vehicle.id"
                  :label="`${vehicle.plateNumber} (${vehicle.vehicleType})`"
                  :value="vehicle.id"
                >
                  <div style="display: flex; justify-content: space-between; align-items: center">
                    <span>{{ vehicle.plateNumber }} ({{ vehicle.vehicleType }})</span>
                    <ElTag
                      :type="vehicle.storageStatus === '在库待命' ? 'success' : 'warning'"
                      size="small"
                    >
                      {{ vehicle.storageStatus }}
                    </ElTag>
                  </div>
                </ElOption>
              </ElSelect>
            </ElFormItem>
            <ElFormItem label="配送路线" prop="routeId">
              <ElSelect
                v-model="formData.routeId"
                placeholder="请选择配送路线"
                :disabled="selectedVehicleStatus === '正在装货'"
                :loading="routeLoading"
              >
                <ElOption
                  v-for="route in availableRoutes"
                  :key="route.id"
                  :label="`${route.departure} → ${route.destination}`"
                  :value="route.id"
                >
                  <div>
                    <div>{{ route.departure }} → {{ route.destination }}</div>
                    <div style="font-size: 12px; color: #999">
                      距离：{{ route.totalDistance }}km，预计：{{ route.estimatedTime }}小时
                    </div>
                  </div>
                </ElOption>
              </ElSelect>
              <div
                v-if="selectedVehicleStatus === '正在装货'"
                style="margin-top: 5px; font-size: 12px; color: #999"
              >
                该车辆正在装货，路线不可修改
              </div>
            </ElFormItem>
          </ElForm>
          <template #footer>
            <div class="dialog-footer">
              <ElButton @click="dialogVisible = false">取消</ElButton>
              <ElButton type="primary" @click="handleAssignDelivery">确认分配</ElButton>
            </div>
          </template>
        </ElDialog>
      </ElCard>
    </div>
  </ArtTableFullScreen>
</template>

<script setup lang="ts">
  import { h, ref, reactive, onMounted } from 'vue'
  // 同时导入两个API服务
  import { DeliveryService as OrderService } from '@/api/orderApi'
  import { DeliveryService as VehicleService } from '@/api/deliveryApi'
  import { ElDialog, FormInstance, ElImage, ElTag, ElButton } from 'element-plus'
  import { ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { SearchChangeParams, SearchFormItem } from '@/types'

  defineOptions({ name: 'DeliveryToDeliver' })

  const dialogVisible = ref(false)
  const loading = ref(false)
  const vehicleLoading = ref(false)
  const routeLoading = ref(false)

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

  // 当前操作的订单
  const currentOrder = ref<any>({})

  // 可用车辆列表
  const availableVehicles = ref<any[]>([])

  // 可用路线列表
  const availableRoutes = ref<any[]>([])

  // 选中车辆的状态
  const selectedVehicleStatus = ref('')

  // 重置表单
  const handleReset = () => {
    Object.assign(formFilters, { ...initialSearchState })
    pagination.currentPage = 1
    getToDeliverOrderList()
  }

  // 搜索处理
  const handleSearch = () => {
    console.log('搜索参数:', formFilters)
    pagination.currentPage = 1
    getToDeliverOrderList()
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

  // 显示分配对话框
  const showAssignDialog = async (row: any) => {
    currentOrder.value = { ...row }
    dialogVisible.value = true

    // 重置表单数据
    formData.vehicleId = ''
    formData.routeId = ''
    selectedVehicleStatus.value = ''

    // 重置表单验证状态
    if (formRef.value) {
      formRef.value.resetFields()
    }

    // 加载可用车辆
    await loadAvailableVehicles()
  }

  // 加载可用车辆列表
  const loadAvailableVehicles = async () => {
    vehicleLoading.value = true
    try {
      const response = await VehicleService.getVehicleList({
        current: 1,
        size: 1000, // 获取所有车辆
        isEnabled: 'true' // 只获取启用的车辆
      })

      if (response.code === 200) {
        // 筛选状态为启用、在库状态为"在库待命"或"正在装货"的车辆
        availableVehicles.value = response.data.list.filter(
          (vehicle: any) =>
            vehicle.isEnabled &&
            (vehicle.storageStatus === '在库待命' || vehicle.storageStatus === '正在装货')
        )
      } else {
        ElMessage.error('获取车辆列表失败')
        availableVehicles.value = []
      }
    } catch (error) {
      console.error('获取车辆列表失败:', error)
      ElMessage.error('获取车辆列表失败，请稍后重试')
      availableVehicles.value = []
    } finally {
      vehicleLoading.value = false
    }
  }

  // 加载可用路线列表
  const loadAvailableRoutes = async () => {
    routeLoading.value = true
    try {
      const response = await VehicleService.getStaticRouteList({
        current: 1,
        size: 1000, // 获取所有路线
        isActive: 'true' // 只获取启用的路线
      })

      if (response.code === 200) {
        availableRoutes.value = response.data.list.filter((route: any) => route.isActive)
      } else {
        ElMessage.error('获取路线列表失败')
        availableRoutes.value = []
      }
    } catch (error) {
      console.error('获取路线列表失败:', error)
      ElMessage.error('获取路线列表失败，请稍后重试')
      availableRoutes.value = []
    } finally {
      routeLoading.value = false
    }
  }

  // 车辆选择变化处理
  const handleVehicleChange = async (vehicleId: string) => {
    const selectedVehicle = availableVehicles.value.find((v) => v.id === vehicleId)
    if (selectedVehicle) {
      selectedVehicleStatus.value = selectedVehicle.storageStatus

      if (selectedVehicle.storageStatus === '正在装货') {
        // 如果是正在装货的车辆，显示其已分配的路线
        if (selectedVehicle.currentRoute && selectedVehicle.currentRoute !== '无') {
          // 先加载所有路线
          await loadAvailableRoutes()

          // 根据currentRoute字段匹配路线
          // currentRoute格式可能是 "出发地 → 目的地"
          const routeMatch = availableRoutes.value.find(
            (route) => `${route.departure} → ${route.destination}` === selectedVehicle.currentRoute
          )

          if (routeMatch) {
            formData.routeId = routeMatch.id
          } else {
            // 如果没有匹配到，清空选择
            formData.routeId = ''
          }
        } else {
          formData.routeId = ''
        }
      } else {
        // 如果是在库待命的车辆，加载可用路线
        await loadAvailableRoutes()
        formData.routeId = ''
      }
    }
  }

  // 动态列配置
  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection' },
    {
      prop: 'orderNumber',
      label: '运单号',
      width: 180,
      fixed: 'left'
    },
    {
      prop: 'commodityInfo',
      label: '商品信息',
      width: 240,
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
      width: 260,
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
      prop: 'status',
      label: '订单状态',
      width: 100,
      formatter: (row: any) => {
        return h(ElTag, { type: 'info' }, () => '待配送')
      }
    },
    {
      prop: 'createTime',
      label: '创建时间',
      sortable: true,
      width: 160
    },
    {
      prop: 'creatorName',
      label: '创建人',
      width: 120
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
            text: '分配配送',
            onClick: () => showAssignDialog(row)
          })
        ])
      }
    }
  ])

  onMounted(() => {
    getToDeliverOrderList()
  })

  // 获取待配送运单列表数据
  const getToDeliverOrderList = async () => {
    loading.value = true
    try {
      const { currentPage, pageSize } = pagination

      const params = {
        current: currentPage,
        size: pageSize,
        orderNumber: formFilters.orderNumber || undefined,
        deliveryStatus: '3' // 使用正确的参数名：deliveryStatus
      }

      const response = await OrderService.getDeliveryOrderList(params)

      if (response.code === 200) {
        tableData.value = response.data.list.map((item: any) => ({
          ...item,
          commodityImage: item.commodityImage || '/default-commodity.png'
        }))
        pagination.total = response.data.total
        pagination.currentPage = response.data.current
        pagination.pageSize = response.data.size
      } else {
        ElMessage.error(response.msg || '获取待配送运单列表失败')
        tableData.value = []
        pagination.total = 0
      }
    } catch (error) {
      console.error('获取待配送运单列表失败:', error)
      ElMessage.error('获取待配送运单列表失败，请稍后重试')
      tableData.value = []
      pagination.total = 0
    } finally {
      loading.value = false
    }
  }

  const handleRefresh = () => {
    getToDeliverOrderList()
  }

  // 处理表格行选择变化
  const handleSelectionChange = (selection: any[]) => {
    selectedRows.value = selection
  }

  // 处理分页大小变化
  const handleSizeChange = (newPageSize: number) => {
    pagination.pageSize = newPageSize
    pagination.currentPage = 1
    getToDeliverOrderList()
  }

  // 处理当前页变化
  const handleCurrentChange = (newCurrentPage: number) => {
    pagination.currentPage = newCurrentPage
    getToDeliverOrderList()
  }

  // 表单实例
  const formRef = ref<FormInstance>()

  // 表单数据
  const formData = reactive({
    vehicleId: '',
    routeId: ''
  })

  // 表单验证规则
  const rules = reactive<FormRules>({
    vehicleId: [{ required: true, message: '请选择配送车辆', trigger: 'change' }],
    routeId: [{ required: true, message: '请选择配送路线', trigger: 'change' }]
  })

  // 分配配送车辆和路线
  const handleAssignDelivery = () => {
    if (!formRef.value) return

    formRef.value.validate(async (valid) => {
      if (valid) {
        try {
          const selectedVehicle = availableVehicles.value.find((v) => v.id === formData.vehicleId)
          const selectedRoute = availableRoutes.value.find((r) => r.id === formData.routeId)

          // 调用运单分配API
          const assignResponse = await VehicleService.assignOrder({
            orderId: currentOrder.value.id,
            vehicleId: formData.vehicleId,
            routeInfo: selectedRoute
              ? {
                  departure: selectedRoute.departure,
                  destination: selectedRoute.destination
                }
              : undefined
          })

          if (assignResponse.code === 200) {
            // 如果选择的是在库待命的车辆，需要更新车辆状态为正在装货
            if (selectedVehicle?.storageStatus === '在库待命') {
              await VehicleService.updateVehicle({
                id: selectedVehicle.id,
                storageStatus: '正在装货',
                currentRoute: `${selectedRoute?.departure} → ${selectedRoute?.destination}`
              })
            }

            ElMessage.success('配送车辆和路线分配成功，运单状态已更新为配送中')
            dialogVisible.value = false
            getToDeliverOrderList()
          } else {
            ElMessage.error(assignResponse.msg || '分配失败')
          }
        } catch (error) {
          console.error('分配失败:', error)
          ElMessage.error('分配失败，请稍后重试')
        }
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
