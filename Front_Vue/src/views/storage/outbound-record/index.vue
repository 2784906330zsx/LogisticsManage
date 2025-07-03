<template>
  <ArtTableFullScreen>
    <div class="outbound-record-page" id="table-full-screen">
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
            <ElButton @click="showDialog('add')">新增出库记录</ElButton>
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
          :title="dialogType === 'add' ? '新增出库记录' : '编辑出库记录'"
          width="40%"
          align-center
        >
          <ElForm ref="formRef" :model="formData" :rules="rules" label-width="100px">
            <ElFormItem label="商品" prop="commodityId">
              <ElSelect
                v-model="formData.commodityId"
                placeholder="请选择商品"
                @change="handleCommodityChange"
              >
                <ElOption
                  v-for="commodity in COMMODITY_LIST_DATA"
                  :key="commodity.id"
                  :label="commodity.name"
                  :value="commodity.id"
                />
              </ElSelect>
            </ElFormItem>
            <ElFormItem label="出库数量" prop="quantity">
              <ElInputNumber v-model="formData.quantity" :min="1" />
            </ElFormItem>
            <ElFormItem label="出库原因" prop="reason">
              <ElSelect v-model="formData.reason" placeholder="请选择出库原因">
                <ElOption label="客户订单" value="客户订单" />
                <ElOption label="批量订单" value="批量订单" />
                <ElOption label="企业采购" value="企业采购" />
                <ElOption label="产品损坏" value="产品损坏" />
                <ElOption label="退货处理" value="退货处理" />
                <ElOption label="其他" value="其他" />
              </ElSelect>
            </ElFormItem>
            <ElFormItem label="关联订单" prop="relatedOrder">
              <ElInput v-model="formData.relatedOrder" placeholder="请输入关联订单号" />
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
  import { OUTBOUND_RECORD_DATA, COMMODITY_LIST_DATA } from '@/mock/temp/formData'
  import { ElDialog, FormInstance, ElImage } from 'element-plus'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { SearchChangeParams, SearchFormItem } from '@/types'

  const { width } = useWindowSize()

  defineOptions({ name: 'OutboundRecord' })

  const dialogType = ref('add')
  const dialogVisible = ref(false)
  const loading = ref(false)

  // 定义表单搜索初始值
  const initialSearchState = {
    commodityName: '',
    reason: '',
    relatedOrder: ''
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
    getOutboundRecordList()
  }

  // 搜索处理
  const handleSearch = () => {
    console.log('搜索参数:', formFilters)
    pagination.currentPage = 1
    getOutboundRecordList()
  }

  // 表单项变更处理
  const handleFormChange = (params: SearchChangeParams): void => {
    console.log('表单项变更:', params)
  }

  // 表单配置项
  const formItems: SearchFormItem[] = [
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
      label: '出库原因',
      prop: 'reason',
      type: 'select',
      config: {
        clearable: true
      },
      options: () => [
        { label: '客户订单', value: '客户订单' },
        { label: '批量订单', value: '批量订单' },
        { label: '企业采购', value: '企业采购' },
        { label: '产品损坏', value: '产品损坏' },
        { label: '退货处理', value: '退货处理' },
        { label: '其他', value: '其他' }
      ],
      onChange: handleFormChange
    },
    {
      label: '关联订单',
      prop: 'relatedOrder',
      type: 'input',
      config: {
        clearable: true
      },
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
      formData.commodityId = row.commodityId
      formData.quantity = row.quantity
      formData.reason = row.reason
      formData.relatedOrder = row.relatedOrder
    } else {
      formData.commodityId = undefined // 改为undefined而不是null
      formData.quantity = 1
      formData.reason = ''
      formData.relatedOrder = ''
    }
  }

  // 处理商品选择变化
  const handleCommodityChange = (commodityId: number) => {
    const commodity = COMMODITY_LIST_DATA.find((item) => item.id === commodityId)
    if (commodity) {
      // 可以在这里设置一些默认值
    }
  }

  // 删除记录
  const deleteRecord = () => {
    ElMessageBox.confirm('确定要删除该出库记录吗？', '删除记录', {
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
      prop: 'commodityId',
      label: '商品ID',
      width: 80
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
            )
          ])
        ])
      }
    },
    {
      prop: 'quantity',
      label: '出库数量',
      sortable: true,
      formatter: (row: any) => `${row.quantity} 件`
    },
    {
      prop: 'reason',
      label: '出库原因',
      width: 120
    },
    {
      prop: 'outboundTime',
      label: '出库时间',
      sortable: true,
      width: 160
    },
    {
      prop: 'relatedOrder',
      label: '关联订单',
      width: 140
    },
    {
      prop: 'operator',
      label: '操作员',
      width: 100
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
            onClick: () => deleteRecord()
          })
        ])
      }
    }
  ])

  // 表单实例
  const formRef = ref<FormInstance>()

  // 表单数据
  // 表单数据
  const formData = reactive({
    commodityId: undefined as number | undefined, // 改为undefined而不是null
    quantity: 1,
    reason: '',
    relatedOrder: ''
  })

  onMounted(() => {
    getOutboundRecordList()
  })

  // 获取出库记录列表数据
  const getOutboundRecordList = async () => {
    loading.value = true
    try {
      const { currentPage, pageSize } = pagination

      // 模拟API调用
      await new Promise((resolve) => setTimeout(resolve, 500))

      // 过滤数据
      let filteredData = [...OUTBOUND_RECORD_DATA]

      if (formFilters.commodityName) {
        filteredData = filteredData.filter((item) =>
          item.commodityName.toLowerCase().includes(formFilters.commodityName.toLowerCase())
        )
      }

      if (formFilters.reason) {
        filteredData = filteredData.filter((item) => item.reason === formFilters.reason)
      }

      if (formFilters.relatedOrder) {
        filteredData = filteredData.filter((item) =>
          item.relatedOrder.toLowerCase().includes(formFilters.relatedOrder.toLowerCase())
        )
      }

      const total = filteredData.length
      const start = (currentPage - 1) * pageSize
      const end = start + pageSize

      tableData.value = filteredData.slice(start, end)
      pagination.total = total
    } catch (error) {
      console.error('获取出库记录列表失败:', error)
    } finally {
      loading.value = false
    }
  }

  const handleRefresh = () => {
    getOutboundRecordList()
  }

  // 处理表格行选择变化
  const handleSelectionChange = (selection: any[]) => {
    selectedRows.value = selection
  }

  // 表单验证规则
  const rules = reactive<FormRules>({
    commodityId: [{ required: true, message: '请选择商品', trigger: 'change' }],
    quantity: [{ required: true, message: '请输入出库数量', trigger: 'blur' }],
    reason: [{ required: true, message: '请选择出库原因', trigger: 'change' }]
  })

  // 提交表单
  const handleSubmit = async () => {
    if (!formRef.value) return

    await formRef.value.validate((valid) => {
      if (valid) {
        ElMessage.success(dialogType.value === 'add' ? '添加成功' : '更新成功')
        dialogVisible.value = false
        getOutboundRecordList()
      }
    })
  }

  // 处理表格分页变化
  const handleSizeChange = (newPageSize: number) => {
    pagination.pageSize = newPageSize
    getOutboundRecordList()
  }

  const handleCurrentChange = (newCurrentPage: number) => {
    pagination.currentPage = newCurrentPage
    getOutboundRecordList()
  }
</script>

<style lang="scss" scoped>
  .outbound-record-page {
    :deep(.commodity-info) {
      .commodity-image {
        flex-shrink: 0;
      }

      .commodity-name {
        font-weight: 500;
        color: var(--art-text-gray-800);
      }
    }
  }
</style>
