<template>
  <ArtTableFullScreen>
    <div class="commodity-page" id="table-full-screen">
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
            <ElButton @click="showDialog('add')">新增商品</ElButton>
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
          :title="dialogType === 'add' ? '新增商品' : '编辑商品'"
          width="40%"
          align-center
        >
          <ElForm ref="formRef" :model="formData" :rules="rules" label-width="100px">
            <ElFormItem label="商品名称" prop="name">
              <ElInput v-model="formData.name" />
            </ElFormItem>
            <ElFormItem label="商品图片" prop="image">
              <ElInput v-model="formData.image" placeholder="请输入图片URL" />
            </ElFormItem>
            <ElFormItem label="品牌" prop="brand">
              <ElInput v-model="formData.brand" placeholder="请输入品牌名称" />
            </ElFormItem>
            <ElFormItem label="商品介绍" prop="description">
              <ElInput v-model="formData.description" type="textarea" :rows="3" />
            </ElFormItem>
            <ElFormItem label="价格" prop="price">
              <ElInputNumber v-model="formData.price" :min="0" :precision="2" />
            </ElFormItem>
            <ElFormItem label="供应商" prop="supplier">
              <ElSelect
                v-model="formData.supplier"
                placeholder="请选择供应商"
                filterable
                clearable
                style="width: 100%"
              >
                <ElOption
                  v-for="supplier in supplierList"
                  :key="supplier.id"
                  :label="supplier.name"
                  :value="supplier.name"
                />
              </ElSelect>
            </ElFormItem>
            <ElFormItem label="存储区域" prop="storageArea">
              <div style="display: flex; gap: 8px; width: 100%">
                <ElSelect
                  v-model="storageSelection.area"
                  placeholder="选择区域"
                  @change="handleAreaChange"
                  style="flex: 1"
                >
                  <ElOption
                    v-for="area in areaOptions"
                    :key="area.value"
                    :label="area.label"
                    :value="area.value"
                  />
                </ElSelect>
                <ElSelect
                  v-model="storageSelection.level"
                  placeholder="选择层级"
                  @change="handleLevelChange"
                  :disabled="!storageSelection.area"
                  style="flex: 1"
                >
                  <ElOption
                    v-for="level in levelOptions"
                    :key="level.value"
                    :label="level.label"
                    :value="level.value"
                  />
                </ElSelect>
                <ElSelect
                  v-model="storageSelection.shelf"
                  placeholder="选择货架"
                  @change="handleShelfChange"
                  :disabled="!storageSelection.level"
                  style="flex: 1"
                >
                  <ElOption
                    v-for="shelf in shelfOptions"
                    :key="shelf.value"
                    :label="shelf.label"
                    :value="shelf.value"
                  />
                </ElSelect>
              </div>
            </ElFormItem>
            <ElFormItem label="商品状态" prop="status">
              <ElSelect v-model="formData.status">
                <ElOption label="在售" value="1" />
                <ElOption label="下架" value="2" />
                <ElOption label="预售" value="3" />
                <ElOption label="缺货" value="4" />
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
  import { StorageService } from '@/api/storageApi'
  import { PurchaseService } from '@/api/purchaseApi'
  import { ElDialog, FormInstance, ElTag, ElImage } from 'element-plus'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { SearchChangeParams, SearchFormItem } from '@/types'

  defineOptions({ name: 'Commodity' })

  const dialogType = ref('add')
  const dialogVisible = ref(false)
  const loading = ref(false)

  // 供应商列表
  const supplierList = ref<any[]>([])

  // 存储区域选择
  const storageSelection = reactive({
    area: '',
    level: '',
    shelf: ''
  })

  // 区域选项
  const areaOptions = [
    { label: 'A区', value: 'A' },
    { label: 'B区', value: 'B' },
    { label: 'C区', value: 'C' }
  ]

  // 层级选项
  const levelOptions = [
    { label: 'L1层', value: 'L1' },
    { label: 'L2层', value: 'L2' },
    { label: 'L3层', value: 'L3' }
  ]

  // 货架选项
  const shelfOptions = computed(() => {
    const options = []
    for (let i = 1; i <= 10; i++) {
      const shelfNumber = i.toString().padStart(2, '0')
      options.push({
        label: `${shelfNumber}号`,
        value: shelfNumber
      })
    }
    return options
  })

  // 处理区域变化
  const handleAreaChange = () => {
    storageSelection.level = ''
    storageSelection.shelf = ''
    updateStorageArea()
  }

  // 处理层级变化
  const handleLevelChange = () => {
    storageSelection.shelf = ''
    updateStorageArea()
  }

  // 处理货架变化
  const handleShelfChange = () => {
    updateStorageArea()
  }

  // 更新存储区域字符串
  const updateStorageArea = () => {
    if (storageSelection.area && storageSelection.level && storageSelection.shelf) {
      formData.storageArea = `${storageSelection.area}区-${storageSelection.level}层-${storageSelection.shelf}号`
    } else {
      formData.storageArea = ''
    }
  }

  // 解析存储区域字符串
  const parseStorageArea = (storageArea: string) => {
    if (!storageArea) {
      storageSelection.area = ''
      storageSelection.level = ''
      storageSelection.shelf = ''
      return
    }

    const parts = storageArea.split('-')
    if (parts.length === 3) {
      storageSelection.area = parts[0].replace('区', '')
      storageSelection.level = parts[1].replace('层', '')
      storageSelection.shelf = parts[2].replace('号', '')
    }
  }

  // 定义表单搜索初始值
  const initialSearchState = {
    name: '',
    brand: '',
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
    getCommodityList()
  }

  // 搜索处理
  const handleSearch = () => {
    console.log('搜索参数:', formFilters)
    pagination.currentPage = 1
    getCommodityList()
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
      label: '商品状态',
      prop: 'status',
      type: 'select',
      config: {
        clearable: true
      },
      options: () => [
        { label: '在售', value: '1' },
        { label: '下架', value: '2' },
        { label: '预售', value: '3' },
        { label: '缺货', value: '4' }
      ],
      onChange: handleFormChange
    }
  ]

  // 获取标签类型
  const getTagType = (status: string) => {
    switch (status) {
      case '1':
        return 'success'
      case '2':
        return 'danger'
      case '3':
        return 'warning'
      case '4':
        return 'info'
      default:
        return 'info'
    }
  }

  // 构建标签文本
  const buildTagText = (status: string) => {
    switch (status) {
      case '1':
        return '在售'
      case '2':
        return '下架'
      case '3':
        return '预售'
      case '4':
        return '缺货'
      default:
        return '未知'
    }
  }

  // 获取供应商列表
  const getSupplierList = async () => {
    try {
      const response = await PurchaseService.getSupplierList({
        current: 1,
        size: 1000 // 获取所有供应商
      })
      if (response.code === 200) {
        supplierList.value = response.data.list || []
      }
    } catch (error) {
      console.error('获取供应商列表失败:', error)
    }
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
      formData.name = row.name
      formData.image = row.image
      formData.brand = row.brand
      formData.description = row.description
      formData.price = row.price
      formData.stock = row.stock
      formData.supplier = row.supplier
      formData.storageArea = row.storageArea
      formData.status = row.status
      // 解析存储区域
      parseStorageArea(row.storageArea)
    } else {
      formData.id = undefined
      formData.name = ''
      formData.image = ''
      formData.brand = ''
      formData.description = ''
      formData.price = 0
      formData.stock = 0 // 新增时自动设为0
      formData.supplier = ''
      formData.storageArea = ''
      formData.status = '1'
      storageSelection.area = ''
      storageSelection.level = ''
      storageSelection.shelf = ''
    }
  }

  // 删除商品
  const deleteCommodity = (row: any) => {
    ElMessageBox.confirm(`确定要删除商品"${row.name}"吗？`, '删除商品', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'error'
    }).then(async () => {
      try {
        await StorageService.deleteCommodity({ id: row.id })
        ElMessage.success('删除成功')
        getCommodityList()
      } catch (error) {
        ElMessage.error('删除失败：' + error)
      }
    })
  }

  // 动态列配置
  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection' },
    {
      prop: 'id',
      label: '商品ID',
      sortable: true,
      width: 90
    },
    {
      prop: 'image',
      label: '商品名称',
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
      prop: 'brand',
      label: '品牌',
      width: 60
    },
    {
      prop: 'description',
      label: '商品介绍',
      width: 200,
      formatter: (row: any) => {
        const text = row.description || ''
        return text.length > 50 ? text.substring(0, 50) + '...' : text
      }
    },
    {
      prop: 'price',
      label: '进价',
      width: 100,
      sortable: true,
      formatter: (row: any) => `¥${row.price}`
    },
    {
      prop: 'supplier',
      label: '供应商',
      width: 180
    },
    {
      prop: 'status',
      label: '状态',
      width: 80,
      formatter: (row) => {
        return h(ElTag, { type: getTagType(row.status) }, () => buildTagText(row.status))
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
            onClick: () => deleteCommodity(row)
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
    name: '',
    image: '',
    brand: '',
    description: '',
    price: 0,
    stock: 0,
    supplier: '',
    storageArea: '',
    status: '1'
  })

  onMounted(() => {
    getCommodityList()
    getSupplierList()
  })

  // 获取商品列表数据
  const getCommodityList = async () => {
    loading.value = true
    try {
      const params = {
        current: pagination.currentPage,
        size: pagination.pageSize,
        ...formFilters
      }

      const response = await StorageService.getCommodityList(params)

      if (response.code === 200) {
        tableData.value = response.data.list
        pagination.total = response.data.total
      } else {
        ElMessage.error(response.msg || '获取商品列表失败')
      }
    } catch (error) {
      console.error('获取商品列表失败:', error)
      ElMessage.error('获取商品列表失败')
    } finally {
      loading.value = false
    }
  }

  const handleRefresh = () => {
    getCommodityList()
  }

  // 处理表格行选择变化
  const handleSelectionChange = (selection: any[]) => {
    selectedRows.value = selection
  }

  // 表单验证规则
  const rules = reactive<FormRules>({
    name: [
      { required: true, message: '请输入商品名称', trigger: 'blur' },
      { min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur' }
    ],
    image: [{ required: true, message: '请输入商品图片URL', trigger: 'blur' }],
    brand: [
      { required: true, message: '请输入品牌名称', trigger: 'blur' },
      { min: 1, max: 30, message: '长度在 1 到 30 个字符', trigger: 'blur' }
    ],
    description: [{ required: true, message: '请输入商品介绍', trigger: 'blur' }],
    price: [{ required: true, message: '请输入价格', trigger: 'blur' }],
    supplier: [{ required: true, message: '请选择供应商', trigger: 'change' }],
    storageArea: [{ required: true, message: '请选择存储区域', trigger: 'blur' }],
    status: [{ required: true, message: '请选择商品状态', trigger: 'change' }]
  })

  // 提交表单
  const handleSubmit = async () => {
    if (!formRef.value) return

    await formRef.value.validate(async (valid) => {
      if (valid) {
        try {
          if (dialogType.value === 'add') {
            await StorageService.addCommodity({
              name: formData.name,
              image: formData.image,
              brand: formData.brand,
              description: formData.description,
              price: formData.price,
              stock: formData.stock,
              supplier: formData.supplier,
              storageArea: formData.storageArea,
              status: formData.status
            })
            ElMessage.success('添加成功')
          } else {
            await StorageService.updateCommodity({
              id: formData.id!,
              name: formData.name,
              image: formData.image,
              brand: formData.brand,
              description: formData.description,
              price: formData.price,
              stock: formData.stock,
              supplier: formData.supplier,
              storageArea: formData.storageArea,
              status: formData.status
            })
            ElMessage.success('更新成功')
          }

          dialogVisible.value = false
          getCommodityList()
        } catch (error) {
          ElMessage.error(dialogType.value === 'add' ? '添加失败：' + error : '更新失败：' + error)
        }
      }
    })
  }

  // 处理表格分页变化
  const handleSizeChange = (newPageSize: number) => {
    pagination.pageSize = newPageSize
    getCommodityList()
  }

  const handleCurrentChange = (newCurrentPage: number) => {
    pagination.currentPage = newCurrentPage
    getCommodityList()
  }
</script>

<style lang="scss" scoped>
  .commodity-page {
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
