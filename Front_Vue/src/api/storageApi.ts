import request from '@/utils/http'

export class StorageService {
  // 获取商品列表
  static getCommodityList(
    params: Api.Common.PaginatingParams & {
      name?: string
      brand?: string
      status?: string
    }
  ) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/commodity/list',
      params
    })
  }

  // 获取库存列表
  static getInventoryList(
    params: Api.Common.PaginatingParams & {
      name?: string
      brand?: string
      supplier?: string
      storageArea?: string
    }
  ) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/inventory/list',
      params
    })
  }

  // 新增商品
  static addCommodity(data: {
    name: string
    image: string
    brand: string
    description: string
    status?: string
    price: number
    stock: number
    supplier: string
    storageArea: string
    totalInbound?: number
    totalOutbound?: number
  }): Promise<Api.Http.BaseResponse<any>> {
    return request.post<Api.Http.BaseResponse<any>>({
      url: '/api/commodity/manage',
      data
    })
  }

  // 更新商品
  static updateCommodity(data: {
    id: number
    name?: string
    image?: string
    brand?: string
    description?: string
    status?: string
    price?: number
    stock?: number
    supplier?: string
    storageArea?: string
  }): Promise<Api.Http.BaseResponse<any>> {
    return request.put<Api.Http.BaseResponse<any>>({
      url: '/api/commodity/manage',
      data
    })
  }

  // 删除商品
  static deleteCommodity(data: { id: number }): Promise<Api.Http.BaseResponse<any>> {
    return request.del<Api.Http.BaseResponse<any>>({
      url: '/api/commodity/manage',
      data
    })
  }

  // 调整库存
  static adjustInventory(data: {
    commodityId: number
    adjustType: '入库' | '出库'
    quantity: number
    reason: string
    relatedOrder?: string
  }): Promise<Api.Http.BaseResponse<any>> {
    return request.post<Api.Http.BaseResponse<any>>({
      url: '/api/inventory/adjust/',
      data
    })
  }
}
