<template>
  <div class="page-content user">
    <div class="content">
      <div class="left-wrap">
        <div class="user-wrap box-style">
          <img class="bg" src="@imgs/user/bg.webp" />
          <img class="avatar" :src="form.avatar" />
          <div class="name-container">
            <h2 class="name">{{ userInfo.userName }}</h2>
            <div class="tags-container">
              <el-tag
                size="small"
                :type="form.gender === 1 ? 'primary' : 'danger'"
                effect="light"
                class="gender-tag"
              >
                <i class="iconfont-sys">{{ form.gender === 1 ? '&#xe81f;' : '&#xe81e;' }}</i>
                {{ form.gender === 1 ? '男' : '女' }}
              </el-tag>
              <el-tag size="small" type="success" effect="light" class="position-tag">
                {{ form.position }}
              </el-tag>
            </div>
          </div>

          <div class="outer-info">
            <div>
              <i class="iconfont-sys">&#xe82f;</i>
              <span>工号：{{ form.jobNumber }}</span>
            </div>
            <div>
              <i class="iconfont-sys">&#xe72e;</i>
              <span>邮箱：{{ form.email }}</span>
            </div>

            <div>
              <i class="iconfont-sys">&#xe776;</i>
              <span>电话：{{ form.phone }}</span>
            </div>
            <div>
              <i class="iconfont-sys">&#xe884;</i>
              <span>部门：{{ form.department }}</span>
            </div>
          </div>
        </div>
      </div>
      <div class="right-wrap">
        <div class="info box-style">
          <h1 class="title">基本设置</h1>

          <ElForm
            :model="form"
            class="form"
            ref="ruleFormRef"
            :rules="rules"
            label-width="86px"
            label-position="top"
          >
            <ElRow>
              <ElFormItem label="姓名" prop="userName">
                <el-input v-model="form.userName" :disabled="!isEdit" />
              </ElFormItem>
              <ElFormItem label="性别" prop="gender" class="right-input">
                <ElSelect v-model="form.gender" placeholder="Select" :disabled="!isEdit">
                  <ElOption
                    v-for="item in options"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value"
                  />
                </ElSelect>
              </ElFormItem>
            </ElRow>

            <ElRow>
              <ElFormItem label="手机" prop="phone">
                <ElInput v-model="form.phone" :disabled="!isEdit" />
              </ElFormItem>
              <ElFormItem label="邮箱" prop="email" class="right-input">
                <ElInput v-model="form.email" :disabled="!isEdit" />
              </ElFormItem>
            </ElRow>

            <div class="el-form-item-right">
              <ElButton type="primary" style="width: 90px" v-ripple @click="edit">
                {{ isEdit ? '保存' : '编辑' }}
              </ElButton>
            </div>
          </ElForm>
        </div>

        <div class="info box-style" style="margin-top: 20px">
          <h1 class="title">更改密码</h1>

          <ElForm :model="pwdForm" class="form" label-width="86px" label-position="top">
            <ElFormItem label="当前密码" prop="password">
              <ElInput
                v-model="pwdForm.password"
                type="password"
                :disabled="!isEditPwd"
                show-password
              />
            </ElFormItem>

            <ElFormItem label="新密码" prop="newPassword">
              <ElInput
                v-model="pwdForm.newPassword"
                type="password"
                :disabled="!isEditPwd"
                show-password
              />
            </ElFormItem>

            <ElFormItem label="确认新密码" prop="confirmPassword">
              <ElInput
                v-model="pwdForm.confirmPassword"
                type="password"
                :disabled="!isEditPwd"
                show-password
              />
            </ElFormItem>

            <div class="el-form-item-right">
              <ElButton type="primary" style="width: 90px" v-ripple @click="editPwd">
                {{ isEditPwd ? '保存' : '编辑' }}
              </ElButton>
            </div>
          </ElForm>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
  import { useUserStore } from '@/store/modules/user'
  import { UserService } from '@/api/usersApi'
  import { ElForm, ElTag, FormInstance, FormRules } from 'element-plus'

  defineOptions({ name: 'UserCenter' })

  const userStore = useUserStore()
  const userInfo = computed(() => userStore.getUserInfo)

  const isEdit = ref(false)
  const isEditPwd = ref(false)
  const loading = ref(false)

  // 修改form数据结构，与UserInfo类型完全一致
  const form = reactive({
    userId: 0,
    gender: 1,
    userName: '',
    jobNumber: '',
    position: '',
    department: '',
    roles: [] as string[],
    buttons: [] as string[],
    avatar: '',
    email: '',
    phone: ''
  })

  const pwdForm = reactive({
    password: '',
    newPassword: '',
    confirmPassword: ''
  })

  // 初始化用户信息
  const initUserInfo = () => {
    const info = userInfo.value
    if (info) {
      form.userId = info.userId || 0
      form.gender = info.gender || 1
      form.userName = info.userName || ''
      form.jobNumber = info.jobNumber || ''
      form.position = info.position || ''
      form.department = info.department || ''
      form.roles = info.roles || []
      form.buttons = info.buttons || []
      form.avatar = info.avatar || ''
      form.email = info.email || ''
      form.phone = info.phone || ''
    }
  }

  // 获取用户信息
  const fetchUserInfo = async () => {
    try {
      loading.value = true
      const response = await UserService.getUserInfo()
      if (response.code === 200) {
        userStore.setUserInfo(response.data)
        initUserInfo()
      }
    } catch (error) {
      console.error('获取用户信息失败:', error)
    } finally {
      loading.value = false
    }
  }

  // 页面加载时获取用户信息
  onMounted(() => {
    if (!userInfo.value || !userInfo.value.userId) {
      fetchUserInfo()
    } else {
      initUserInfo()
    }
  })

  // 监听userInfo变化
  watch(
    userInfo,
    () => {
      initUserInfo()
    },
    { deep: true }
  )

  const ruleFormRef = ref<FormInstance>()

  const rules = reactive<FormRules>({
    userName: [
      { required: true, message: '请输入姓名', trigger: 'blur' },
      { min: 2, max: 50, message: '长度在 2 到 30 个字符', trigger: 'blur' }
    ],
    email: [{ required: true, message: '请输入邮箱', trigger: 'blur' }],
    phone: [{ required: true, message: '请输入手机号码', trigger: 'blur' }],
    gender: [{ required: true, message: '请选择性别', trigger: 'blur' }]
  })

  const options = [
    { value: 1, label: '男' },
    { value: 2, label: '女' }
  ]

  const edit = async () => {
    if (isEdit.value) {
      // 保存逻辑
      if (!ruleFormRef.value) return
      const valid = await ruleFormRef.value.validate()
      if (valid) {
        // TODO: 调用更新用户信息API
        console.log('保存用户信息:', form)
        isEdit.value = false
      }
    } else {
      isEdit.value = true
    }
  }

  const editPwd = () => {
    if (isEditPwd.value) {
      // TODO: 调用修改密码API
      console.log('修改密码:', pwdForm)
      isEditPwd.value = false
    } else {
      isEditPwd.value = true
    }
  }
