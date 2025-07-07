import request from '@/utils/http'

export class UserService {
  // 登录
  static login(params: Api.Auth.LoginParams) {
    return request.post<Api.Auth.LoginResponse>({
      url: '/api/auth/login',
      params
      // showErrorMessage: false // 不显示错误消息
    })
  }

  //修改用户密码
  static updateUserPassword(params: { oldPassword: string; newPassword: string }) {
    return request.post<Api.Http.BaseResponse>({
      url: '/api/auth/updatePassword',
      params
    })
  }

  // 获取用户信息
  static getUserInfo() {
    return request.get<Api.Http.BaseResponse<Api.User.UserInfo>>({
      url: '/api/user/info'
    })
  }

  // 获取用户列表 - 修正返回类型
  static getUserList(params: Api.Common.PaginatingParams) {
    return request.get<Api.Http.BaseResponse<Api.User.UserListData>>({
      url: '/api/user/list',
      params
    })
  }

  // 获取角色列表
  static getRoleList(params: Api.Common.PaginatingParams) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/role/list',
      params
    })
  }

  //修改用户信息
  static updateUserInfo(params: any) {
    return request.post<Api.Http.BaseResponse>({
      url: '/api/user/update',
      params
    })
  }

  //新增用户
  static createUser(params: any) {
    return request.post<Api.Http.BaseResponse>({
      url: '/api/user/create',
      params
    })
  }

  //删除用户
  static deleteUser(userId: number) {
    return request.del<Api.Http.BaseResponse>({
      url: `/api/user/delete?userId=${userId}`
    })
  }

  // 获取部门列表
  static getDepartmentList(params: Api.Common.PaginatingParams) {
    return request.get<Api.Http.BaseResponse<any>>({
      url: '/api/department/list',
      params
    })
  }

  // 新增部门
  static addDepartment(data: {
    departmentName: string
    des: string
    enable: boolean
  }): Promise<Api.Http.BaseResponse<any>> {
    return request.post<Api.Http.BaseResponse<any>>({
      url: '/api/department/manage',
      data
    })
  }

  // 修改部门
  static updateDepartment(data: {
    id: number
    departmentName: string
    des: string
    enable: boolean
  }): Promise<Api.Http.BaseResponse<any>> {
    return request.put<Api.Http.BaseResponse<any>>({
      url: '/api/department/manage',
      data
    })
  }

  // 删除部门
  static deleteDepartment(data: { id: number }): Promise<Api.Http.BaseResponse<any>> {
    return request.del<Api.Http.BaseResponse<any>>({
      url: '/api/department/manage',
      data
    })
  }

  // 新增角色
  static addRole(data: {
    roleName: string
    roleCode: string
    des: string
    departmentCode: number
    enable: boolean
  }): Promise<Api.Http.BaseResponse<any>> {
    return request.post<Api.Http.BaseResponse<any>>({
      url: '/api/role/manage',
      data
    })
  }

  // 修改角色
  static updateRole(data: {
    id: number
    roleName: string
    roleCode: string
    des: string
    departmentCode: number
    enable: boolean
  }): Promise<Api.Http.BaseResponse<any>> {
    return request.put<Api.Http.BaseResponse<any>>({
      url: '/api/role/manage',
      data
    })
  }

  // 删除角色
  static deleteRole(data: { id: number }): Promise<Api.Http.BaseResponse<any>> {
    return request.del<Api.Http.BaseResponse<any>>({
      url: '/api/role/manage',
      data
    })
  }
}
