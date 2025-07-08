<template>
  <ArtTableFullScreen>
    <div class="inventory-page" id="table-full-screen">
      <!-- 搜索栏 -->
      <ArtSearchBar
        v-model:filter="formFilters"
        :items="formItems"
        @reset="handleReset"
        @search="handleSearch"
      ></ArtSearchBar>

      <ElCard shadow="never" class="art-table-card">
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

        <!-- 库存调整对话框 -->
        <ElDialog v-model="adjustDialogVisible" title="库存调整" width="500px" align-center>
          <ElForm ref="formRef" :model="formData" :rules="rules" label-width="120px">
            <ElFormItem label="商品名称" prop="name">
              <ElInput v-model="formData.name" disabled />
            </ElFormItem>
            <ElFormItem label="当前库存" prop="currentStock">
              <ElInputNumber v-model="formData.currentStock" disabled />
            </ElFormItem>
            <ElFormItem label="存储区域" prop="storageArea">
              <div style="display: flex; gap: 8px; align-items: center">
                <ElSelect
                  v-model="formData.selectedZone"
                  placeholder="选择区域"
                  style="width: 100px"
                >
                  <ElOption label="A区" value="A" />
                  <ElOption label="B区" value="B" />
                  <ElOption label="C区" value="C" />
                </ElSelect>
                <span>-</span>
                <ElSelect
                  v-model="formData.selectedLevel"
                  placeholder="选择层"
                  style="width: 100px"
                >
                  <ElOption label="L1层" value="L1" />
                  <ElOption label="L2层" value="L2" />
                  <ElOption label="L3层" value="L3" />
                </ElSelect>
                <span>-</span>
                <ElSelect
                  v-model="formData.selectedShelf"
                  placeholder="选择货架"
                  style="width: 100px"
                >
                  <ElOption
                    v-for="i in 10"
                    :key="i"
                    :label="`${String(i).padStart(2, '0')}号`"
                    :value="String(i).padStart(2, '0')"
                  />
                </ElSelect>
              </div>
            </ElFormItem>
            <ElFormItem label="调整类型" prop="adjustType">
              <ElSelect v-model="formData.adjustType">
                <ElOption label="入库" value="in" />
                <ElOption label="出库" value="out" />
              </ElSelect>
            </ElFormItem>
            <ElFormItem label="调整数量" prop="adjustQuantity">
              <ElInputNumber v-model="formData.adjustQuantity" :min="1" />
            </ElFormItem>
            <ElFormItem label="调整原因" prop="reason">
              <ElInput v-model="formData.reason" type="textarea" :rows="3" />
            </ElFormItem>
          </ElForm>
          <template #footer>
            <div class="dialog-footer">
              <ElButton @click="adjustDialogVisible = false">取消</ElButton>
              <ElButton type="primary" @click="handleSubmit">确认调整</ElButton>
            </div>
          </template>
        </ElDialog>
      </ElCard>
    </div>
  </ArtTableFullScreen>
</template>

