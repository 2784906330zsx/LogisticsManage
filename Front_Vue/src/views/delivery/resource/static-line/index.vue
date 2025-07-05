<template>
  <ArtTableFullScreen>
    <div class="static-route-page" id="table-full-screen">
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
            <ElButton @click="showDialog('add')">新增线路</ElButton>
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
          :title="dialogType === 'add' ? '新增线路' : '编辑线路'"
          width="50%"
          align-center
        >
          <ElForm ref="formRef" :model="formData" :rules="rules" label-width="100px">
            <ElRow :gutter="20">
              <ElCol :span="12">
                <ElFormItem label="出发地" prop="departure">
                  <ElInput v-model="formData.departure" placeholder="请输入出发地" />
                </ElFormItem>
              </ElCol>
              <ElCol :span="12">
                <ElFormItem label="目的地" prop="destination">
                  <ElInput v-model="formData.destination" placeholder="请输入目的地" />
                </ElFormItem>
              </ElCol>
            </ElRow>
            <ElRow :gutter="20">
              <ElCol :span="12">
                <ElFormItem label="总距离" prop="totalDistance">
                  <ElInputNumber
                    v-model="formData.totalDistance"
                    :min="0"
                    :precision="1"
                    placeholder="请输入总距离"
                  />
                  <span style="margin-left: 8px; color: #666">公里</span>
                </ElFormItem>
              </ElCol>
              <ElCol :span="12">
                <ElFormItem label="预计耗时" prop="estimatedTime">
                  <ElInputNumber
                    v-model="formData.estimatedTime"
                    :min="0"
                    :precision="1"
                    placeholder="请输入预计耗时"
                  />
                  <span style="margin-left: 8px; color: #666">小时</span>
                </ElFormItem>
              </ElCol>
            </ElRow>
            <ElFormItem label="班次信息" prop="scheduleInfo">
              <ElInput
                v-model="formData.scheduleInfo"
                type="textarea"
                :rows="3"
                placeholder="请输入班次信息，如：每日发车：08:00, 14:00, 20:00"
              />
            </ElFormItem>
            <ElFormItem label="是否启用" prop="isActive">
              <ElSwitch v-model="formData.isActive" />
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
  import { STATIC_ROUTE_LIST_DATA } from '@/mock/formData'
  import { ElDialog, FormInstance, ElTag } from 'element-plus'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { SearchChangeParams, SearchFormItem } from '@/types'

  //   const { width } = useWindowSize()

  defineOptions({ name: 'StaticRoute' })

  const dialogType = ref('add')
  const dialogVisible = ref(false)
  const loading = ref(false)

  // 定义表单搜索初始值
  const initialSearchState = {
    departure: '',
    destination: '',
    isActive: ''
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

  // 重置表单
  const handleReset = () => {
    Object.assign(formFilters, { ...initialSearchState })
    pagination.currentPage = 1
    getStaticRouteList()
  }

  // 搜索处理
  const handleSearch = () => {
    console.log('搜索参数:', formFilters)
    pagination.currentPage = 1
    getStaticRouteList()
  }

  // 表单项变更处理
  const handleFormChange = (params: SearchChangeParams): void => {
    console.log('表单项变更:', params)
  }

  // 表单配置项
  const formItems: SearchFormItem[] = [
    {
      label: '出发地',
      prop: 'departure',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '目的地',
      prop: 'destination',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '状态',
      prop: 'isActive',
      type: 'select',
      config: {
        clearable: true
      },
      options: () => [
        { label: '启用', value: 'true' },
        { label: '停用', value: 'false' }
      ],
      onChange: handleFormChange
    }
  ]

  // 显示对话框
  const showDialog = (type: string, row?: any) => {
    dialogVisible.value = true
    dialogType.value = type

    // 重置表单验证状态
    if (formRef.value) {
      formRef.value.resetFields()
    }

    if (type === 'edit' && row) {
      formData.departure = row.departure
      formData.destination = row.destination
      formData.totalDistance = row.totalDistance
      formData.estimatedTime = row.estimatedTime
      formData.scheduleInfo = row.scheduleInfo
      formData.isActive = row.isActive
    } else {
      formData.departure = ''
      formData.destination = ''
      formData.totalDistance = 0
      formData.estimatedTime = 0
      formData.scheduleInfo = ''
      formData.isActive = true
    }
  }

  // 删除线路
  const deleteStaticRoute = () => {
    ElMessageBox.confirm('确定要删除该线路吗？', '删除线路', {
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
      label: '线路ID',
      width: 80
    },
    {
      prop: 'departure',
      label: '出发地',
      minWidth: 150
    },
    {
      prop: 'destination',
      label: '目的地',
      minWidth: 150
    },
    {
      prop: 'totalDistance',
      label: '总距离',
      width: 100,
      formatter: (row: any) => `${row.totalDistance}公里`
    },
    {
      prop: 'estimatedTime',
      label: '预计耗时',
      width: 100,
      formatter: (row: any) => `${row.estimatedTime}小时`
    },
    {
      prop: 'scheduleInfo',
      label: '班次信息',
      minWidth: 200,
      formatter: (row: any) => {
        const text = row.scheduleInfo || ''
        return text.length > 30 ? text.substring(0, 30) + '...' : text
      }
    },
    {
      prop: 'isActive',
      label: '状态',
      width: 80,
      formatter: (row) => {
        return h(ElTag, { type: row.isActive ? 'success' : 'danger' }, () =>
          row.isActive ? '启用' : '停用'
        )
      }
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
      width: 150,
      formatter: (row: any) => {
        return h('div', [
          h(ArtButtonTable, {
            type: 'edit',
            onClick: () => showDialog('edit', row)
          }),
          h(ArtButtonTable, {
            type: 'delete',
            onClick: () => deleteStaticRoute()
          })
        ])
      }
    }
  ])

  // 表单实例
  const formRef = ref<FormInstance>()

  // 表单数据
  const formData = reactive({
    departure: '',
    destination: '',
    totalDistance: 0,
    estimatedTime: 0,
    scheduleInfo: '',
    isActive: true
  })

  onMounted(() => {
    getStaticRouteList()
  })

  // 获取固定线路列表数据
  const getStaticRouteList = async () => {
    loading.value = true
    try {
      const { currentPage, pageSize } = pagination

      // 模拟API调用
      await new Promise((resolve) => setTimeout(resolve, 500))

      // 过滤数据
      let filteredData = [...STATIC_ROUTE_LIST_DATA]

      if (formFilters.departure) {
        filteredData = filteredData.filter((item) =>
          item.departure.toLowerCase().includes(formFilters.departure.toLowerCase())
        )
      }

      if (formFilters.destination) {
        filteredData = filteredData.filter((item) =>
          item.destination.toLowerCase().includes(formFilters.destination.toLowerCase())
        )
      }

      if (formFilters.isActive !== '') {
        const isActiveFilter = formFilters.isActive === 'true'
        filteredData = filteredData.filter((item) => item.isActive === isActiveFilter)
      }

      const total = filteredData.length
      const start = (currentPage - 1) * pageSize
      const end = start + pageSize

      tableData.value = filteredData.slice(start, end)
      pagination.total = total
    } catch (error) {
      console.error('获取固定线路列表失败:', error)
    } finally {
      loading.value = false
    }
  }

  const handleRefresh = () => {
    getStaticRouteList()
  }

  // 处理表格行选择变化
  const handleSelectionChange = (selection: any[]) => {
    selectedRows.value = selection
  }

  // 表单验证规则
  const rules = reactive<FormRules>({
    departure: [
      { required: true, message: '请输入出发地', trigger: 'blur' },
      { min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur' }
    ],
    destination: [
      { required: true, message: '请输入目的地', trigger: 'blur' },
      { min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur' }
    ],
    totalDistance: [{ required: true, message: '请输入总距离', trigger: 'blur' }],
    estimatedTime: [{ required: true, message: '请输入预计耗时', trigger: 'blur' }],
    scheduleInfo: [
      { required: true, message: '请输入班次信息', trigger: 'blur' },
      { min: 5, max: 200, message: '长度在 5 到 200 个字符', trigger: 'blur' }
    ]
  })

  // 提交表单
  const handleSubmit = async () => {
    if (!formRef.value) return

    await formRef.value.validate((valid) => {
      if (valid) {
        ElMessage.success(dialogType.value === 'add' ? '添加成功' : '更新成功')
        dialogVisible.value = false
        getStaticRouteList()
      }
    })
  }

  // 处理表格分页变化
  const handleSizeChange = (newPageSize: number) => {
    pagination.pageSize = newPageSize
    getStaticRouteList()
  }

  const handleCurrentChange = (newCurrentPage: number) => {
    pagination.currentPage = newCurrentPage
    getStaticRouteList()
  }
</script>

<style lang="scss" scoped>
  .static-route-page {
    // 可以添加自定义样式
  }
</style>
