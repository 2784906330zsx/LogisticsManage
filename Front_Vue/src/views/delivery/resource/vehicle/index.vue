<template>
  <ArtTableFullScreen>
    <div class="vehicle-management-page" id="table-full-screen">
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
              <ElTag type="primary">车辆管理</ElTag>
              <span class="text-sm text-gray-500">共 {{ pagination.total }} 辆车</span>
            </div>
          </template>
          <template #right>
            <ElButton type="primary" @click="showAddDialog">
              <ElIcon><Plus /></ElIcon>
              新增车辆
            </ElButton>
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

        <!-- 新增/编辑车辆对话框 -->
        <ElDialog v-model="dialogVisible" :title="dialogTitle" width="700px" align-center>
          <ElForm ref="formRef" :model="formData" :rules="rules" label-width="120px">
            <ElRow :gutter="20">
              <ElCol :span="12">
                <ElFormItem label="车辆类型" prop="vehicleType">
                  <ElSelect v-model="formData.vehicleType" placeholder="请选择车辆类型">
                    <ElOption label="电动三轮车" value="电动三轮车" />
                    <ElOption label="面包车" value="面包车" />
                    <ElOption label="小型卡车" value="小型卡车" />
                    <ElOption label="中型卡车" value="中型卡车" />
                    <ElOption label="大型卡车" value="大型卡车" />
                  </ElSelect>
                </ElFormItem>
              </ElCol>
              <ElCol :span="12">
                <ElFormItem label="车牌号" prop="plateNumber">
                  <ElInput v-model="formData.plateNumber" placeholder="请输入车牌号" />
                </ElFormItem>
              </ElCol>
            </ElRow>
            <ElRow :gutter="20">
              <ElCol :span="12">
                <ElFormItem label="当前载货量" prop="currentLoad">
                  <ElInputNumber v-model="formData.currentLoad" :min="0" placeholder="当前载货量" />
                </ElFormItem>
              </ElCol>
              <ElCol :span="12">
                <ElFormItem label="最大载货量" prop="maxLoad">
                  <ElInputNumber v-model="formData.maxLoad" :min="1" placeholder="最大载货量" />
                </ElFormItem>
              </ElCol>
            </ElRow>
            <ElRow :gutter="20">
              <ElCol :span="12">
                <ElFormItem label="健康状态" prop="healthStatus">
                  <ElSelect v-model="formData.healthStatus" placeholder="请选择健康状态">
                    <ElOption label="正常" value="正常" />
                    <ElOption label="小破" value="小破" />
                    <ElOption label="大破" value="大破" />
                  </ElSelect>
                </ElFormItem>
              </ElCol>
              <ElCol :span="12">
                <ElFormItem label="在库状态" prop="storageStatus">
                  <ElSelect v-model="formData.storageStatus" placeholder="请选择在库状态">
                    <ElOption label="在库待命" value="在库待命" />
                    <ElOption label="在库维修" value="在库维修" />
                    <ElOption label="外出送货" value="外出送货" />
                    <ElOption label="外出维修" value="外出维修" />
                  </ElSelect>
                </ElFormItem>
              </ElCol>
            </ElRow>
            <ElFormItem label="当前运行线路" prop="currentRoute">
              <ElInput v-model="formData.currentRoute" placeholder="请输入当前运行线路" />
            </ElFormItem>

            <!-- 司机信息区域 -->
            <ElFormItem label="司机工号" prop="driverJobNumber">
              <div class="driver-input-container">
                <ElInput
                  v-model="formData.driverJobNumber"
                  placeholder="请输入司机工号"
                  @blur="handleDriverJobNumberChange"
                  @input="handleDriverJobNumberInput"
                  style="width: 200px"
                />
                <ElButton
                  type="primary"
                  :loading="driverLoading"
                  @click="searchDriverInfo"
                  style="margin-left: 10px"
                >
                  查询司机
                </ElButton>
              </div>
            </ElFormItem>

            <!-- 司机信息显示 -->
            <ElFormItem label="司机信息" v-if="driverInfo.name || driverInfo.avatar">
              <div class="driver-info-display">
                <div class="driver-avatar">
                  <ElAvatar :size="60" :src="driverInfo.avatar" :alt="driverInfo.name">
                    <ElIcon><User /></ElIcon>
                  </ElAvatar>
                </div>
                <div class="driver-details">
                  <div class="driver-name">{{ driverInfo.name || '未知' }}</div>
                  <div class="driver-job-number">工号: {{ formData.driverJobNumber }}</div>
                  <div class="driver-status" v-if="driverInfo.status">
                    <ElTag
                      :type="driverInfo.status === '在职' ? 'success' : 'warning'"
                      size="small"
                    >
                      {{ driverInfo.status }}
                    </ElTag>
                  </div>
                </div>
              </div>
            </ElFormItem>

            <ElRow :gutter="20">
              <ElCol :span="12">
                <ElFormItem label="购入时间" prop="purchaseTime">
                  <ElDatePicker
                    v-model="formData.purchaseTime"
                    type="datetime"
                    placeholder="请选择购入时间"
                    format="YYYY-MM-DD HH:mm:ss"
                    value-format="YYYY-MM-DD HH:mm:ss"
                  />
                </ElFormItem>
              </ElCol>
              <ElCol :span="12">
                <ElFormItem label="是否启用" prop="isEnabled">
                  <ElSwitch v-model="formData.isEnabled" />
                </ElFormItem>
              </ElCol>
            </ElRow>
          </ElForm>
          <template #footer>
            <div class="dialog-footer">
              <ElButton @click="dialogVisible = false">取消</ElButton>
              <ElButton type="primary" @click="handleSubmit">确认</ElButton>
            </div>
          </template>
        </ElDialog>
      </ElCard>
    </div>
  </ArtTableFullScreen>
