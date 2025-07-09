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

export interface VehicleItem {
  id: number
  vehicleType: string
  plateNumber: string
  currentLoad: number
  maxLoad: number
  healthStatus: string
  storageStatus: string
  currentRoute: string
  driverJobNumber: string
  purchaseTime: string
  isEnabled: boolean
  loadRate: number
}

export interface VehicleListParams {
  current: number
  size: number
  plateNumber?: string
  vehicleType?: string
  healthStatus?: string
  storageStatus?: string
  isEnabled?: string
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

  // 获取车辆列表
  static getVehicleList(params: VehicleListParams) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/delivery/vehicles/',
      params: {
        current: params.current,
        size: params.size,
        plateNumber: params.plateNumber,
        vehicleType: params.vehicleType,
        healthStatus: params.healthStatus,
        storageStatus: params.storageStatus,
        isEnabled: params.isEnabled
      }
    })
  }

  // 新增车辆
  static addVehicle(data: {
    vehicleType: string
    plateNumber: string
    currentLoad?: number
    maxLoad: number
    healthStatus?: string
    storageStatus?: string
    currentRoute?: string
    driverJobNumber: string
    purchaseTime: string
    isEnabled?: boolean
  }): Promise<Api.Http.BaseResponse<any>> {
    return request.post<Api.Http.BaseResponse<any>>({
      url: '/api/delivery/vehicles/manage/',
      data
    })
  }

  // 更新车辆
  static updateVehicle(data: {
    id: number
    vehicleType?: string
    plateNumber?: string
    currentLoad?: number
    maxLoad?: number
    healthStatus?: string
    storageStatus?: string
    currentRoute?: string
    driverJobNumber?: string
    purchaseTime?: string
    isEnabled?: boolean
  }): Promise<Api.Http.BaseResponse<any>> {
    return request.put<Api.Http.BaseResponse<any>>({
      url: '/api/delivery/vehicles/manage/',
      data
    })
  }

  // 删除车辆
  static deleteVehicle(data: { id: number }): Promise<Api.Http.BaseResponse<any>> {
    return request.del<Api.Http.BaseResponse<any>>({
      url: '/api/delivery/vehicles/manage/',
      data
    })
  }
}
