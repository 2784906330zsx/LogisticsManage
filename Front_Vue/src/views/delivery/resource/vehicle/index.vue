<template>
  <ArtTableFullScreen>
    <div class="vehicle-page" id="table-full-screen">
      <!-- 搜索栏 -->
      <ArtSearchBar
        v-model:filter="formFilters"
        :items="formItems"
        @reset="handleReset"
        @search="handleSearch"
      ></ArtSearchBar>

      <ElCard shadow="never" class="art-table-card">
        <!-- 表格头部 -->
        <ArtTableHeader v-model:columns="columnChecks" @refresh="handleRefresh">
          <template #left>
            <ElButton @click="showDialog('add')">新增车辆</ElButton>
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

        <!-- 新增/编辑对话框 -->
        <ElDialog
          v-model="dialogVisible"
          :title="dialogType === 'add' ? '新增车辆' : '编辑车辆'"
          width="40%"
          align-center
        >
          <ElForm ref="formRef" :model="formData" :rules="rules" label-width="100px">
            <ElFormItem label="车辆类型" prop="type">
              <ElSelect v-model="formData.type" @change="handleTypeChange">
                <ElOption label="电动三轮车" value="电动三轮车" />
                <ElOption label="面包车" value="面包车" />
                <ElOption label="小型卡车" value="小型卡车" />
                <ElOption label="中型卡车" value="中型卡车" />
                <ElOption label="大型卡车" value="大型卡车" />
              </ElSelect>
            </ElFormItem>
            <ElFormItem label="当前载货量" prop="currentLoad">
              <ElInputNumber v-model="formData.currentLoad" :min="0" :max="formData.maxLoad" />
            </ElFormItem>
            <ElFormItem label="最大载货量" prop="maxLoad">
              <ElInputNumber v-model="formData.maxLoad" :min="0" readonly />
            </ElFormItem>
            <ElFormItem label="健康状态" prop="healthStatus">
              <ElSelect v-model="formData.healthStatus">
                <ElOption label="正常" value="正常" />
                <ElOption label="小破" value="小破" />
                <ElOption label="大破" value="大破" />
              </ElSelect>
            </ElFormItem>
            <ElFormItem label="车牌号" prop="plateNumber">
              <ElInput v-model="formData.plateNumber" placeholder="请输入车牌号" />
            </ElFormItem>
            <ElFormItem label="购入时间" prop="purchaseTime">
              <ElDatePicker
                v-model="formData.purchaseTime"
                type="datetime"
                placeholder="请选择购入时间"
                format="YYYY-MM-DD HH:mm:ss"
                value-format="YYYY-MM-DD HH:mm:ss"
              />
            </ElFormItem>
            <ElFormItem label="在库状态" prop="storageStatus">
              <ElSelect v-model="formData.storageStatus" @change="handleStorageStatusChange">
                <ElOption label="在库待命" value="在库待命" />
                <ElOption label="在库维修" value="在库维修" />
                <ElOption label="外出送货" value="外出送货" />
                <ElOption label="外出维修" value="外出维修" />
              </ElSelect>
            </ElFormItem>
            <ElFormItem
              v-if="formData.storageStatus === '外出送货'"
              label="当前运行线路"
              prop="currentRoute"
            >
              <ElSelect v-model="formData.currentRoute" placeholder="请选择运行线路">
                <ElOption label="短途/市内配送中，无固定线路" value="短途/市内配送中，无固定线路" />
                <ElOption
                  v-for="route in availableRoutes"
                  :key="route.id"
                  :label="`${route.departure} → ${route.destination}`"
                  :value="`${route.departure} → ${route.destination}`"
                />
              </ElSelect>
            </ElFormItem>
            <ElFormItem label="是否启用" prop="isEnabled">
              <ElSwitch v-model="formData.isEnabled" />
            </ElFormItem>
          </ElForm>
          <template #footer>
            <div class="dialog-footer">
              <ElButton @click="dialogVisible = false">取消</ElButton>
              <ElButton type="primary" @click="handleSubmit">提交</ElButton>
            </div>
          </template>
        </ElDialog>
      </ElCard>
    </div>
  </ArtTableFullScreen>
</template>

