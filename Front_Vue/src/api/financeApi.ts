import request from '@/utils/http'

export class FinanceService {
  // 获取待审核订单列表
  static getPendingOrderList(
    params: Api.Common.PaginatingParams & {
      orderNumber?: string
      commodityName?: string
      supplierName?: string
      purchaserName?: string
    }
  ) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/finance/order/review/',
      params
    })
  }

  // 审核订单
  static reviewOrder(data: {
    orderId: number
    action: 'approve' | 'reject'
    reviewComment?: string
  }) {
    return request.post<Api.Http.BaseResponse<any>>({
      url: '/api/finance/order/review/',
      data
    })
  }

  // 获取支出记录列表
  static getExpenditureRecordList(
    params: Api.Common.PaginatingParams & {
      reason?: string
      relatedOrder?: string
      operatorName?: string
    }
  ) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/finance/expenditure/record/',
      params
    })
  }

  // 创建支出记录
  static createExpenditureRecord(data: {
    amount: number
    reason: string
    relatedOrder?: string
    remark?: string
  }) {
    return request.post<Api.Http.BaseResponse<any>>({
      url: '/api/finance/expenditure/record/',
      data
    })
  }

  // 更新支出记录
  static updateExpenditureRecord(data: {
    id: number
    amount?: number
    reason?: string
    relatedOrder?: string
    remark?: string
  }) {
    return request.put<Api.Http.BaseResponse<any>>({
      url: '/api/finance/expenditure/record/',
      data
    })
  }

  // 删除支出记录
  static deleteExpenditureRecord(id: number) {
    return request.del<Api.Http.BaseResponse<any>>({
      url: '/api/finance/expenditure/record/',
      data: { id }
    })
  }

  // 获取收入记录列表
  static getIncomeRecordList(
    params: Api.Common.PaginatingParams & {
      reason?: string
      relatedOrder?: string
      operatorName?: string
    }
  ) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/finance/income/record/',
      params
    })
  }

  // 创建收入记录
  static createIncomeRecord(data: {
    amount: number
    reason: string
    relatedOrder?: string
    remark?: string
  }) {
    return request.post<Api.Http.BaseResponse<any>>({
      url: '/api/finance/income/record/',
      data
    })
  }

  // 更新收入记录
  static updateIncomeRecord(data: {
    id: number
    amount?: number
    reason?: string
    relatedOrder?: string
    remark?: string
  }) {
    return request.put<Api.Http.BaseResponse<any>>({
      url: '/api/finance/income/record/',
      data
    })
  }

  // 删除收入记录
  static deleteIncomeRecord(id: number) {
    return request.del<Api.Http.BaseResponse<any>>({
      url: '/api/finance/income/record/',
      data: { id }
    })
  }

  // 获取财务总览
  static getFinanceOverview() {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/finance/overview/'
    })
  }

  // 获取财务统计数据（新增）
  static getFinanceStatistics() {
    return request.get<
      Api.Http.BaseResponse<{
        balance: number
        todayIncome: number
        todayExpenditure: number
        totalIncome: number
        totalExpenditure: number
        netProfit: number
      }>
    >({
      url: '/api/finance/statistics/'
    })
  }
}