</script>

<style lang="scss">
  .user {
    .icon {
      width: 1.4em;
      height: 1.4em;
      overflow: hidden;
      vertical-align: -0.15em;
      fill: currentcolor;
    }
  }
</style>

<style lang="scss" scoped>
  .page-content {
    width: 100%;
    height: 100%;
    padding: 0 !important;
    background: transparent !important;
    border: none !important;
    box-shadow: none !important;

    $box-radius: calc(var(--custom-radius) + 4px);

    .box-style {
      border: 1px solid var(--art-border-color);
    }

    .content {
      position: relative;
      display: flex;
      justify-content: space-between;
      margin-top: 10px;

      .left-wrap {
        width: 450px;
        margin-right: 25px;

        .user-wrap {
          position: relative;
          height: 600px;
          padding: 35px 40px;
          overflow: hidden;
          text-align: center;
          background: var(--art-main-bg-color);
          border-radius: $box-radius;

          .bg {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 200px;
            object-fit: cover;
          }

          .avatar {
            position: relative;
            z-index: 10;
            width: 80px;
            height: 80px;
            margin-top: 120px;
            object-fit: cover;
            border: 2px solid #fff;
            border-radius: 50%;
          }

          .name-container {
            margin-top: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;

            .name {
              margin: 0;
              font-size: 22px;
              font-weight: 400;
            }

            .tags-container {
              display: flex;
              gap: 8px;
              align-items: center;
              flex-wrap: wrap;
              justify-content: center;

              .gender-tag {
                display: flex;
                align-items: center;
                gap: 4px;
                border-radius: 12px;

                i {
                  font-size: 12px;
                }
              }

              .position-tag {
                border-radius: 12px;
                font-weight: 500;
                color: #2d5a27; /* 添加深绿色字体颜色 */
              }
            }
          }

          .des {
            margin-top: 20px;
            font-size: 14px;
          }

          .outer-info {
            width: 300px;
            margin: auto;
            margin-top: 30px;
            text-align: left;

            > div {
              margin-top: 10px;

              span {
                margin-left: 8px;
                font-size: 14px;
              }
            }
          }

          .lables {
            margin-top: 40px;

            h3 {
              font-size: 15px;
              font-weight: 500;
            }

            > div {
              display: flex;
              flex-wrap: wrap;
              justify-content: center;
              margin-top: 15px;

              > div {
                padding: 3px 6px;
                margin: 0 10px 10px 0;
                font-size: 12px;
                background: var(--art-main-bg-color);
                border: 1px solid var(--art-border-color);
                border-radius: 2px;
              }
            }
          }
        }

        .gallery {
          margin-top: 25px;
          border-radius: 10px;

          .item {
            img {
              width: 100%;
              height: 100%;
              object-fit: cover;
            }
          }
        }
      }

      .right-wrap {
        flex: 1;
        overflow: hidden;
        border-radius: $box-radius;

        .info {
          background: var(--art-main-bg-color);
          border-radius: $box-radius;

          .title {
            padding: 15px 25px;
            font-size: 20px;
            font-weight: 400;
            color: var(--art-text-gray-800);
            border-bottom: 1px solid var(--art-border-color);
          }

          .form {
            box-sizing: border-box;
            padding: 30px 25px;

            > .el-row {
              .el-form-item {
                width: calc(50% - 10px);
              }

              .el-input,
              .el-select {
                width: 100%;
              }
            }

            .right-input {
              margin-left: 20px;
            }

            .el-form-item-right {
              display: flex;
              align-items: center;
              justify-content: end;

              .el-button {
                width: 110px !important;
              }
            }
          }
        }
      }
    }
  }

  @media only screen and (max-width: $device-ipad-vertical) {
    .page-content {
      .content {
        display: block;
        margin-top: 5px;

        .left-wrap {
          width: 100%;
        }

        .right-wrap {
          width: 100%;
          margin-top: 15px;
        }
      }
    }
  }
</style>
