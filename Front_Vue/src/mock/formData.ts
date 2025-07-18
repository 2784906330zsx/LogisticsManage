import avatar1 from '@/assets/img/avatar/avatar1.webp'
import avatar2 from '@/assets/img/avatar/avatar2.webp'
import avatar3 from '@/assets/img/avatar/avatar3.webp'
import avatar4 from '@/assets/img/avatar/avatar4.webp'
import avatar5 from '@/assets/img/avatar/avatar5.webp'
import avatar6 from '@/assets/img/avatar/avatar6.webp'
import avatar7 from '@/assets/img/avatar/avatar7.webp'
import avatar8 from '@/assets/img/avatar/avatar8.webp'
// import avatar9 from '@/assets/img/avatar/avatar9.webp'
// import avatar10 from '@/assets/img/avatar/avatar10.webp'

export interface User {
  userId: number //员工工号
  username: string //员工姓名
  gender: 1 | 0 //性别
  mobile: string //手机号
  email: string //邮箱
  department: string //所属部门
  position: string // 职务
  status: 1 | 2 | 3 // 1: 在职, 2: 休假, 3: 离职
  avatar: string //头像
}

// 用户列表
export const ACCOUNT_TABLE_DATA: User[] = []

export interface Role {
  id?: number // 添加可选的id属性
  roleName: string
  roleCode: string
  des: string
  date: string
  enable: boolean
  departmentCode: number // 修改为number类型
}

// 角色列表
export const ROLE_LIST_DATA: Role[] = []

export interface Department {
  id?: number // 添加可选的id属性
  departmentName: string
  departmentCode: number // 修改为number类型
  des: string
  date: string
  enable: boolean
}

// 部门列表
export const DEPARTMENT_LIST_DATA: Department[] = []

export interface Commodity {
  id: number
  name: string // 商品名称
  image: string // 商品图片
  brand: string // 品牌
  description: string // 商品介绍
  status: string // 商品状态：1-在售，2-下架，3-预售，4-缺货
  createTime: string // 创建时间
  price: number // 价格
  stock: number // 库存
  totalInbound: number // 总入库数量
  totalOutbound: number // 总出库数量
  supplier: string // 供货商
  lastUpdateTime: string // 最近更新时间
  storageArea: string // 存储区域，格式：A区-L1层-01号
}

// 商品列表模拟数据
export const COMMODITY_LIST_DATA: Commodity[] = []

// 入库记录接口
export interface InboundRecord {
  inboundRecordId: number
  commodityId: number // 商品ID
  commodityName: string // 商品名称
  commodityImage: string // 商品图片
  quantity: number // 入库数量
  reason: string // 入库原因
  inboundTime: string // 入库时间
  relatedOrder: string // 关联订单
  operator: string // 操作员
}

// 出库记录接口
export interface OutboundRecord {
  outboundRecordId: number
  commodityId: number // 商品ID
  commodityName: string // 商品名称
  commodityImage: string // 商品图片
  quantity: number // 出库数量
  reason: string // 出库原因
  outboundTime: string // 出库时间
  relatedOrder: string // 关联订单
  operator: string // 操作员
}

// 入库记录模拟数据
export const INBOUND_RECORD_DATA: InboundRecord[] = []

// 出库记录模拟数据
export const OUTBOUND_RECORD_DATA: OutboundRecord[] = []

// 供应商接口
export interface Supplier {
  id: number
  name: string // 供应商名称
  type: string // 供应商类型
  address: string // 地址
  contactPerson: string // 联系人
  contactPhone: string // 联系电话
  contactEmail: string // 联系邮箱
  createTime: string // 创建时间
  status: string // 状态：1-正常，2-暂停合作，3-黑名单
}

// 供应商列表模拟数据
export const SUPPLIER_LIST_DATA: Supplier[] = []

// 采购订单接口
export interface PurchaseOrder {
  id: number
  orderNumber: string // 订单编号
  commodityId: number // 商品ID
  commodityName: string // 采购商品名称
  commodityImage: string // 采购商品图片
  supplierId: number // 供应商ID
  supplierName: string // 采购供应商
  unitPrice: number // 采购单价
  quantity: number // 采购数量
  totalAmount: number // 总金额
  orderTime: string // 下单时间
  inboundTime: string | null // 入库时间
  status: string // 订单状态：1-未入库，2-已入库，3-已取消
  purchaserName: string // 采购人姓名
  purchaserJobNumber: string // 采购人工号
  warehouseKeeperName: string | null // 入库人姓名
  warehouseKeeperJobNumber: string | null // 入库人工号
}

