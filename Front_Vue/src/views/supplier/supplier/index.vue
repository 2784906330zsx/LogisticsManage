<template>
  <ArtTableFullScreen>
    <div class="supplier-page" id="table-full-screen">
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
            <ElButton @click="showDialog('add')">新增供应商</ElButton>
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
          :title="dialogType === 'add' ? '新增供应商' : '编辑供应商'"
          width="50%"
          align-center
        >
          <ElForm ref="formRef" :model="formData" :rules="rules" label-width="120px">
            <ElRow :gutter="20">
              <ElCol :span="12">
                <ElFormItem label="供应商" prop="name">
                  <ElInput v-model="formData.name" placeholder="请输入供应商名称" />
                </ElFormItem>
              </ElCol>
              <ElCol :span="12">
                <ElFormItem label="类型" prop="type">
                  <ElSelect v-model="formData.type" placeholder="请选择供应商类型">
                    <ElOption label="企业" value="企业" />
                    <ElOption label="个人或个体工商户" value="个人或个体工商户" />
                    <ElOption label="事业单位" value="事业单位" />
                    <ElOption label="政府部门" value="政府部门" />
                    <ElOption label="社会团体" value="社会团体" />
                    <ElOption label="集体组织" value="集体组织" />
                  </ElSelect>
                </ElFormItem>
              </ElCol>
            </ElRow>
            <ElFormItem label="地址" prop="address">
              <ElInput v-model="formData.address" placeholder="请输入详细地址" />
            </ElFormItem>
            <ElRow :gutter="20">
              <ElCol :span="12">
                <ElFormItem label="联系人" prop="contactPerson">
                  <ElInput v-model="formData.contactPerson" placeholder="请输入联系人姓名" />
                </ElFormItem>
              </ElCol>
              <ElCol :span="12">
                <ElFormItem label="联系电话" prop="contactPhone">
                  <ElInput v-model="formData.contactPhone" placeholder="请输入联系电话" />
                </ElFormItem>
              </ElCol>
            </ElRow>
            <ElFormItem label="联系邮箱" prop="contactEmail">
              <ElInput v-model="formData.contactEmail" placeholder="请输入联系邮箱" />
            </ElFormItem>
            <ElFormItem label="状态" prop="status">
              <ElSelect v-model="formData.status" placeholder="请选择状态">
                <ElOption label="正常" value="正常" />
                <ElOption label="暂停合作" value="暂停合作" />
                <ElOption label="黑名单" value="黑名单" />
              </ElSelect>
            </ElFormItem>
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
  import { PurchaseService } from '@/api/purchaseApi'
  import { ElDialog, FormInstance, ElTag } from 'element-plus'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { SearchChangeParams, SearchFormItem } from '@/types'

  defineOptions({ name: 'Supplier' })

  const dialogType = ref('add')
  const dialogVisible = ref(false)
  const loading = ref(false)
  const submitLoading = ref(false)

  // 定义表单搜索初始值
  const initialSearchState = {
    name: '',
    type: '',
    contactPerson: '',
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
    getSupplierList()
  }

  // 搜索处理
  const handleSearch = () => {
    console.log('搜索参数:', formFilters)
    pagination.currentPage = 1
    getSupplierList()
  }

  // 表单项变更处理
  const handleFormChange = (params: SearchChangeParams): void => {
    console.log('表单项变更:', params)
  }

  // 表单配置项
  const formItems: SearchFormItem[] = [
    {
      label: '供应商名称',
      prop: 'name',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '供应商类型',
      prop: 'type',
      type: 'select',
      config: {
        clearable: true
      },
      options: () => [
        { label: '企业', value: '企业' },
        { label: '个人或个体工商户', value: '个人或个体工商户' },
        { label: '事业单位', value: '事业单位' },
        { label: '政府部门', value: '政府部门' },
        { label: '社会团体', value: '社会团体' },
        { label: '集体组织', value: '集体组织' }
      ],
      onChange: handleFormChange
    },
    {
      label: '联系人',
      prop: 'contactPerson',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '状态',
      prop: 'status',
      type: 'select',
      config: {
        clearable: true
      },
      options: () => [
        { label: '正常', value: '正常' },
        { label: '暂停合作', value: '暂停合作' },
        { label: '黑名单', value: '黑名单' }
      ],
      onChange: handleFormChange
    }
  ]

  // 获取标签类型
  const getTagType = (status: string) => {
    switch (status) {
      case '正常':
        return 'success'
      case '暂停合作':
        return 'warning'
      case '黑名单':
        return 'danger'
      default:
        return 'info'
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
      formData.type = row.type
      formData.address = row.address
      formData.contactPerson = row.contactPerson
      formData.contactPhone = row.contactPhone
      formData.contactEmail = row.contactEmail
      formData.status = row.status
    } else {
      formData.id = undefined
      formData.name = ''
      formData.type = ''
      formData.address = ''
      formData.contactPerson = ''
      formData.contactPhone = ''
      formData.contactEmail = ''
      formData.status = '正常'
    }
  }

  // 删除供应商
  const deleteSupplier = (row: any) => {
    ElMessageBox.confirm('确定要删除该供应商吗？', '删除供应商', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'error'
    }).then(async () => {
      try {
        // 修复：直接传递 row.id 而不是对象
        const response = await PurchaseService.deleteSupplier(row.id)
        if (response.code === 200) {
          ElMessage.success('删除成功')
          getSupplierList()
        } else {
          ElMessage.error(response.msg || '删除失败')
        }
      } catch (error) {
        console.error('删除供应商失败:', error)
        ElMessage.error('删除失败')
      }
    })
  }

  // 动态列配置
  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection' },
    {
      prop: 'id',
      label: '供应商ID',
      width: 100
    },
    {
      prop: 'name',
      label: '供应商名称',
      minWidth: 200
    },
    {
      prop: 'type',
      label: '供应商类型',
      width: 150,
      formatter: (row: any) => {
        return h(
          ElTag,
          {
            type: 'info',
            size: 'small'
          },
          () => row.type
        )
      }
    },
    {
      prop: 'address',
      label: '地址',
      minWidth: 250,
      formatter: (row: any) => {
        const text = row.address || ''
        return text.length > 30 ? text.substring(0, 30) + '...' : text
      }
    },
    {
      prop: 'contactPerson',
      label: '联系人',
      width: 120
    },
    {
      prop: 'contactPhone',
      label: '联系电话',
      width: 140
    },
    {
      prop: 'contactEmail',
      label: '联系邮箱',
      minWidth: 200
    },
    {
      prop: 'status',
      label: '状态',
      width: 100,
      formatter: (row) => {
        return h(ElTag, { type: getTagType(row.status) }, () => row.status)
      }
    },
    {
      prop: 'createTime',
      label: '添加时间',
      sortable: true,
      width: 160
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
            onClick: () => deleteSupplier(row)
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
    type: '',
    address: '',
    contactPerson: '',
    contactPhone: '',
    contactEmail: '',
    status: '正常'
  })

  onMounted(() => {
    getSupplierList()
  })

  // 获取供应商列表数据
  const getSupplierList = async () => {
    loading.value = true
    try {
      const { currentPage, pageSize } = pagination

      const params = {
        current: currentPage,
        size: pageSize,
        name: formFilters.name || undefined,
        type: formFilters.type || undefined,
        contactPerson: formFilters.contactPerson || undefined,
        status: formFilters.status || undefined
      }

      const response = await PurchaseService.getSupplierList(params)

      if (response.code === 200) {
        tableData.value = response.data.list // 修改：results -> list
        pagination.total = response.data.total // 修改：count -> total
      } else {
        ElMessage.error(response.msg || '获取供应商列表失败')
      }
    } catch (error) {
      console.error('获取供应商列表失败:', error)
      ElMessage.error('获取供应商列表失败')
    } finally {
      loading.value = false
    }
  }

  const handleRefresh = () => {
    getSupplierList()
  }

  // 处理表格行选择变化
  const handleSelectionChange = (selection: any[]) => {
    selectedRows.value = selection
  }

  // 表单验证规则
  const rules = reactive<FormRules>({
    name: [
      { required: true, message: '请输入供应商名称', trigger: 'blur' },
      { min: 2, max: 100, message: '长度在 2 到 100 个字符', trigger: 'blur' }
    ],
    type: [{ required: true, message: '请选择供应商类型', trigger: 'change' }],
    address: [
      { required: true, message: '请输入地址', trigger: 'blur' },
      { min: 5, max: 200, message: '长度在 5 到 200 个字符', trigger: 'blur' }
    ],
    contactPerson: [
      { required: true, message: '请输入联系人', trigger: 'blur' },
      { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
    ],
    contactPhone: [
      { required: true, message: '请输入联系电话', trigger: 'blur' },
      {
        pattern: /^1[3-9]\d{9}$|^0\d{2,3}-?\d{7,8}$/,
        message: '请输入正确的手机号或座机号',
        trigger: 'blur'
      }
    ],
    contactEmail: [
      { required: true, message: '请输入联系邮箱', trigger: 'blur' },
      { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
    ],
    status: [{ required: true, message: '请选择状态', trigger: 'change' }]
  })

  // 提交表单
  const handleSubmit = async () => {
    if (!formRef.value) return

    await formRef.value.validate(async (valid) => {
      if (valid) {
        submitLoading.value = true
        try {
          if (dialogType.value === 'add') {
            const response = await PurchaseService.addSupplier({
              name: formData.name,
              type: formData.type,
              address: formData.address,
              contactPerson: formData.contactPerson,
              contactPhone: formData.contactPhone,
              contactEmail: formData.contactEmail,
              status: formData.status
            })

            if (response.code === 200) {
              ElMessage.success('添加成功')
              dialogVisible.value = false
              getSupplierList()
            } else {
              ElMessage.error(response.msg || '添加失败')
            }
          } else {
            const response = await PurchaseService.updateSupplier({
              id: formData.id!,
              name: formData.name,
              type: formData.type,
              address: formData.address,
              contactPerson: formData.contactPerson,
              contactPhone: formData.contactPhone,
              contactEmail: formData.contactEmail,
              status: formData.status
            })

            if (response.code === 200) {
              ElMessage.success('更新成功')
              dialogVisible.value = false
              getSupplierList()
            } else {
              ElMessage.error(response.msg || '更新失败')
            }
          }
        } catch (error) {
          console.error('提交失败:', error)
          ElMessage.error('提交失败')
        } finally {
          submitLoading.value = false
        }
      }
    })
  }

  // 处理表格分页变化
  const handleSizeChange = (newPageSize: number) => {
    pagination.pageSize = newPageSize
    getSupplierList()
  }

  const handleCurrentChange = (newCurrentPage: number) => {
    pagination.currentPage = newCurrentPage
    getSupplierList()
  }
</script>
