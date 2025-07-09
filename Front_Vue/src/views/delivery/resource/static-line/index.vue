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
          <ElForm ref="formRef" :model="formData" :rules="rules" label-width="120px">
            <ElFormItem label="出发地" prop="departure">
              <ElInput v-model="formData.departure" placeholder="请输入出发地" />
            </ElFormItem>
            <ElFormItem label="目的地" prop="destination">
              <ElInput v-model="formData.destination" placeholder="请输入目的地" />
            </ElFormItem>
            <ElFormItem label="总距离(公里)" prop="totalDistance">
              <ElInputNumber
                v-model="formData.totalDistance"
                :min="0"
                :precision="2"
                style="width: 100%"
              />
            </ElFormItem>
            <ElFormItem label="预计耗时(小时)" prop="estimatedTime">
              <ElInputNumber
                v-model="formData.estimatedTime"
                :min="0"
                :precision="1"
                style="width: 100%"
              />
            </ElFormItem>
            <ElFormItem label="班次信息" prop="scheduleInfo">
              <ElInput
                v-model="formData.scheduleInfo"
                type="textarea"
                :rows="3"
                placeholder="请输入班次信息"
              />
            </ElFormItem>
            <ElFormItem label="线路状态" prop="isActive">
              <ElSelect v-model="formData.isActive" style="width: 100%">
                <ElOption label="启用" :value="true" />
                <ElOption label="停用" :value="false" />
              </ElSelect>
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
  import { DeliveryService } from '@/api/deliveryApi'
  import { ElDialog, FormInstance, ElTag } from 'element-plus'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { SearchChangeParams, SearchFormItem } from '@/types'

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
      label: '线路状态',
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

  // 获取标签类型
  const getTagType = (isActive: boolean) => {
    return isActive ? 'success' : 'danger'
  }

  // 构建标签文本
  const buildTagText = (isActive: boolean) => {
    return isActive ? '启用' : '停用'
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
      formData.id = row.id
      formData.departure = row.departure
      formData.destination = row.destination
      formData.totalDistance = row.totalDistance
      formData.estimatedTime = row.estimatedTime
      formData.scheduleInfo = row.scheduleInfo
      formData.isActive = row.isActive
    } else {
      formData.id = undefined
      formData.departure = ''
      formData.destination = ''
      formData.totalDistance = 0
      formData.estimatedTime = 0
      formData.scheduleInfo = ''
      formData.isActive = true
    }
  }

  // 动态列配置
  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection' },
    {
      prop: 'id',
      label: '线路ID',
      sortable: true,
      width: 90
    },
    {
      prop: 'departure',
      label: '出发地',
      width: 200
    },
    {
      prop: 'destination',
      label: '目的地',
      width: 200
    },
    {
      prop: 'totalDistance',
      label: '总距离',
      width: 120,
      sortable: true,
      formatter: (row: any) => `${row.totalDistance} km`
    },
    {
      prop: 'estimatedTime',
      label: '耗时',
      width: 130,
      sortable: true,
      formatter: (row: any) => `${row.estimatedTime} h`
    },
    {
      prop: 'scheduleInfo',
      label: '班次信息',
      width: 200,
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
        return h(ElTag, { type: getTagType(row.isActive) }, () => buildTagText(row.isActive))
      }
    },
    {
      prop: 'createTime',
      label: '创建时间',
      width: 180,
      sortable: true
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
            onClick: () => deleteRoute(row)
          })
        ])
      }
    }
  ])

  // 表单实例
  const formRef = ref<FormInstance>()

  // 表单数据
  const formData = reactive({
    id: undefined as number | undefined,
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
      const params = {
        current: pagination.currentPage,
        size: pagination.pageSize,
        ...formFilters
      }

      const response = await DeliveryService.getStaticRouteList(params)

      if (response.code === 200) {
        tableData.value = response.data.list
        pagination.total = response.data.total
      } else {
        ElMessage.error(response.msg || '获取固定线路列表失败')
      }
    } catch (error) {
      console.error('获取固定线路列表失败:', error)
      ElMessage.error('获取固定线路列表失败')
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
      { min: 2, max: 200, message: '长度在 2 到 200 个字符', trigger: 'blur' }
    ],
    destination: [
      { required: true, message: '请输入目的地', trigger: 'blur' },
      { min: 2, max: 200, message: '长度在 2 到 200 个字符', trigger: 'blur' }
    ],
    totalDistance: [{ required: true, message: '请输入总距离', trigger: 'blur' }],
    estimatedTime: [{ required: true, message: '请输入预计耗时', trigger: 'blur' }],
    scheduleInfo: [{ required: true, message: '请输入班次信息', trigger: 'blur' }],
    isActive: [{ required: true, message: '请选择线路状态', trigger: 'change' }]
  })

  // 提交表单
  const handleSubmit = async () => {
    if (!formRef.value) return

    await formRef.value.validate(async (valid) => {
      if (valid) {
        try {
          if (dialogType.value === 'add') {
            // 新增时不需要传递id
            // eslint-disable-next-line @typescript-eslint/no-unused-vars
            const { id, ...addData } = formData
            await DeliveryService.addStaticRoute(addData)
            ElMessage.success('添加成功')
          } else {
            // 编辑时确保id存在
            if (formData.id) {
              await DeliveryService.updateStaticRoute(
                formData as {
                  id: number
                  departure?: string
                  destination?: string
                  totalDistance?: number
                  estimatedTime?: number
                  scheduleInfo?: string
                  isActive?: boolean
                }
              )
              ElMessage.success('更新成功')
            } else {
              ElMessage.error('缺少线路ID')
              return
            }
          }

          dialogVisible.value = false
          getStaticRouteList()
        } catch (error) {
          ElMessage.error(dialogType.value === 'add' ? '添加失败：' + error : '更新失败：' + error)
        }
      }
    })
  }

  // 删除线路（更新现有的deleteRoute函数）
  const deleteRoute = async (row: any) => {
    try {
      await ElMessageBox.confirm(
        `确定要删除线路"${row.departure} → ${row.destination}"吗？`,
        '删除线路',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'error'
        }
      )

      await DeliveryService.deleteStaticRoute({ id: row.id })
      ElMessage.success('删除成功')
      getStaticRouteList()
    } catch (error) {
      if (error !== 'cancel') {
        ElMessage.error('删除失败：' + error)
      }
    }
  }

  // 删除未使用的deleteStaticRoute函数
  // const deleteStaticRoute = async (row: any) => { ... } // 删除这个函数

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
    // 自定义样式
  }
</style>
