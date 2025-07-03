import { RoutesAlias } from '../routesAlias'
import { AppRouteRecord } from '@/types/router'

/**
 * 菜单列表、异步路由
 *
 * 支持两种模式:
 * 前端静态配置 - 直接使用本文件中定义的路由配置
 * 后端动态配置 - 后端返回菜单数据，前端解析生成路由
 *
 * 菜单标题（title）:
 * 可以是 i18n 的 key，也可以是字符串，比如：'用户列表'
 *
 * RoutesAlias.Home 指向的是布局组件，后端返回的菜单数据中，component 字段需要指向 /index/index
 * 路由元数据（meta）：异步路由在 asyncRoutes 中配置，静态路由在 staticRoutes 中配置
 */
export const asyncRoutes: AppRouteRecord[] = [
  // {
  //   name: 'Dashboard',
  //   path: '/dashboard',
  //   component: RoutesAlias.Home,
  //   meta: {
  //     title: 'menus.dashboard.title',
  //     icon: '&#xe721;',
  //     roles: ['R_SUPER']
  //   }
  // },
  {
    path: '/user',
    name: 'User',
    component: RoutesAlias.Home,
    meta: {
      title: 'menus.user.title',
      icon: '&#xe7b9;',
      roles: ['R_SUPER', 'R_ADMIN']
    },
    children: [
      {
        path: 'person',
        name: 'Person',
        component: RoutesAlias.User,
        meta: {
          title: 'menus.user.person',
          keepAlive: true,
          roles: ['R_SUPER', 'R_ADMIN']
        }
      },
      {
        path: 'role',
        name: 'Role',
        component: RoutesAlias.Role,
        meta: {
          title: 'menus.user.role',
          keepAlive: true,
          roles: ['R_SUPER']
        }
      },
      {
        path: 'department',
        name: 'Department',
        component: RoutesAlias.Department,
        meta: {
          title: 'menus.user.department',
          keepAlive: true,
          roles: ['R_SUPER', 'R_ADMIN']
        }
      },
      {
        path: 'user-center',
        name: 'UserCenter',
        component: RoutesAlias.UserCenter,
        meta: {
          title: 'menus.user.userCenter',
          isHide: true,
          keepAlive: true,
          isHideTab: true
        }
      }
    ]
  },
  {
    path: '/order',
    name: 'Order',
    component: RoutesAlias.Home,
    meta: {
      title: 'menus.order.title',
      icon: '&#xe6dd;',
      roles: ['R_SUPER', 'R_ADMIN']
    },
    children: [
      {
        path: 'all',
        name: 'AllOrder',
        component: RoutesAlias.AllOrder,
        meta: {
          title: 'menus.order.all',
          keepAlive: true
        }
      },
      {
        path: 'create',
        name: 'CreateOrder',
        component: RoutesAlias.CreateOrder,
        meta: {
          title: 'menus.order.create',
          keepAlive: true
        }
      },
      {
        path: 'to-confirm',
        name: 'ToConfirmOrder',
        component: RoutesAlias.ToConfirmOrder,
        meta: {
          title: 'menus.order.toConfirm',
          keepAlive: true
        }
      },
      {
        path: 'to-check',
        name: 'ToCheckOrder',
        component: RoutesAlias.ToCheckOrder,
        meta: {
          title: 'menus.order.toCheck',
          keepAlive: true
        }
      }
    ]
  },
  {
    path: '/delivery',
    name: 'Delivery',
    component: RoutesAlias.Home,
    meta: {
      title: 'menus.delivery.title',
      icon: '&#xe6e8;',
      roles: ['R_SUPER', 'R_ADMIN']
    },
    children: [
      {
        path: 'delivery-analysis',
        name: 'DeliveryAnalysis',
        component: RoutesAlias.DeliveryAnalysis,
        meta: {
          title: 'menus.delivery.analysis',
          keepAlive: false
        }
      },
      {
        path: 'resource',
        name: 'DeliveryResource',
        meta: {
          title: 'menus.delivery.resource.title'
        },
        children: [
          {
            path: 'static-line',
            name: 'StaticLine',
            component: RoutesAlias.StaticLine,
            meta: {
              title: 'menus.delivery.resource.staticLine',
              keepAlive: true
            }
          },
          {
            path: 'vehicle',
            name: 'Vehicle',
            component: RoutesAlias.Vehicle,
            meta: {
              title: 'menus.delivery.resource.vehicle',
              keepAlive: true
            }
          }
        ]
      },
      {
        path: 'order',
        name: 'DeliveryOrder',
        meta: {
          title: 'menus.delivery.order.title'
        },
        children: [
          {
            path: 'to-deliver',
            name: 'ToDeliverOrder',
            component: RoutesAlias.ToDeliverOrder,
            meta: {
              title: 'menus.delivery.order.toDeliver',
              keepAlive: true
            }
          },
          {
            path: 'delivering',
            name: 'DeliveringOrder',
            component: RoutesAlias.DeliveringOrder,
            meta: {
              title: 'menus.delivery.order.delivering',
              keepAlive: true
            }
          },
          {
            path: 'delivered',
            name: 'DeliveredOrder',
            component: RoutesAlias.DeliveredOrder,
            meta: {
              title: 'menus.delivery.order.delivered',
              keepAlive: true
            }
          },
          {
            path: 'cancelled',
            name: 'CancelledOrder',
            component: RoutesAlias.CancelledOrder,
            meta: {
              title: 'menus.delivery.order.cancelled',
              keepAlive: true
            }
          }
        ]
      }
    ]
  },
  {
    path: '/storage',
    name: 'Storage',
    component: RoutesAlias.Home,
    meta: {
      title: 'menus.storage.title',
      icon: '&#xe6f7;',
      roles: ['R_SUPER', 'R_ADMIN']
    },
    children: [
      {
        path: 'commodity',
        name: 'Commodity',
        component: RoutesAlias.Commodity,
        meta: {
          title: 'menus.storage.commodity',
          keepAlive: true
        }
      },
      {
        path: 'inventory',
        name: 'Inventory',
        component: RoutesAlias.Inventory,
        meta: {
          title: 'menus.storage.inventory',
          keepAlive: true
        }
      },
      {
        path: 'inbound-record',
        name: 'InboundRecord',
        component: RoutesAlias.InboundRecord,
        meta: {
          title: 'menus.storage.inboundRecord',
          keepAlive: true
        }
      },
      {
        path: 'outbound-record',
        name: 'OutboundRecord',
        component: RoutesAlias.OutboundRecord,
        meta: {
          title: 'menus.storage.outboundRecord',
          keepAlive: true
        }
      }
    ]
  },
  {
    path: '/supplier',
    name: 'Supplier',
    component: RoutesAlias.Home,
    meta: {
      title: 'menus.supplier.title',
      icon: '&#xe70a;',
      roles: ['R_SUPER', 'R_ADMIN']
    },
    children: [
      {
        path: 'purchase-order',
        name: 'PurchaseOrder',
        component: RoutesAlias.PurchaseOrder,
        meta: {
          title: 'menus.supplier.purchaseOrder',
          keepAlive: true
        }
      },
      {
        path: 'supplier',
        name: 'SupplierInfo',
        component: RoutesAlias.Supplier,
        meta: {
          title: 'menus.supplier.supplier',
          keepAlive: true
        }
      }
    ]
  },
  {
    path: '/finance',
    name: 'Finance',
    component: RoutesAlias.Home,
    meta: {
      title: 'menus.finance.title',
      icon: '&#xe718;',
      roles: ['R_SUPER', 'R_ADMIN']
    },
    children: [
      {
        path: 'analysis',
        name: 'FinanceAnalysis',
        component: RoutesAlias.FinanceAnalysis,
        meta: {
          title: 'menus.finance.analysis',
          keepAlive: true
        }
      },
      {
        path: 'order-review',
        name: 'OrderReview',
        component: RoutesAlias.OrderReview,
        meta: {
          title: 'menus.finance.orderReview',
          keepAlive: true
        }
      },
      {
        path: 'income-record',
        name: 'IncomeRecord',
        component: RoutesAlias.IncomeRecord,
        meta: {
          title: 'menus.finance.incomeRecord',
          keepAlive: true
        }
      },
      {
        path: 'expenditure-record',
        name: 'ExpenditureRecord',
        component: RoutesAlias.ExpenditureRecord,
        meta: {
          title: 'menus.finance.expenditureRecord',
          keepAlive: true
        }
      }
    ]
  }
]
