<template>
  <div class="create-shipping-order-page">
    <ElCard shadow="never">
      <template #header>
        <div class="card-header">
          <ElIcon><Plus /></ElIcon>
          <span>创建运单</span>
        </div>
      </template>

      <ElForm
        ref="formRef"
        :model="formData"
        :rules="rules"
        label-width="120px"
        class="create-form"
      >
        <!-- 在商品信息分割线之前添加运单信息部分 -->
        <!-- 运单信息 -->
        <ElDivider content-position="left">运单信息</ElDivider>
        <ElRow :gutter="20">
          <ElCol :span="12">
            <ElFormItem label="创建人">
              <ElInput v-model="formData.creatorName" disabled />
            </ElFormItem>
          </ElCol>
          <ElCol :span="12">
            <ElFormItem label="创建人工号">
              <ElInput v-model="formData.creatorJobNumber" disabled />
            </ElFormItem>
          </ElCol>
        </ElRow>

        <!-- 商品信息 -->
        <ElDivider content-position="left">商品信息</ElDivider>
        <ElRow :gutter="20">
          <ElCol :span="12">
            <ElFormItem label="商品ID" prop="commodityCode">
              <ElInput
                v-model="formData.commodityCode"
                placeholder="请输入商品ID"
                @input="handleCommodityCodeChange"
              />
            </ElFormItem>
          </ElCol>
          <ElCol :span="12">
            <ElFormItem label="商品名称" prop="commodityName">
              <ElSelect
                v-model="formData.commodityId"
                placeholder="请选择商品名称"
                filterable
                @change="handleCommodityChange"
              >
                <ElOption
                  v-for="commodity in COMMODITY_LIST_DATA"
                  :key="commodity.id"
                  :label="commodity.name"
                  :value="commodity.id"
                />
              </ElSelect>
              <div
                v-if="commodityNotFound"
                style="color: #f56c6c; font-size: 12px; margin-top: 4px"
              >
                找不到该商品ID对应的商品
              </div>
            </ElFormItem>
          </ElCol>
        </ElRow>
        <ElRow :gutter="20">
          <ElCol :span="12">
            <ElFormItem label="商品数量" prop="quantity">
              <ElInputNumber v-model="formData.quantity" :min="1" style="width: 100%" />
            </ElFormItem>
          </ElCol>
        </ElRow>

        <!-- 显示选中的商品信息 -->
        <ElRow :gutter="20" v-if="selectedCommodity">
          <ElCol :span="24">
            <ElFormItem label="商品详情">
              <div class="commodity-preview">
                <ElImage
                  :src="selectedCommodity.image"
                  style="width: 80px; height: 80px; border-radius: 6px; margin-right: 16px"
                  fit="cover"
                />
                <div class="commodity-details">
                  <p><strong>商品ID：</strong>{{ selectedCommodity.id }}</p>
                  <p><strong>商品名称：</strong>{{ selectedCommodity.name }}</p>
                  <p><strong>品牌：</strong>{{ selectedCommodity.brand }}</p>
                  <p><strong>价格：</strong>¥{{ selectedCommodity.price }}</p>
                </div>
              </div>
            </ElFormItem>
          </ElCol>
        </ElRow>

        <!-- 收货信息 -->
        <ElDivider content-position="left">收货信息</ElDivider>
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

        <!-- 操作按钮 -->
        <ElFormItem>
          <ElButton type="primary" @click="handleSubmit" :loading="submitting"> 创建运单 </ElButton>
          <ElButton @click="handleReset">重置</ElButton>
          <ElButton @click="handleCancel">取消</ElButton>
        </ElFormItem>
      </ElForm>
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import { Plus } from '@element-plus/icons-vue'
  import { COMMODITY_LIST_DATA } from '@/mock/formData'
  import { FormInstance, ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useRouter } from 'vue-router'

  defineOptions({ name: 'CreateShippingOrder' })

  const router = useRouter()
  const formRef = ref<FormInstance>()
  const submitting = ref(false)
  const selectedCommodity = ref<any>(null)
  const commodityNotFound = ref(false)

  // 表单数据
  const formData = reactive({
    creatorName: '', // 添加创建人字段
    creatorJobNumber: '', // 添加创建人工号字段
    commodityCode: '', // 商品ID输入框
    commodityId: undefined as number | undefined,
    quantity: 1,
    receiverName: '',
    receiverPhone: '',
    receiverAddress: ''
  })

  // 生成运单号
  const generateOrderNumber = () => {
    const now = new Date()
    const year = now.getFullYear()
    const month = String(now.getMonth() + 1).padStart(2, '0')
    const day = String(now.getDate()).padStart(2, '0')
    const hours = String(now.getHours()).padStart(2, '0')
    const minutes = String(now.getMinutes()).padStart(2, '0')
    const seconds = String(now.getSeconds()).padStart(2, '0')
    const random = Math.floor(Math.random() * 1000)
      .toString()
      .padStart(3, '0')
    return `WD${year}${month}${day}${hours}${minutes}${seconds}${random}`
  }

  // 格式化时间
  //   const formatDateTime = (date: Date) => {
  //     const year = date.getFullYear()
  //     const month = String(date.getMonth() + 1).padStart(2, '0')
  //     const day = String(date.getDate()).padStart(2, '0')
  //     const hours = String(date.getHours()).padStart(2, '0')
  //     const minutes = String(date.getMinutes()).padStart(2, '0')
  //     const seconds = String(date.getSeconds()).padStart(2, '0')
  //     return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
  //   }

  // 生成创建人信息（模拟从用户信息获取）
  // 取消注释并修改生成创建人信息函数
  const generateCreatorInfo = () => {
    // 这里应该从实际的用户信息中获取
    const creators = [
      { name: '张三', jobNumber: 'EMP001' },
      { name: '李四', jobNumber: 'EMP002' },
      { name: '王五', jobNumber: 'EMP003' }
    ]
    const randomCreator = creators[Math.floor(Math.random() * creators.length)]
    return randomCreator
  }

  // 初始化创建人信息
  const initializeCreatorInfo = () => {
    const creator = generateCreatorInfo()
    formData.creatorName = creator.name
    formData.creatorJobNumber = creator.jobNumber
  }

  // 在页面加载时初始化创建人信息
  onMounted(() => {
    initializeCreatorInfo()
  })

  // 处理商品ID输入变化
  const handleCommodityCodeChange = (value: string) => {
    commodityNotFound.value = false

    if (value) {
      const commodity = COMMODITY_LIST_DATA.find((item) => item.id.toString() === value)
      if (commodity) {
        formData.commodityId = commodity.id
        selectedCommodity.value = commodity
      } else {
        // 商品ID不存在时显示错误提示
        commodityNotFound.value = true
        formData.commodityId = undefined
        selectedCommodity.value = null
      }
    } else {
      formData.commodityId = undefined
      selectedCommodity.value = null
    }
  }

  // 处理商品选择变化
  const handleCommodityChange = (commodityId: number) => {
    const commodity = COMMODITY_LIST_DATA.find((item) => item.id === commodityId)
    if (commodity) {
      formData.commodityCode = commodity.id.toString()
      selectedCommodity.value = commodity
      commodityNotFound.value = false
    }
  }

  // 表单验证规则
  const rules = reactive<FormRules>({
    commodityCode: [{ required: true, message: '请输入商品ID', trigger: 'blur' }],
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
        submitting.value = true

        // 模拟API调用
        setTimeout(() => {
          // 在创建成功后生成运单号和创建时间
          const orderNumber = generateOrderNumber()
          //   const createTime = formatDateTime(new Date())
          //   const creator = generateCreatorInfo()

          ElMessage.success(`运单创建成功！运单号：${orderNumber}`)
          submitting.value = false

          // 跳转到运单管理页面
          router.push('/order/all')
        }, 1000)
      }
    })
  }

  // 重置表单时重新初始化创建人信息
  const handleReset = () => {
    if (formRef.value) {
      formRef.value.resetFields()
    }
    selectedCommodity.value = null
    commodityNotFound.value = false
    initializeCreatorInfo() // 重新初始化创建人信息
  }

  // 取消操作
  const handleCancel = () => {
    router.push('/order/all')
  }
</script>

<style scoped>
  .create-shipping-order-page {
    padding: 20px;
    max-width: 1200px;
    margin: 0 auto;
  }

  .card-header {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 18px;
    font-weight: 600;
  }

  .create-form {
    max-width: 800px;
  }

  .commodity-preview {
    display: flex;
    align-items: flex-start;
    padding: 16px;
    background-color: #f8f9fa;
    border-radius: 8px;
    border: 1px solid #e9ecef;
  }

  .commodity-details {
    flex: 1;
  }

  .commodity-details p {
    margin: 4px 0;
    font-size: 14px;
    line-height: 1.5;
  }

  :deep(.el-divider__text) {
    font-weight: 600;
    color: #409eff;
  }
</style>
