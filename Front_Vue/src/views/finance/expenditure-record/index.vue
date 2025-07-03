<template>
  <ArtTableFullScreen>
    <div class="expenditure-record-page" id="table-full-screen">
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
            <ElButton @click="showDialog('add')">新增支出记录</ElButton>
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
          :title="dialogType === 'add' ? '新增支出记录' : '编辑支出记录'"
          width="40%"
          align-center
        >
          <ElForm ref="formRef" :model="formData" :rules="rules" label-width="100px">
            <ElFormItem label="支出金额" prop="amount">
              <ElInputNumber
                v-model="formData.amount"
                :min="0"
                :precision="2"
                placeholder="请输入支出金额"
              />
            </ElFormItem>
            <ElFormItem label="支出原因" prop="reason">
              <ElSelect v-model="formData.reason" placeholder="请选择支出原因">
                <ElOption label="采购支出" value="采购支出" />
                <ElOption label="运营成本" value="运营成本" />
                <ElOption label="员工工资" value="员工工资" />
                <ElOption label="政府税收" value="政府税收" />
                <ElOption label="其他" value="其他" />
              </ElSelect>
            </ElFormItem>
            <ElFormItem label="关联订单" prop="relatedOrder">
              <ElInput v-model="formData.relatedOrder" placeholder="请输入关联订单号（可为空）" />
            </ElFormItem>
            <ElFormItem label="备注" prop="remark">
              <ElInput v-model="formData.remark" type="textarea" placeholder="请输入备注信息" />
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
  import { ElDialog, FormInstance } from 'element-plus'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { SearchChangeParams, SearchFormItem } from '@/types'

  defineOptions({ name: 'ExpenditureRecord' })

  const dialogType = ref('add')
  const dialogVisible = ref(false)
  const loading = ref(false)

  // 支出记录接口
  interface ExpenditureRecord {
    id: number
    amount: number // 支出金额
    reason: string // 支出原因
    relatedOrder: string // 关联订单
    expenditureTime: string // 支出时间
    operatorName: string // 操作员姓名
    operatorJobNumber: string // 操作员工号
    remark: string // 备注
  }

  // 模拟支出记录数据
  const EXPENDITURE_RECORD_DATA: ExpenditureRecord[] = [
    {
      id: 1,
      amount: 85000.0,
      reason: '采购支出',
      relatedOrder: 'PO202401150001',
      expenditureTime: '2024-01-15 10:30:00',
      operatorName: 'Emma Wilson',
      operatorJobNumber: 'EMP005',
      remark: 'iPhone 15 Pro 采购付款'
    },
    {
      id: 2,
      amount: 45000.0,
      reason: '员工工资',
      relatedOrder: '',
      expenditureTime: '2024-01-31 17:00:00',
      operatorName: 'Emma Wilson',
      operatorJobNumber: 'EMP005',
      remark: '1月份员工工资发放'
    },
    {
      id: 3,
      amount: 12000.0,
      reason: '运营成本',
      relatedOrder: '',
      expenditureTime: '2024-01-18 09:15:00',
      operatorName: 'Emma Wilson',
      operatorJobNumber: 'EMP005',
      remark: '仓库租金及水电费'
    },
    {
      id: 4,
      amount: 8500.0,
      reason: '政府税收',
      relatedOrder: '',
      expenditureTime: '2024-02-01 16:45:00',
      operatorName: 'Emma Wilson',
      operatorJobNumber: 'EMP005',
      remark: '企业所得税缴纳'
    },
    {
      id: 5,
      amount: 3200.0,
      reason: '其他',
      relatedOrder: '',
      expenditureTime: '2024-01-20 11:30:00',
      operatorName: 'Emma Wilson',
      operatorJobNumber: 'EMP005',
      remark: '办公用品采购'
    }
  ]

  // 定义表单搜索初始值
  const initialSearchState = {
    reason: '',
    relatedOrder: '',
    operatorName: ''
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
    getExpenditureRecordList()
  }

  // 搜索处理
  const handleSearch = () => {
    console.log('搜索参数:', formFilters)
    pagination.currentPage = 1
    getExpenditureRecordList()
  }

  // 表单项变更处理
  const handleFormChange = (params: SearchChangeParams): void => {
    console.log('表单项变更:', params)
  }

  // 表单配置项
  const formItems: SearchFormItem[] = [
    {
      label: '支出原因',
      prop: 'reason',
      type: 'select',
      config: {
        clearable: true
      },
      options: () => [
        { label: '采购支出', value: '采购支出' },
        { label: '运营成本', value: '运营成本' },
        { label: '员工工资', value: '员工工资' },
        { label: '政府税收', value: '政府税收' },
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
    },
    {
      label: '操作员',
      prop: 'operatorName',
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
      formData.amount = row.amount
      formData.reason = row.reason
      formData.relatedOrder = row.relatedOrder
      formData.remark = row.remark
    } else {
      formData.amount = 0
      formData.reason = ''
      formData.relatedOrder = ''
      formData.remark = ''
    }
  }

  // 删除记录
  const deleteRecord = () => {
    ElMessageBox.confirm('确定要删除该支出记录吗？', '删除记录', {
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
      label: '记录ID',
      width: 80
    },
    {
      prop: 'amount',
      label: '支出金额',
      width: 140,
      sortable: true,
      formatter: (row: any) => {
        return h('span', { style: 'color: #F56C6C; font-weight: 500' }, `¥${row.amount.toFixed(2)}`)
      }
    },
    {
      prop: 'reason',
      label: '支出原因',
      width: 120
    },
    {
      prop: 'relatedOrder',
      label: '关联订单',
      width: 140,
      formatter: (row: any) => {
        return row.relatedOrder || '-'
      }
    },
    {
      prop: 'expenditureTime',
      label: '支出时间',
      sortable: true,
      width: 160
    },
    {
      prop: 'operator',
      label: '操作人',
      width: 120,
      formatter: (row: any) => {
        return h('div', { style: 'line-height: 1.2;' }, [
          h('div', { style: 'font-weight: bold;' }, row.operatorName),
          h('div', { style: 'font-size: 12px; color: #999;' }, row.operatorJobNumber)
        ])
      }
    },
    {
      prop: 'remark',
      label: '备注',
      minWidth: 150,
      formatter: (row: any) => {
        return row.remark || '-'
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
            onClick: () => deleteRecord()
          })
        ])
      }
    }
  ])

  // 表单实例
  const formRef = ref<FormInstance>()

  // 表单数据
  const formData = reactive({
    amount: 0,
    reason: '',
    relatedOrder: '',
    remark: ''
  })

  onMounted(() => {
    getExpenditureRecordList()
  })

  // 获取支出记录列表数据
  const getExpenditureRecordList = async () => {
    loading.value = true
    try {
      const { currentPage, pageSize } = pagination

      // 模拟API调用
      await new Promise((resolve) => setTimeout(resolve, 500))

      // 过滤数据
      let filteredData = [...EXPENDITURE_RECORD_DATA]

      if (formFilters.reason) {
        filteredData = filteredData.filter((item) => item.reason === formFilters.reason)
      }

      if (formFilters.relatedOrder) {
        filteredData = filteredData.filter((item) =>
          item.relatedOrder.toLowerCase().includes(formFilters.relatedOrder.toLowerCase())
        )
      }

      if (formFilters.operatorName) {
        filteredData = filteredData.filter((item) =>
          item.operatorName.toLowerCase().includes(formFilters.operatorName.toLowerCase())
        )
      }

      const total = filteredData.length
      const start = (currentPage - 1) * pageSize
      const end = start + pageSize

      tableData.value = filteredData.slice(start, end)
      pagination.total = total
    } catch (error) {
      console.error('获取支出记录列表失败:', error)
    } finally {
      loading.value = false
    }
  }

  const handleRefresh = () => {
    getExpenditureRecordList()
  }

  // 处理表格行选择变化
  const handleSelectionChange = (selection: any[]) => {
    selectedRows.value = selection
  }

  // 表单验证规则
  const rules = reactive<FormRules>({
    amount: [{ required: true, message: '请输入支出金额', trigger: 'blur' }],
    reason: [{ required: true, message: '请选择支出原因', trigger: 'change' }]
  })

  // 提交表单
  const handleSubmit = async () => {
    if (!formRef.value) return

    await formRef.value.validate((valid) => {
      if (valid) {
        ElMessage.success(dialogType.value === 'add' ? '添加成功' : '更新成功')
        dialogVisible.value = false
        getExpenditureRecordList()
      }
    })
  }

  // 处理表格分页变化
  const handleSizeChange = (newPageSize: number) => {
    pagination.pageSize = newPageSize
    getExpenditureRecordList()
  }

  const handleCurrentChange = (newCurrentPage: number) => {
    pagination.currentPage = newCurrentPage
    getExpenditureRecordList()
  }
</script>

<style lang="scss" scoped>
  .expenditure-record-page {
    // 样式可以根据需要添加
  }
</style>
