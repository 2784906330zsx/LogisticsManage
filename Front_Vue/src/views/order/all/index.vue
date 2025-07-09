<template>
  <ArtTableFullScreen>
    <div class="shipping-order-page" id="table-full-screen">
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
              <ElTag type="primary">运单管理</ElTag>
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

        <!-- 编辑运单对话框 -->
        <ElDialog v-model="dialogVisible" title="编辑运单" width="600px" align-center>
          <ElForm ref="formRef" :model="formData" :rules="rules" label-width="120px">
            <ElRow :gutter="20">
              <ElCol :span="12">
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
              </ElCol>
              <ElCol :span="12">
                <ElFormItem label="商品数量" prop="quantity">
                  <ElInputNumber v-model="formData.quantity" :min="1" style="width: 100%" />
                </ElFormItem>
              </ElCol>
            </ElRow>
            <ElRow :gutter="20">
              <ElCol :span="12">
                <ElFormItem label="收货人姓名" prop="receiverName">
                  <ElInput v-model="formData.receiverName" placeholder="请输入收货人姓名" />
                </ElFormItem>
              </ElCol>
              <ElCol :span="12">
                <ElFormItem label="联系方式" prop="receiverPhone">
                  <ElInput v-model="formData.receiverPhone" placeholder="请输入联系方式" />
                </ElFormItem>
              </ElCol>
            </ElRow>
            <ElFormItem label="收货地址" prop="receiverAddress">
              <ElInput
                v-model="formData.receiverAddress"
                type="textarea"
                :rows="3"
                placeholder="请输入详细收货地址"
              />
            </ElFormItem>
            <ElFormItem label="订单状态" prop="status">
              <ElSelect v-model="formData.status" placeholder="请选择订单状态">
                <ElOption label="待确认" value="1" />
                <ElOption label="确认未通过" value="2" />
                <ElOption label="待配送" value="3" />
                <ElOption label="配送中" value="4" />
                <ElOption label="已送达" value="5" />
                <ElOption label="已确认收货" value="6" />
                <ElOption label="已取消" value="7" />
              </ElSelect>
            </ElFormItem>
            <ElFormItem label="物流跟踪信息" prop="trackingInfo">
              <ElInput
                v-model="formData.trackingInfo"
                type="textarea"
                :rows="2"
                placeholder="请输入物流跟踪信息"
              />
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
  import { DeliveryService } from '@/api/orderApi'
  import { COMMODITY_LIST_DATA } from '@/mock/formData'
  import { ElDialog, FormInstance, ElImage, ElTag, ElButton } from 'element-plus'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { SearchChangeParams, SearchFormItem } from '@/types'

  defineOptions({ name: 'ShippingOrderAll' })

  const dialogVisible = ref(false)
  const loading = ref(false)

  // 定义表单搜索初始值
  const initialSearchState = {
    orderNumber: '',
    commodityName: '',
    receiverName: '',
    status: ''
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
    getShippingOrderList()
  }

  // 搜索处理
  const handleSearch = () => {
    console.log('搜索参数:', formFilters)
    if (formFilters.commodityName || formFilters.receiverName) {
      ElMessage.warning('请使用运单号和状态搜索')
    }
    pagination.currentPage = 1
    getShippingOrderList()
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
    },
    {
      label: '订单状态',
      prop: 'status',
      type: 'select',
      config: {
        clearable: true
      },
      options: () => [
        { label: '待确认', value: '1' },
        { label: '确认未通过', value: '2' },
        { label: '已确认，待配送', value: '3' },
        { label: '配送中', value: '4' },
        { label: '已送达', value: '5' },
        { label: '已确认收货', value: '6' },
        { label: '退货待审核', value: '7' },
        { label: '审核未通过', value: '8' },
        { label: '已退货', value: '9' }
      ],
      onChange: handleFormChange
    }
  ]

  // 显示编辑对话框
  const showDialog = (row: any) => {
    dialogVisible.value = true

    // 重置表单验证状态
    if (formRef.value) {
      formRef.value.resetFields()
    }

    formData.commodityId = row.commodityId
    formData.quantity = row.quantity
    formData.receiverName = row.receiverName
    formData.receiverPhone = row.receiverPhone
    formData.receiverAddress = row.receiverAddress
    formData.status = row.status
    formData.trackingInfo = row.trackingInfo || ''
  }

  // 处理商品选择变化
  const handleCommodityChange = (commodityId: number) => {
    const commodity = COMMODITY_LIST_DATA.find((item) => item.id === commodityId)
    if (commodity) {
      // 可以在这里设置一些默认值
    }
  }

  // 删除运单
  const deleteShippingOrder = () => {
    ElMessageBox.confirm('确定要删除该运单吗？', '删除运单', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'error'
    }).then(() => {
      ElMessage.success('删除成功')
    })
  }

  // 获取状态标签类型
  const getStatusTagType = (
    status: string
  ): 'primary' | 'success' | 'warning' | 'info' | 'danger' => {
    const statusMap: Record<string, 'primary' | 'success' | 'warning' | 'info' | 'danger'> = {
      '1': 'warning', // 待确认
      '2': 'danger', // 确认未通过
      '3': 'info', // 待配送
      '4': 'primary', // 配送中
      '5': 'success', // 已送达
      '6': 'success', // 已确认收货
      '7': 'info', // 待退货审核
      '8': 'info', // 审核未通过
      '9': 'danger' // 已退货
    }
    return statusMap[status] || 'info'
  }

  // 获取状态文本
  const getStatusText = (status: string) => {
    const statusMap: Record<string, string> = {
      '1': '待确认',
      '2': '确认未通过',
      '3': '已确认，待配送',
      '4': '配送中',
      '5': '已送达',
      '6': '已确认收货',
      '7': '退货待审核',
      '8': '审核未通过',
      '9': '已退货'
    }
    return statusMap[status] || '未知状态'
  }

  // 动态列配置
  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection' },
    {
      prop: 'orderNumber',
      label: '运单号',
      width: 140
    },
    {
      prop: 'commodityImage',
      label: '商品信息',
      width: 200,
      formatter: (row: any) => {
        return h('div', { class: 'commodity-info', style: 'display: flex; align-items: center' }, [
          h(ElImage, {
            class: 'commodity-image',
            src: row.commodityImage,
            style: 'width: 60px; height: 60px; border-radius: 6px; margin-right: 12px',
            fit: 'cover',
            lazy: true,
            // 添加错误处理
            onError: () => {
              // 图片加载失败时的处理
              console.warn('商品图片加载失败:', row.commodityImage)
            },
            // 添加占位图片
            placeholder: '/default-commodity.png'
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
      label: '收货信息',
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
      width: 120,
      formatter: (row: any) => {
        return h(ElTag, { type: getStatusTagType(row.status) }, () => getStatusText(row.status))
      }
    },
    {
      prop: 'createTime',
      label: '创建时间',
      sortable: true,
      width: 160
    },
    {
      prop: 'creator',
      label: '创建人',
      width: 120,
      formatter: (row: any) => {
        return h('div', { style: 'line-height: 1.4;' }, [
          h('div', { style: 'font-weight: bold; margin-bottom: 2px;' }, row.creatorName || '-'),
          h('div', { style: 'font-size: 12px; color: #666;' }, row.creatorJobNumber || '-')
        ])
      }
    },
    {
      prop: 'completeTime',
      label: '完成时间',
      width: 160,
      formatter: (row: any) => row.completeTime || '-'
    },
    {
      prop: 'operation',
      label: '操作',
      width: 150,
      formatter: (row: any) => {
        return h('div', [
          h(ArtButtonTable, {
            type: 'edit',
            onClick: () => showDialog(row)
          }),
          h(ArtButtonTable, {
            type: 'delete',
            onClick: () => deleteShippingOrder()
          })
        ])
      }
    }
  ])

  // 表单实例
  const formRef = ref<FormInstance>()

  // 表单数据
  const formData = reactive({
    commodityId: undefined as number | undefined,
    quantity: 1,
    receiverName: '',
    receiverPhone: '',
    receiverAddress: '',
    status: '1',
    trackingInfo: ''
  })

  onMounted(() => {
    getShippingOrderList()
  })

  // 获取运单列表数据
  const getShippingOrderList = async () => {
    loading.value = true
    try {
      const { currentPage, pageSize } = pagination

      const params = {
        current: currentPage,
        size: pageSize,
        orderNumber: formFilters.orderNumber || undefined,
        status: formFilters.status || undefined
      }

      const response = await DeliveryService.getShippingOrderList(params)

      if (response.code === 200) {
        // 处理数据，补充缺失字段
        tableData.value = response.data.list.map((item: any) => ({
          ...item,
          // 移除硬编码的默认图片，使用后端返回的图片或提供备用图片
          commodityImage: item.commodityImage || '/default-commodity.png',
          completeTime: item.complete_time || '-'
        }))
        pagination.total = response.data.total
        pagination.currentPage = response.data.current
        pagination.pageSize = response.data.size
      } else {
        ElMessage.error(response.msg || '获取运单列表失败')
        tableData.value = []
        pagination.total = 0
      }
    } catch (error) {
      console.error('获取运单列表失败:', error)
      ElMessage.error('获取运单列表失败，请稍后重试')
      tableData.value = []
      pagination.total = 0
    } finally {
      loading.value = false
    }
  }

  const handleRefresh = () => {
    getShippingOrderList()
  }

  // 处理表格行选择变化
  const handleSelectionChange = (selection: any[]) => {
    selectedRows.value = selection
  }

  // 表单验证规则
  const rules = reactive<FormRules>({
    commodityId: [{ required: true, message: '请选择商品', trigger: 'change' }],
    quantity: [{ required: true, message: '请输入商品数量', trigger: 'blur' }],
    receiverName: [{ required: true, message: '请输入收货人姓名', trigger: 'blur' }],
    receiverPhone: [
      { required: true, message: '请输入联系方式', trigger: 'blur' },
      { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
    ],
    receiverAddress: [{ required: true, message: '请输入收货地址', trigger: 'blur' }]
  })

  // 提交表单
  const handleSubmit = async () => {
    if (!formRef.value) return

    await formRef.value.validate((valid) => {
      if (valid) {
        ElMessage.success('更新成功')
        dialogVisible.value = false
        getShippingOrderList()
      }
    })
  }

  // 处理表格分页变化
  const handleSizeChange = (newPageSize: number) => {
    pagination.pageSize = newPageSize
    getShippingOrderList()
  }

  const handleCurrentChange = (newCurrentPage: number) => {
    pagination.currentPage = newCurrentPage
    getShippingOrderList()
  }
</script>

<style scoped>
  .shipping-order-page {
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
