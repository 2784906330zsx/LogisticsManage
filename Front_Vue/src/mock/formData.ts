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
  roleName: string
  roleCode: string
  des: string
  date: string
  enable: boolean
  departmentCode: string // 所属部门编码
}

// 角色列表
export const ROLE_LIST_DATA: Role[] = [
  {
    roleName: '超级管理员',
    roleCode: 'R_SUPER',
    des: '拥有系统最高权限',
    date: '2025-07-01 12:34:56',
    enable: true,
    departmentCode: 'D_GENERAL' // 总经办
  },
  {
    roleName: '人事管理员',
    roleCode: 'R_USER_INFO',
    des: '管理用户信息相关权限',
    date: '2025-07-01 12:34:56',
    enable: true,
    departmentCode: 'D_HR' // 人事管理部
  },
  {
    roleName: '订单管理员',
    roleCode: 'R_ORDER',
    des: '管理订单相关权限',
    date: '2025-07-01 12:34:56',
    enable: true,
    departmentCode: 'D_ORDER' // 订单管理部
  },
  {
    roleName: '配送运输管理员',
    roleCode: 'R_DELIVERY',
    des: '管理配送运输相关权限',
    date: '2025-07-01 12:34:56',
    enable: true,
    departmentCode: 'D_DELIVERY' // 配送管理部
  },
  {
    roleName: '仓储作业管理员',
    roleCode: 'R_STORAGE',
    des: '管理仓储作业权限',
    date: '2025-07-01 12:34:56',
    enable: true,
    departmentCode: 'D_STORAGE' // 仓储管理部
  },
  {
    roleName: '采购与供应商管理员',
    roleCode: 'R_PURCHASE',
    des: '管理采购与供应商相关权限',
    date: '2025-07-01 12:34:56',
    enable: true,
    departmentCode: 'D_PURCHASE' // 采购管理部
  },
  {
    roleName: '财务管理员',
    roleCode: 'R_FINANCE',
    des: '管理财务相关权限',
    date: '2025-07-01 12:34:56',
    enable: true,
    departmentCode: 'D_FINANCE' // 财务管理部
  },
  {
    roleName: '人事管理部员工',
    roleCode: 'E_USER_INFO',
    des: '拥有系统普通权限',
    date: '2025-07-01 12:34:56',
    enable: true,
    departmentCode: 'D_HR'
  },
  {
    roleName: '客服与售后员工',
    roleCode: 'E_SERVICE',
    des: '客服与售后员工权限',
    date: '2025-07-01 12:34:56',
    enable: true,
    departmentCode: 'D_SERVICE' // 客服售后部
  },
  {
    roleName: '财务员工',
    roleCode: 'E_FINANCE',
    des: '财务员工权限',
    date: '2025-07-01 12:34:56',
    enable: true,
    departmentCode: 'D_FINANCE' // 财务管理部
  },
  {
    roleName: '订单员',
    roleCode: 'E_ORDER',
    des: '订单员权限',
    date: '2025-07-01 12:34:56',
    enable: true,
    departmentCode: 'D_ORDER' // 订单管理部
  },
  {
    roleName: '配送员',
    roleCode: 'E_DELIVERY',
    des: '配送员权限',
    date: '2025-07-01 12:34:56',
    enable: true,
    departmentCode: 'D_DELIVERY' // 配送管理部
  },
  {
    roleName: '仓储员',
    roleCode: 'E_STORAGE',
    des: '仓储员权限',
    date: '2025-07-01 12:34:56',
    enable: true,
    departmentCode: 'D_STORAGE' // 仓储管理部
  },
  {
    roleName: '采购员',
    roleCode: 'E_PURCHASE',
    des: '采购员权限',
    date: '2025-07-01 12:34:56',
    enable: true,
    departmentCode: 'D_PURCHASE' // 采购管理部
  }
]