</template>

<script setup lang="ts">
  import { h } from 'vue'
  import {
    ElDialog,
    ElButton,
    ElTag,
    ElIcon,
    ElSwitch,
    ElAvatar,
    FormInstance,
    ElMessage,
    ElMessageBox
  } from 'element-plus'
  import { Plus, User } from '@element-plus/icons-vue'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { SearchChangeParams, SearchFormItem } from '@/types'
  import { DeliveryService, VehicleItem } from '@/api/deliveryApi'

  defineOptions({ name: 'VehicleManagement' })

  const dialogVisible = ref(false)
  const loading = ref(false)
  const driverLoading = ref(false)
  const dialogTitle = ref('新增车辆')
  const isEdit = ref(false)

  // 司机信息接口
  interface DriverInfo {
    name: string
    avatar: string
    status: string
    jobNumber: string
  }

  // 司机信息状态
  const driverInfo = reactive<DriverInfo>({
    name: '',
    avatar: '',
    status: '',
    jobNumber: ''
  })

  // 定义表单搜索初始值
  const initialSearchState = {
    plateNumber: '',
    vehicleType: '',
    healthStatus: '',
    storageStatus: '',
    isEnabled: ''
  }

  // 响应式表单数据
  const formFilters = reactive({ ...initialSearchState })

  const pagination = reactive({
    currentPage: 1,
    pageSize: 20,
    total: 0
  })

  // 表格数据
  const tableData = ref<VehicleItem[]>([])

  // 表格实例引用
  const tableRef = ref()
  const formRef = ref<FormInstance>()

  // 选中的行数据
  const selectedRows = ref<any[]>([])

  // 表单数据
  const formData = reactive<{
    id: number | null
    vehicleType: string
    plateNumber: string
    currentLoad: number
    maxLoad: number
    healthStatus: '正常' | '小破' | '大破'
    storageStatus: '在库待命' | '在库维修' | '外出送货' | '外出维修'
    currentRoute: string
    driverJobNumber: string
    purchaseTime: string
    isEnabled: boolean
  }>({
    id: null,
    vehicleType: '',
    plateNumber: '',
    currentLoad: 0,
    maxLoad: 1,
    healthStatus: '正常',
    storageStatus: '在库待命',
    currentRoute: '',
    driverJobNumber: '',
    purchaseTime: '',
    isEnabled: true
  })

  // 模拟司机数据
  const mockDriverData: Record<string, DriverInfo> = {
    '100001': {
      name: 'CEO',
      avatar:
        'https://tse2-mm.cn.bing.net/th/id/OIP-C.y1zvENK0EldIdSTEqJWPxwAAAA?w=215&h=215&c=7&r=0&o=5&dpr=1.1&pid=1.7',
      status: '在职',
      jobNumber: '100001'
    },
    EMP001: {
      name: '张三',
      avatar: 'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png',
      status: '在职',
      jobNumber: 'EMP001'
    },
    EMP002: {
      name: '李四',
      avatar: 'https://cube.elemecdn.com/9/c2/f0ee8a3c7c9638a54940382568c9dpng.png',
      status: '在职',
      jobNumber: 'EMP002'
    },
    EMP003: {
      name: '王五',
      avatar: 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png',
      status: '在职',
      jobNumber: 'EMP003'
    }
  }

  // 查询司机信息
  const searchDriverInfo = async () => {
    if (!formData.driverJobNumber.trim()) {
      ElMessage.warning('请输入司机工号')
      return
    }

    driverLoading.value = true
    try {
      // 模拟API调用延迟
      await new Promise((resolve) => setTimeout(resolve, 500))

      const driver = mockDriverData[formData.driverJobNumber]
      if (driver) {
        Object.assign(driverInfo, driver)
        ElMessage.success('司机信息查询成功')
      } else {
        // 清空司机信息
        Object.assign(driverInfo, {
          name: '',
          avatar: '',
          status: '',
          jobNumber: ''
        })
        ElMessage.warning('未找到该工号对应的司机信息')
      }
    } catch (error) {
      console.error('查询司机信息失败:', error)
      ElMessage.error('查询司机信息失败')
    } finally {
      driverLoading.value = false
    }
  }

  // 司机工号输入处理
  const handleDriverJobNumberInput = () => {
    // 清空之前的司机信息
    if (driverInfo.name) {
      Object.assign(driverInfo, {
        name: '',
        avatar: '',
        status: '',
        jobNumber: ''
      })
    }
  }

  // 司机工号失焦处理
  const handleDriverJobNumberChange = () => {
    if (formData.driverJobNumber.trim()) {
      searchDriverInfo()
    }
  }

  // 表单验证规则
  const rules = reactive<FormRules>({
    vehicleType: [{ required: true, message: '请选择车辆类型', trigger: 'change' }],
    plateNumber: [{ required: true, message: '请输入车牌号', trigger: 'blur' }],
    maxLoad: [{ required: true, message: '请输入最大载货量', trigger: 'blur' }],
    driverJobNumber: [{ required: true, message: '请输入司机工号', trigger: 'blur' }],
    purchaseTime: [{ required: true, message: '请选择购入时间', trigger: 'change' }]
  })

  // 重置表单
  const handleReset = () => {
    Object.assign(formFilters, { ...initialSearchState })
    pagination.currentPage = 1
    getVehicleList()
  }

  // 搜索处理
  const handleSearch = () => {
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
      label: '车牌号',
      prop: 'plateNumber',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '车辆类型',
      prop: 'vehicleType',
      type: 'select',
      config: {
        clearable: true,
        options: [
          { label: '电动三轮车', value: '电动三轮车' },
          { label: '面包车', value: '面包车' },
          { label: '小型卡车', value: '小型卡车' },
          { label: '中型卡车', value: '中型卡车' },
          { label: '大型卡车', value: '大型卡车' }
        ]
      },
      onChange: handleFormChange
    },
    {
      label: '健康状态',
      prop: 'healthStatus',
      type: 'select',
      config: {
        clearable: true,
        options: [
          { label: '正常', value: '正常' },
          { label: '小破', value: '小破' },
          { label: '大破', value: '大破' }
        ]
      },
      onChange: handleFormChange
    },
    {
      label: '在库状态',
      prop: 'storageStatus',
      type: 'select',
      config: {
        clearable: true,
        options: [
          { label: '在库待命', value: '在库待命' },
          { label: '在库维修', value: '在库维修' },
          { label: '外出送货', value: '外出送货' },
          { label: '外出维修', value: '外出维修' }
        ]
      },
      onChange: handleFormChange
    },
    {
      label: '启用状态',
      prop: 'isEnabled',
      type: 'select',
      config: {
        clearable: true,
        options: [
          { label: '启用', value: 'true' },
          { label: '禁用', value: 'false' }
        ]
      },
      onChange: handleFormChange
    }
  ]

  // 显示新增对话框
  const showAddDialog = () => {
    dialogTitle.value = '新增车辆'
    isEdit.value = false
    resetFormData()
    dialogVisible.value = true
  }

  // 显示编辑对话框
  const showEditDialog = (row: VehicleItem) => {
    dialogTitle.value = '编辑车辆'
    isEdit.value = true
    Object.assign(formData, row)
    // 查询司机信息
    if (formData.driverJobNumber) {
      searchDriverInfo()
    }
    dialogVisible.value = true
  }

  // 重置表单数据
  const resetFormData = () => {
    Object.assign(formData, {
      id: null,
      vehicleType: '',
      plateNumber: '',
      currentLoad: 0,
      maxLoad: 1,
      healthStatus: '正常',
      storageStatus: '在库待命',
      currentRoute: '',
      driverJobNumber: '',
      purchaseTime: '',
      isEnabled: true
    })
    // 清空司机信息
    Object.assign(driverInfo, {
      name: '',
      avatar: '',
      status: '',
      jobNumber: ''
    })
    if (formRef.value) {
      formRef.value.resetFields()
    }
  }

  // 提交表单
  const handleSubmit = async () => {
    if (!formRef.value) return

    try {
      await formRef.value.validate()

      if (isEdit.value) {
        if (formData.id === null) {
          ElMessage.error('编辑时ID不能为空')
          return
        }
        await DeliveryService.updateVehicle(formData as typeof formData & { id: number })
        ElMessage.success('车辆信息更新成功')
      } else {
        // eslint-disable-next-line @typescript-eslint/no-unused-vars
        const { id, ...addData } = formData
        await DeliveryService.addVehicle(addData)
        ElMessage.success('车辆创建成功')
      }

      dialogVisible.value = false
      getVehicleList()
    } catch (error) {
      console.error('提交失败:', error)
      ElMessage.error('操作失败，请重试')
    }
  }

  // 删除车辆
  const handleDelete = async (row: VehicleItem) => {
    try {
      await ElMessageBox.confirm(`确定要删除车辆 "${row.plateNumber}" 吗？`, '删除确认', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })

      await DeliveryService.deleteVehicle({ id: row.id })
      ElMessage.success('车辆删除成功')
      getVehicleList()
    } catch (error) {
      if (error !== 'cancel') {
        console.error('删除失败:', error)
        ElMessage.error('删除失败，请重试')
      }
    }
  }

  // 动态列配置
  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection' },
    {
      prop: 'plateNumber',
      label: '车牌号',
      width: 100,
      fixed: 'left'
    },
    {
      prop: 'vehicleType',
      label: '车辆类型',
      width: 120
    },
    {
      prop: 'loadInfo',
      label: '载货信息',
      width: 120,
      formatter: (row: VehicleItem) => {
        return h('div', [
          h('div', { style: 'margin-bottom: 2px' }, `${row.currentLoad}/${row.maxLoad}`),
          h('div', { style: 'font-size: 12px; color: #666' }, `载货率: ${row.loadRate}%`)
        ])
      }
    },
    {
      prop: 'healthStatus',
      label: '健康状态',
      width: 80,
      formatter: (row: VehicleItem) => {
        const typeMap: Record<string, 'success' | 'warning' | 'danger' | 'info' | 'primary'> = {
          正常: 'success',
          小破: 'warning',
          大破: 'danger'
        }
        const tagType = typeMap[row.healthStatus] || 'info'
        return h(ElTag, { type: tagType }, () => row.healthStatus)
      }
    },
    {
      prop: 'storageStatus',
      label: '在库状态',
      width: 100,
      formatter: (row: VehicleItem) => {
        const typeMap: Record<string, 'success' | 'warning' | 'danger' | 'info' | 'primary'> = {
          在库待命: 'success',
          在库维修: 'warning',
          外出送货: 'primary',
          外出维修: 'danger'
        }
        const tagType = typeMap[row.storageStatus] || 'info'
        return h(ElTag, { type: tagType }, () => row.storageStatus)
      }
    },
    {
      prop: 'currentRoute',
      label: '当前线路',
      width: 200,
      showOverflowTooltip: true
    },
    {
      prop: 'driverInfo',
      label: '司机信息',
      width: 160,
      formatter: (row: VehicleItem) => {
        // 根据工号获取司机信息
        const driver = mockDriverData[row.driverJobNumber]
        if (driver) {
          return h('div', { class: 'driver-info-cell' }, [
            h(ElAvatar, {
              size: 32,
              src: driver.avatar,
              style: 'margin-right: 8px; vertical-align: middle;'
            }),
            h('div', { style: 'display: inline-block; vertical-align: middle;' }, [
              h('div', { style: 'font-weight: 500; line-height: 1.2;' }, driver.name),
              h(
                'div',
                { style: 'font-size: 12px; color: #666; line-height: 1.2;' },
                row.driverJobNumber
              )
            ])
          ])
        } else {
          return h('div', { style: 'color: #999;' }, row.driverJobNumber || '未分配')
        }
      }
    },
    {
      prop: 'purchaseTime',
      label: '购入时间',
      width: 160,
      sortable: true
    },
    {
      prop: 'isEnabled',
      label: '启用状态',
      width: 100,
      formatter: (row: VehicleItem) => {
        return h(ElTag, { type: row.isEnabled ? 'success' : 'danger' }, () =>
          row.isEnabled ? '启用' : '禁用'
        )
      }
    },
    {
      prop: 'operation',
      label: '操作',
      width: 150,
      fixed: 'right',
      formatter: (row: VehicleItem) => {
        return h('div', { class: 'flex gap-2' }, [
          h(ArtButtonTable, {
            type: 'edit',
            text: '编辑',
            onClick: () => showEditDialog(row)
          }),
          h(ArtButtonTable, {
            type: 'delete',
            text: '删除',
            onClick: () => handleDelete(row)
          })
        ])
      }
    }
  ])

  // 获取车辆列表
  const getVehicleList = async () => {
    loading.value = true
    try {
      const params = {
        current: pagination.currentPage,
        size: pagination.pageSize,
        ...formFilters
      }

      const response = await DeliveryService.getVehicleList(params)

      if (response.code === 200) {
        tableData.value = response.data.list
        pagination.total = response.data.total
      } else {
        ElMessage.error(response.msg || '获取车辆列表失败')
      }
    } catch (error) {
      console.error('获取车辆列表失败:', error)
      ElMessage.error('获取车辆列表失败')
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

  // 处理分页大小变化
  const handleSizeChange = (newPageSize: number) => {
    pagination.pageSize = newPageSize
    pagination.currentPage = 1
    getVehicleList()
  }

  // 处理当前页变化
  const handleCurrentChange = (newCurrentPage: number) => {
    pagination.currentPage = newCurrentPage
    getVehicleList()
  }

  // 页面加载时获取数据
  onMounted(() => {
    getVehicleList()
  })
</script>

<style scoped>
  .vehicle-management-page {
    height: 100%;
  }

  .commodity-info {
    display: flex;
    align-items: center;
  }

  .dialog-footer {
    text-align: right;
  }

  .driver-input-container {
    display: flex;
    align-items: center;
  }

  .driver-info-display {
    display: flex;
    align-items: center;
    padding: 12px;
    background-color: #f5f7fa;
    border-radius: 6px;
    border: 1px solid #e4e7ed;
  }

  .driver-avatar {
    margin-right: 16px;
  }

  .driver-details {
    flex: 1;
  }

  .driver-name {
    font-size: 16px;
    font-weight: 500;
    color: #303133;
    margin-bottom: 4px;
  }

  .driver-job-number {
    font-size: 14px;
    color: #606266;
    margin-bottom: 4px;
  }

  .driver-status {
    margin-top: 4px;
  }

  .driver-info-cell {
    display: flex;
    align-items: center;
  }
</style>
