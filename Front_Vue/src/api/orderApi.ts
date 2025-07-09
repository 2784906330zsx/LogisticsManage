import request from '@/utils/http'

export class DeliveryService {
  // 创建运单
  static createShippingOrder(data: {
    commodityId: number
    quantity: number
    receiverName: string
    receiverPhone: string
    receiverAddress: string
  }): Promise<Api.Http.BaseResponse<any>> {
    return request.post<Api.Http.BaseResponse<any>>({
      url: '/api/order/order/',
      data
    })
  }

  // 获取运单列表
  static getShippingOrderList(
    params: Api.Common.PaginatingParams & {
      orderNumber?: string
      status?: string
    }
  ) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/order/order/',
      params
    })
  }

  // 根据商品ID获取商品详情
  static getCommodityInfo(commodityId: number) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/order/commodity/info/',
      params: { commodityId }
    })
  }

  // 运单确认
  static confirmShippingOrder(data: {
    orderId: number
    action: 'approve' | 'reject'
    reviewComment?: string
  }) {
    return request.post<Api.Http.BaseResponse<any>>({
      url: '/api/order/confirm/',
      data
    })
  }

  // 退货审核
  static reviewReturnOrder(data: {
    orderId: number
    action: 'approve' | 'reject'
    reviewComment?: string
  }) {
    return request.post<Api.Http.BaseResponse<any>>({
      url: '/api/order/return-review/',
      data
    })
  }

  // 获取配送运单列表（按状态筛选）
  static getDeliveryOrderList(
    params: Api.Common.PaginatingParams & {
      orderNumber?: string
      deliveryStatus?: string // 配送状态：3-待配送，4-配送中，5-已送达，9-已取消
    }
  ) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/delivery/order/list/',
      params
    })
  }

  // 分配配送员
  static assignDeliveryPerson(data: {
    orderId: number
    deliveryPersonName: string
    deliveryPersonPhone: string
    deliveryCarNumber?: string
  }) {
    return request.post<Api.Http.BaseResponse<any>>({
      url: '/api/delivery/order/assign/',
      data
    })
  }

  // 更新配送状态
  static updateDeliveryStatus(data: { orderId: number; status: string; trackingInfo?: string }) {
    return request.post<Api.Http.BaseResponse<any>>({
      url: '/api/delivery/order/update-status/',
      data
    })
  }
}
