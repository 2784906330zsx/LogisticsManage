import request from '@/utils/http'

export class PurchaseService {
  // 获取供应商列表
  static getSupplierList(
    params: Api.Common.PaginatingParams & {
      name?: string
      type?: string
      contactPerson?: string
      status?: string
    }
  ) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/purchase/supplier/list/', // 添加结尾斜杠
      params
    })
  }

  // 获取采购订单列表
  static getPurchaseOrderList(
    params: Api.Common.PaginatingParams & {
      orderNumber?: string
      commodityName?: string
      supplierName?: string
      status?: string
      purchaserName?: string
    }
  ) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/purchase/order/list/', // 添加结尾斜杠
      params
    })
  }

  // 新增供应商
  static addSupplier(data: {
    name: string
    type: string
    address: string
    contactPerson: string
    contactPhone: string
    contactEmail: string
    status?: string
  }) {
    return request.post<Api.Http.BaseResponse<any>>({
      url: '/api/purchase/supplier/manage/', // 添加结尾斜杠
      data
    })
  }

  // 更新供应商
  static updateSupplier(data: {
    id: number
    name?: string
    type?: string
    address?: string
    contactPerson?: string
    contactPhone?: string
    contactEmail?: string
    status?: string
  }) {
    return request.put<Api.Http.BaseResponse<any>>({
      url: '/api/purchase/supplier/manage/', // 添加结尾斜杠
      data
    })
  }

  // 删除供应商
  static deleteSupplier(id: number) {
    return request.del<Api.Http.BaseResponse<any>>({
      url: '/api/purchase/supplier/manage/', // 添加结尾斜杠
      data: { id }
    })
  }

  // 获取商品列表（用于下拉选择）
  static getCommodityList(params?: any) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/storage/commodity/list', // 去掉结尾斜杠
      params
    })
  }

  // 根据商品ID获取商品信息
  static getCommodityInfo(commodityId: number) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/purchase/order/manage/', // 添加结尾斜杠
      params: { commodityId }
    })
  }

  // 新增采购订单
  static addPurchaseOrder(data: any) {
    return request.post<Api.Http.BaseResponse<any>>({
      url: '/api/purchase/order/manage/', // 添加结尾斜杠
      data
    })
  }

  // 删除采购订单
  static deletePurchaseOrder(id: number) {
    return request.del<Api.Http.BaseResponse<any>>({
      url: '/api/purchase/order/manage/', // 添加结尾斜杠
      data: { id }
    })
  }
}