<script setup lang="ts">
  import { h } from 'vue'
  import { StorageService } from '@/api/storageApi'
  import { ElDialog, FormInstance, ElImage, ElTag } from 'element-plus'
  import { ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { SearchChangeParams, SearchFormItem } from '@/types'

  defineOptions({ name: 'Inventory' })

  const adjustDialogVisible = ref(false)
  const loading = ref(false)

  // 定义表单搜索初始值
  const initialSearchState = {
    name: '',
    brand: '',
    supplier: '',
    storageArea: ''
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
    getInventoryList()
  }

  // 搜索处理
  const handleSearch = () => {
    console.log('搜索参数:', formFilters)
    pagination.currentPage = 1
    getInventoryList()
  }

  // 表单项变更处理
  const handleFormChange = (params: SearchChangeParams): void => {
    console.log('表单项变更:', params)
  }

  // 表单配置项
  const formItems: SearchFormItem[] = [
    {
      label: '商品名称',
      prop: 'name',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '品牌',
      prop: 'brand',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '供货商',
      prop: 'supplier',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '存储区域',
      prop: 'storageArea',
      type: 'input',
      config: {
        clearable: true,
        placeholder: '如：A区-L1层-01号'
      },
      onChange: handleFormChange
    }
  ]

  // 显示对话框
  const showDialog = (type: string, row?: any) => {
    adjustDialogVisible.value = true

    // 重置表单验证状态
    if (formRef.value) {
      formRef.value.resetFields()
    }

    if (row) {
      formData.id = row.id
      formData.name = row.name
      formData.currentStock = row.stock
      formData.adjustType = 'in'
      formData.adjustQuantity = 1
      formData.reason = ''

      // 解析存储区域
      const parts = row.storageArea.split('-')
      if (parts.length === 3) {
        formData.selectedZone = parts[0].replace('区', '')
        formData.selectedLevel = parts[1].replace('层', '')
        formData.selectedShelf = parts[2].replace('号', '')
      } else {
        formData.selectedZone = 'A'
        formData.selectedLevel = 'L1'
        formData.selectedShelf = '01'
      }
    }
  }

  // 动态列配置
  const { columns } = useCheckedColumns(() => [
    { type: 'selection' },
    {
      prop: 'id',
      label: '商品ID',
      sortable: true,
      width: 100
    },
    {
      prop: 'image',
      label: '商品信息',
      width: 200,
      formatter: (row: any) => {
        return h('div', { class: 'commodity-info', style: 'display: flex; align-items: center' }, [
          h(ElImage, {
            class: 'commodity-image',
            src: row.image,
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
              row.name
            )
          ])
        ])
      }
    },
    {
      prop: 'price',
      label: '进货价',
      sortable: true,
      formatter: (row: any) => `¥${row.price}`
    },
    {
      prop: 'stock',
      label: '库存数',
      sortable: true,
      formatter: (row: any) => {
        return h('div', { style: 'display: flex; align-items: center; gap: 8px' }, [
          h('span', { style: 'font-weight: 500' }, row.stock)
        ])
      }
    },
    {
      prop: 'totalInbound',
      label: '总入库数量',
      width: 120,
      sortable: true
    },
    {
      prop: 'totalOutbound',
      label: '总出库数量',
      width: 120,
      sortable: true
    },
    {
      prop: 'supplier',
      label: '供货商',
      minWidth: 150
    },
    {
      prop: 'storageArea',
      label: '存储区域',
      width: 130,
      formatter: (row: any) => {
        return h(
          ElTag,
          {
            type: 'info',
            size: 'small'
          },
          () => row.storageArea
        )
      }
    },
    {
      prop: 'lastUpdateTime',
      label: '最近更新时间',
      sortable: true,
      minWidth: 160
    },
    {
      prop: 'operation',
      label: '操作',
      width: 120,
      formatter: (row: any) => {
        return h('div', [
          h(ArtButtonTable, {
            type: 'edit',
            text: '调整',
            onClick: () => showDialog('adjust', row)
          })
        ])
      }
    }
  ])

  // 表单实例
  const formRef = ref<FormInstance>()

  // 表单数据
  const formData = reactive({
    id: 0,
    name: '',
    currentStock: 0,
    selectedZone: 'A',
    selectedLevel: 'L1',
    selectedShelf: '01',
    adjustType: 'in',
    adjustQuantity: 1,
    reason: ''
  })

  onMounted(() => {
    getInventoryList()
  })

  // 获取库存列表数据
  const getInventoryList = async () => {
    loading.value = true
    try {
      const params = {
        current: pagination.currentPage,
        size: pagination.pageSize,
        ...formFilters
      }

      const response = await StorageService.getInventoryList(params)

      if (response.code === 200) {
        tableData.value = response.data.list
        pagination.total = response.data.total
      } else {
        ElMessage.error(response.msg || '获取库存列表失败')
      }
    } catch (error) {
      console.error('获取库存列表失败:', error)
      ElMessage.error('获取库存列表失败')
    } finally {
      loading.value = false
    }
  }

  // 处理表格行选择变化
  const handleSelectionChange = (selection: any[]) => {
    selectedRows.value = selection
  }

  // 表单验证规则
  const rules = reactive<FormRules>({
    selectedZone: [{ required: true, message: '请选择存储区域', trigger: 'change' }],
    selectedLevel: [{ required: true, message: '请选择存储层级', trigger: 'change' }],
    selectedShelf: [{ required: true, message: '请选择货架号', trigger: 'change' }],
    adjustType: [{ required: true, message: '请选择调整类型', trigger: 'change' }],
    adjustQuantity: [{ required: true, message: '请输入调整数量', trigger: 'blur' }],
    reason: [{ required: true, message: '请输入调整原因', trigger: 'blur' }]
  })

  // 提交表单
  // 提交表单
  const handleSubmit = async () => {
    if (!formRef.value) return

    await formRef.value.validate(async (valid) => {
      if (valid) {
        try {
          loading.value = true

          // 构建调整库存的请求数据
          const adjustData: {
            commodityId: number
            adjustType: '入库' | '出库'
            quantity: number
            reason: string
          } = {
            commodityId: formData.id,
            adjustType: formData.adjustType === 'in' ? '入库' : '出库',
            quantity: formData.adjustQuantity,
            reason: formData.reason
          }

          // 调用库存调整API
          const response = await StorageService.adjustInventory(adjustData)

          if (response.code === 200) {
            ElMessage.success('库存调整成功')
            adjustDialogVisible.value = false
            getInventoryList() // 刷新列表
          } else {
            ElMessage.error(response.msg || '库存调整失败')
          }
        } catch (error) {
          console.error('库存调整失败:', error)
          ElMessage.error('库存调整失败')
        } finally {
          loading.value = false
        }
      }
    })
  }

  // 处理表格分页变化
  const handleSizeChange = (newPageSize: number) => {
    pagination.pageSize = newPageSize
    getInventoryList()
  }

  const handleCurrentChange = (newCurrentPage: number) => {
    pagination.currentPage = newCurrentPage
    getInventoryList()
  }
</script>

<style lang="scss" scoped>
  .inventory-page {
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

<style scoped>
  .storage-selection {
    display: flex;
    gap: 10px;
  }

  .storage-selection .el-select {
    flex: 1;
  }
</style>
