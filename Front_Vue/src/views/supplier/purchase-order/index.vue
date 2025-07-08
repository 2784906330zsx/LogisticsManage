<template>
  <ArtTableFullScreen>
    <div class="purchase-order-page" id="table-full-screen">
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
            <ElButton @click="showDialog('add')">新增采购订单</ElButton>
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
          :title="dialogType === 'add' ? '新增采购订单' : '编辑采购订单'"
          width="60%"
          align-center
        >
          <ElForm ref="formRef" :model="formData" :rules="rules" label-width="120px">
            <ElRow :gutter="20" v-if="dialogType === 'edit'">
              <ElCol :span="12">
                <ElFormItem label="订单编号">
                  <ElInput v-model="formData.orderNumber" readonly placeholder="自动生成" />
                </ElFormItem>
              </ElCol>
            </ElRow>
            <ElRow :gutter="20">
              <ElCol :span="12">
                <ElFormItem label="商品ID" prop="commodityCode">
                  <ElInput
                    v-model="formData.commodityCode"
                    placeholder="请输入商品ID"
                    @input="handleCommodityCodeChange"
                  />
                </ElFormItem>
              </ElCol>
              <ElCol :span="12">
                <ElFormItem label="采购商品" prop="commodityId">
                  <ElSelect
                    v-model="formData.commodityId"
                    placeholder="请选择采购商品"
                    filterable
                    remote
                    :remote-method="searchCommodities"
                    :loading="commodityLoading"
                    @change="handleCommodityChange"
                  >
                    <ElOption
                      v-for="commodity in commodityOptions"
                      :key="commodity.id"
                      :label="commodity.name"
                      :value="commodity.id"
                    />
                  </ElSelect>
                  <div
                    v-if="commodityNotFound"
                    style="color: #f56c6c; font-size: 12px; margin-top: 4px"
                  >
                    找不到该商品ID对应的商品
                  </div>
                </ElFormItem>
              </ElCol>
            </ElRow>
            <ElRow :gutter="20">
              <ElCol :span="12">
                <ElFormItem label="采购供应商">
                  <ElInput v-model="formData.supplierName" readonly placeholder="自动填充" />
                </ElFormItem>
              </ElCol>
              <ElCol :span="12">
                <ElFormItem label="采购单价" prop="unitPrice">
                  <ElInputNumber
                    v-model="formData.unitPrice"
                    :min="0"
                    :precision="2"
                    placeholder="请输入采购单价"
                    style="width: 100%"
                    @change="calculateTotal"
                  />
                </ElFormItem>
              </ElCol>
            </ElRow>
            <ElRow :gutter="20">
              <ElCol :span="12">
                <ElFormItem label="采购数量" prop="quantity">
                  <ElInputNumber
                    v-model="formData.quantity"
                    :min="1"
                    placeholder="请输入采购数量"
                    style="width: 100%"
                    @change="calculateTotal"
                  />
                </ElFormItem>
              </ElCol>
              <ElCol :span="12">
                <ElFormItem label="总金额">
                  <ElInput
                    :value="formData.totalAmount.toFixed(2)"
                    readonly
                    placeholder="自动计算"
                  />
                </ElFormItem>
              </ElCol>
            </ElRow>
          </ElForm>
          <template #footer>
            <div class="dialog-footer">
              <ElButton @click="dialogVisible = false">取消</ElButton>
              <ElButton type="primary" @click="handleSubmit" :loading="submitLoading"
                >提交</ElButton
              >
            </div>
          </template>
        </ElDialog>
      </ElCard>
    </div>
  </ArtTableFullScreen>
</template>

