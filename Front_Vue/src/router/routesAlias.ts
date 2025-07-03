/**
 * 路由别名，方便快速找到页面，同时可以用作路由跳转
 */
export enum RoutesAlias {
  Home = '/index/index', // 布局容器
  Login = '/auth/login', // 登录
  Register = '/auth/register', // 注册
  ForgetPassword = '/auth/forget-password', // 忘记密码
  Dashboard = '/dashboard', // 总览大屏
  //
  User = '/user/user', // 用户信息
  Role = '/user/role', // 角色管理
  Department = '/user/department', // 部门管理
  UserCenter = '/user/user-center', // 用户中心
  // 订单
  CreateOrder = '/order/create', // 创建订单
  AllOrder = '/order/all', // 所有订单
  ToConfirmOrder = '/order/to-confirm', // 待确认订单
  ToCheckOrder = '/order/to-check', // 待审核退款订单
  //
  DeliveryAnalysis = '/delivery/analysis', // 配送分析
  StaticLine = '/delivery/resource/static-line', // 固定配送线路
  Vehicle = '/delivery/resource/vehicle', // 车辆管理
  //
  ToDeliverOrder = '/delivery/order/to-deliver', // 待配送订单
  DeliveringOrder = '/delivery/order/delivering', // 配送中订单
  DeliveredOrder = '/delivery/order/delivered', // 已送达订单
  CancelledOrder = '/delivery/order/cancelled', // 已取消订单
  //
  Commodity = '/storage/commodity', // 商品管理
  Inventory = '/storage/inventory', // 查看库存
  InboundRecord = '/storage/inbound-record', // 入库记录
  OutboundRecord = '/storage/outbound-record', // 出库记录
  //
  PurchaseOrder = '/supplier/purchase-order', // 采购订单
  Supplier = '/supplier/supplier', // 供应商信息
  //
  FinanceAnalysis = '/finance/analysis', // 收支分析
  IncomeRecord = '/finance/income-record', // 收入记录
  ExpenditureRecord = '/finance/expenditure-record', // 支出记录
  OrderReview = '/finance/order-review' // 财务审核
}
