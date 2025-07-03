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
            <ElButton @click="showDialog('add')" v-ripple>新增部门</ElButton>
          </ElFormItem>
        </ElCol>
      </ElRow>
    </ElForm>
    <ArtTable :data="departmentList" index>
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
              <!-- 可以在 list 中添加 auth 属性来控制按钮的权限, auth 属性值为权限标识 -->
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
        <ElFormItem label="部门编码" prop="departmentCode">
          <ElInput v-model="form.departmentCode" />
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
          <ElButton type="primary" @click="handleSubmit(formRef)">提交</ElButton>
        </div>
      </template>
    </ElDialog>
  </div>
</template>

<script setup lang="ts">
  import { ElMessage, ElMessageBox } from 'element-plus'
  import type { FormInstance, FormRules } from 'element-plus'
  import { Department, DEPARTMENT_LIST_DATA } from '@/mock/temp/formData'
  import { ButtonMoreItem } from '@/components/core/forms/art-button-more/index.vue'

  defineOptions({ name: 'Department' })

  const dialogVisible = ref(false)

  const formRef = ref<FormInstance>()

  const rules = reactive<FormRules>({
    departmentName: [
      { required: true, message: '请输入部门名称', trigger: 'blur' },
      { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
    ],
    departmentCode: [
      { required: true, message: '请输入部门编码', trigger: 'blur' },
      { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
    ],
    des: [{ required: true, message: '请输入部门描述', trigger: 'blur' }]
  })

  const form = reactive<Department>({
    departmentName: '',
    departmentCode: '',
    des: '',
    date: '',
    enable: true
  })

  const departmentList = ref<Department[]>([])

  onMounted(() => {
    getTableData()
  })

  const getTableData = () => {
    departmentList.value = DEPARTMENT_LIST_DATA
  }

  const dialogType = ref('add')

  const showDialog = (type: string, row?: any) => {
    dialogVisible.value = true
    dialogType.value = type

    if (type === 'edit' && row) {
      form.departmentName = row.departmentName
      form.departmentCode = row.departmentCode
      form.des = row.des
      form.date = row.date
      form.enable = row.enable
    } else {
      form.departmentName = ''
      form.departmentCode = ''
      form.des = ''
      form.date = ''
      form.enable = true
    }
  }

  const buttonMoreClick = (item: ButtonMoreItem, row: any) => {
    if (item.key === 'edit') {
      showDialog('edit', row)
    } else if (item.key === 'delete') {
      deleteDepartment()
    }
  }

  const deleteDepartment = () => {
    ElMessageBox.confirm('确定删除该部门吗？', '删除确认', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'error'
    }).then(() => {
      ElMessage.success('删除成功')
    })
  }

  const handleSubmit = async (formEl: FormInstance | undefined) => {
    if (!formEl) return

    await formEl.validate((valid) => {
      if (valid) {
        const message = dialogType.value === 'add' ? '新增成功' : '修改成功'
        ElMessage.success(message)
        dialogVisible.value = false
        formEl.resetFields()
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
