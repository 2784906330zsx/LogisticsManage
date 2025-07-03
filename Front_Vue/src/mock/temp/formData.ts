import avatar1 from '@/assets/img/avatar/avatar1.webp'
import avatar2 from '@/assets/img/avatar/avatar2.webp'
import avatar3 from '@/assets/img/avatar/avatar3.webp'
import avatar4 from '@/assets/img/avatar/avatar4.webp'
import avatar5 from '@/assets/img/avatar/avatar5.webp'
import avatar6 from '@/assets/img/avatar/avatar6.webp'
import avatar7 from '@/assets/img/avatar/avatar7.webp'
import avatar8 from '@/assets/img/avatar/avatar8.webp'
import avatar9 from '@/assets/img/avatar/avatar9.webp'
import avatar10 from '@/assets/img/avatar/avatar10.webp'

export interface User {
  id: number
  username: string
  gender: 1 | 0
  mobile: string
  email: string
  dep: string
  status: string
  jobNumber: string // 工号
  position: string // 职务
  avatar: string
}

// 用户列表
export const ACCOUNT_TABLE_DATA: User[] = [
  {
    id: 1,
    username: 'alexmorgan',
    gender: 1,
    mobile: '18670001591',
    email: 'alexmorgan@company.com',
    dep: '研发部',
    status: '1', // 1: 在职, 2: 休假, 3: 离职
    jobNumber: 'EMP001',
    position: '超级管理员',
    avatar: avatar1
  },
  {
    id: 2,
    username: 'sophiabaker',
    gender: 1,
    mobile: '17766664444',
    email: 'sophiabaker@company.com',
    dep: '电商部',
    status: '1',
    jobNumber: 'EMP002',
    position: '订单管理员',
    avatar: avatar2
  },
  {
    id: 3,
    username: 'liampark',
    gender: 1,
    mobile: '18670001597',
    email: 'liampark@company.com',
    dep: '人事部',
    status: '2',
    jobNumber: 'EMP003',
    position: '用户信息管理员',
    avatar: avatar3
  },
  {
    id: 4,
    username: 'oliviagrant',
    gender: 0,
    mobile: '18670001596',
    email: 'oliviagrant@company.com',
    dep: '产品部',
    status: '1',
    jobNumber: 'EMP004',
    position: '普通用户',
    avatar: avatar4
  },
  {
    id: 5,
    username: 'emmawilson',
    gender: 0,
    mobile: '18670001595',
    email: 'emmawilson@company.com',
    dep: '财务部',
    status: '1',
    jobNumber: 'EMP005',
    position: '财务管理员',
    avatar: avatar5
  },
  {
    id: 6,
    username: 'noahevan',
    gender: 1,
    mobile: '18670001594',
    email: 'noahevan@company.com',
    dep: '运营部',
    status: '3',
    jobNumber: 'EMP006',
    position: '普通用户',
    avatar: avatar6
  },
  {
    id: 7,
    username: 'avamartin',
    gender: 1,
    mobile: '18123820191',
    email: 'avamartin@company.com',
    dep: '客服部',
    status: '2',
    jobNumber: 'EMP007',
    position: '普通用户',
    avatar: avatar7
  },
  {
    id: 8,
    username: 'jacoblee',
    gender: 1,
    mobile: '18670001592',
    email: 'jacoblee@company.com',
    dep: '总经办',
    status: '1',
    jobNumber: 'EMP008',
    position: '超级管理员',
    avatar: avatar8
  },
  {
    id: 9,
    username: 'miaclark',
    gender: 0,
    mobile: '18670001581',
    email: 'miaclark@company.com',
    dep: '研发部',
    status: '1',
    jobNumber: 'EMP009',
    position: '仓储作业管理员',
    avatar: avatar9
  },
  {
    id: 10,
    username: 'ethanharris',
    gender: 1,
    mobile: '13755554444',
    email: 'ethanharris@company.com',
    dep: '研发部',
    status: '1',
    jobNumber: 'EMP010',
    position: '配送运输管理员',
    avatar: avatar10
  },
  {
    id: 11,
    username: 'isabellamoore',
    gender: 1,
    mobile: '13766660000',
    email: 'isabellamoore@company.com',
    dep: '研发部',
    status: '1',
    jobNumber: 'EMP011',
    position: '采购与供应商管理员',
    avatar: avatar6
  },
  {
    id: 12,
    username: 'masonwhite',
    gender: 1,
    mobile: '18670001502',
    email: 'masonwhite@company.com',
    dep: '研发部',
    status: '1',
    jobNumber: 'EMP012',
    position: '普通用户',
    avatar: avatar7
  },
  {
    id: 13,
    username: 'charlottehall',
    gender: 1,
    mobile: '13006644977',
    email: 'charlottehall@company.com',
    dep: '研发部',
    status: '1',
    jobNumber: 'EMP013',
    position: '普通用户',
    avatar: avatar8
  },
  {
    id: 14,
    username: 'benjaminscott',
    gender: 0,
    mobile: '13599998888',
    email: 'benjaminscott@company.com',
    dep: '研发部',
    status: '1',
    jobNumber: 'EMP014',
    position: '普通用户',
    avatar: avatar9
  },
  {
    id: 15,
    username: 'ameliaking',
    gender: 1,
    mobile: '13799998888',
    email: 'ameliaking@company.com',
    dep: '研发部',
    status: '1',
    jobNumber: 'EMP015',
    position: '普通用户',
    avatar: avatar10
  }
]

