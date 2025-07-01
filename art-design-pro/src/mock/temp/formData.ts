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
  create_time: string
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
    status: '1',
    create_time: '2020-09-09 10:01:10',
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
    create_time: '2020-10-10 13:01:12',
    avatar: avatar2
  },
  {
    id: 3,
    username: 'liampark',
    gender: 1,
    mobile: '18670001597',
    email: 'liampark@company.com',
    dep: '人事部',
    status: '1',
    create_time: '2020-11-14 12:01:45',
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
    create_time: '2020-11-14 09:01:20',
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
    create_time: '2020-11-13 11:01:05',
    avatar: avatar5
  },
  {
    id: 6,
    username: 'noahevan',
    gender: 1,
    mobile: '18670001594',
    email: 'noahevan@company.com',
    dep: '运营部',
    status: '1',
    create_time: '2020-10-11 13:10:26',
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
    create_time: '2020-05-14 12:05:10',
    avatar: avatar7
  },
  {
    id: 8,
    username: 'jacoblee',
    gender: 1,
    mobile: '18670001592',
    email: 'jacoblee@company.com',
    dep: '总经办',
    status: '3',
    create_time: '2020-11-12 07:22:25',
    avatar: avatar8
  },
  {
    id: 9,
    username: 'miaclark',
    gender: 0,
    mobile: '18670001581',
    email: 'miaclark@company.com',
    dep: '研发部',
    status: '4',
    create_time: '2020-06-12 05:04:20',
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
    create_time: '2020-11-12 16:01:10',
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
    create_time: '2020-11-14 12:01:20',
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
    create_time: '2020-11-14 12:01:20',
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
    create_time: '2020-11-14 12:01:20',
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
    create_time: '2020-11-14 12:01:20',
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
    create_time: '2020-11-14 12:01:20',
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
