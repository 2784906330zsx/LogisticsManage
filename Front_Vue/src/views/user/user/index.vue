<template>
  <ArtTableFullScreen>
    <div class="account-page" id="table-full-screen">
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
            <ElButton @click="showDialog('add')">新增用户</ElButton>
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

        <ElDialog
          v-model="dialogVisible"
          :title="dialogType === 'add' ? '添加用户' : '编辑用户'"
          width="30%"
          align-center
        >
          <ElForm ref="formRef" :model="formData" :rules="rules" label-width="80px">
            <ElFormItem label="姓名" prop="username">
              <ElInput v-model="formData.username" />
            </ElFormItem>
            <ElFormItem label="工号" prop="jobNumber">
              <ElInput v-model="formData.jobNumber" />
            </ElFormItem>
            <ElFormItem label="联系电话" prop="phone">
              <ElInput v-model="formData.phone" />
            </ElFormItem>
            <ElFormItem label="邮箱" prop="email">
              <ElInput v-model="formData.email" />
            </ElFormItem>
            <ElFormItem label="性别" prop="gender">
              <ElSelect v-model="formData.gender">
                <ElOption label="男" value="男" />
                <ElOption label="女" value="女" />
              </ElSelect>
            </ElFormItem>
            <ElFormItem label="部门" prop="department">
              <ElSelect v-model="formData.department">
                <ElOption
                  v-for="dept in departmentList"
                  :key="dept.departmentCode"
                  :value="dept.departmentName"
                  :label="dept.departmentName"
                />
              </ElSelect>
            </ElFormItem>
            <ElFormItem label="职务" prop="position">
              <ElSelect v-model="formData.position">
                <ElOption
                  v-for="role in roleList"
                  :key="role.roleCode"
                  :value="role.roleName"
                  :label="role.roleName"
                />
              </ElSelect>
            </ElFormItem>
            <ElFormItem label="状态" prop="status">
              <ElSelect v-model="formData.status">
                <ElOption label="在职" value="1" />
                <ElOption label="休假" value="2" />
                <ElOption label="离职" value="3" />
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
  import { ROLE_LIST_DATA, ACCOUNT_TABLE_DATA, DEPARTMENT_LIST_DATA } from '@/mock/temp/formData'

  import { ElDialog, FormInstance, ElTag } from 'element-plus'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { UserService } from '@/api/usersApi'
  import { SearchChangeParams, SearchFormItem } from '@/types'
  const { width } = useWindowSize()

  defineOptions({ name: 'User' }) // 定义组件名称，用于 KeepAlive 缓存控制

  const dialogType = ref('add')
  const dialogVisible = ref(false)
  const loading = ref(false)

  // 定义表单搜索初始值
  const initialSearchState = {
    name: '',
    phone: '',
    email: '',
    gender: '',
    department: '',
    position: '',
    status: ''
  }

  const roleList = ref<any[]>([])
  const departmentList = ref<any[]>([])

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
    pagination.currentPage = 1 // 重置到第一页
    getUserList()
  }

  // 搜索处理
  const handleSearch = () => {
    console.log('搜索参数:', formFilters)
    pagination.currentPage = 1 // 搜索时重置到第一页
    getUserList()
  }

  // 表单项变更处理
  const handleFormChange = (params: SearchChangeParams): void => {
    console.log('表单项变更:', params)
  }

  // 表单配置项
  const formItems: SearchFormItem[] = [
    {
      label: '用户名',
      prop: 'name',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '电话',
      prop: 'phone',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '邮箱',
      prop: 'email',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '性别',
      prop: 'gender',
      type: 'select',
      config: {
        clearable: true
      },
      options: () => [
        { label: '男', value: '1' },
        { label: '女', value: '0' }
      ],
      onChange: handleFormChange
    },
    {
      label: '部门',
      prop: 'department',
      type: 'select',
      config: {
        clearable: true
      },
      options: () =>
        departmentList.value.map((dept) => ({
          label: dept.departmentName,
          value: dept.departmentName
        })),
      onChange: handleFormChange
    },
    {
      label: '职务',
      prop: 'position',
      type: 'select',
      config: {
        clearable: true
      },
      options: () =>
        roleList.value.map((role) => ({
          label: role.roleName,
          value: role.roleName
        })),
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
        { label: '在职', value: '1' },
        { label: '休假', value: '2' },
        { label: '离职', value: '3' }
      ],
      onChange: handleFormChange
    }
  ]

  // 获取标签类型
  // 1: 在职 2: 休假 3: 离职
  const getTagType = (status: string) => {
    switch (status) {
      case '1':
        return 'success'
      case '2':
        return 'warning'
      case '3':
        return 'danger'
      default:
        return 'info'
    }
  }

  // 构建标签文本
  const buildTagText = (status: string) => {
    let text = ''
    if (status === '1') {
      text = '在职'
    } else if (status === '2') {
      text = '休假'
    } else if (status === '3') {
      text = '离职'
    }
    return text
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
      formData.username = row.username
      formData.jobNumber = row.jobNumber
      formData.phone = row.userPhone
      formData.email = row.userEmail
      formData.gender = row.userGender === 1 ? '男' : '女'
      formData.department = row.dep
      formData.position = row.position
      formData.status = row.status
    } else {
      formData.username = ''
      formData.jobNumber = ''
      formData.phone = ''
      formData.email = ''
      formData.gender = '男'
      formData.department = ''
      formData.position = ''
      formData.status = '1'
    }
  }

  // 删除用户
  const deleteUser = () => {
    ElMessageBox.confirm('确定要删除该用户吗？', '删除用户', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'error'
    }).then(() => {
      ElMessage.success('删除成功')
    })
  }

  // 动态列配置
  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection' }, // 勾选列
    {
      prop: 'avatar',
      label: '用户名',
      minWidth: width.value < 500 ? 220 : '',
      formatter: (row: any) => {
        return h('div', { class: 'user', style: 'display: flex; align-items: center' }, [
          h('img', { class: 'avatar', src: row.avatar }),
          h('div', {}, [h('p', { class: 'user-name' }, row.userName)])
        ])
      }
    },
    {
      prop: 'jobNumber',
      label: '工号',
      sortable: true
    },
    {
      prop: 'userEmail',
      label: '邮箱'
    },
    {
      prop: 'userGender',
      label: '性别',
      sortable: true,
      formatter: (row) => (row.userGender === 1 ? '男' : '女')
    },
    { prop: 'userPhone', label: '手机号' },
    {
      prop: 'dep',
      label: '部门'
    },
    {
      prop: 'position',
      label: '职务'
    },
    {
      prop: 'status',
      label: '状态',
      formatter: (row) => {
        return h(ElTag, { type: getTagType(row.status) }, () => buildTagText(row.status))
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
            onClick: () => deleteUser()
          })
        ])
      }
    }
  ])

  // 表单实例
  const formRef = ref<FormInstance>()

  // 表单数据
  const formData = reactive({
    username: '',
    jobNumber: '',
    phone: '',
    email: '',
    gender: '',
    department: '',
    position: '',
    status: '1'
  })

  onMounted(() => {
    getUserList()
    getRoleList()
    getDepartmentList()
  })

  // 获取用户列表数据
  const getUserList = async () => {
    loading.value = true
    try {
      const { currentPage, pageSize } = pagination

      const { records, current, size, total } = await UserService.getUserList({
        current: currentPage,
        size: pageSize
      })

      // 使用本地头像和新增字段替换接口返回的数据
      tableData.value = records.map((item: any, index: number) => ({
        ...item,
        avatar: ACCOUNT_TABLE_DATA[index % ACCOUNT_TABLE_DATA.length].avatar,
        jobNumber: ACCOUNT_TABLE_DATA[index % ACCOUNT_TABLE_DATA.length].jobNumber,
        position: ACCOUNT_TABLE_DATA[index % ACCOUNT_TABLE_DATA.length].position,
        dep: ACCOUNT_TABLE_DATA[index % ACCOUNT_TABLE_DATA.length].dep
      }))

      // 更新分页信息
      Object.assign(pagination, { currentPage: current, pageSize: size, total })
    } catch (error) {
      console.error('获取用户列表失败:', error)
    } finally {
      loading.value = false
    }
  }

  const getRoleList = () => {
    roleList.value = ROLE_LIST_DATA
  }

  const getDepartmentList = () => {
    departmentList.value = DEPARTMENT_LIST_DATA
  }

  const handleRefresh = () => {
    getUserList()
  }

  // 处理表格行选择变化
  const handleSelectionChange = (selection: any[]) => {
    selectedRows.value = selection
  }

  // 表单验证规则
  const rules = reactive<FormRules>({
    username: [
      { required: true, message: '请输入用户名', trigger: 'blur' },
      { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
    ],
    jobNumber: [{ required: true, message: '请输入工号', trigger: 'blur' }],
    phone: [
      { required: true, message: '请输入手机号', trigger: 'blur' },
      { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号格式', trigger: 'blur' }
    ],
    email: [
      { required: true, message: '请输入邮箱', trigger: 'blur' },
      { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
    ],
    gender: [{ required: true, message: '请选择性别', trigger: 'change' }],
    department: [{ required: true, message: '请选择部门', trigger: 'change' }],
    position: [{ required: true, message: '请选择职务', trigger: 'change' }],
    status: [{ required: true, message: '请选择状态', trigger: 'change' }]
  })

  // 提交表单
  const handleSubmit = async () => {
    if (!formRef.value) return

    await formRef.value.validate((valid) => {
      if (valid) {
        ElMessage.success(dialogType.value === 'add' ? '添加成功' : '更新成功')
        dialogVisible.value = false
      }
    })
  }

  // 处理表格分页变化
  const handleSizeChange = (newPageSize: number) => {
    pagination.pageSize = newPageSize
    getUserList()
  }

  const handleCurrentChange = (newCurrentPage: number) => {
    pagination.currentPage = newCurrentPage
    getUserList()
  }
</script>

<style lang="scss" scoped>
  .account-page {
    :deep(.user) {
      .avatar {
        width: 40px;
        height: 40px;
        border-radius: 6px;
      }

      > div {
        margin-left: 10px;

        .user-name {
          font-weight: 500;
          color: var(--art-text-gray-800);
        }
      }
    }
  }
</style>