export interface Role {
  roleName: string
  roleCode: string
  des: string
  date: string
  enable: boolean
}

// 角色列表
export const ROLE_LIST_DATA: Role[] = [
  {
    roleName: '超级管理员',
    roleCode: 'R_SUPER',
    des: '拥有系统最高权限',
    date: '2025-07-01 12:34:56',
    enable: true
  },
  {
    roleName: '用户信息管理员',
    roleCode: 'R_USER_INFO',
    des: '管理用户信息相关权限',
    date: '2025-07-01 12:34:56',
    enable: true
  },

  {
    roleName: '订单管理员',
    roleCode: 'R_ORDER',
    des: '管理订单相关权限',
    date: '2025-07-01 12:34:56',
    enable: true
  },
  {
    roleName: '配送运输管理员',
    roleCode: 'R_DELIVERY',
    des: '管理配送运输相关权限',
    date: '2025-07-01 12:34:56',
    enable: true
  },
  {
    roleName: '仓储作业管理员',
    roleCode: 'R_STORAGE',
    des: '管理仓储作业权限',
    date: '2025-07-01 12:34:56',
    enable: true
  },
  {
    roleName: '采购与供应商管理员',
    roleCode: 'R_PURCHASE',
    des: '管理采购与供应商相关权限',
    date: '2025-07-01 12:34:56',
    enable: true
  },
  {
    roleName: '财务管理员',
    roleCode: 'R_FINANCE',
    des: '管理财务相关权限',
    date: '2025-07-01 12:34:56',
    enable: true
  },
  {
    roleName: '普通用户',
    roleCode: 'R_USER',
    des: '拥有系统普通权限',
    date: '2025-07-01 12:34:56',
    enable: true
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
export const DEPARTMENT_LIST_DATA: Department[] = [
  {
    departmentName: '研发部',
    departmentCode: 'D_DEV',
    des: '负责产品研发和技术创新',
    date: '2025-07-01 12:34:56',
    enable: true
  },
  {
    departmentName: '产品部',
    departmentCode: 'D_PRODUCT',
    des: '负责产品规划和设计',
    date: '2025-07-01 12:34:56',
    enable: true
  },
  {
    departmentName: '运营部',
    departmentCode: 'D_OPERATION',
    des: '负责业务运营和推广',
    date: '2025-07-01 12:34:56',
    enable: true
  },
  {
    departmentName: '财务部',
    departmentCode: 'D_FINANCE',
    des: '负责财务管理和会计核算',
    date: '2025-07-01 12:34:56',
    enable: true
  },
  {
    departmentName: '人事部',
    departmentCode: 'D_HR',
    des: '负责人力资源管理',
    date: '2025-07-01 12:34:56',
    enable: true
  },
  {
    departmentName: '客服部',
    departmentCode: 'D_SERVICE',
    des: '负责客户服务和支持',
    date: '2025-07-01 12:34:56',
    enable: true
  },
  {
    departmentName: '总经办',
    departmentCode: 'D_GENERAL',
    des: '负责公司整体管理和决策',
    date: '2025-07-01 12:34:56',
    enable: true
  },
  {
    departmentName: '电商部',
    departmentCode: 'D_ECOMMERCE',
    des: '负责电商平台运营',
    date: '2025-07-01 12:34:56',
    enable: false
  }
]

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
    name: 'iPhone 15 Pro',
    image:
      'https://ts3.tc.mm.bing.net/th/id/OIP-C.pnIPiPhSJs-mIQlpbmB1iQHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
    brand: 'Apple',
    description: '全新iPhone 15 Pro，搭载A17 Pro芯片，钛金属设计',
    status: '1',
    createTime: '2024-01-15 10:30:00',
    price: 7999,
    stock: 50,
    totalInbound: 200,
    totalOutbound: 150,
    supplier: '苹果官方授权经销商',
    lastUpdateTime: '2024-01-20 14:30:00',
    storageArea: 'A区-L1层-01号'
  },
  {
    id: 2,
    name: 'MacBook Pro 14英寸',
    image:
      'https://tse1-mm.cn.bing.net/th/id/OIP-C.qdxvw-wo5BgJhIjI8D_l4AHaDv?w=318&h=176&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    brand: 'Apple',
    description: 'M3芯片MacBook Pro，专业级性能',
    status: '1',
    createTime: '2024-01-10 14:20:00',
    price: 14999,
    stock: 30,
    totalInbound: 80,
    totalOutbound: 50,
    supplier: '苹果官方授权经销商',
    lastUpdateTime: '2024-01-18 16:45:00',
    storageArea: 'A区-L2层-03号'
  },
  {
    id: 3,
    name: 'AirPods Pro 2',
    image:
      'https://tse2-mm.cn.bing.net/th/id/OIP-C.mFldcGeGvtJIDXRJta_-UQHaGz?w=183&h=180&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    brand: 'Apple',
    description: '主动降噪无线耳机，空间音频体验',
    status: '2',
    createTime: '2024-01-08 09:15:00',
    price: 1899,
    stock: 0,
    totalInbound: 300,
    totalOutbound: 300,
    supplier: '苹果官方授权经销商',
    lastUpdateTime: '2024-01-19 11:20:00',
    storageArea: 'B区-L1层-05号'
  },
  {
    id: 4,
    name: 'Samsung Galaxy S24',
    image:
      'https://tse2-mm.cn.bing.net/th/id/OIP-C.dLQKHaF3aUxCK7LAeWJyJgHaFj?w=234&h=180&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    brand: 'Samsung',
    description: '三星旗舰手机，AI摄影功能',
    status: '3',
    createTime: '2024-02-01 16:45:00',
    price: 5999,
    stock: 100,
    totalInbound: 150,
    totalOutbound: 50,
    supplier: '三星电子有限公司',
    lastUpdateTime: '2024-02-05 09:30:00',
    storageArea: 'B区-L2层-07号'
  },
  {
    id: 5,
    name: 'Dell XPS 13',
    image:
      'https://tse1-mm.cn.bing.net/th/id/OIP-C.BCLBIGqjqsAzjOi7OHt6KQHaFj?w=287&h=180&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    brand: 'Dell',
    description: '轻薄商务笔记本，13英寸4K显示屏',
    status: '1',
    createTime: '2024-01-20 11:30:00',
    price: 8999,
    stock: 25,
    totalInbound: 60,
    totalOutbound: 35,
    supplier: '戴尔科技集团',
    lastUpdateTime: '2024-01-22 13:15:00',
    storageArea: 'C区-L1层-02号'
  },
  {
    id: 6,
    name: 'Sony WH-1000XM5',
    image:
      'https://tse1-mm.cn.bing.net/th/id/OIP-C.Vo4zscjAo2A-40QsVFqujwAAAA?w=260&h=195&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    brand: 'Sony',
    description: '顶级降噪头戴式耳机',
    status: '4',
    createTime: '2024-01-12 13:20:00',
    price: 2399,
    stock: 0,
    totalInbound: 120,
    totalOutbound: 120,
    supplier: '索尼中国有限公司',
    lastUpdateTime: '2024-01-21 10:45:00',
    storageArea: 'C区-L3层-08号'
  },
  {
    id: 7,
    name: 'iPad Air 5',
    image:
      'https://tse2-mm.cn.bing.net/th/id/OIP-C.VUVnS_dCXuDM_soOgq_EawHaFj?w=247&h=186&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    brand: 'Apple',
    description: 'M1芯片iPad Air，10.9英寸液体视网膜显示屏',
    status: '1',
    createTime: '2024-01-18 15:10:00',
    price: 4399,
    stock: 40,
    totalInbound: 100,
    totalOutbound: 60,
    supplier: '苹果官方授权经销商',
    lastUpdateTime: '2024-01-23 08:20:00',
    storageArea: 'A区-L3层-04号'
  },
  {
    id: 8,
    name: 'Xiaomi 14 Pro',
    image:
      'https://tse1-mm.cn.bing.net/th/id/OIP-C.fAuoy-0RFYkQphSIsbjGvQHaFj?w=227&h=180&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    brand: 'Xiaomi',
    description: '小米旗舰手机，徕卡影像系统',
    status: '1',
    createTime: '2024-01-25 12:00:00',
    price: 4999,
    stock: 60,
    totalInbound: 120,
    totalOutbound: 60,
    supplier: '小米科技有限责任公司',
    lastUpdateTime: '2024-01-26 15:30:00',
    storageArea: 'B区-L3层-10号'
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
    commodityName: 'iPhone 15 Pro',
    commodityImage:
      'https://ts3.tc.mm.bing.net/th/id/OIP-C.pnIPiPhSJs-mIQlpbmB1iQHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
    quantity: 50,
    reason: '新品采购',
    inboundTime: '2024-01-15 10:30:00',
    relatedOrder: 'PO202401150001',
    operator: 'alexmorgan'
  },
  {
    inboundRecordId: 2,
    commodityId: 2,
    commodityName: 'MacBook Pro 14英寸',
    commodityImage:
      'https://tse1-mm.cn.bing.net/th/id/OIP-C.qdxvw-wo5BgJhIjI8D_l4AHaDv?w=318&h=176&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    quantity: 30,
    reason: '补充库存',
    inboundTime: '2024-01-16 14:20:00',
    relatedOrder: 'PO202401160002',
    operator: 'miaclark'
  },
  {
    inboundRecordId: 3,
    commodityId: 3,
    commodityName: 'AirPods Pro 2',
    commodityImage:
      'https://tse2-mm.cn.bing.net/th/id/OIP-C.mFldcGeGvtJIDXRJta_-UQHaGz?w=183&h=180&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    quantity: 100,
    reason: '季度采购',
    inboundTime: '2024-01-18 09:15:00',
    relatedOrder: 'PO202401180003',
    operator: 'miaclark'
  },
  {
    inboundRecordId: 4,
    commodityId: 4,
    commodityName: 'Samsung Galaxy S24',
    commodityImage:
      'https://tse2-mm.cn.bing.net/th/id/OIP-C.dLQKHaF3aUxCK7LAeWJyJgHaFj?w=234&h=180&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    quantity: 80,
    reason: '新品上市',
    inboundTime: '2024-02-01 16:45:00',
    relatedOrder: 'PO202402010004',
    operator: 'alexmorgan'
  },
  {
    inboundRecordId: 5,
    commodityId: 5,
    commodityName: 'Dell XPS 13',
    commodityImage:
      'https://tse1-mm.cn.bing.net/th/id/OIP-C.BCLBIGqjqsAzjOi7OHt6KQHaFj?w=287&h=180&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    quantity: 25,
    reason: '客户预订',
    inboundTime: '2024-01-20 11:30:00',
    relatedOrder: 'PO202401200005',
    operator: 'miaclark'
  }
]

