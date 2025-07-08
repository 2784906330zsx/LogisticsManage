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
      url: '/api/supplier/list',
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
  }): Promise<Api.Http.BaseResponse<any>> {
    return request.post<Api.Http.BaseResponse<any>>({
      url: '/api/supplier/manage/', // 添加尾部斜杠
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
  }): Promise<Api.Http.BaseResponse<any>> {
    return request.put<Api.Http.BaseResponse<any>>({
      url: '/api/supplier/manage/', // 添加尾部斜杠
      data
    })
  }

  // 删除供应商
  static deleteSupplier(data: { id: number }): Promise<Api.Http.BaseResponse<any>> {
    return request.del<Api.Http.BaseResponse<any>>({
      url: '/api/supplier/manage/', // 添加尾部斜杠
      data
    })
  }
}
