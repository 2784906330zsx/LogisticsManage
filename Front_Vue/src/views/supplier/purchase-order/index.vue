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
                    @change="handleCommodityChange"
                  >
                    <ElOption
                      v-for="commodity in COMMODITY_LIST_DATA"
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
                <ElFormItem label="采购供应商" prop="supplierId">
                  <ElSelect v-model="formData.supplierId" placeholder="请选择供应商" filterable>
                    <ElOption
                      v-for="supplier in SUPPLIER_LIST_DATA"
                      :key="supplier.id"
                      :label="supplier.name"
                      :value="supplier.id"
                    />
                  </ElSelect>
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
                  />
                </ElFormItem>
              </ElCol>
            </ElRow>
            <ElRow :gutter="20">
              <ElCol :span="12">
                <ElFormItem label="总金额">
                  <ElInput
                    :value="(formData.unitPrice * formData.quantity).toFixed(2)"
                    readonly
                    placeholder="自动计算"
                  />
                </ElFormItem>
              </ElCol>
            </ElRow>
            <ElRow :gutter="20" v-if="formData.status === '3'">
              <ElCol :span="12">
                <ElFormItem label="入库时间" prop="inboundTime">
                  <ElDatePicker
                    v-model="formData.inboundTime"
                    type="datetime"
                    placeholder="请选择入库时间"
                    format="YYYY-MM-DD HH:mm:ss"
                    value-format="YYYY-MM-DD HH:mm:ss"
                    style="width: 100%"
                  />
                </ElFormItem>
              </ElCol>
              <ElCol :span="12">
                <ElFormItem label="入库人" prop="warehouseKeeperId">
                  <ElSelect
                    v-model="formData.warehouseKeeperId"
                    placeholder="请选择入库人"
                    filterable
                  >
                    <ElOption
                      v-for="user in ACCOUNT_TABLE_DATA"
                      :key="user.id"
                      :label="`${user.username} (${user.jobNumber})`"
                      :value="user.id"
                    />
                  </ElSelect>
                </ElFormItem>
              </ElCol>
            </ElRow>
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
  import {
    PURCHASE_ORDER_DATA,
    COMMODITY_LIST_DATA,
    SUPPLIER_LIST_DATA,
    ACCOUNT_TABLE_DATA
  } from '@/mock/temp/formData'
  import { ElDialog, FormInstance, ElTag, ElImage } from 'element-plus'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { SearchChangeParams, SearchFormItem } from '@/types'

  defineOptions({ name: 'PurchaseOrder' })

  const dialogType = ref('add')
  const dialogVisible = ref(false)
  const loading = ref(false)

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

  // 生成订单编号
  const generateOrderNumber = () => {
    const now = new Date()
    const year = now.getFullYear()
    const month = String(now.getMonth() + 1).padStart(2, '0')
    const day = String(now.getDate()).padStart(2, '0')
    const hours = String(now.getHours()).padStart(2, '0')
    const minutes = String(now.getMinutes()).padStart(2, '0')
    const seconds = String(now.getSeconds()).padStart(2, '0')
    const random = Math.floor(Math.random() * 1000)
      .toString()
      .padStart(3, '0')
    return `PO${year}${month}${day}${hours}${minutes}${seconds}${random}`
  }

  const showDialog = (type: string, row?: any) => {
    dialogVisible.value = true
    dialogType.value = type
    commodityNotFound.value = false // 重置错误提示状态

    // 重置表单验证状态
    if (formRef.value) {
      formRef.value.resetFields()
    }

    if (type === 'edit' && row) {
      formData.orderNumber = row.orderNumber
      formData.commodityCode = row.commodityCode || ''
      formData.commodityId = row.commodityId
      formData.supplierId = row.supplierId
      formData.unitPrice = row.unitPrice
      formData.quantity = row.quantity
      formData.orderTime = row.orderTime
      formData.inboundTime = row.inboundTime
      formData.status = row.status
      formData.warehouseKeeperId = row.warehouseKeeperId
    } else {
      formData.orderNumber = ''
      formData.commodityId = undefined
      formData.supplierId = undefined
      formData.unitPrice = 0
      formData.quantity = 1
      formData.inboundTime = ''
      formData.status = '1'
      formData.warehouseKeeperId = undefined
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
      prop: 'inboundTime',
      label: '入库时间',
      width: 160,
      formatter: (row: any) => {
        return row.inboundTime || '-'
      }
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
      prop: 'warehouseKeeper',
      label: '入库人',
      width: 120,
      formatter: (row: any) => {
        if (row.warehouseKeeperName) {
          return h('div', { style: 'line-height: 1.2;' }, [
            h('div', { style: 'font-weight: bold;' }, row.warehouseKeeperName),
            h('div', { style: 'font-size: 12px; color: #999;' }, row.warehouseKeeperJobNumber)
          ])
        }
        return '-'
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
  // 修改表单数据，添加commodityCode字段
  const formData = reactive({
    orderNumber: '',
    commodityCode: '', // 新增商品ID字段
    commodityId: undefined as number | undefined,
    supplierId: undefined as number | undefined,
    unitPrice: 0,
    quantity: 1,
    orderTime: '',
    inboundTime: '',
    status: '1',
    warehouseKeeperId: undefined as number | undefined
  })

  onMounted(() => {
    getPurchaseOrderList()
  })

  // 获取采购订单列表数据
  const getPurchaseOrderList = async () => {
    loading.value = true
    try {
      const { currentPage, pageSize } = pagination

      // 模拟API调用
      await new Promise((resolve) => setTimeout(resolve, 500))

      // 过滤数据
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
      const start = (currentPage - 1) * pageSize
      const end = start + pageSize

      tableData.value = filteredData.slice(start, end)
      pagination.total = total
    } catch (error) {
      console.error('获取采购订单列表失败:', error)
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
  // 修改表单验证规则，添加商品ID必填验证
  const rules = reactive<FormRules>({
    commodityCode: [{ required: true, message: '请输入商品ID', trigger: 'blur' }],
    commodityId: [{ required: true, message: '请选择采购商品', trigger: 'change' }],
    supplierId: [{ required: true, message: '请选择供应商', trigger: 'change' }],
    unitPrice: [
      { required: true, message: '请输入采购单价', trigger: 'blur' },
      { type: 'number', min: 0.01, message: '采购单价必须大于0', trigger: 'blur' }
    ],
    quantity: [
      { required: true, message: '请输入采购数量', trigger: 'blur' },
      { type: 'number', min: 1, message: '采购数量必须大于0', trigger: 'blur' }
    ],
    inboundTime: [
      {
        validator: (rule: any, value: any, callback: any) => {
          if (formData.status === '3' && !value) {
            callback(new Error('已入库状态必须填写入库时间'))
          } else {
            callback()
          }
        },
        trigger: 'change'
      }
    ],
    warehouseKeeperId: [
      {
        validator: (rule: any, value: any, callback: any) => {
          if (formData.status === '3' && !value) {
            callback(new Error('已入库状态必须选择入库人'))
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
        // 如果是新增订单，自动生成订单编号和设置下单时间
        if (dialogType.value === 'add') {
          formData.orderNumber = generateOrderNumber()
          formData.orderTime = new Date().toISOString().slice(0, 19).replace('T', ' ')
          formData.status = '1'
        }

        ElMessage.success(dialogType.value === 'add' ? '添加成功' : '更新成功')
        dialogVisible.value = false
        getPurchaseOrderList()
      }
    })
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

  // 修改商品关联处理函数
  // 当商品ID输入变化时，自动选择对应商品并填写供应商和单价
  const handleCommodityCodeChange = (value: string) => {
    commodityNotFound.value = false

    if (value) {
      const commodity = COMMODITY_LIST_DATA.find((item) => item.id.toString() === value)
      if (commodity) {
        formData.commodityId = commodity.id
        // 自动填写供应商
        const supplier = SUPPLIER_LIST_DATA.find((item) => item.name === commodity.supplier)
        if (supplier) {
          formData.supplierId = supplier.id
        }
        // 自动填写单价
        formData.unitPrice = commodity.price
      } else {
        // 商品ID不存在时显示错误提示
        commodityNotFound.value = true
        formData.commodityId = undefined
        formData.supplierId = undefined
        formData.unitPrice = 0
      }
    } else {
      formData.commodityId = undefined
      formData.supplierId = undefined
      formData.unitPrice = 0
    }
  }

  // 当商品选择变化时，自动填入商品ID、供应商和单价
  const handleCommodityChange = (value: number) => {
    commodityNotFound.value = false

    if (value) {
      const commodity = COMMODITY_LIST_DATA.find((item) => item.id === value)
      if (commodity) {
        formData.commodityCode = commodity.id.toString()
        // 自动填写供应商
        const supplier = SUPPLIER_LIST_DATA.find((item) => item.name === commodity.supplier)
        if (supplier) {
          formData.supplierId = supplier.id
        }
        // 自动填写单价
        formData.unitPrice = commodity.price
      }
    } else {
      formData.commodityCode = ''
      formData.supplierId = undefined
      formData.unitPrice = 0
    }
  }
  // 添加错误提示状态
  const commodityNotFound = ref(false)
</script>
