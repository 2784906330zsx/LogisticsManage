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
                :loading="loadingCommodity"
              />
            </ElFormItem>
          </ElCol>
          <ElCol :span="12">
            <ElFormItem label="商品名称" prop="commodityId">
              <ElSelect
                v-model="formData.commodityId"
                placeholder="请选择商品名称"
                filterable
                @change="handleCommodityChange"
                :loading="loadingCommodities"
              >
                <ElOption
                  v-for="commodity in commodityList"
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
              <ElInputNumber
                v-model="formData.quantity"
                :min="1"
                :max="selectedCommodity?.stock || 999999"
                style="width: 100%"
              />
              <div
                v-if="selectedCommodity && formData.quantity > selectedCommodity.stock"
                style="color: #f56c6c; font-size: 12px; margin-top: 4px"
              >
                库存不足，当前库存：{{ selectedCommodity.stock }}
              </div>
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
                  <p><strong>库存：</strong>{{ selectedCommodity.stock }}</p>
                  <p><strong>供应商：</strong>{{ selectedCommodity.supplier }}</p>
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
          <ElButton
            type="primary"
            @click="handleSubmit"
            :loading="submitting"
            :disabled="!canSubmit"
          >
            创建运单
          </ElButton>
          <ElButton @click="handleReset">重置</ElButton>
          <ElButton @click="handleCancel">取消</ElButton>
        </ElFormItem>
      </ElForm>
    </ElCard>
  </div>
</template>

<script setup lang="ts">
  import { Plus } from '@element-plus/icons-vue'
  import { FormInstance, ElMessage } from 'element-plus'
  import type { FormRules } from 'element-plus'
  import { useRouter } from 'vue-router'
  import { DeliveryService } from '@/api/orderApi'
  import { StorageService } from '@/api/storageApi'
  import { UserService } from '@/api/usersApi'

  defineOptions({ name: 'CreateShippingOrder' })

  const router = useRouter()
  const formRef = ref<FormInstance>()
  const submitting = ref(false)
  const loadingCommodity = ref(false)
  const loadingCommodities = ref(false)
  const selectedCommodity = ref<any>(null)
  const commodityNotFound = ref(false)
  const commodityList = ref<any[]>([])
  const userInfo = ref<any>(null)

  // 表单数据
  const formData = reactive({
    creatorName: '',
    creatorJobNumber: '',
    commodityCode: '',
    commodityId: undefined as number | undefined,
    quantity: 1,
    receiverName: '',
    receiverPhone: '',
    receiverAddress: ''
  })

  // 计算属性：是否可以提交
  const canSubmit = computed(() => {
    return (
      formData.commodityId &&
      formData.quantity > 0 &&
      selectedCommodity.value &&
      formData.quantity <= selectedCommodity.value.stock &&
      formData.receiverName &&
      formData.receiverPhone &&
      formData.receiverAddress
    )
  })

  // 获取用户信息
  const fetchUserInfo = async () => {
    try {
      const response = await UserService.getUserInfo()
      if (response.code === 200) {
        userInfo.value = response.data
        formData.creatorName = response.data.userName
        formData.creatorJobNumber = response.data.jobNumber
      }
    } catch (error) {
      console.error('获取用户信息失败:', error)
      ElMessage.error('获取用户信息失败')
    }
  }

  // 获取商品列表
  const fetchCommodityList = async () => {
    try {
      loadingCommodities.value = true
      const response = await StorageService.getAllCommodities()
      if (response.code === 200) {
        commodityList.value = response.data.list || []
      }
    } catch (error) {
      console.error('获取商品列表失败:', error)
      ElMessage.error('获取商品列表失败')
    } finally {
      loadingCommodities.value = false
    }
  }

  // 根据商品ID获取商品详情
  const fetchCommodityById = async (commodityId: number) => {
    try {
      loadingCommodity.value = true
      const response = await StorageService.getCommodityById(commodityId)
      if (response.code === 200) {
        return response.data
      }
      return null
    } catch (error) {
      console.error('获取商品详情失败:', error)
      return null
    } finally {
      loadingCommodity.value = false
    }
  }

  // 处理商品ID输入变化
  const handleCommodityCodeChange = async (value: string) => {
    commodityNotFound.value = false

    if (value) {
      const commodityId = parseInt(value)
      if (!isNaN(commodityId)) {
        const commodity = await fetchCommodityById(commodityId)
        if (commodity) {
          formData.commodityId = commodity.id
          selectedCommodity.value = commodity
        } else {
          commodityNotFound.value = true
          formData.commodityId = undefined
          selectedCommodity.value = null
        }
      } else {
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
  const handleCommodityChange = async (commodityId: number) => {
    const commodity = await fetchCommodityById(commodityId)
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
    quantity: [
      { required: true, message: '请输入商品数量', trigger: 'blur' },
      {
        validator: (rule, value, callback) => {
          if (selectedCommodity.value && value > selectedCommodity.value.stock) {
            callback(new Error('商品数量不能超过库存'))
          } else {
            callback()
          }
        },
        trigger: 'blur'
      }
    ],
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

    await formRef.value.validate(async (valid) => {
      if (valid) {
        submitting.value = true

        try {
          const response = await DeliveryService.createShippingOrder({
            commodityId: formData.commodityId!,
            quantity: formData.quantity,
            receiverName: formData.receiverName,
            receiverPhone: formData.receiverPhone,
            receiverAddress: formData.receiverAddress
          })

          if (response.code === 200) {
            ElMessage.success(`运单创建成功！运单号：${response.data.orderNumber}`)
            router.push('/order/all')
          } else {
            ElMessage.error(response.msg || '运单创建失败')
          }
        } catch (error) {
          console.error('创建运单失败:', error)
          ElMessage.error('创建运单失败')
        } finally {
          submitting.value = false
        }
      }
    })
  }

  // 重置表单
  const handleReset = () => {
    if (formRef.value) {
      formRef.value.resetFields()
    }
    selectedCommodity.value = null
    commodityNotFound.value = false
    fetchUserInfo() // 重新获取用户信息
  }

  // 取消操作
  const handleCancel = () => {
    router.push('/order/all')
  }

  // 页面初始化
  onMounted(() => {
    fetchUserInfo()
    fetchCommodityList()
  })
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
