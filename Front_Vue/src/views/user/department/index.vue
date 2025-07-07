<template>
  <div class="page-content">
    <ElForm>
      <ElRow :gutter="12">
        <ElCol :xs="24" :sm="12" :lg="6">
          <ElFormItem>
            <ElInput v-model="searchForm.departmentName" placeholder="部门名称" clearable></ElInput>
          </ElFormItem>
        </ElCol>
        <ElCol :xs="24" :sm="12" :lg="6">
          <ElFormItem>
            <ElButton @click="handleSearch" v-ripple>搜索</ElButton>
            <ElButton @click="showDialog('add')" v-ripple>新增部门</ElButton>
          </ElFormItem>
        </ElCol>
      </ElRow>
    </ElForm>
    <ArtTable :data="departmentList" :loading="loading" index>
      <template #default>
        <ElTableColumn label="部门名称" prop="departmentName" />
        <ElTableColumn label="部门编码" prop="departmentCode" />
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
              <ArtButtonMore
                :list="[
                  { key: 'edit', label: '编辑部门' },
                  { key: 'delete', label: '删除部门' }
                ]"
                @click="buttonMoreClick($event, scope.row)"
              />
            </ElRow>
          </template>
        </ElTableColumn>
      </template>
    </ArtTable>

    <!-- 分页组件 -->
    <ElPagination
      v-model:current-page="pagination.current"
      v-model:page-size="pagination.size"
      :total="pagination.total"
      :page-sizes="[10, 20, 50, 100]"
      layout="total, sizes, prev, pager, next, jumper"
      @size-change="getTableData"
      @current-change="getTableData"
    />

    <ElDialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增部门' : '编辑部门'"
      width="30%"
      align-center
    >
      <ElForm ref="formRef" :model="form" :rules="rules" label-width="120px">
        <ElFormItem label="部门名称" prop="departmentName">
          <ElInput v-model="form.departmentName" />
        </ElFormItem>
        <ElFormItem label="部门编码" prop="departmentCode" v-if="dialogType === 'edit'">
          <ElInput v-model.number="form.departmentCode" type="number" disabled />
        </ElFormItem>
        <ElFormItem label="描述" prop="des">
          <ElInput v-model="form.des" type="textarea" :rows="3" />
        </ElFormItem>
        <ElFormItem label="启用">
          <ElSwitch v-model="form.enable" />
        </ElFormItem>
      </ElForm>
      <template #footer>
        <div class="dialog-footer">
          <ElButton @click="dialogVisible = false">取消</ElButton>
          <ElButton type="primary" :loading="submitLoading" @click="handleSubmit(formRef)"
            >提交</ElButton
          >
        </div>
      </template>
    </ElDialog>
  </div>
</template>

<script setup lang="ts">
  import { ElMessage, ElMessageBox } from 'element-plus'
  import type { FormInstance, FormRules } from 'element-plus'
  import { Department } from '@/mock/formData'
  import { ButtonMoreItem } from '@/components/core/forms/art-button-more/index.vue'
  import { UserService } from '@/api/usersApi'

  defineOptions({ name: 'Department' })

  const dialogVisible = ref(false)
  const formRef = ref<FormInstance>()
  const loading = ref(false)
  const submitLoading = ref(false)

  const rules = reactive<FormRules>({
    departmentName: [
      { required: true, message: '请输入部门名称', trigger: 'blur' },
      { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
    ],
    des: [{ required: true, message: '请输入部门描述', trigger: 'blur' }]
  })

  const form = reactive<Department & { id?: number }>({
    departmentName: '',
    departmentCode: 0, // 修改为number类型的默认值
    des: '',
    date: '',
    enable: true
  })

  const searchForm = reactive({
    departmentName: ''
  })

  const departmentList = ref<Department[]>([])
  const pagination = reactive({
    current: 1,
    size: 20,
    total: 0
  })

  onMounted(() => {
    getTableData()
  })

  const getTableData = async () => {
    try {
      loading.value = true
      const response = await UserService.getDepartmentList({
        current: pagination.current,
        size: pagination.size,
        ...searchForm
      })

      if (response.code === 200) {
        departmentList.value = response.data.records
        pagination.total = response.data.total
        pagination.current = response.data.current
        pagination.size = response.data.size
      } else {
        ElMessage.error(response.msg || '获取部门列表失败')
      }
    } catch (error) {
      ElMessage.error('获取部门列表失败')
      console.error('获取部门列表错误:', error)
    } finally {
      loading.value = false
    }
  }

  const handleSearch = () => {
    pagination.current = 1
    getTableData()
  }

  const dialogType = ref('add')

  const showDialog = (type: string, row?: any) => {
    dialogVisible.value = true
    dialogType.value = type

    if (type === 'edit' && row) {
      form.id = row.id
      form.departmentName = row.departmentName
      form.departmentCode = Number(row.departmentCode) // 确保转换为number
      form.des = row.des
      form.enable = row.enable
    } else {
      form.id = undefined
      form.departmentName = ''
      form.departmentCode = 0 // 修改为number类型的默认值
      form.des = ''
      form.enable = true
    }
  }

  const buttonMoreClick = (item: ButtonMoreItem, row: any) => {
    if (item.key === 'edit') {
      showDialog('edit', row)
    } else if (item.key === 'delete') {
      deleteDepartment(row)
    }
  }

  const deleteDepartment = (row: any) => {
    ElMessageBox.confirm('确定删除该部门吗？', '删除确认', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'error'
    }).then(async () => {
      try {
        const response = await UserService.deleteDepartment({ id: row.id })
        if (response.code === 200) {
          ElMessage.success('删除成功')
          getTableData()
        } else {
          ElMessage.error(response.msg || '删除失败')
        }
      } catch (error) {
        ElMessage.error('删除失败')
        console.error('删除部门错误:', error)
      }
    })
  }

  const handleSubmit = async (formEl: FormInstance | undefined) => {
    if (!formEl) return

    await formEl.validate(async (valid) => {
      if (valid) {
        try {
          submitLoading.value = true
          let response

          if (dialogType.value === 'add') {
            response = await UserService.addDepartment({
              departmentName: form.departmentName,
              des: form.des,
              enable: form.enable
            })
          } else {
            response = await UserService.updateDepartment({
              id: form.id!,
              departmentName: form.departmentName,
              des: form.des,
              enable: form.enable
            })
          }

          if (response.code === 200) {
            const message = dialogType.value === 'add' ? '新增成功' : '修改成功'
            ElMessage.success(message)
            dialogVisible.value = false
            formEl.resetFields()
            getTableData()
          } else {
            ElMessage.error(response.msg || '操作失败')
          }
        } catch (error) {
          ElMessage.error('操作失败')
          console.error('提交错误:', error)
        } finally {
          submitLoading.value = false
        }
      }
    })
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
