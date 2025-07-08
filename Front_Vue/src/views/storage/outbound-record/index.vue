<template>
  <ArtTableFullScreen>
    <div class="outbound-record-page" id="table-full-screen">
      <!-- 搜索栏 -->
      <ArtSearchBar
        v-model:filter="formFilters"
        :items="formItems"
        @reset="handleReset"
        @search="handleSearch"
      ></ArtSearchBar>

      <ElCard shadow="never" class="art-table-card">
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
      </ElCard>
    </div>
  </ArtTableFullScreen>
</template>

<script setup lang="ts">
  import { h } from 'vue'
  import { OUTBOUND_RECORD_DATA } from '@/mock/formData'
  import { ElImage } from 'element-plus'
  import { ElMessageBox, ElMessage } from 'element-plus'
  import { useCheckedColumns } from '@/composables/useCheckedColumns'
  import ArtButtonTable from '@/components/core/forms/art-button-table/index.vue'
  import { SearchChangeParams, SearchFormItem } from '@/types'
  import { useUserStore } from '@/store/modules/user'

  // const { width } = useWindowSize()
  const userStore = useUserStore()

  defineOptions({ name: 'OutboundRecord' })

  const loading = ref(false)

  // 定义表单搜索初始值
  const initialSearchState = {
    commodityName: '',
    reason: '',
    relatedOrder: ''
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
    getOutboundRecordList()
  }

  // 搜索处理
  const handleSearch = () => {
    console.log('搜索参数:', formFilters)
    pagination.currentPage = 1
    getOutboundRecordList()
  }

  // 表单项变更处理
  const handleFormChange = (params: SearchChangeParams): void => {
    console.log('表单项变更:', params)
  }

  // 表单配置项
  const formItems: SearchFormItem[] = [
    {
      label: '商品名称',
      prop: 'commodityName',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '出库原因',
      prop: 'reason',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    },
    {
      label: '关联订单',
      prop: 'relatedOrder',
      type: 'input',
      config: {
        clearable: true
      },
      onChange: handleFormChange
    }
  ]

  // 删除记录
  const deleteRecord = (row: any) => {
    // 检查是否为超级管理员 - 基于roleCode判断
    if (userStore.info?.roleCode !== 'R_SUPER') {
      ElMessage.warning('只有超级管理员可以删除出库记录')
      return
    }

    ElMessageBox.confirm(
      `确定要删除商品"${row.commodityName}"的出库记录吗？\n出库数量：${row.quantity}\n出库时间：${row.outboundTime}`,
      '删除记录',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'error'
      }
    ).then(() => {
      // TODO: 调用实际的删除API
      // await storageApi.deleteOutboundRecord(row.id)
      console.log('删除出库记录:', row)
      ElMessage.success(`已删除商品"${row.commodityName}"的出库记录`)
      getOutboundRecordList()
    })
  }

  // 动态列配置
  const { columns } = useCheckedColumns(() => [
    { type: 'selection' },
    {
      prop: 'id',
      label: 'ID',
      width: 80
    },
    {
      prop: 'commodityImage',
      label: '商品信息',
      width: 200,
      formatter: (row: any) => {
        return h('div', { class: 'commodity-info', style: 'display: flex; align-items: center' }, [
          h(ElImage, {
            class: 'commodity-image',
            src: row.commodityImage,
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
              row.commodityName
            )
          ])
        ])
      }
    },
    {
      prop: 'quantity',
      label: '出库数量',
      sortable: true
    },
    {
      prop: 'reason',
      label: '出库原因',
      minWidth: 150
    },
    {
      prop: 'relatedOrder',
      label: '关联订单',
      width: 120
    },
    {
      prop: 'outboundName',
      label: '出库人',
      width: 100
    },
    {
      prop: 'outboundTime',
      label: '出库时间',
      sortable: true,
      minWidth: 160
    },
    {
      prop: 'operation',
      label: '操作',
      width: 100,
      formatter: (row: any) => {
        // 只有超级管理员才显示删除按钮
        if (userStore.info?.roleCode === 'R_SUPER') {
          return h('div', [
            h(ArtButtonTable, {
              type: 'delete',
              onClick: () => deleteRecord(row)
            })
          ])
        }
        return h('span', { style: 'color: #999' }, '无权限')
      }
    }
  ])

  onMounted(() => {
    getOutboundRecordList()
  })

  // 获取出库记录列表数据
  const getOutboundRecordList = async () => {
    loading.value = true
    try {
      const { currentPage, pageSize } = pagination

      // 模拟API调用
      await new Promise((resolve) => setTimeout(resolve, 500))

      // 过滤数据
      let filteredData = [...OUTBOUND_RECORD_DATA]

      if (formFilters.commodityName) {
        filteredData = filteredData.filter((item) =>
          item.commodityName.toLowerCase().includes(formFilters.commodityName.toLowerCase())
        )
      }

      if (formFilters.reason) {
        filteredData = filteredData.filter((item) => item.reason === formFilters.reason)
      }

      if (formFilters.relatedOrder) {
        filteredData = filteredData.filter((item) =>
          item.relatedOrder.toLowerCase().includes(formFilters.relatedOrder.toLowerCase())
        )
      }

      // 分页
      const startIndex = (currentPage - 1) * pageSize
      const endIndex = startIndex + pageSize
      const paginatedData = filteredData.slice(startIndex, endIndex)

      tableData.value = paginatedData
      pagination.total = filteredData.length
    } catch (error) {
      console.error('获取出库记录列表失败:', error)
      ElMessage.error('获取出库记录列表失败')
    } finally {
      loading.value = false
    }
  }

  // 处理表格行选择变化
  const handleSelectionChange = (selection: any[]) => {
    selectedRows.value = selection
  }

  // 处理表格分页变化
  const handleSizeChange = (newPageSize: number) => {
    pagination.pageSize = newPageSize
    getOutboundRecordList()
  }

  const handleCurrentChange = (newCurrentPage: number) => {
    pagination.currentPage = newCurrentPage
    getOutboundRecordList()
  }
</script>

<style lang="scss" scoped>
  .outbound-record-page {
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
