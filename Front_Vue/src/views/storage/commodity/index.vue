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
            <ElFormItem label="库存" prop="stock">
              <ElInputNumber v-model="formData.stock" :min="0" />
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
  import { COMMODITY_LIST_DATA } from '@/mock/temp/formData'
  import { ElDialog, FormInstance, ElTag, ElImage } from 'element-plus'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { SearchChangeParams, SearchFormItem } from '@/types'

  const { width } = useWindowSize()

  defineOptions({ name: 'Commodity' })

  const dialogType = ref('add')
  const dialogVisible = ref(false)
  const loading = ref(false)

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

  // 显示对话框
  const showDialog = (type: string, row?: any) => {
    dialogVisible.value = true
    dialogType.value = type

    // 重置表单验证状态
    if (formRef.value) {
      formRef.value.resetFields()
    }

    if (type === 'edit' && row) {
      formData.name = row.name
      formData.image = row.image
      formData.brand = row.brand
      formData.description = row.description
      formData.price = row.price
      formData.stock = row.stock
      formData.status = row.status
    } else {
      formData.name = ''
      formData.image = ''
      formData.brand = ''
      formData.description = ''
      formData.price = 0
      formData.stock = 0
      formData.status = '1'
    }
  }

  // 删除商品
  const deleteCommodity = () => {
    ElMessageBox.confirm('确定要删除该商品吗？', '删除商品', {
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
      label: '商品ID',
      width: 80
    },
    {
      prop: 'image',
      label: '商品名称',
      minWidth: width.value < 500 ? 250 : 280,
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
      width: 120
    },
    {
      prop: 'description',
      label: '商品介绍',
      minWidth: 200,
      formatter: (row: any) => {
        const text = row.description || ''
        return text.length > 50 ? text.substring(0, 50) + '...' : text
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
      label: '库存',
      sortable: true
    },
    {
      prop: 'status',
      label: '状态',
      formatter: (row) => {
        return h(ElTag, { type: getTagType(row.status) }, () => buildTagText(row.status))
      }
    },
    {
      prop: 'createTime',
      label: '创建时间',
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
            onClick: () => deleteCommodity()
          })
        ])
      }
    }
  ])

  // 表单实例
  const formRef = ref<FormInstance>()

  // 表单数据
  const formData = reactive({
    name: '',
    image: '',
    brand: '',
    description: '',
    price: 0,
    stock: 0,
    status: '1'
  })

  onMounted(() => {
    getCommodityList()
  })

  // 获取商品列表数据
  const getCommodityList = async () => {
    loading.value = true
    try {
      const { currentPage, pageSize } = pagination

      // 模拟API调用
      await new Promise((resolve) => setTimeout(resolve, 500))

      // 过滤数据
      let filteredData = [...COMMODITY_LIST_DATA]

      if (formFilters.name) {
        filteredData = filteredData.filter((item) =>
          item.name.toLowerCase().includes(formFilters.name.toLowerCase())
        )
      }

      if (formFilters.brand) {
        filteredData = filteredData.filter((item) =>
          item.brand.toLowerCase().includes(formFilters.brand.toLowerCase())
        )
      }

      if (formFilters.status) {
        filteredData = filteredData.filter((item) => item.status === formFilters.status)
      }

      const total = filteredData.length
      const start = (currentPage - 1) * pageSize
      const end = start + pageSize

      tableData.value = filteredData.slice(start, end)
      pagination.total = total
    } catch (error) {
      console.error('获取商品列表失败:', error)
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
    stock: [{ required: true, message: '请输入库存', trigger: 'blur' }],
    status: [{ required: true, message: '请选择商品状态', trigger: 'change' }]
  })

  // 提交表单
  const handleSubmit = async () => {
    if (!formRef.value) return

    await formRef.value.validate((valid) => {
      if (valid) {
        ElMessage.success(dialogType.value === 'add' ? '添加成功' : '更新成功')
        dialogVisible.value = false
        getCommodityList()
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
