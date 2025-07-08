<template>
  <ArtTableFullScreen>
    <div class="income-record-page" id="table-full-screen">
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
            <ElButton type="primary" @click="showDialog()">
              <ElIcon><Plus /></ElIcon>
              新增收入记录
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

        <!-- 新增/编辑对话框 -->
        <ElDialog
          v-model="dialogVisible"
          :title="dialogType === 'add' ? '新增收入记录' : '编辑收入记录'"
          width="500px"
          align-center
          :close-on-click-modal="false"
        >
          <ElForm ref="formRef" :model="formData" :rules="rules" label-width="100px">
            <ElFormItem label="收入金额" prop="amount">
              <ElInputNumber
                v-model="formData.amount"
                :min="0.01"
                :precision="2"
                :step="0.01"
                placeholder="请输入收入金额"
                style="width: 100%"
              />
            </ElFormItem>
            <ElFormItem label="收入原因" prop="reason">
              <ElSelect v-model="formData.reason" placeholder="请选择收入原因" style="width: 100%">
                <ElOption label="总公司拨款" value="总公司拨款" />
                <ElOption label="业务收入" value="业务收入" />
                <ElOption label="采购退款" value="采购退款" />
                <ElOption label="其他" value="其他" />
              </ElSelect>
            </ElFormItem>
            <ElFormItem label="关联订单" prop="relatedOrder">
              <ElInput
                v-model="formData.relatedOrder"
                placeholder="请输入关联订单号（可为空）"
                clearable
              />
            </ElFormItem>
            <ElFormItem label="备注" prop="remark">
              <ElInput
                v-model="formData.remark"
                type="textarea"
                :rows="3"
                placeholder="请输入备注信息"
                maxlength="500"
                show-word-limit
              />
            </ElFormItem>
          </ElForm>
          <template #footer>
            <div class="dialog-footer">
              <ElButton @click="dialogVisible = false">取消</ElButton>
              <ElButton type="primary" :loading="submitLoading" @click="handleSubmit">
                {{ dialogType === 'add' ? '新增' : '更新' }}
              </ElButton>
            </div>
          </template>
        </ElDialog>
      </ElCard>
    </div>
  </ArtTableFullScreen>
</template>

