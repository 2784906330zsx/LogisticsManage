import request from '@/utils/http'

export interface StaticRouteItem {
  id: number
  departure: string
  destination: string
  totalDistance: number
  estimatedTime: number
  scheduleInfo: string
  isActive: boolean
  createTime: string
}

export interface StaticRouteListParams {
  current: number
  size: number
  departure?: string
  destination?: string
  isActive?: string
}

export interface StaticRouteListResponse {
  code: number
  message: string
  data: {
    list: StaticRouteItem[]
    total: number
    page: number
    pageSize: number
    totalPages: number
  }
}

export class DeliveryService {
  // 获取固定线路列表
  static getStaticRouteList(params: StaticRouteListParams) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/delivery/static-routes/',
      params: {
        current: params.current,
        size: params.size,
        departure: params.departure,
        destination: params.destination,
        isActive: params.isActive
      }
    })
  }

  // 新增固定线路
  static addStaticRoute(data: {
    departure: string
    destination: string
    totalDistance: number
    estimatedTime: number
    scheduleInfo: string
    isActive?: boolean
  }): Promise<Api.Http.BaseResponse<any>> {
    return request.post<Api.Http.BaseResponse<any>>({
      url: '/api/delivery/static-routes/manage/',
      data
    })
  }

  // 更新固定线路
  static updateStaticRoute(data: {
    id: number
    departure?: string
    destination?: string
    totalDistance?: number
    estimatedTime?: number
    scheduleInfo?: string
    isActive?: boolean
  }): Promise<Api.Http.BaseResponse<any>> {
    return request.put<Api.Http.BaseResponse<any>>({
      url: '/api/delivery/static-routes/manage/',
      data
    })
  }

  // 删除固定线路
  static deleteStaticRoute(data: { id: number }): Promise<Api.Http.BaseResponse<any>> {
    return request.del<Api.Http.BaseResponse<any>>({
      url: '/api/delivery/static-routes/manage/',
      data
    })
  }
}
