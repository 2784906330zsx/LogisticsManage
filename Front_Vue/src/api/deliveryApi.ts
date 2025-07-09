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

export interface OrderAssignParams {
  orderId: string
  vehicleId: string
  routeInfo?: {
    departure: string
    destination: string
  }
  // 移除 driverName 和 driverPhone，因为后端会自动获取
}

export class DeliveryService {
  // 获取固定线路列表
  static getStaticRouteList(params: StaticRouteListParams) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/delivery/static-route/list/',
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
      url: '/api/delivery/static-route/manage/',
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
      url: '/api/delivery/static-route/manage/',
      data
    })
  }

  // 删除固定线路
  static deleteStaticRoute(data: { id: number }): Promise<Api.Http.BaseResponse<any>> {
    return request.del<Api.Http.BaseResponse<any>>({
      url: '/api/delivery/static-route/manage/',
      data
    })
  }

  // 获取车辆列表
  static getVehicleList(params: VehicleListParams) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/delivery/vehicle/list/',
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
      url: '/api/delivery/vehicle/manage/',
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
      url: '/api/delivery/vehicle/manage/',
      data
    })
  }

  // 删除车辆
  static deleteVehicle(data: { id: number }): Promise<Api.Http.BaseResponse<any>> {
    return request.del<Api.Http.BaseResponse<any>>({
      url: '/api/delivery/vehicle/manage/',
      data
    })
  }

  //分配运单给配送车辆
  static assignOrder(params: OrderAssignParams): Promise<Api.Http.BaseResponse<any>> {
    return request.post<Api.Http.BaseResponse<any>>({
      url: '/api/delivery/order/assign/',
      data: params
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
}
