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
            <ElButton @click="showDialog('add')">新增员工</ElButton>
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
          :title="dialogType === 'add' ? '添加员工' : '编辑员工'"
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
            <ElFormItem label="手机号" prop="phone">
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
            <!-- 部门下拉框 -->
            <ElFormItem label="部门" prop="department">
              <ElSelect v-model="formData.department" @change="onDepartmentChange">
                <ElOption
                  v-for="dept in departmentList"
                  :key="dept.id || dept.departmentCode"
                  :value="dept.departmentName"
                  :label="dept.departmentName"
                />
              </ElSelect>
            </ElFormItem>

            <!-- 职务下拉框 -->
            <ElFormItem label="职务" prop="position">
              <ElSelect v-model="formData.position" @change="onPositionChange">
                <ElOption
                  v-for="role in filteredRoleList"
                  :key="role.id || role.roleCode"
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
            <ElFormItem label="密码" prop="password" v-if="dialogType === 'add'">
              <ElInput v-model="formData.password" type="password" show-password />
            </ElFormItem>
            <ElFormItem label="头像URL" prop="avatar">
              <ElInput v-model="formData.avatar" placeholder="请输入头像URL" />
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

  // 需要添加一个变量来存储当前编辑的用户ID
  const currentEditUserId = ref(null)

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
      label: '姓名',
      prop: 'name',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '手机号',
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
      options: () => {
        let roles = roleList.value
        if (formFilters.department) {
          const selectedDept = departmentList.value.find(
            (dept) => dept.departmentName === formFilters.department
          )
          if (selectedDept) {
            roles = roleList.value.filter((role) => {
              return (
                role.departmentCode === selectedDept.departmentCode ||
                role.department === selectedDept.departmentName ||
                role.departmentName === selectedDept.departmentName
              )
            })
          }
        }
        return roles.map((role) => ({
          label: role.roleName,
          value: role.roleName
        }))
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
      currentEditUserId.value = row.userId
      formData.username = row.userName
      formData.jobNumber = row.jobNumber
      formData.phone = row.userPhone
      formData.email = row.userEmail
      formData.avatar = row.avatar || ''
      formData.gender = row.userGender === 1 ? '男' : '女'
      formData.department = row.dep
      formData.position = row.position
      formData.status = row.status
      formData.password = '' // 编辑时不显示密码
    } else {
      formData.username = ''
      formData.jobNumber = ''
      formData.phone = ''
      formData.email = ''
      formData.password = ''
      formData.avatar = ''
      formData.gender = '男'
      formData.department = ''
      formData.position = ''
      formData.status = '1'
    }
  }

  // 删除员工
  const deleteUser = async (row: any) => {
    ElMessageBox.confirm('确定要删除该员工吗？', '删除员工', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'error'
    })
      .then(async () => {
        try {
          const response = await UserService.deleteUser(row.userId)
          if (response.code === 200) {
            ElMessage.success('删除成功')
            getUserList() // 刷新列表
          } else {
            ElMessage.error(response.msg || '删除失败')
          }
        } catch (error) {
          console.error('删除用户失败:', error)
          ElMessage.error('删除失败，请重试')
        }
      })
      .catch(() => {
        // 用户取消删除
      })
  }

  // 动态列配置
  const { columnChecks, columns } = useCheckedColumns(() => [
    { type: 'selection' }, // 勾选列
    {
      prop: 'avatar',
      label: '姓名',
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
            onClick: () => deleteUser(row)
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
    password: '',
    avatar: '',
    gender: '',
    department: '',
    position: '',
    status: '1'
  })

  // 添加计算属性：根据选择的部门过滤职务列表
  const filteredRoleList = computed(() => {
    if (!formData.department || !departmentList.value.length || !roleList.value.length) {
      return roleList.value
    }

    // 找到选中部门的信息
    const selectedDept = departmentList.value.find(
      (dept) => dept.departmentName === formData.department
    )
    if (!selectedDept) {
      return roleList.value
    }

    // 根据部门过滤职务（假设roleList中有departmentCode或department字段）
    return roleList.value.filter((role) => {
      // 根据实际的数据结构调整这里的逻辑
      return (
        role.departmentCode === selectedDept.departmentCode ||
        role.department === selectedDept.departmentName ||
        role.departmentName === selectedDept.departmentName
      )
    })
  })

  // 部门选择变化处理
  const onDepartmentChange = () => {
    // 清空职务选择
    formData.position = ''

    // 如果当前选择的职务不属于新选择的部门，则清空职务
    if (formData.position && filteredRoleList.value.length > 0) {
      const isPositionInDepartment = filteredRoleList.value.some(
        (role) => role.roleName === formData.position
      )
      if (!isPositionInDepartment) {
        formData.position = ''
      }
    }
  }

  // 职务选择变化处理
  const onPositionChange = (positionName: string) => {
    console.log('选择的职务:', positionName)
    console.log('当前角色列表:', roleList.value)
    console.log('当前部门列表:', departmentList.value)

    if (!positionName || !roleList.value.length || !departmentList.value.length) {
      return
    }

    // 找到选中职务的信息
    const selectedRole = roleList.value.find((role) => role.roleName === positionName)
    console.log('找到的角色:', selectedRole)

    if (!selectedRole) {
      return
    }

    // 根据职务的departmentCode自动选择对应的部门
    let targetDepartment = ''

    if (selectedRole.departmentCode) {
      const dept = departmentList.value.find(
        (d) => d.departmentCode === selectedRole.departmentCode
      )
      console.log('匹配的部门:', dept)
      targetDepartment = dept?.departmentName || ''
    }

    console.log('目标部门:', targetDepartment)
    console.log('当前部门:', formData.department)

    if (targetDepartment && targetDepartment !== formData.department) {
      formData.department = targetDepartment
      console.log('已设置部门为:', targetDepartment)
    }
  }

  onMounted(() => {
    getUserList()
    getRoleList()
    getDepartmentList()
  })

  // 获取员工列表数据
  const getUserList = async () => {
    loading.value = true
    try {
      const { currentPage, pageSize } = pagination

      // 构建请求参数，包含搜索条件
      const params = {
        current: currentPage,
        size: pageSize,
        ...formFilters // 添加搜索条件
      }

      const response = await UserService.getUserList(params)

      if (response.code === 200) {
        const { records, current, size, total } = response.data

        // 直接使用后端返回的数据
        tableData.value = records

        // 更新分页信息
        Object.assign(pagination, { currentPage: current, pageSize: size, total })
      } else {
        ElMessage.error(response.msg || '获取用户列表失败')
      }
    } catch (error) {
      console.error('获取员工列表失败:', error)
      ElMessage.error('获取用户列表失败')
    } finally {
      loading.value = false
    }
  }

  // 获取角色列表数据
  const getRoleList = async () => {
    try {
      const response = await UserService.getRoleList({
        current: 1,
        size: 1000 // 获取所有角色用于下拉框
      })

      if (response.code === 200) {
        // 根据后端返回的数据结构调整
        roleList.value = response.data.records || response.data || []
      } else {
        ElMessage.error(response.msg || '获取角色列表失败')
      }
    } catch (error) {
      console.error('获取角色列表失败:', error)
      ElMessage.error('获取角色列表失败')
    }
  }

  // 获取部门列表数据
  const getDepartmentList = async () => {
    try {
      const response = await UserService.getDepartmentList({
        current: 1,
        size: 1000 // 获取所有部门用于下拉框
      })

      if (response.code === 200) {
        // 根据后端返回的数据结构调整
        departmentList.value = response.data.records || response.data || []
      } else {
        ElMessage.error(response.msg || '获取部门列表失败')
      }
    } catch (error) {
      console.error('获取部门列表失败:', error)
      ElMessage.error('获取部门列表失败')
    }
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
      { required: true, message: '请输入姓名', trigger: 'blur' },
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
    status: [{ required: true, message: '请选择状态', trigger: 'change' }],
    password: [
      { required: true, message: '请输入密码', trigger: 'blur' },
      { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' }
    ],
    avatar: [{ type: 'url', message: '请输入正确的URL格式', trigger: 'blur' }]
  })

  // 提交表单
  const handleSubmit = async () => {
    if (!formRef.value) return

    await formRef.value.validate(async (valid) => {
      if (valid) {
        try {
          if (dialogType.value === 'add') {
            // 新增用户
            const createData = {
              username: formData.username,
              jobNumber: formData.jobNumber,
              phone: formData.phone,
              email: formData.email,
              password: formData.password,
              avatar: formData.avatar,
              gender: formData.gender,
              department: formData.department,
              position: formData.position,
              status: formData.status
            }

            const response = await UserService.createUser(createData)
            if (response.code === 200) {
              ElMessage.success('新增成功')
              getUserList() // 刷新列表
            } else {
              ElMessage.error(response.msg || '新增失败')
            }
          } else {
            // 更新用户信息
            const updateData = {
              userId: currentEditUserId.value,
              username: formData.username,
              jobNumber: formData.jobNumber,
              phone: formData.phone,
              email: formData.email,
              avatar: formData.avatar,
              gender: formData.gender,
              department: formData.department,
              position: formData.position,
              status: formData.status
            }

            const response = await UserService.updateUserInfo(updateData)
            if (response.code === 200) {
              ElMessage.success('更新成功')
              getUserList() // 刷新列表
            } else {
              ElMessage.error(response.msg || '更新失败')
            }
          }
          dialogVisible.value = false
        } catch (error) {
          console.error('提交失败:', error)
          ElMessage.error('操作失败，请重试')
        }
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