// 采购订单列表模拟数据
export const PURCHASE_ORDER_DATA: PurchaseOrder[] = []

// 运单接口
export interface ShippingOrder {
  id: number
  orderNumber: string // 运单号（自动生成）
  commodityId: number // 商品ID
  commodityImage: string // 商品图片
  commodityName: string // 商品名称
  quantity: number // 商品数量
  receiverName: string // 收货人姓名
  receiverPhone: string // 联系方式
  receiverAddress: string // 收货地址
  status: string // 订单状态：1-待审核，2-审核未通过，3-审核通过/待配送，4-配送中，5-已送达，6-已确认收货，7-已取消
  createTime: string // 运单创建时间
  completeTime: string | null // 运单完成时间
  creatorName: string // 创建人姓名
  creatorJobNumber: string // 创建人工号
  deliveryPersonName?: string // 配送员姓名
  deliveryPersonPhone?: string // 配送员电话
  trackingInfo?: string // 物流跟踪信息
}

// 运单列表模拟数据
export const SHIPPING_ORDER_DATA: ShippingOrder[] = [
  {
    id: 1,
    orderNumber: 'SO202501150001',
    commodityId: 1,
    commodityImage:
      'https://ts1.tc.mm.bing.net/th/id/OIP-C.CjbS9TqwMegLcwaTA7pCAgHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
    commodityName: '海尔冰箱',
    quantity: 2,
    receiverName: '张三',
    receiverPhone: '13800138001',
    receiverAddress: '北沪市朝阳区建国门外大街1号国贸大厦A座1001室',
    status: '6',
    createTime: '2025-01-15 10:30:00',
    completeTime: '2025-01-18 16:45:00',
    creatorName: 'Sophia Baker',
    creatorJobNumber: 'EMP002',
    deliveryPersonName: '李配送',
    deliveryPersonPhone: '13900139001',
    trackingInfo: '已签收'
  },
  {
    id: 2,
    orderNumber: 'SO202501160002',
    commodityId: 2,
    commodityImage:
      'https://imgservice.suning.cn/uimg1/b2c/image/ofgTnG1XQh9fdeaGhs0wnA.jpg_800w_800h_4e',
    commodityName: 'MacBook Pro 14英寸',
    quantity: 1,
    receiverName: '李四',
    receiverPhone: '13800138002',
    receiverAddress: '上海市浦东新区陆家嘴环路1000号恒生银行大厦20楼',
    status: '4',
    createTime: '2025-01-16 14:20:00',
    completeTime: null,
    creatorName: 'Alex Morgan',
    creatorJobNumber: 'EMP001',
    deliveryPersonName: '王配送',
    deliveryPersonPhone: '13900139002',
    trackingInfo: '配送中，预计今日18:00前送达'
  },
  {
    id: 3,
    orderNumber: 'SO202501170003',
    commodityId: 3,
    commodityImage:
      'https://imgservice.suning.cn/uimg1/b2c/image/TJqCFOY9MhPSXJab_76Ceg.jpg_800w_800h_4e',
    commodityName: 'AirPods Pro 2',
    quantity: 3,
    receiverName: '王五',
    receiverPhone: '13800138003',
    receiverAddress: '广州市天河区珠江新城花城大道85号高德置地广场A座3001室',
    status: '3',
    createTime: '2025-01-17 09:15:00',
    completeTime: null,
    creatorName: 'Ethan Harris',
    creatorJobNumber: 'EMP010',
    trackingInfo: '已审核通过，等待配送'
  },
  {
    id: 4,
    orderNumber: 'SO202501180004',
    commodityId: 4,
    commodityImage:
      'https://imgservice.suning.cn/uimg1/b2c/image/2jOBNNCQdMN2C5VkFaPIjg.png_800w_800h_4e',
    commodityName: 'Haier Galaxy S24',
    quantity: 1,
    receiverName: '赵六',
    receiverPhone: '13800138004',
    receiverAddress: '深圳市南山区科技园南区深南大道9988号',
    status: '5',
    createTime: '2025-01-18 16:45:00',
    completeTime: null,
    creatorName: 'Sophia Baker',
    creatorJobNumber: 'EMP002',
    deliveryPersonName: '陈配送',
    deliveryPersonPhone: '13900139003',
    trackingInfo: '已送达，等待客户确认收货'
  },
  {
    id: 5,
    orderNumber: 'SO202501190005',
    commodityId: 5,
    commodityImage:
      'https://ts1.tc.mm.bing.net/th/id/OIP-C.0E-HDX7AMbNspKcsWq9SPgHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
    commodityName: 'Haier XPS 13',
    quantity: 1,
    receiverName: '孙七',
    receiverPhone: '13800138005',
    receiverAddress: '杭州市西湖区文三路259号昌地火炬大厦1号楼17楼',
    status: '1',
    createTime: '2025-01-19 11:30:00',
    completeTime: null,
    creatorName: 'Mia Clark',
    creatorJobNumber: 'EMP009',
    trackingInfo: '等待审核'
  },
  {
    id: 6,
    orderNumber: 'SO202501200006',
    commodityId: 6,
    commodityImage:
      'https://tse1-mm.cn.bing.net/th/id/OIP-C.Vo4zscjAo2A-40QsVFqujwAAAA?w=260&h=195&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    commodityName: 'Sony WH-1000XM5',
    quantity: 2,
    receiverName: '周八',
    receiverPhone: '13800138006',
    receiverAddress: '成都市高新区天府大道中段1388号美年广场A座2001室',
    status: '2',
    createTime: '2025-01-20 13:20:00',
    completeTime: null,
    creatorName: 'Isabella Moore',
    creatorJobNumber: 'EMP011',
    trackingInfo: '审核未通过：收货地址不详细'
  },
  {
    id: 7,
    orderNumber: 'SO202501210007',
    commodityId: 7,
    commodityImage:
      'https://tse2-mm.cn.bing.net/th/id/OIP-C.VUVnS_dCXuDM_soOgq_EawHaFj?w=247&h=186&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    commodityName: 'iPad Air 5',
    quantity: 1,
    receiverName: '吴九',
    receiverPhone: '13800138007',
    receiverAddress: '武汉市江汉区中山大道818号平安大厦25楼',
    status: '7',
    createTime: '2025-01-21 15:10:00',
    completeTime: '2025-01-21 15:30:00',
    creatorName: 'Alex Morgan',
    creatorJobNumber: 'EMP001',
    trackingInfo: '订单已取消'
  },
  {
    id: 8,
    orderNumber: 'SO202501220008',
    commodityId: 8,
    commodityImage:
      'https://tse1-mm.cn.bing.net/th/id/OIP-C.fAuoy-0RFYkQphSIsbjGvQHaFj?w=227&h=180&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    commodityName: 'Xiaomi 14 Pro',
    quantity: 1,
    receiverName: '郑十',
    receiverPhone: '13800138008',
    receiverAddress: '西安市雁塔区科技路33号高新国际商务中心17楼',
    status: '6',
    createTime: '2025-01-22 08:40:00',
    completeTime: '2025-01-25 14:20:00',
    creatorName: 'Ethan Harris',
    creatorJobNumber: 'EMP010',
    deliveryPersonName: '刘配送',
    deliveryPersonPhone: '13900139004',
    trackingInfo: '已签收'
  }
]

// 车辆接口
export interface Vehicle {
  id: number
  type: string // 车辆类型：电动三轮车/面包车/小型卡车/中型卡车/大型卡车
  currentLoad: number // 当前载货量
  maxLoad: number // 最大载货量
  healthStatus: string // 健康状态：正常/小破/大破
  plateNumber: string // 车牌号
  // 新增司机信息
  driverName: string // 司机姓名
  driverJobNumber: string // 司机工号
  driverAvatar: string // 司机头像
  purchaseTime: string // 购入时间
  storageStatus: string // 在库状态：在库待命/在库维修/外出送货/外出维修
  currentRoute?: string // 当前运行线路（仅外出送货时有值）
  isEnabled: boolean // 是否启用
}

// 车辆列表模拟数据
export const VEHICLE_LIST_DATA: Vehicle[] = []

// 固定线路接口
export interface StaticRoute {
  id: number
  departure: string // 出发地
  destination: string // 目的地
  totalDistance: number // 总距离（公里）
  estimatedTime: number // 预计耗时（小时）
  scheduleInfo: string // 班次信息
  isActive: boolean // 是否启用
  createTime: string // 创建时间
}

// 固定线路列表模拟数据
export const STATIC_ROUTE_LIST_DATA: StaticRoute[] = []
