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
            <ElButton type="primary" @click="showDialog()">
              <ElIcon><Plus /></ElIcon>
              新增支出记录
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

        <!-- 新增对话框 -->
        <ElDialog
          v-model="dialogVisible"
          title="新增支出记录"
          width="500px"
          align-center
          :close-on-click-modal="false"
        >
          <ElForm ref="formRef" :model="formData" :rules="rules" label-width="100px">
            <ElFormItem label="支出金额" prop="amount">
              <ElInputNumber
                v-model="formData.amount"
                :min="0.01"
                :precision="2"
                :step="0.01"
                placeholder="请输入支出金额"
                style="width: 100%"
              />
            </ElFormItem>
            <ElFormItem label="支出原因" prop="reason">
              <ElSelect v-model="formData.reason" placeholder="请选择支出原因" style="width: 100%">
                <ElOption label="采购支出" value="采购支出" />
                <ElOption label="运营成本" value="运营成本" />
                <ElOption label="员工工资" value="员工工资" />
                <ElOption label="政府税收" value="政府税收" />
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
                新增
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

  defineOptions({ name: 'ExpenditureRecord' })

  // 用户store
  const userStore = useUserStore()

  // 响应式数据
  const dialogVisible = ref(false)
  const loading = ref(false)
  const submitLoading = ref(false)

  // 支出记录接口
  interface ExpenditureRecord {
    id: number
    amount: number
    reason: string
    relatedOrder: string
    expenditureTime: string
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
  const tableData = ref<ExpenditureRecord[]>([])

  // 表格实例引用
  const tableRef = ref()

  // 选中的行数据
  const selectedRows = ref<ExpenditureRecord[]>([])

  // 表单实例
  const formRef = ref<FormInstance>()

  // 表单数据
  const formData = reactive({
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
    getExpenditureRecordList()
  }

  // 搜索处理
  const handleSearch = () => {
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
        clearable: true,
        placeholder: '请选择支出原因'
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

  // 显示新增对话框
  const showDialog = () => {
    dialogVisible.value = true

    // 重置表单验证状态
    nextTick(() => {
      if (formRef.value) {
        formRef.value.resetFields()
      }
    })

    // 重置表单数据
    formData.amount = 0
    formData.reason = ''
    formData.relatedOrder = ''
    formData.remark = ''
  }

  // 删除记录（仅超级管理员可用）
  const deleteRecord = async (row: ExpenditureRecord) => {
    if (!isSuperAdmin.value) {
      ElMessage.warning('只有超级管理员才能删除支出记录')
      return
    }

    try {
      await ElMessageBox.confirm(
        `确定要删除支出记录 "${row.reason} - ¥${row.amount}" 吗？`,
        '删除确认',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
      )

      const response = await FinanceService.deleteExpenditureRecord(row.id)

      if (response.code === 200) {
        ElMessage.success('删除成功')
        await getExpenditureRecordList()
      } else {
        ElMessage.error(response.msg || '删除失败')
      }
    } catch (error) {
      if (error !== 'cancel') {
        console.error('删除支出记录失败:', error)
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
      label: '支出金额',
      width: 140,
      sortable: true,
      formatter: (row: ExpenditureRecord) => {
        return h('span', { style: 'color: #F56C6C; font-weight: 500' }, `¥${row.amount.toFixed(2)}`)
      }
    },
    {
      prop: 'reason',
      label: '支出原因',
      width: 120,
      formatter: (row: ExpenditureRecord) => {
        const colorMap: Record<string, string> = {
          采购支出: '#409EFF',
          运营成本: '#E6A23C',
          员工工资: '#67C23A',
          政府税收: '#F56C6C',
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
      formatter: (row: ExpenditureRecord) => {
        return row.relatedOrder || h('span', { style: 'color: #C0C4CC' }, '-')
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
      formatter: (row: ExpenditureRecord) => {
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
      formatter: (row: ExpenditureRecord) => {
        return row.remark || h('span', { style: 'color: #C0C4CC' }, '-')
      }
    },
    {
      prop: 'operation',
      label: '操作',
      width: 100,
      fixed: 'right',
      formatter: (row: ExpenditureRecord) => {
        // 只有超级管理员才显示删除按钮
        if (isSuperAdmin.value) {
          return h('div', { class: 'flex gap-2' }, [
            h(ArtButtonTable, {
              type: 'delete',
              onClick: () => deleteRecord(row)
            })
          ])
        } else {
          return h('span', { style: 'color: #C0C4CC; font-size: 12px;' }, '无操作权限')
        }
      }
    }
  ])

  // 表单验证规则
  const rules = reactive<FormRules>({
    amount: [
      { required: true, message: '请输入支出金额', trigger: 'blur' },
      {
        validator: (rule, value, callback) => {
          if (value <= 0) {
            callback(new Error('支出金额必须大于0'))
          } else {
            callback()
          }
        },
        trigger: 'blur'
      }
    ],
    reason: [{ required: true, message: '请选择支出原因', trigger: 'change' }]
  })

  // 获取支出记录列表数据
  const getExpenditureRecordList = async () => {
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

      const response = await FinanceService.getExpenditureRecordList(params)

      if (response.code === 200) {
        tableData.value = response.data.list || []
        pagination.total = response.data.total || 0
      } else {
        ElMessage.error(response.msg || '获取支出记录失败')
        tableData.value = []
        pagination.total = 0
      }
    } catch (error) {
      console.error('获取支出记录失败:', error)
      ElMessage.error('获取支出记录失败')
      tableData.value = []
      pagination.total = 0
    } finally {
      loading.value = false
    }
  }

  // 提交表单（仅新增）
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

      const response = await FinanceService.createExpenditureRecord(requestData)

      if (response.code === 200) {
        ElMessage.success('新增成功')
        dialogVisible.value = false
        await getExpenditureRecordList()
      } else {
        ElMessage.error(response.msg || '新增失败')
      }
    } catch (error) {
      console.error('提交失败:', error)
      ElMessage.error('提交失败')
    } finally {
      submitLoading.value = false
    }
  }

  const handleRefresh = () => {
    getExpenditureRecordList()
  }

  // 处理表格行选择变化
  const handleSelectionChange = (selection: ExpenditureRecord[]) => {
    selectedRows.value = selection
  }

  // 处理表格分页变化
  const handleSizeChange = (newPageSize: number) => {
    pagination.pageSize = newPageSize
    pagination.currentPage = 1
    getExpenditureRecordList()
  }

  const handleCurrentChange = (newCurrentPage: number) => {
    pagination.currentPage = newCurrentPage
    getExpenditureRecordList()
  }

  // 组件挂载时获取数据
  onMounted(() => {
    getExpenditureRecordList()
  })
</script>

<style lang="scss" scoped>
  .expenditure-record-page {
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
