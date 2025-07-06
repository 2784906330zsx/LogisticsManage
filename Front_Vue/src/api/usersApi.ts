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

  //修改用户信息
  static updateUserInfo(params: Api.User.UserInfo) {
    return request.post<Api.Http.BaseResponse>({
      url: '/api/user/update',
      params
    })
  }

  //获取角色列表
  static getRoleList() {
    return request.get<Api.Http.BaseResponse<Api.User.Role[]>>({
      url: '/api/user/role/list'
    })
  }
}
