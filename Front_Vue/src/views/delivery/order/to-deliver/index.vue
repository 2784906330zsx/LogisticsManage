<template>
  <ArtTableFullScreen>
    <div class="delivery-to-deliver-page" id="table-full-screen">
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
              <ElTag type="info">待配送运单</ElTag>
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

        <!-- 分配配送员对话框 -->
        <ElDialog v-model="dialogVisible" title="分配配送员" width="500px" align-center>
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
            <ElFormItem label="配送员" prop="deliveryPersonName">
              <ElSelect v-model="formData.deliveryPersonName" placeholder="请选择配送员">
                <ElOption label="李配送" value="李配送" />
                <ElOption label="王配送" value="王配送" />
                <ElOption label="陈配送" value="陈配送" />
                <ElOption label="张配送" value="张配送" />
              </ElSelect>
            </ElFormItem>
            <ElFormItem label="配送员电话" prop="deliveryPersonPhone">
              <ElInput v-model="formData.deliveryPersonPhone" placeholder="请输入配送员电话" />
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
  import { h } from 'vue'
  import { SHIPPING_ORDER_DATA } from '@/mock/temp/formData'
  import { ElDialog, FormInstance, ElImage, ElTag, ElButton } from 'element-plus'
  import { ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { SearchChangeParams, SearchFormItem } from '@/types'

  const { width } = useWindowSize()

  defineOptions({ name: 'DeliveryToDeliver' })

  const dialogVisible = ref(false)
  const loading = ref(false)

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

  // 显示分配配送员对话框
  const showAssignDialog = (row: any) => {
    currentOrder.value = { ...row }
    dialogVisible.value = true

    // 重置表单验证状态
    if (formRef.value) {
      formRef.value.resetFields()
    }

    // 重置表单数据
    formData.deliveryPersonName = ''
    formData.deliveryPersonPhone = ''
  }

  // 动态列配置
  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection' },
    {
      prop: 'orderNumber',
      label: '运单号',
      width: 160
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
      minWidth: 300,
      formatter: (row: any) => {
        return h('div', { style: 'line-height: 1.4;' }, [
          h('div', { style: 'font-weight: bold; margin-bottom: 4px;' }, row.receiverName),
          h(
            'div',
            { style: 'font-size: 12px; color: #666; margin-bottom: 2px;' },
            row.receiverPhone
          ),
          h(
            'div',
            {
              style: 'font-size: 12px; color: #999; word-break: break-all; line-height: 1.3;'
            },
            row.receiverAddress
          )
        ])
      }
    },
    {
      prop: 'status',
      label: '订单状态',
      width: 120
      // ,
      // formatter: (row: any) => {
      //   return h(ElTag, { type: 'info' }, () => '待配送')
      // }
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

  // 表单实例
  const formRef = ref<FormInstance>()

  // 表单数据
  const formData = reactive({
    deliveryPersonName: '',
    deliveryPersonPhone: ''
  })

  onMounted(() => {
    getToDeliverOrderList()
  })

  // 获取待配送运单列表数据
  const getToDeliverOrderList = async () => {
    loading.value = true
    try {
      const { currentPage, pageSize } = pagination

      // 模拟API调用
      await new Promise((resolve) => setTimeout(resolve, 500))

      // 只获取状态为'3'（待配送）的运单
      let filteredData = SHIPPING_ORDER_DATA.filter((item) => item.status === '3')

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

      const total = filteredData.length
      const start = (currentPage - 1) * pageSize
      const end = start + pageSize

      tableData.value = filteredData.slice(start, end)
      pagination.total = total
    } catch (error) {
      console.error('获取待配送运单列表失败:', error)
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

  // 表单验证规则
  const rules = reactive<FormRules>({
    deliveryPersonName: [{ required: true, message: '请选择配送员', trigger: 'change' }],
    deliveryPersonPhone: [
      { required: true, message: '请输入配送员电话', trigger: 'blur' },
      { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
    ]
  })

  // 分配配送员
  const handleAssignDelivery = async () => {
    if (!formRef.value) return

    await formRef.value.validate((valid) => {
      if (valid) {
        // 这里应该调用API更新运单状态为配送中，并分配配送员
        console.log('分配配送员:', {
          orderId: currentOrder.value.id,
          deliveryPersonName: formData.deliveryPersonName,
          deliveryPersonPhone: formData.deliveryPersonPhone
        })

        ElMessage.success('配送员分配成功')
        dialogVisible.value = false
        getToDeliverOrderList()
      }
    })
  }

  // 处理表格分页变化
  const handleSizeChange = (newPageSize: number) => {
    pagination.pageSize = newPageSize
    getToDeliverOrderList()
  }

  const handleCurrentChange = (newCurrentPage: number) => {
    pagination.currentPage = newCurrentPage
    getToDeliverOrderList()
  }
</script>

<style scoped>
  .delivery-to-deliver-page {
    height: 100%;
  }

  .flex {
    display: flex;
  }

  .items-center {
    align-items: center;
  }

  .gap-2 {
    gap: 8px;
  }

  .text-sm {
    font-size: 14px;
  }

  .text-gray-500 {
    color: #6b7280;
  }

  .commodity-info {
    display: flex;
    align-items: center;
  }

  .commodity-image {
    flex-shrink: 0;
  }
</style>