// 出库记录模拟数据
export const OUTBOUND_RECORD_DATA: OutboundRecord[] = [
  {
    outboundRecordId: 1,
    commodityId: 1,
    commodityName: 'iPhone 15 Pro',
    commodityImage:
      'https://ts3.tc.mm.bing.net/th/id/OIP-C.pnIPiPhSJs-mIQlpbmB1iQHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
    quantity: 2,
    reason: '老板送人',
    outboundTime: '2024-01-16 14:30:00',
    relatedOrder: 'SO202401160001',
    operator: '蔡鑫培'
  },
  {
    outboundRecordId: 2,
    commodityId: 2,
    commodityName: 'MacBook Pro 14英寸',
    commodityImage:
      'https://tse1-mm.cn.bing.net/th/id/OIP-C.qdxvw-wo5BgJhIjI8D_l4AHaDv?w=318&h=176&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    quantity: 1,
    reason: '客户订单',
    outboundTime: '2024-01-17 10:15:00',
    relatedOrder: 'SO202401170002',
    operator: 'ethanharris'
  },
  {
    outboundRecordId: 3,
    commodityId: 3,
    commodityName: 'AirPods Pro 2',
    commodityImage:
      'https://tse2-mm.cn.bing.net/th/id/OIP-C.mFldcGeGvtJIDXRJta_-UQHaGz?w=183&h=180&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    quantity: 5,
    reason: '批量订单',
    outboundTime: '2024-01-19 15:20:00',
    relatedOrder: 'SO202401190003',
    operator: 'ethanharris'
  },
  {
    outboundRecordId: 4,
    commodityId: 1,
    commodityName: 'iPhone 15 Pro',
    commodityImage:
      'https://ts3.tc.mm.bing.net/th/id/OIP-C.pnIPiPhSJs-mIQlpbmB1iQHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
    quantity: 3,
    reason: '企业采购',
    outboundTime: '2024-01-21 11:45:00',
    relatedOrder: 'SO202401210004',
    operator: 'ethanharris'
  },
  {
    outboundRecordId: 5,
    commodityId: 4,
    commodityName: 'Samsung Galaxy S24',
    commodityImage:
      'https://tse2-mm.cn.bing.net/th/id/OIP-C.dLQKHaF3aUxCK7LAeWJyJgHaFj?w=234&h=180&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    quantity: 1,
    reason: '客户订单',
    outboundTime: '2024-02-02 09:30:00',
    relatedOrder: 'SO202402020005',
    operator: 'ethanharris'
  },
  {
    outboundRecordId: 6,
    commodityId: 6,
    commodityName: 'Sony WH-1000XM5',
    commodityImage:
      'https://tse1-mm.cn.bing.net/th/id/OIP-C.Vo4zscjAo2A-40QsVFqujwAAAA?w=260&h=195&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    quantity: 2,
    reason: '产品损坏',
    outboundTime: '2024-01-22 16:10:00',
    relatedOrder: 'RMA202401220001',
    operator: 'miaclark'
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
    name: '苹果官方授权经销商',
    type: '企业',
    address: '北京市朝阳区建国门外大街1号国贸大厦A座',
    contactPerson: '张经理',
    contactPhone: '010-85123456',
    contactEmail: 'zhang.manager@apple-dealer.com',
    createTime: '2025-01-15 10:30:00',
    status: '1'
  },
  {
    id: 2,
    name: '小米科技有限责任公司',
    type: '企业',
    address: '北京市海淀区清河中街68号华润五彩城购物中心',
    contactPerson: '李总监',
    contactPhone: '010-56781234',
    contactEmail: 'li.director@xiaomi.com',
    createTime: '2025-02-20 14:20:00',
    status: '1'
  },
  {
    id: 3,
    name: '三星电子（中国）有限公司',
    type: '企业',
    address: '上海市浦东新区张江高科技园区李冰路399号',
    contactPerson: '王部长',
    contactPhone: '021-58901234',
    contactEmail: 'wang.minister@samsung.cn',
    createTime: '2025-03-10 09:15:00',
    status: '1'
  },
  {
    id: 4,
    name: '戴尔（中国）有限公司',
    type: '企业',
    address: '上海市浦东新区金桥出口加工区云桥路1388号',
    contactPerson: '刘经理',
    contactPhone: '021-38123456',
    contactEmail: 'liu.manager@dell.com.cn',
    createTime: '2025-04-05 16:45:00',
    status: '1'
  },
  {
    id: 5,
    name: '索尼（中国）有限公司',
    type: '企业',
    address: '北京市朝阳区太阳宫中路16号院1号楼冠捷大厦',
    contactPerson: '田主管',
    contactPhone: '010-65432109',
    contactEmail: 'tian.supervisor@sony.com.cn',
    createTime: '2025-05-12 11:30:00',
    status: '1'
  },
  {
    id: 6,
    name: '华强北电子市场',
    type: '个人或个体工商户',
    address: '深圳市福田区华强北路华强电子世界1楼A区',
    contactPerson: '陈老板',
    contactPhone: '0755-83456789',
    contactEmail: 'chen.boss@hqb-market.com',
    createTime: '2025-06-18 15:10:00',
    status: '2'
  },
  {
    id: 7,
    name: '中关村科技发展有限公司',
    type: '事业单位',
    address: '北京市海淀区中关村大街27号中关村大厦',
    contactPerson: '赵处长',
    contactPhone: '010-62345678',
    contactEmail: 'zhao.director@zgc.gov.cn',
    createTime: '2025-07-25 12:00:00',
    status: '1'
  },
  {
    id: 8,
    name: '广州市政府采购中心',
    type: '政府部门',
    address: '广州市越秀区东风中路305号',
    contactPerson: '孙科长',
    contactPhone: '020-83216789',
    contactEmail: 'sun.section@gz.gov.cn',
    createTime: '2025-08-30 08:20:00',
    status: '3'
  },
  {
    id: 9,
    name: '深圳市电子商会',
    type: '社会团体',
    address: '深圳市南山区科技园南区深圳湾科技生态园',
    contactPerson: '周秘书长',
    contactPhone: '0755-26789012',
    contactEmail: 'zhou.secretary@szec.org.cn',
    createTime: '2025-09-15 14:30:00',
    status: '1'
  },
  {
    id: 10,
    name: '杭州电商产业园',
    type: '集体组织',
    address: '杭州市余杭区文一西路969号',
    contactPerson: '吴主任',
    contactPhone: '0571-88123456',
    contactEmail: 'wu.director@hzec-park.com',
    createTime: '2025-10-20 16:45:00',
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
    commodityName: 'iPhone 15 Pro',
    commodityImage:
      'https://ts3.tc.mm.bing.net/th/id/OIP-C.pnIPiPhSJs-mIQlpbmB1iQHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
    supplierId: 1,
    supplierName: '苹果官方授权经销商',
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
    commodityName: 'MacBook Pro 14英寸',
    commodityImage:
      'https://tse1-mm.cn.bing.net/th/id/OIP-C.qdxvw-wo5BgJhIjI8D_l4AHaDv?w=318&h=176&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    supplierId: 1,
    supplierName: '苹果官方授权经销商',
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
    commodityName: 'AirPods Pro 2',
    commodityImage:
      'https://tse2-mm.cn.bing.net/th/id/OIP-C.mFldcGeGvtJIDXRJta_-UQHaGz?w=183&h=180&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    supplierId: 1,
    supplierName: '苹果官方授权经销商',
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
    commodityName: 'Samsung Galaxy S24',
    commodityImage:
      'https://tse2-mm.cn.bing.net/th/id/OIP-C.dLQKHaF3aUxCK7LAeWJyJgHaFj?w=234&h=180&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    supplierId: 3,
    supplierName: '三星电子（中国）有限公司',
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
    commodityName: 'Dell XPS 13',
    commodityImage:
      'https://tse4-mm.cn.bing.net/th/id/OIP-C.Qr8zKGD5fJ5J5J5J5J5J5QAAAA?w=260&h=195&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    supplierId: 4,
    supplierName: '戴尔（中国）有限公司',
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
  },
  {
    id: 6,
    orderNumber: 'PO202501200006',
    commodityId: 6,
    commodityName: 'Sony WH-1000XM5',
    commodityImage:
      'https://tse1-mm.cn.bing.net/th/id/OIP-C.Vo4zscjAo2A-40QsVFqujwAAAA?w=260&h=195&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    supplierId: 5,
    supplierName: '索尼（中国）有限公司',
    unitPrice: 2399.0,
    quantity: 40,
    totalAmount: 95960.0,
    orderTime: '2025-01-20 11:10:00',
    inboundTime: null,
    status: '1',
    purchaserName: 'Isabella Moore',
    purchaserJobNumber: 'EMP011',
    warehouseKeeperName: null,
    warehouseKeeperJobNumber: null
  },
  {
    id: 7,
    orderNumber: 'PO202501210007',
    commodityId: 2,
    commodityName: 'MacBook Pro 14英寸',
    commodityImage:
      'https://tse1-mm.cn.bing.net/th/id/OIP-C.qdxvw-wo5BgJhIjI8D_l4AHaDv?w=318&h=176&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    supplierId: 1,
    supplierName: '苹果官方授权经销商',
    unitPrice: 15999.0,
    quantity: 10,
    totalAmount: 159990.0,
    orderTime: '2025-01-21 13:25:00',
    inboundTime: null,
    status: '3',
    purchaserName: 'Isabella Moore',
    purchaserJobNumber: 'EMP011',
    warehouseKeeperName: null,
    warehouseKeeperJobNumber: null
  },
  {
    id: 8,
    orderNumber: 'PO202501220008',
    commodityId: 1,
    commodityName: 'iPhone 15 Pro',
    commodityImage:
      'https://ts3.tc.mm.bing.net/th/id/OIP-C.pnIPiPhSJs-mIQlpbmB1iQHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
    supplierId: 1,
    supplierName: '苹果官方授权经销商',
    unitPrice: 8999.0,
    quantity: 25,
    totalAmount: 224975.0,
    orderTime: '2025-01-22 08:40:00',
    inboundTime: '2025-01-23 10:15:00',
    status: '2',
    purchaserName: 'Isabella Moore',
    purchaserJobNumber: 'EMP011',
    warehouseKeeperName: 'Mia Clark',
    warehouseKeeperJobNumber: 'EMP009'
  }
]