<script setup lang="ts">
  import { h } from 'vue'
  import { VEHICLE_LIST_DATA, STATIC_ROUTE_LIST_DATA } from '@/mock/temp/formData'
  import { ElDialog, FormInstance, ElTag, ElProgress } from 'element-plus'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { SearchChangeParams, SearchFormItem } from '@/types'

  defineOptions({ name: 'Vehicle' })

  const dialogType = ref('add')
  const dialogVisible = ref(false)
  const loading = ref(false)

  // 定义表单搜索初始值
  const initialSearchState = {
    type: '',
    healthStatus: '',
    storageStatus: '',
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

  // 获取可用的固定线路（仅启用的线路）
  const availableRoutes = computed(() => {
    return STATIC_ROUTE_LIST_DATA.filter((route) => route.isActive)
  })

  // 重置表单
  const handleReset = () => {
    Object.assign(formFilters, { ...initialSearchState })
    pagination.currentPage = 1
    getVehicleList()
  }

  // 搜索处理
  const handleSearch = () => {
    console.log('搜索参数:', formFilters)
    pagination.currentPage = 1
    getVehicleList()
  }

  // 表单项变更处理
  const handleFormChange = (params: SearchChangeParams): void => {
    console.log('表单项变更:', params)
  }

  // 表单配置项
  const formItems: SearchFormItem[] = [
    {
      label: '车辆类型',
      prop: 'type',
      type: 'select',
      config: {
        clearable: true
      },
      options: () => [
        { label: '电动三轮车', value: '电动三轮车' },
        { label: '面包车', value: '面包车' },
        { label: '小型卡车', value: '小型卡车' },
        { label: '中型卡车', value: '中型卡车' },
        { label: '大型卡车', value: '大型卡车' }
      ],
      onChange: handleFormChange
    },
    {
      label: '健康状态',
      prop: 'healthStatus',
      type: 'select',
      config: {
        clearable: true
      },
      options: () => [
        { label: '正常', value: '正常' },
        { label: '小破', value: '小破' },
        { label: '大破', value: '大破' }
      ],
      onChange: handleFormChange
    },
    {
      label: '在库状态',
      prop: 'storageStatus',
      type: 'select',
      config: {
        clearable: true
      },
      options: () => [
        { label: '在库待命', value: '在库待命' },
        { label: '在库维修', value: '在库维修' },
        { label: '外出送货', value: '外出送货' },
        { label: '外出维修', value: '外出维修' }
      ],
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

  // 获取健康状态标签类型
  const getHealthStatusTagType = (status: string) => {
    switch (status) {
      case '正常':
        return 'success'
      case '小破':
        return 'warning'
      case '大破':
        return 'danger'
      default:
        return 'info'
    }
  }

  // 获取在库状态标签类型
  const getStorageStatusTagType = (status: string) => {
    switch (status) {
      case '在库待命':
        return 'success'
      case '在库维修':
        return 'warning'
      case '外出送货':
        return 'primary'
      case '外出维修':
        return 'danger'
      default:
        return 'info'
    }
  }

  // 根据车辆类型设置最大载货量
  const handleTypeChange = (type: string) => {
    const loadMap: { [key: string]: number } = {
      电动三轮车: 2,
      面包车: 4,
      小型卡车: 8,
      中型卡车: 16,
      大型卡车: 32
    }
    formData.maxLoad = loadMap[type] || 0
    if (formData.currentLoad > formData.maxLoad) {
      formData.currentLoad = 0
    }
  }

  // 处理在库状态变更
  const handleStorageStatusChange = (status: string) => {
    if (status !== '外出送货') {
      formData.currentRoute = ''
    }
  }

  // 显示对话框
  const showDialog = (type: string, row?: any) => {
    dialogVisible.value = true
    dialogType.value = type

    // 重置表单验证状态
    if (formRef.value) {
      formRef.value.resetFields()
    }

    if (type === 'edit' && row) {
      formData.type = row.type
      formData.currentLoad = row.currentLoad
      formData.maxLoad = row.maxLoad
      formData.healthStatus = row.healthStatus
      formData.plateNumber = row.plateNumber
      formData.purchaseTime = row.purchaseTime
      formData.storageStatus = row.storageStatus
      formData.currentRoute = row.currentRoute || ''
      formData.isEnabled = row.isEnabled
    } else {
      formData.type = ''
      formData.currentLoad = 0
      formData.maxLoad = 0
      formData.healthStatus = '正常'
      formData.plateNumber = ''
      formData.purchaseTime = ''
      formData.storageStatus = '在库待命'
      formData.currentRoute = ''
      formData.isEnabled = true
    }
  }

  // 删除车辆
  const deleteVehicle = () => {
    ElMessageBox.confirm('确定要删除该车辆吗？', '删除车辆', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'error'
    }).then(() => {
      ElMessage.success('删除成功')
    })
  }

  // 动态列配置
  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection' },
    {
      prop: 'id',
      label: '车辆ID',
      width: 80
    },
    {
      prop: 'type',
      label: '车辆类型',
      width: 120
    },
    {
      prop: 'load',
      label: '载货量',
      minWidth: 200,
      formatter: (row: any) => {
        const percentage = (row.currentLoad / row.maxLoad) * 100
        return h('div', { style: 'display: flex; align-items: center; gap: 8px' }, [
          h(ElProgress, {
            percentage: percentage,
            strokeWidth: 8,
            textInside: true,
            status: percentage > 80 ? 'exception' : percentage > 60 ? 'warning' : 'success'
          }),
          h('span', { style: 'font-size: 12px; color: #666' }, `${row.currentLoad}/${row.maxLoad}`)
        ])
      }
    },
    {
      prop: 'healthStatus',
      label: '健康状态',
      formatter: (row) => {
        return h(ElTag, { type: getHealthStatusTagType(row.healthStatus) }, () => row.healthStatus)
      }
    },
    {
      prop: 'plateNumber',
      label: '车牌号',
      width: 120
    },
    {
      prop: 'purchaseTime',
      label: '购入时间',
      sortable: true,
      width: 160
    },
    {
      prop: 'storageStatus',
      label: '在库状态',
      formatter: (row) => {
        return h(
          ElTag,
          { type: getStorageStatusTagType(row.storageStatus) },
          () => row.storageStatus
        )
      }
    },
    {
      prop: 'currentRoute',
      label: '当前运行线路',
      minWidth: 200,
      formatter: (row) => {
        if (row.storageStatus === '外出送货' && row.currentRoute) {
          return h('span', { style: 'color: #409eff' }, row.currentRoute)
        }
        return h('span', { style: 'color: #909399' }, '-')
      }
    },
    {
      prop: 'isEnabled',
      label: '是否启用',
      formatter: (row) => {
        return h(ElTag, { type: row.isEnabled ? 'success' : 'danger' }, () =>
          row.isEnabled ? '启用' : '禁用'
        )
      }
    },
    {
      prop: 'operation',
      label: '操作',
      width: 150,
      formatter: (row: any) => {
        return h('div', [
          h(ArtButtonTable, {
            type: 'edit',
            onClick: () => showDialog('edit', row)
          }),
          h(ArtButtonTable, {
            type: 'delete',
            onClick: () => deleteVehicle()
          })
        ])
      }
    }
  ])

  // 表单实例
  const formRef = ref<FormInstance>()

  // 表单数据
  const formData = reactive({
    type: '',
    currentLoad: 0,
    maxLoad: 0,
    healthStatus: '正常',
    plateNumber: '',
    purchaseTime: '',
    storageStatus: '在库待命',
    currentRoute: '',
    isEnabled: true
  })

  onMounted(() => {
    getVehicleList()
  })

  // 获取车辆列表数据
  const getVehicleList = async () => {
    loading.value = true
    try {
      const { currentPage, pageSize } = pagination

      // 模拟API调用
      await new Promise((resolve) => setTimeout(resolve, 500))

      // 过滤数据
      let filteredData = [...VEHICLE_LIST_DATA]

      if (formFilters.type) {
        filteredData = filteredData.filter((item) => item.type === formFilters.type)
      }

      if (formFilters.healthStatus) {
        filteredData = filteredData.filter((item) => item.healthStatus === formFilters.healthStatus)
      }

      if (formFilters.storageStatus) {
        filteredData = filteredData.filter(
          (item) => item.storageStatus === formFilters.storageStatus
        )
      }

      if (formFilters.plateNumber) {
        filteredData = filteredData.filter((item) =>
          item.plateNumber.toLowerCase().includes(formFilters.plateNumber.toLowerCase())
        )
      }

      const total = filteredData.length
      const start = (currentPage - 1) * pageSize
      const end = start + pageSize

      tableData.value = filteredData.slice(start, end)
      pagination.total = total
    } catch (error) {
      console.error('获取车辆列表失败:', error)
    } finally {
      loading.value = false
    }
  }

  const handleRefresh = () => {
    getVehicleList()
  }

  // 处理表格行选择变化
  const handleSelectionChange = (selection: any[]) => {
    selectedRows.value = selection
  }

  // 表单验证规则
  const rules = reactive<FormRules>({
    type: [{ required: true, message: '请选择车辆类型', trigger: 'change' }],
    currentLoad: [{ required: true, message: '请输入当前载货量', trigger: 'blur' }],
    maxLoad: [{ required: true, message: '请输入最大载货量', trigger: 'blur' }],
    healthStatus: [{ required: true, message: '请选择健康状态', trigger: 'change' }],
    plateNumber: [
      { required: true, message: '请输入车牌号', trigger: 'blur' },
      { min: 6, max: 8, message: '车牌号长度在 6 到 8 个字符', trigger: 'blur' }
    ],
    purchaseTime: [{ required: true, message: '请选择购入时间', trigger: 'change' }],
    storageStatus: [{ required: true, message: '请选择在库状态', trigger: 'change' }],
    currentRoute: [
      {
        validator: (rule: any, value: string, callback: any) => {
          if (formData.storageStatus === '外出送货' && !value) {
            callback(new Error('外出送货状态下必须选择运行线路'))
          } else {
            callback()
          }
        },
        trigger: 'change'
      }
    ]
  })

  // 提交表单
  const handleSubmit = async () => {
    if (!formRef.value) return

    await formRef.value.validate((valid) => {
      if (valid) {
        ElMessage.success(dialogType.value === 'add' ? '添加成功' : '更新成功')
        dialogVisible.value = false
        getVehicleList()
      }
    })
  }

  // 处理表格分页变化
  const handleSizeChange = (newPageSize: number) => {
    pagination.pageSize = newPageSize
    getVehicleList()
  }

  const handleCurrentChange = (newCurrentPage: number) => {
    pagination.currentPage = newCurrentPage
    getVehicleList()
  }
</script>

<style lang="scss" scoped>
  .vehicle-page {
    // 可以添加自定义样式
  }
</style>
