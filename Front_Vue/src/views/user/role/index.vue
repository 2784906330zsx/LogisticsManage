<template>
  <div class="page-content">
    <ElForm>
      <ElRow :gutter="12">
        <ElCol :xs="24" :sm="12" :lg="6">
          <ElFormItem>
            <ElInput placeholder="部门名称"></ElInput>
          </ElFormItem>
        </ElCol>
        <ElCol :xs="24" :sm="12" :lg="6">
          <ElFormItem>
            <ElButton v-ripple>搜索</ElButton>
            <ElButton @click="showDialog('add')" v-ripple>新增角色</ElButton>
          </ElFormItem>
        </ElCol>
      </ElRow>
    </ElForm>
    <ArtTable :data="roleList" index>
      <template #default>
        <ElTableColumn label="角色名称" prop="roleName" />
        <ElTableColumn label="角色编码" prop="roleCode" />
        <ElTableColumn label="所属部门" prop="departmentName" />
        <ElTableColumn label="描述" prop="des" />
        <ElTableColumn label="启用" prop="enable">
          <template #default="scope">
            <ElTag :type="scope.row.enable ? 'primary' : 'info'">
              {{ scope.row.enable ? '启用' : '禁用' }}
            </ElTag>
          </template>
        </ElTableColumn>
        <ElTableColumn label="创建时间" prop="date">
          <template #default="scope">
            {{ formatDate(scope.row.date) }}
          </template>
        </ElTableColumn>
        <ElTableColumn fixed="right" label="操作" width="100px">
          <template #default="scope">
            <ElRow>
              <!-- 可以在 list 中添加 auth 属性来控制按钮的权限, auth 属性值为权限标识 -->
              <ArtButtonMore
                :list="[
                  { key: 'permission', label: '菜单权限' },
                  { key: 'edit', label: '编辑角色' },
                  { key: 'delete', label: '删除角色' }
                ]"
                @click="buttonMoreClick($event, scope.row)"
              />
            </ElRow>
          </template>
        </ElTableColumn>
      </template>
    </ArtTable>

    <ElDialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增角色' : '编辑角色'"
      width="30%"
      align-center
    >
      <ElForm ref="formRef" :model="form" :rules="rules" label-width="120px">
        <ElFormItem label="角色名称" prop="roleName">
          <ElInput v-model="form.roleName" />
        </ElFormItem>
        <ElFormItem label="角色编码" prop="roleCode">
          <ElInput v-model="form.roleCode" />
        </ElFormItem>
        <ElFormItem label="所属部门" prop="departmentCode">
          <ElSelect v-model="form.departmentCode" placeholder="请选择部门">
            <ElOption
              v-for="dept in departmentList"
              :key="dept.id || dept.departmentCode"
              :label="dept.departmentName"
              :value="dept.id || Number(dept.departmentCode)"
            />
          </ElSelect>
        </ElFormItem>
        <ElFormItem label="描述" prop="roleStatus">
          <ElInput v-model="form.des" type="textarea" :rows="3" />
        </ElFormItem>
        <ElFormItem label="启用">
          <ElSwitch v-model="form.enable" />
        </ElFormItem>
      </ElForm>
      <template #footer>
        <div class="dialog-footer">
          <ElButton @click="dialogVisible = false">取消</ElButton>
          <ElButton type="primary" @click="handleSubmit(formRef)">提交</ElButton>
        </div>
      </template>
    </ElDialog>

    <ElDialog
      v-model="permissionDialog"
      title="菜单权限"
      width="520px"
      align-center
      class="el-dialog-border"
    >
      <ElScrollbar height="70vh">
        <ElTree
          ref="treeRef"
          :data="processedMenuList"
          show-checkbox
          node-key="name"
          :default-expand-all="isExpandAll"
          :default-checked-keys="[1, 2, 3]"
          :props="defaultProps"
          @check="handleTreeCheck"
        >
          <template #default="{ data }">
            <div style="display: flex; align-items: center">
              <span v-if="data.isAuth">
                {{ data.label }}
              </span>
              <span v-else>{{ defaultProps.label(data) }}</span>
            </div>
          </template>
        </ElTree>
      </ElScrollbar>
      <template #footer>
        <div class="dialog-footer">
          <ElButton @click="toggleExpandAll">{{ isExpandAll ? '全部收起' : '全部展开' }}</ElButton>
          <ElButton @click="toggleSelectAll" style="margin-left: 8px">{{
            isSelectAll ? '取消全选' : '全部选择'
          }}</ElButton>
          <ElButton type="primary" @click="savePermission">保存</ElButton>
        </div>
      </template>
    </ElDialog>
  </div>
