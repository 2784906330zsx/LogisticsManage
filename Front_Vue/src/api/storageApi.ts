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
      url: '/api/storage/commodity/list',
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
      url: '/api/storage/inventory/list',
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
      url: '/api/storage/commodity/manage',
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
      url: '/api/storage/commodity/manage',
      data
    })
  }

  // 删除商品
  static deleteCommodity(data: { id: number }): Promise<Api.Http.BaseResponse<any>> {
    return request.del<Api.Http.BaseResponse<any>>({
      url: '/api/storage/commodity/manage',
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
      url: '/api/storage/inventory/adjust/',
      data
    })
  }

  // 获取所有商品（不分页）
  static getAllCommodities() {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/storage/commodity/list',
      params: {
        current: 1,
        size: 1000, // 获取大量数据
        status: '1' // 只获取启用的商品
      }
    })
  }

  // 根据商品ID获取商品详情
  static getCommodityById(commodityId: number) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/delivery/commodity/info/',
      params: { commodityId }
    })
  }

  // 获取入库记录列表
  static getInboundRecordList(
    params: Api.Common.PaginatingParams & {
      commodityName?: string
      reason?: string
      relatedOrder?: string
    }
  ) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/storage/inbound/list',
      params
    })
  }

  // 获取出库记录列表
  static getOutboundRecordList(
    params: Api.Common.PaginatingParams & {
      commodityName?: string
      reason?: string
      relatedOrder?: string
    }
  ) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/storage/outbound/list',
      params
    })
  }

  // 删除入库记录（超级管理员权限）
  static deleteInboundRecord(id: number): Promise<Api.Http.BaseResponse<any>> {
    return request.del<Api.Http.BaseResponse<any>>({
      url: '/api/storage/inbound/manage',
      data: { id }
    })
  }

  // 删除出库记录（超级管理员权限）
  static deleteOutboundRecord(id: number): Promise<Api.Http.BaseResponse<any>> {
    return request.del<Api.Http.BaseResponse<any>>({
      url: '/api/storage/outbound/manage',
      data: { id }
    })
  }
}