<script setup lang="ts">
  import { h, ref, reactive, onMounted, computed, nextTick } from 'vue'
  import { ElDialog, ElMessage, ElMessageBox, FormInstance } from 'element-plus'
  import { Plus } from '@element-plus/icons-vue'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import { useUserStore } from '@/store/modules/user'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { SearchChangeParams, SearchFormItem } from '@/types'
  import { FinanceService } from '@/api/financeApi'

  defineOptions({ name: 'IncomeRecord' })

  // 用户store
  const userStore = useUserStore()

  // 响应式数据
  const dialogVisible = ref(false)
  const dialogType = ref<'add' | 'edit'>('add')
  const loading = ref(false)
  const submitLoading = ref(false)

  // 收入记录接口
  interface IncomeRecord {
    id: number
    amount: number
    reason: string
    relatedOrder: string
    incomeTime: string
    operatorName: string
    operatorJobNumber: string
    remark: string
    createTime: string
  }

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
  const tableData = ref<IncomeRecord[]>([])

  // 表格实例引用
  const tableRef = ref()

  // 选中的行数据
  const selectedRows = ref<IncomeRecord[]>([])

  // 表单实例
  const formRef = ref<FormInstance>()

  // 表单数据
  const formData = reactive({
    id: null as number | null,
    amount: 0,
    reason: '',
    relatedOrder: '',
    remark: ''
  })

  // 检查是否为超级管理员
  const isSuperAdmin = computed(() => {
    const userInfo = userStore.getUserInfo
    return userInfo.roles?.includes('R_SUPER') || false
  })

  // 重置表单
  const handleReset = () => {
    Object.assign(formFilters, { ...initialSearchState })
    pagination.currentPage = 1
    getIncomeRecordList()
  }

  // 搜索处理
  const handleSearch = () => {
    pagination.currentPage = 1
    getIncomeRecordList()
  }

  // 表单项变更处理
  const handleFormChange = (params: SearchChangeParams): void => {
    console.log('表单项变更:', params)
  }

  // 表单配置项
  const formItems: SearchFormItem[] = [
    {
      label: '收入原因',
      prop: 'reason',
      type: 'select',
      config: {
        clearable: true,
        placeholder: '请选择收入原因'
      },
      options: () => [
        { label: '总公司拨款', value: '总公司拨款' },
        { label: '业务收入', value: '业务收入' },
        { label: '采购退款', value: '采购退款' },
        { label: '其他', value: '其他' }
      ],
      onChange: handleFormChange
    },
    {
      label: '关联订单',
      prop: 'relatedOrder',
      type: 'input',
      config: {
        clearable: true,
        placeholder: '请输入关联订单号'
      },
      onChange: handleFormChange
    },
    {
      label: '操作员',
      prop: 'operatorName',
      type: 'input',
      config: {
        clearable: true,
        placeholder: '请输入操作员姓名'
      },
      onChange: handleFormChange
    }
  ]

  // 显示对话框
  const showDialog = (type: 'add' | 'edit' = 'add', row?: IncomeRecord) => {
    dialogVisible.value = true
    dialogType.value = type

    // 重置表单验证状态
    nextTick(() => {
      if (formRef.value) {
        formRef.value.resetFields()
      }
    })

    if (type === 'add') {
      // 重置表单数据
      formData.id = null
      formData.amount = 0
      formData.reason = ''
      formData.relatedOrder = ''
      formData.remark = ''
    } else if (row) {
      // 编辑模式，填充数据
      formData.id = row.id
      formData.amount = row.amount
      formData.reason = row.reason
      formData.relatedOrder = row.relatedOrder || ''
      formData.remark = row.remark || ''
    }
  }

  // 编辑记录
  const editRecord = (row: IncomeRecord) => {
    showDialog('edit', row)
  }

  // 删除记录
  const deleteRecord = async (row: IncomeRecord) => {
    try {
      await ElMessageBox.confirm(
        `确定要删除收入记录 "${row.reason} - ¥${row.amount}" 吗？`,
        '删除确认',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
      )

      const response = await FinanceService.deleteIncomeRecord(row.id)

      if (response.code === 200) {
        ElMessage.success('删除成功')
        await getIncomeRecordList()
      } else {
        ElMessage.error(response.data.message || '删除失败')
      }
    } catch (error) {
      if (error !== 'cancel') {
        console.error('删除收入记录失败:', error)
        ElMessage.error('删除失败')
      }
    }
  }

  // 动态列配置
  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection' },
    {
      prop: 'id',
      label: '记录ID',
      width: 100,
      sortable: true
    },
    {
      prop: 'amount',
      label: '收入金额',
      width: 140,
      sortable: true,
      formatter: (row: IncomeRecord) => {
        return h('span', { style: 'color: #67C23A; font-weight: 500' }, `¥${row.amount.toFixed(2)}`)
      }
    },
    {
      prop: 'reason',
      label: '收入原因',
      width: 120,
      formatter: (row: IncomeRecord) => {
        const colorMap: Record<string, string> = {
          总公司拨款: '#67C23A',
          业务收入: '#409EFF',
          采购退款: '#E6A23C',
          其他: '#909399'
        }
        return h(
          'span',
          {
            style: {
              color: colorMap[row.reason] || '#909399',
              fontWeight: '500'
            }
          },
          row.reason
        )
      }
    },
    {
      prop: 'relatedOrder',
      label: '关联订单',
      width: 140,
      formatter: (row: IncomeRecord) => {
        return row.relatedOrder || h('span', { style: 'color: #C0C4CC' }, '-')
      }
    },
    {
      prop: 'incomeTime',
      label: '收入时间',
      sortable: true,
      width: 160
    },
    {
      prop: 'operator',
      label: '操作人',
      width: 120,
      formatter: (row: IncomeRecord) => {
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
      formatter: (row: IncomeRecord) => {
        return row.remark || h('span', { style: 'color: #C0C4CC' }, '-')
      }
    },
    {
      prop: 'operation',
      label: '操作',
      width: 120,
      fixed: 'right',
      formatter: (row: IncomeRecord) => {
        // 使用 isSuperAdmin 进行权限控制
        if (!isSuperAdmin.value) {
          return h('span', { style: 'color: #C0C4CC; font-size: 12px;' }, '无操作权限')
        }

        return h('div', { class: 'flex gap-2' }, [
          h(ArtButtonTable, {
            type: 'edit',
            onClick: () => editRecord(row)
          }),
          h(ArtButtonTable, {
            type: 'delete',
            onClick: () => deleteRecord(row)
          })
        ])
      }
    }
  ])

  // 表单验证规则
  const rules = reactive<FormRules>({
    amount: [
      { required: true, message: '请输入收入金额', trigger: 'blur' },
      {
        validator: (rule, value, callback) => {
          if (value <= 0) {
            callback(new Error('收入金额必须大于0'))
          } else {
            callback()
          }
        },
        trigger: 'blur'
      }
    ],
    reason: [{ required: true, message: '请选择收入原因', trigger: 'change' }]
  })

  // 获取收入记录列表数据
  const getIncomeRecordList = async () => {
    loading.value = true
    try {
      const { currentPage, pageSize } = pagination

      const params = {
        current: currentPage,
        size: pageSize,
        reason: formFilters.reason || undefined,
        relatedOrder: formFilters.relatedOrder || undefined,
        operatorName: formFilters.operatorName || undefined
      }

      const response = await FinanceService.getIncomeRecordList(params)

      if (response.code === 200) {
        tableData.value = response.data.list || []
        pagination.total = response.data.total || 0
      } else {
        ElMessage.error(response.data.message || '获取收入记录失败')
        tableData.value = []
        pagination.total = 0
      }
    } catch (error) {
      console.error('获取收入记录失败:', error)
      ElMessage.error('获取收入记录失败')
      tableData.value = []
      pagination.total = 0
    } finally {
      loading.value = false
    }
  }

  // 提交表单
  const handleSubmit = async () => {
    if (!formRef.value) return

    try {
      await formRef.value.validate()
      submitLoading.value = true

      const requestData = {
        amount: formData.amount,
        reason: formData.reason,
        relatedOrder: formData.relatedOrder || undefined,
        remark: formData.remark || undefined
      }

      let response
      if (dialogType.value === 'add') {
        response = await FinanceService.createIncomeRecord(requestData)
      } else {
        response = await FinanceService.updateIncomeRecord({
          id: formData.id!,
          ...requestData
        })
      }

      if (response.code === 200) {
        ElMessage.success(dialogType.value === 'add' ? '新增成功' : '更新成功')
        dialogVisible.value = false
        await getIncomeRecordList()
      } else {
        ElMessage.error(response.data.message || '操作失败')
      }
    } catch (error) {
      console.error('提交失败:', error)
      ElMessage.error('提交失败')
    } finally {
      submitLoading.value = false
    }
  }

  const handleRefresh = () => {
    getIncomeRecordList()
  }

  // 处理表格行选择变化
  const handleSelectionChange = (selection: IncomeRecord[]) => {
    selectedRows.value = selection
  }

  // 处理表格分页变化
  const handleSizeChange = (newPageSize: number) => {
    pagination.pageSize = newPageSize
    pagination.currentPage = 1
    getIncomeRecordList()
  }

  const handleCurrentChange = (newCurrentPage: number) => {
    pagination.currentPage = newCurrentPage
    getIncomeRecordList()
  }

  // 组件挂载时获取数据
  onMounted(() => {
    getIncomeRecordList()
  })
</script>

<style lang="scss" scoped>
  .income-record-page {
    .dialog-footer {
      display: flex;
      justify-content: flex-end;
      gap: 12px;
    }

    .flex {
      display: flex;
    }

    .gap-2 {
      gap: 8px;
    }
  }
</style>
