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
}