</template>

<script setup lang="ts">
  import { useMenuStore } from '@/store/modules/menu'
  import { ElMessage, ElMessageBox } from 'element-plus'
  import type { FormInstance, FormRules } from 'element-plus'
  import { formatMenuTitle } from '@/router/utils/utils'
  import { Role, Department, DEPARTMENT_LIST_DATA } from '@/mock/formData'
  import { ButtonMoreItem } from '@/components/core/forms/art-button-more/index.vue'
  import { UserService } from '@/api/usersApi'

  defineOptions({ name: 'Role' })

  const dialogVisible = ref(false)
  const permissionDialog = ref(false)
  const { menuList } = storeToRefs(useMenuStore())
  const treeRef = ref()
  const isExpandAll = ref(true)
  const isSelectAll = ref(false)

  // 处理菜单数据，将 authList 转换为子节点
  const processedMenuList = computed(() => {
    const processNode = (node: any) => {
      const processed = { ...node }

      // 如果有 authList，将其转换为子节点
      if (node.meta && node.meta.authList && node.meta.authList.length) {
        const authNodes = node.meta.authList.map((auth: any) => ({
          id: `${node.id}_${auth.auth_mark}`,
          name: `${node.name}_${auth.auth_mark}`,
          label: auth.title,
          auth_mark: auth.auth_mark,
          isAuth: true,
          checked: auth.checked || false
        }))

        processed.children = processed.children ? [...processed.children, ...authNodes] : authNodes
      }

      // 递归处理子节点
      if (processed.children) {
        processed.children = processed.children.map(processNode)
      }

      return processed
    }

    return menuList.value.map(processNode)
  })

  const formRef = ref<FormInstance>()

  const rules = reactive<FormRules>({
    roleName: [
      { required: true, message: '请输入角色名称', trigger: 'blur' },
      { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
    ],
    roleCode: [{ required: true, message: '请输入角色编码', trigger: 'blur' }],
    departmentCode: [{ required: true, message: '请选择所属部门', trigger: 'change' }],
    des: [{ required: true, message: '请输入角色描述', trigger: 'blur' }]
  })

  const form = reactive<Role>({
    id: undefined, // 添加id属性
    roleName: '',
    roleCode: '',
    des: '',
    date: '',
    enable: true,
    departmentCode: 0 // 改为number类型的默认值
  })

  const roleList = ref<Role[]>([])
  const departmentList = ref<Department[]>([])
  const loading = ref(false)
  const pagination = reactive({
    current: 1,
    size: 20,
    total: 0
  })

  onMounted(() => {
    getTableData()
    getDepartmentList()
  })

  const getTableData = async () => {
    try {
      loading.value = true
      const response = await UserService.getRoleList({
        current: pagination.current,
        size: pagination.size
      })

      if (response.code === 200) {
        roleList.value = response.data.records
        pagination.total = response.data.total
        pagination.current = response.data.current
        pagination.size = response.data.size
      } else {
        ElMessage.error(response.msg || '获取角色列表失败')
      }
    } catch (error) {
      ElMessage.error('获取角色列表失败')
      console.error('获取角色列表错误:', error)
    } finally {
      loading.value = false
    }
  }

  const getDepartmentList = async () => {
    try {
      const response = await UserService.getDepartmentList({
        current: 1,
        size: 100 // 获取所有部门用于下拉选择
      })

      if (response.code === 200) {
        departmentList.value = response.data.records
      } else {
        ElMessage.error(response.msg || '获取部门列表失败')
      }
    } catch (error) {
      console.error('获取部门列表错误:', error)
      // 如果API调用失败，回退到mock数据
      departmentList.value = DEPARTMENT_LIST_DATA
    }
  }

  const dialogType = ref('add')

  const showPermissionDialog = () => {
    permissionDialog.value = true
  }

  const defaultProps = {
    children: 'children',
    label: (data: any) => formatMenuTitle(data.meta?.title) || ''
  }

  const deleteRole = (row: any) => {
    ElMessageBox.confirm('确定删除该角色吗？', '删除确认', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'error'
    }).then(async () => {
      try {
        const response = await UserService.deleteRole({ id: row.id })
        if (response.code === 200) {
          ElMessage.success('删除成功')
          getTableData() // 刷新列表
        } else {
          ElMessage.error(response.msg || '删除失败')
        }
      } catch (error) {
        ElMessage.error('删除失败')
        console.error('删除角色错误:', error)
      }
    })
  }

  const handleSubmit = async (formEl: FormInstance | undefined) => {
    if (!formEl) return

    await formEl.validate(async (valid) => {
      if (valid) {
        try {
          let response
          if (dialogType.value === 'add') {
            response = await UserService.addRole({
              roleName: form.roleName,
              roleCode: form.roleCode,
              des: form.des,
              departmentCode: Number(form.departmentCode), // 确保转换为number
              enable: form.enable
            })
          } else {
            response = await UserService.updateRole({
              id: form.id!,
              roleName: form.roleName,
              roleCode: form.roleCode,
              des: form.des,
              departmentCode: Number(form.departmentCode), // 确保转换为number
              enable: form.enable
            })
          }

          if (response.code === 200) {
            const message = dialogType.value === 'add' ? '新增成功' : '修改成功'
            ElMessage.success(message)
            dialogVisible.value = false
            formEl.resetFields()
            getTableData() // 刷新列表
          } else {
            ElMessage.error(response.msg || '操作失败')
          }
        } catch (error) {
          ElMessage.error('操作失败')
          console.error('角色操作错误:', error)
        }
      }
    })
  }

  const buttonMoreClick = (item: ButtonMoreItem, row: any) => {
    if (item.key === 'permission') {
      showPermissionDialog()
    } else if (item.key === 'edit') {
      showDialog('edit', row)
    } else if (item.key === 'delete') {
      deleteRole(row)
    }
  }

  const showDialog = (type: string, row?: any) => {
    dialogVisible.value = true
    dialogType.value = type

    if (type === 'edit' && row) {
      form.id = row.id
      form.roleName = row.roleName
      form.roleCode = row.roleCode
      form.des = row.des
      form.date = row.date
      form.enable = row.enable
      form.departmentCode = Number(row.departmentCode) // 确保转换为number
    } else {
      form.id = undefined
      form.roleName = ''
      form.roleCode = ''
      form.des = ''
      form.date = ''
      form.enable = true
      form.departmentCode = 0 // 改为number类型的默认值
    }
  }

  const savePermission = () => {
    ElMessage.success('权限保存成功')
    permissionDialog.value = false
  }

  const toggleExpandAll = () => {
    const tree = treeRef.value
    if (!tree) return

    // 使用store.nodesMap直接控制所有节点的展开状态
    const nodes = tree.store.nodesMap
    for (const node in nodes) {
      nodes[node].expanded = !isExpandAll.value
    }

    isExpandAll.value = !isExpandAll.value
  }

  const toggleSelectAll = () => {
    const tree = treeRef.value
    if (!tree) return

    if (!isSelectAll.value) {
      // 全选：获取所有节点的key并设置为选中
      const allKeys = getAllNodeKeys(processedMenuList.value)
      tree.setCheckedKeys(allKeys)
    } else {
      // 取消全选：清空所有选中
      tree.setCheckedKeys([])
    }

    isSelectAll.value = !isSelectAll.value
  }

  const getAllNodeKeys = (nodes: any[]): string[] => {
    const keys: string[] = []
    const traverse = (nodeList: any[]) => {
      nodeList.forEach((node) => {
        if (node.name) {
          keys.push(node.name)
        }
        if (node.children && node.children.length > 0) {
          traverse(node.children)
        }
      })
    }
    traverse(nodes)
    return keys
  }

  const handleTreeCheck = () => {
    const tree = treeRef.value
    if (!tree) return

    // 使用树组件的getCheckedKeys方法获取选中的节点
    const checkedKeys = tree.getCheckedKeys()
    const allKeys = getAllNodeKeys(processedMenuList.value)

    // 判断是否全选：选中的节点数量等于总节点数量
    isSelectAll.value = checkedKeys.length === allKeys.length && allKeys.length > 0
  }

  const formatDate = (date: string) => {
    return new Date(date)
      .toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
      })
      .replace(/\//g, '-')
  }
</script>

<style lang="scss" scoped>
  .page-content {
    .svg-icon {
      width: 1.8em;
      height: 1.8em;
      overflow: hidden;
      vertical-align: -8px;
      fill: currentcolor;
    }
  }
</style>
