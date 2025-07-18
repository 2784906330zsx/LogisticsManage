/**
 * namespace: Api
 *
 * 所有接口相关类型定义
 */
declare namespace Api {
  /** 基础类型 */
  namespace Http {
    /** 基础响应 */
    interface BaseResponse<T = any> {
      // 状态码
      code: number
      // 消息
      msg: string
      // 数据
      data: T
    }
  }

  /** 通用类型 */
  namespace Common {
    /** 分页参数 */
    interface PaginatingParams {
      /** 当前页码 */
      current: number
      /** 每页条数 */
      size: number
    }

    /** 启用状态 */
    type EnableStatus = '1' | '2'
  }

  /** 认证类型 */
  namespace Auth {
    /** 登录参数 */
    interface LoginParams {
      jobNumber: string // 改为工号
      password: string
    }

    /** 登录响应 */
    type LoginResponse = Api.Http.BaseResponse<{
      token: string
      refreshToken: string
    }>
  }

  /** 用户类型 */
  namespace User {
    /** 用户查询参数 */
    interface UserQueryParams extends Api.Common.PaginatingParams {
      name?: string
      phone?: string
      email?: string
      gender?: string
      department?: string
      position?: string
      status?: string
    }
    /** 用户信息 */
    interface UserInfo {
      userId: number
      gender: number
      userName: string
      jobNumber: string
      position: string
      department: string
      roleCode: string // 添加roleCode字段
      roles: string[]
      buttons: string[]
      avatar: string
      email: string
      phone: string
    }

    /** 用户列表数据 */
    interface UserListData {
      records: UserInfo[]
      current: number
      size: number
      total: number
    }
  }
}