<script setup lang="ts">
  import { h } from 'vue'
  import { PURCHASE_ORDER_DATA, COMMODITY_LIST_DATA, SUPPLIER_LIST_DATA } from '@/mock/formData'
  import { ElDialog, FormInstance, ElTag, ElImage } from 'element-plus'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { SearchChangeParams, SearchFormItem } from '@/types'
  import { PurchaseService } from '@/api/purchaseApi'

  // 定义商品类型接口
  interface CommodityOption {
    id: number
    name: string
    price: number
    supplier?: string
  }

  // 定义API响应类型
  interface ApiResponse<T = any> {
    code: number
    data: T
    message?: string
    msg?: string
  }

  defineOptions({ name: 'PurchaseOrder' })

  const dialogType = ref('add')
  const dialogVisible = ref(false)
  const loading = ref(false)
  const submitLoading = ref(false)
  const commodityLoading = ref(false)
  const commodityNotFound = ref(false)
  const commodityOptions = ref<CommodityOption[]>([])

  // 定义表单搜索初始值
  const initialSearchState = {
    orderNumber: '',
    commodityName: '',
    supplierName: '',
    status: '',
    purchaserName: ''
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
    getPurchaseOrderList()
  }

  // 搜索处理
  const handleSearch = () => {
    console.log('搜索参数:', formFilters)
    pagination.currentPage = 1
    getPurchaseOrderList()
  }

  // 表单项变更处理
  const handleFormChange = (params: SearchChangeParams): void => {
    console.log('表单项变更:', params)
  }

  // 表单配置项
  const formItems: SearchFormItem[] = [
    {
      label: '订单编号',
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
      label: '供应商',
      prop: 'supplierName',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '订单状态',
      prop: 'status',
      type: 'select',
      config: {
        clearable: true
      },
      options: () => [
        { label: '财务审核中', value: '1' },
        { label: '审核未通过', value: '2' },
        { label: '待入库', value: '3' },
        { label: '已入库', value: '4' },
        { label: '已取消', value: '5' }
      ],
      onChange: handleFormChange
    },
    {
      label: '采购人',
      prop: 'purchaserName',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    }
  ]

  // 获取标签类型
  const getTagType = (status: string) => {
    switch (status) {
      case '1':
        return 'warning'
      case '2':
        return 'info'
      case '3':
        return 'success'
      case '4':
        return 'danger'
      case '5':
        return 'danger'
      default:
        return 'info'
    }
  }

  // 构建标签文本
  const buildTagText = (status: string) => {
    switch (status) {
      case '1':
        return '财务审核中'
      case '2':
        return '审核未通过'
      case '3':
        return '待入库'
      case '4':
        return '已入库'
      case '5':
        return '已取消'
      default:
        return '未知'
    }
  }

  const showDialog = (type: string, row?: any) => {
    dialogVisible.value = true
    dialogType.value = type
    commodityNotFound.value = false

    // 重置表单验证状态
    if (formRef.value) {
      formRef.value.resetFields()
    }

    if (type === 'edit' && row) {
      formData.orderNumber = row.orderNumber
      formData.commodityCode = row.commodityCode || ''
      formData.commodityId = row.commodityId
      formData.supplierId = row.supplierId
      formData.supplierName = row.supplierName
      formData.unitPrice = row.unitPrice
      formData.quantity = row.quantity
      formData.totalAmount = row.totalAmount
      formData.orderTime = row.orderTime
      formData.status = row.status
    } else {
      formData.orderNumber = ''
      formData.commodityCode = ''
      formData.commodityId = undefined
      formData.supplierId = undefined
      formData.supplierName = ''
      formData.unitPrice = 0
      formData.quantity = 1
      formData.totalAmount = 0
      formData.status = '1'
    }

    // 初始化商品选项
    if (type === 'add') {
      searchCommodities('')
    }
  }

  // 删除采购订单
  const deletePurchaseOrder = () => {
    ElMessageBox.confirm('确定要删除该采购订单吗？', '删除采购订单', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'error'
    }).then(() => {
      ElMessage.success('删除成功')
      getPurchaseOrderList()
    })
  }

  // 动态列配置
  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection' },
    {
      prop: 'orderNumber',
      label: '订单编号',
      width: 160
    },
    {
      prop: 'commodityImage',
      label: '商品图片',
      width: 80,
      formatter: (row: any) => {
        return h(ElImage, {
          src: row.commodityImage,
          style: { width: '50px', height: '50px' },
          fit: 'cover',
          previewSrcList: [row.commodityImage]
        })
      }
    },
    {
      prop: 'commodityName',
      label: '商品名称',
      minWidth: 180
    },
    {
      prop: 'supplierName',
      label: '供应商',
      minWidth: 200
    },
    {
      prop: 'unitPrice',
      label: '采购单价',
      width: 120,
      formatter: (row: any) => {
        return `¥${row.unitPrice.toFixed(2)}`
      }
    },
    {
      prop: 'quantity',
      label: '采购数量',
      width: 100
    },
    {
      prop: 'totalAmount',
      label: '总金额',
      width: 140,
      formatter: (row: any) => {
        return `¥${row.totalAmount.toFixed(2)}`
      }
    },
    {
      prop: 'orderTime',
      label: '下单时间',
      width: 160,
      sortable: true
    },
    {
      prop: 'status',
      label: '订单状态',
      width: 100,
      formatter: (row) => {
        return h(ElTag, { type: getTagType(row.status) }, () => buildTagText(row.status))
      }
    },
    {
      prop: 'purchaser',
      label: '采购人',
      width: 120,
      formatter: (row: any) => {
        return h('div', { style: 'line-height: 1.2;' }, [
          h('div', { style: 'font-weight: bold;' }, row.purchaserName),
          h('div', { style: 'font-size: 12px; color: #999;' }, row.purchaserJobNumber)
        ])
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
            onClick: () => deletePurchaseOrder()
          })
        ])
      }
    }
  ])

  // 表单实例
  const formRef = ref<FormInstance>()

  // 表单数据
  const formData = reactive({
    orderNumber: '',
    commodityCode: '',
    commodityId: undefined as number | undefined,
    supplierId: undefined as number | undefined,
    supplierName: '',
    unitPrice: 0,
    quantity: 1,
    totalAmount: 0,
    orderTime: '',
    status: '1'
  })

  onMounted(() => {
    getPurchaseOrderList()
  })

  // 搜索商品
  const searchCommodities = async (query: string) => {
    commodityLoading.value = true
    try {
      const response = (await PurchaseService.getCommodityList({
        name: query,
        pageSize: 50
      })) as ApiResponse<{ list: CommodityOption[] }>

      if (response.code === 200) {
        commodityOptions.value = response.data.list
      }
    } catch (error) {
      console.error('搜索商品失败:', error)
      // 使用模拟数据作为后备
      let filteredData = [...COMMODITY_LIST_DATA] as CommodityOption[]
      if (query) {
        filteredData = filteredData.filter((item) =>
          item.name.toLowerCase().includes(query.toLowerCase())
        )
      }
      commodityOptions.value = filteredData
    } finally {
      commodityLoading.value = false
    }
  }

  // 商品选择变化
  const handleCommodityChange = async (commodityId: number) => {
    if (commodityId) {
      try {
        const response = (await PurchaseService.getCommodityInfo(commodityId)) as ApiResponse<{
          id: number
          name: string
          price: number
          supplier?: { id: number; name: string }
        }>

        if (response.code === 200) {
          const commodity = response.data
          formData.commodityCode = commodity.id.toString()
          formData.unitPrice = commodity.price
          if (commodity.supplier) {
            formData.supplierId = commodity.supplier.id
            formData.supplierName = commodity.supplier.name
          }
          calculateTotal()
        }
      } catch (error) {
        console.error('获取商品信息失败:', error)
        // 使用模拟数据作为后备
        const commodity = COMMODITY_LIST_DATA.find((item) => item.id === commodityId)
        if (commodity) {
          formData.commodityCode = commodity.id.toString()
          formData.unitPrice = commodity.price
          formData.supplierName = commodity.supplier || ''
          // 查找供应商ID
          const supplier = SUPPLIER_LIST_DATA.find((s) => s.name === commodity.supplier)
          if (supplier) {
            formData.supplierId = supplier.id
          }
          calculateTotal()
        }
      }
    }
  }

  // 商品ID输入变化
  const handleCommodityCodeChange = (value: string) => {
    commodityNotFound.value = false

    if (value) {
      const commodityId = parseInt(value)
      if (!isNaN(commodityId)) {
        // 在商品选项中查找
        const commodity = commodityOptions.value.find(
          (item: CommodityOption) => item.id === commodityId
        )
        if (commodity) {
          formData.commodityId = commodityId
          handleCommodityChange(commodityId)
        } else {
          // 从模拟数据中查找
          const mockCommodity = COMMODITY_LIST_DATA.find((item) => item.id === commodityId)
          if (mockCommodity) {
            formData.commodityId = commodityId
            formData.unitPrice = mockCommodity.price
            formData.supplierName = mockCommodity.supplier || ''
            const supplier = SUPPLIER_LIST_DATA.find((s) => s.name === mockCommodity.supplier)
            if (supplier) {
              formData.supplierId = supplier.id
            }
            calculateTotal()
          } else {
            commodityNotFound.value = true
          }
        }
      }
    }
  }

  // 计算总金额
  const calculateTotal = () => {
    formData.totalAmount = formData.unitPrice * formData.quantity
  }

  // 获取采购订单列表数据
  const getPurchaseOrderList = async () => {
    loading.value = true
    try {
      const { currentPage, pageSize } = pagination

      // 调用真实API
      const response = (await PurchaseService.getPurchaseOrderList({
        current: currentPage,
        size: pageSize,
        orderNumber: formFilters.orderNumber || undefined,
        commodityName: formFilters.commodityName || undefined,
        supplierName: formFilters.supplierName || undefined,
        status: formFilters.status || undefined,
        purchaserName: formFilters.purchaserName || undefined
      })) as ApiResponse<{ list: any[]; total: number }>

      if (response.code === 200 && response.data) {
        tableData.value = response.data.list
        pagination.total = response.data.total
      } else {
        ElMessage.error(response.msg || '获取采购订单列表失败')
      }
    } catch (error) {
      console.error('获取采购订单列表失败:', error)
      ElMessage.error('获取采购订单列表失败')

      // 如果API调用失败，使用模拟数据作为后备
      let filteredData = [...PURCHASE_ORDER_DATA]

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

      if (formFilters.supplierName) {
        filteredData = filteredData.filter((item) =>
          item.supplierName.toLowerCase().includes(formFilters.supplierName.toLowerCase())
        )
      }

      if (formFilters.status) {
        filteredData = filteredData.filter((item) => item.status === formFilters.status)
      }

      if (formFilters.purchaserName) {
        filteredData = filteredData.filter((item) =>
          item.purchaserName.toLowerCase().includes(formFilters.purchaserName.toLowerCase())
        )
      }

      const total = filteredData.length
      const start = (pagination.currentPage - 1) * pagination.pageSize
      const end = start + pagination.pageSize

      tableData.value = filteredData.slice(start, end)
      pagination.total = total
    } finally {
      loading.value = false
    }
  }

  const handleRefresh = () => {
    getPurchaseOrderList()
  }

  // 处理表格行选择变化
  const handleSelectionChange = (selection: any[]) => {
    selectedRows.value = selection
  }

  // 表单验证规则
  const rules = reactive<FormRules>({
    commodityCode: [{ required: true, message: '请输入商品ID', trigger: 'blur' }],
    commodityId: [{ required: true, message: '请选择采购商品', trigger: 'change' }],
    unitPrice: [
      { required: true, message: '请输入采购单价', trigger: 'blur' },
      { type: 'number', min: 0.01, message: '采购单价必须大于0', trigger: 'blur' }
    ],
    quantity: [
      { required: true, message: '请输入采购数量', trigger: 'blur' },
      { type: 'number', min: 1, message: '采购数量必须大于0', trigger: 'blur' }
    ]
  })

  // 提交表单
  const handleSubmit = async () => {
    if (!formRef.value) return

    try {
      await formRef.value.validate()

      submitLoading.value = true

      if (dialogType.value === 'add') {
        // 新增采购订单
        const response = (await PurchaseService.addPurchaseOrder({
          commodityId: formData.commodityId,
          supplierId: formData.supplierId,
          unitPrice: formData.unitPrice,
          quantity: formData.quantity
        })) as ApiResponse<{ id: number; orderNumber: string }>

        if (response.code === 200) {
          ElMessage.success('采购订单创建成功')
          dialogVisible.value = false
          await getPurchaseOrderList()
        } else {
          ElMessage.error(response.msg || '创建失败')
        }
      } else {
        // 编辑采购订单（如果需要的话）
        ElMessage.success('更新成功')
        dialogVisible.value = false
        getPurchaseOrderList()
      }
    } catch (error) {
      console.error('提交失败:', error)
      ElMessage.error('提交失败')
    } finally {
      submitLoading.value = false
    }
  }

  // 处理表格分页变化
  const handleSizeChange = (newPageSize: number) => {
    pagination.pageSize = newPageSize
    getPurchaseOrderList()
  }

  const handleCurrentChange = (newCurrentPage: number) => {
    pagination.currentPage = newCurrentPage
    getPurchaseOrderList()
  }
</script>