export interface Department {
  departmentName: string
  departmentCode: string
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
export const COMMODITY_LIST_DATA: Commodity[] = [
  {
    id: 1,
    name: '海尔冰箱',
    image:
      'https://ts1.tc.mm.bing.net/th/id/OIP-C.CjbS9TqwMegLcwaTA7pCAgHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
    brand: 'Haier',
    description: '海尔冰箱，遥遥领先',
    status: '1',
    createTime: '2025-01-15 10:30:00',
    price: 3999,
    stock: 50,
    totalInbound: 200,
    totalOutbound: 150,
    supplier: '海尔集团公司',
    lastUpdateTime: '2025-01-20 14:30:00',
    storageArea: 'A区-L1层-01号'
  },
  {
    id: 2,
    name: '海尔空调',
    image: 'https://imgservice.suning.cn/uimg1/b2c/image/ofgTnG1XQh9fdeaGhs0wnA.jpg_800w_800h_4e',
    brand: 'Haier',
    description: '海尔空调，遥遥领先',
    status: '1',
    createTime: '2025-01-10 14:20:00',
    price: 2999,
    stock: 30,
    totalInbound: 80,
    totalOutbound: 50,
    supplier: '海尔集团公司',
    lastUpdateTime: '2025-01-18 16:45:00',
    storageArea: 'A区-L2层-03号'
  },
  {
    id: 3,
    name: '海尔电视',
    image: 'https://imgservice.suning.cn/uimg1/b2c/image/TJqCFOY9MhPSXJab_76Ceg.jpg_800w_800h_4e',
    brand: 'Haier',
    description: '海尔电视，遥遥领先',
    status: '2',
    createTime: '2025-01-08 09:15:00',
    price: 3999,
    stock: 0,
    totalInbound: 300,
    totalOutbound: 300,
    supplier: '海尔集团公司',
    lastUpdateTime: '2025-01-19 11:20:00',
    storageArea: 'B区-L1层-05号'
  },
  {
    id: 4,
    name: '海尔洗衣机',
    image: 'https://imgservice.suning.cn/uimg1/b2c/image/2jOBNNCQdMN2C5VkFaPIjg.png_800w_800h_4e',
    brand: 'Haier',
    description: '海尔洗衣机，遥遥领先',
    status: '3',
    createTime: '2025-02-01 16:45:00',
    price: 1999,
    stock: 100,
    totalInbound: 150,
    totalOutbound: 50,
    supplier: '海尔集团公司',
    lastUpdateTime: '2025-02-05 09:30:00',
    storageArea: 'B区-L2层-07号'
  },
  {
    id: 5,
    name: '海尔热水器',
    image:
      'https://ts1.tc.mm.bing.net/th/id/OIP-C.0E-HDX7AMbNspKcsWq9SPgHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
    brand: 'Haier',
    description: '海尔热水器，遥遥领先',
    status: '1',
    createTime: '2025-01-20 11:30:00',
    price: 999,
    stock: 25,
    totalInbound: 60,
    totalOutbound: 35,
    supplier: '海尔集团公司',
    lastUpdateTime: '2025-01-22 13:15:00',
    storageArea: 'C区-L1层-02号'
  }
]

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
export const INBOUND_RECORD_DATA: InboundRecord[] = [
  {
    inboundRecordId: 1,
    commodityId: 1,
    commodityName: '海尔冰箱',
    commodityImage:
      'https://ts1.tc.mm.bing.net/th/id/OIP-C.CjbS9TqwMegLcwaTA7pCAgHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
    quantity: 50,
    reason: '新品采购',
    inboundTime: '2025-01-15 10:30:00',
    relatedOrder: 'PO202501150001',
    operator: 'alexmorgan'
  },
  {
    inboundRecordId: 2,
    commodityId: 2,
    commodityName: '海尔空调',
    commodityImage:
      'https://imgservice.suning.cn/uimg1/b2c/image/ofgTnG1XQh9fdeaGhs0wnA.jpg_800w_800h_4e',
    quantity: 30,
    reason: '补充库存',
    inboundTime: '2025-01-16 14:20:00',
    relatedOrder: 'PO202501160002',
    operator: 'miaclark'
  },
  {
    inboundRecordId: 3,
    commodityId: 3,
    commodityName: '海尔电视',
    commodityImage:
      'https://imgservice.suning.cn/uimg1/b2c/image/TJqCFOY9MhPSXJab_76Ceg.jpg_800w_800h_4e',
    quantity: 100,
    reason: '季度采购',
    inboundTime: '2025-01-18 09:15:00',
    relatedOrder: 'PO202501180003',
    operator: 'miaclark'
  },
  {
    inboundRecordId: 4,
    commodityId: 4,
    commodityName: '海尔洗衣机',
    commodityImage:
      'https://imgservice.suning.cn/uimg1/b2c/image/2jOBNNCQdMN2C5VkFaPIjg.png_800w_800h_4e',
    quantity: 80,
    reason: '新品上市',
    inboundTime: '2025-02-01 16:45:00',
    relatedOrder: 'PO202502010004',
    operator: 'alexmorgan'
  },
  {
    inboundRecordId: 5,
    commodityId: 5,
    commodityName: '海尔热水器',
    commodityImage:
      'https://ts1.tc.mm.bing.net/th/id/OIP-C.0E-HDX7AMbNspKcsWq9SPgHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
    quantity: 25,
    reason: '客户预订',
    inboundTime: '2025-01-20 11:30:00',
    relatedOrder: 'PO202501200005',
    operator: 'miaclark'
  }
]

// 出库记录模拟数据
export const OUTBOUND_RECORD_DATA: OutboundRecord[] = [
  {
    outboundRecordId: 1,
    commodityId: 1,
    commodityName: '海尔冰箱',
    commodityImage:
      'https://ts1.tc.mm.bing.net/th/id/OIP-C.CjbS9TqwMegLcwaTA7pCAgHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
    quantity: 2,
    reason: '客户下单',
    outboundTime: '2025-01-16 14:30:00',
    relatedOrder: 'SO202501160001',
    operator: 'HGF'
  },
  {
    outboundRecordId: 2,
    commodityId: 2,
    commodityName: '海尔空调',
    commodityImage:
      'https://imgservice.suning.cn/uimg1/b2c/image/ofgTnG1XQh9fdeaGhs0wnA.jpg_800w_800h_4e',
    quantity: 1,
    reason: '客户订单',
    outboundTime: '2025-01-17 10:15:00',
    relatedOrder: 'SO202501170002',
    operator: 'ethanharris'
  },
  {
    outboundRecordId: 3,
    commodityId: 3,
    commodityName: '海尔电视',
    commodityImage:
      'https://imgservice.suning.cn/uimg1/b2c/image/TJqCFOY9MhPSXJab_76Ceg.jpg_800w_800h_4e',
    quantity: 5,
    reason: '批量订单',
    outboundTime: '2025-01-19 15:20:00',
    relatedOrder: 'SO202501190003',
    operator: 'ethanharris'
  },
  {
    outboundRecordId: 4,
    commodityId: 1,
    commodityName: '海尔冰箱',
    commodityImage:
      'https://ts1.tc.mm.bing.net/th/id/OIP-C.CjbS9TqwMegLcwaTA7pCAgHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
    quantity: 3,
    reason: '企业采购',
    outboundTime: '2025-01-21 11:45:00',
    relatedOrder: 'SO202501210004',
    operator: 'ethanharris'
  },
  {
    outboundRecordId: 5,
    commodityId: 4,
    commodityName: '海尔洗衣机',
    commodityImage:
      'https://imgservice.suning.cn/uimg1/b2c/image/2jOBNNCQdMN2C5VkFaPIjg.png_800w_800h_4e',
    quantity: 1,
    reason: '客户订单',
    outboundTime: '2025-02-02 09:30:00',
    relatedOrder: 'SO202502020005',
    operator: 'ethanharris'
  }
]

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
export const SUPPLIER_LIST_DATA: Supplier[] = [
  {
    id: 1,
    name: '海尔集团公司',
    type: '企业',
    address: '北京市朝阳区中关村科技园区',
    contactPerson: '张经理',
    contactPhone: '010-85123456',
    contactEmail: 'zhang@Haier.com',
    createTime: '2025-01-15 10:30:00',
    status: '1'
  },
  {
    id: 2,
    name: '海尔集团上海分公司',
    type: '企业',
    address: '上海市浦东新区张江高科技园区',
    contactPerson: '李总监',
    contactPhone: '010-56781234',
    contactEmail: 'li.director@haier.com',
    createTime: '2025-02-20 14:20:00',
    status: '1'
  },
  {
    id: 3,
    name: '海尔集团江苏分公司',
    type: '企业',
    address: '江苏省南京市玄武区玄武大道123号',
    contactPerson: '王部长',
    contactPhone: '021-58901234',
    contactEmail: 'wang.minister@Haier.cn',
    createTime: '2025-03-10 09:15:00',
    status: '1'
  },
  {
    id: 4,
    name: '海尔集团浙江分公司',
    type: '企业',
    address: '浙江省杭州市西湖区西湖大道123号',
    contactPerson: '刘经理',
    contactPhone: '021-38123456',
    contactEmail: 'liu.manager@Haier.com.cn',
    createTime: '2025-04-05 16:45:00',
    status: '1'
  }
]

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
export const PURCHASE_ORDER_DATA: PurchaseOrder[] = [
  {
    id: 1,
    orderNumber: 'PO202501150001',
    commodityId: 1,
    commodityName: '海尔冰箱',
    commodityImage:
      'https://ts1.tc.mm.bing.net/th/id/OIP-C.CjbS9TqwMegLcwaTA7pCAgHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
    supplierId: 1,
    supplierName: '海尔集团公司',
    unitPrice: 8999.0,
    quantity: 50,
    totalAmount: 449950.0,
    orderTime: '2025-01-15 09:30:00',
    inboundTime: '2025-01-16 14:20:00',
    status: '2',
    purchaserName: 'Isabella Moore',
    purchaserJobNumber: 'EMP011',
    warehouseKeeperName: 'Mia Clark',
    warehouseKeeperJobNumber: 'EMP009'
  },
  {
    id: 2,
    orderNumber: 'PO202501160002',
    commodityId: 2,
    commodityName: '海尔空调',
    commodityImage:
      'https://imgservice.suning.cn/uimg1/b2c/image/ofgTnG1XQh9fdeaGhs0wnA.jpg_800w_800h_4e',
    supplierId: 1,
    supplierName: '海尔集团公司',
    unitPrice: 15999.0,
    quantity: 20,
    totalAmount: 319980.0,
    orderTime: '2025-01-16 10:15:00',
    inboundTime: null,
    status: '1',
    purchaserName: 'Isabella Moore',
    purchaserJobNumber: 'EMP011',
    warehouseKeeperName: null,
    warehouseKeeperJobNumber: null
  },
  {
    id: 3,
    orderNumber: 'PO202501170003',
    commodityId: 3,
    commodityName: '海尔电视',
    commodityImage:
      'https://imgservice.suning.cn/uimg1/b2c/image/TJqCFOY9MhPSXJab_76Ceg.jpg_800w_800h_4e',
    supplierId: 1,
    supplierName: '海尔集团公司',
    unitPrice: 1899.0,
    quantity: 100,
    totalAmount: 189900.0,
    orderTime: '2025-01-17 14:30:00',
    inboundTime: '2025-01-18 11:45:00',
    status: '2',
    purchaserName: 'Isabella Moore',
    purchaserJobNumber: 'EMP011',
    warehouseKeeperName: 'Mia Clark',
    warehouseKeeperJobNumber: 'EMP009'
  },
  {
    id: 4,
    orderNumber: 'PO202501180004',
    commodityId: 4,
    commodityName: '海尔洗衣机',
    commodityImage:
      'https://imgservice.suning.cn/uimg1/b2c/image/2jOBNNCQdMN2C5VkFaPIjg.png_800w_800h_4e',
    supplierId: 3,
    supplierName: '海尔集团公司',
    unitPrice: 5999.0,
    quantity: 30,
    totalAmount: 179970.0,
    orderTime: '2025-01-18 16:20:00',
    inboundTime: null,
    status: '3',
    purchaserName: 'Isabella Moore',
    purchaserJobNumber: 'EMP011',
    warehouseKeeperName: null,
    warehouseKeeperJobNumber: null
  },
  {
    id: 5,
    orderNumber: 'PO202501190005',
    commodityId: 5,
    commodityName: '海尔热水器',
    commodityImage:
      'https://ts1.tc.mm.bing.net/th/id/OIP-C.0E-HDX7AMbNspKcsWq9SPgHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
    supplierId: 4,
    supplierName: '海尔集团公司',
    unitPrice: 7999.0,
    quantity: 15,
    totalAmount: 119985.0,
    orderTime: '2025-01-19 09:45:00',
    inboundTime: '2025-01-20 15:30:00',
    status: '2',
    purchaserName: 'Isabella Moore',
    purchaserJobNumber: 'EMP011',
    warehouseKeeperName: 'Mia Clark',
    warehouseKeeperJobNumber: 'EMP009'
  }
]

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
export const VEHICLE_LIST_DATA: Vehicle[] = [
  {
    id: 1,
    type: '电动三轮车',
    currentLoad: 0,
    maxLoad: 2,
    healthStatus: '正常',
    plateNumber: '沪A12345',
    driverName: 'alexmorgan',
    driverJobNumber: 'EMP001',
    driverAvatar: avatar1,
    purchaseTime: '2025-03-15 09:30:00',
    storageStatus: '在库待命',
    isEnabled: true
  },
  {
    id: 2,
    type: '面包车',
    currentLoad: 2,
    maxLoad: 4,
    healthStatus: '正常',
    plateNumber: '沪B67890',
    driverName: 'sophiabaker',
    driverJobNumber: 'EMP002',
    driverAvatar: avatar2,
    purchaseTime: '2025-05-20 14:20:00',
    storageStatus: '外出送货',
    currentRoute: '上海市浦东新区总部 → 浙江省杭州市西湖区分部',
    isEnabled: true
  },
  {
    id: 3,
    type: '小型卡车',
    currentLoad: 0,
    maxLoad: 8,
    healthStatus: '小破',
    plateNumber: '沪C11111',
    driverName: 'liampark',
    driverJobNumber: 'EMP003',
    driverAvatar: avatar3,
    purchaseTime: '2025-01-10 11:15:00',
    storageStatus: '在库维修',
    isEnabled: true
  },
  {
    id: 4,
    type: '中型卡车',
    currentLoad: 10,
    maxLoad: 16,
    healthStatus: '正常',
    plateNumber: '沪D22222',
    driverName: 'oliviagrant',
    driverJobNumber: 'EMP004',
    driverAvatar: avatar4,
    purchaseTime: '2022-11-08 16:45:00',
    storageStatus: '外出送货',
    currentRoute: '上海市浦东新区总部 → 北京市朝阳区分部',
    isEnabled: true
  },
  {
    id: 5,
    type: '大型卡车',
    currentLoad: 0,
    maxLoad: 32,
    healthStatus: '大破',
    plateNumber: '沪E33333',
    driverName: 'emmawilson',
    driverJobNumber: 'EMP005',
    driverAvatar: avatar5,
    purchaseTime: '2022-08-25 10:30:00',
    storageStatus: '外出维修',
    isEnabled: false
  },
  {
    id: 6,
    type: '电动三轮车',
    currentLoad: 1,
    maxLoad: 2,
    healthStatus: '正常',
    plateNumber: '沪F44444',
    driverName: 'noahevan',
    driverJobNumber: 'EMP006',
    driverAvatar: avatar6,
    purchaseTime: '2025-07-12 13:20:00',
    storageStatus: '外出送货',
    currentRoute: '短途配送无固定线路',
    isEnabled: true
  },
  {
    id: 7,
    type: '面包车',
    currentLoad: 0,
    maxLoad: 4,
    healthStatus: '小破',
    plateNumber: '沪G55555',
    driverName: 'avamartin',
    driverJobNumber: 'EMP007',
    driverAvatar: avatar7,
    purchaseTime: '2025-04-18 15:10:00',
    storageStatus: '在库待命',
    isEnabled: true
  },
  {
    id: 8,
    type: '小型卡车',
    currentLoad: 5,
    maxLoad: 8,
    healthStatus: '正常',
    plateNumber: '沪H66666',
    driverName: 'jacoblee',
    driverJobNumber: 'EMP008',
    driverAvatar: avatar8,
    purchaseTime: '2025-06-30 12:00:00',
    storageStatus: '外出送货',
    currentRoute: '上海市浦东新区总部 → 江苏省苏州市姑苏区分部',
    isEnabled: true
  }
]

// ... existing code ...

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
export const STATIC_ROUTE_LIST_DATA: StaticRoute[] = [
  {
    id: 1,
    departure: '上海市浦东新区总部',
    destination: '北京市朝阳区分部',
    totalDistance: 1213,
    estimatedTime: 14,
    scheduleInfo: '每日发车：08:00, 14:00, 20:00',
    isActive: true,
    createTime: '2025-01-15 10:30:00'
  },
  {
    id: 2,
    departure: '上海市浦东新区总部',
    destination: '广东省广州市天河区分部',
    totalDistance: 1456,
    estimatedTime: 16,
    scheduleInfo: '每日发车：09:00, 15:00',
    isActive: true,
    createTime: '2025-02-20 14:20:00'
  },
  {
    id: 3,
    departure: '上海市浦东新区总部',
    destination: '广东省深圳市南山区分部',
    totalDistance: 1478,
    estimatedTime: 17,
    scheduleInfo: '每日发车：10:00, 16:00, 22:00',
    isActive: true,
    createTime: '2025-03-10 11:15:00'
  },
  {
    id: 4,
    departure: '上海市浦东新区总部',
    destination: '浙江省杭州市西湖区分部',
    totalDistance: 175,
    estimatedTime: 2,
    scheduleInfo: '每小时发车：07:00-19:00',
    isActive: true,
    createTime: '2025-04-08 16:45:00'
  },
  {
    id: 5,
    departure: '上海市浦东新区总部',
    destination: '江苏省南京市鼓楼区分部',
    totalDistance: 295,
    estimatedTime: 4,
    scheduleInfo: '每日发车：08:30, 13:30, 18:30',
    isActive: false,
    createTime: '2025-05-25 10:30:00'
  },
  {
    id: 6,
    departure: '上海市浦东新区总部',
    destination: '江苏省苏州市姑苏区分部',
    totalDistance: 102,
    estimatedTime: 1.5,
    scheduleInfo: '每30分钟发车：06:00-22:00',
    isActive: true,
    createTime: '2025-06-12 13:20:00'
  },
  {
    id: 7,
    departure: '上海市浦东新区总部',
    destination: '湖北省武汉市江汉区分部',
    totalDistance: 695,
    estimatedTime: 8,
    scheduleInfo: '每日发车：07:00, 19:00',
    isActive: true,
    createTime: '2025-07-18 15:10:00'
  },
  {
    id: 8,
    departure: '上海市浦东新区总部',
    destination: '四川省成都市高新区分部',
    totalDistance: 1965,
    estimatedTime: 22,
    scheduleInfo: '每日发车：20:00',
    isActive: true,
    createTime: '2025-08-30 12:00:00'
  }
]
