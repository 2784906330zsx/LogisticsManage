import json
from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from Core.models import User, Role, Department
from .user_info import get_user_from_token


class UserUpdateView(View):
    """
    用户信息更新视图
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def get_user_role_code(self, user):
        """获取用户的角色代码"""
        if user.position:
            try:
                role = Role.objects.get(id=user.position)
                return role.role_code
            except Role.DoesNotExist:
                return None
        return None

    def check_update_permission(self, current_user, target_user):
        """检查更新权限"""
        current_role_code = self.get_user_role_code(current_user)
        target_role_code = self.get_user_role_code(target_user)

        # 如果无法获取角色信息，拒绝访问
        if not current_role_code:
            return False, "当前用户角色信息不完整"

        # 普通员工（E开头）不能修改任何信息，包括自己的
        if current_role_code.startswith('E_'):
            return False, "普通员工无权修改用户信息"

        # 超级管理员可以修改所有人的信息
        if current_role_code == 'R_SUPER':
            return True, ""

        # 管理员（R开头，除了R_SUPER）可以修改普通员工和管理员的信息
        if current_role_code.startswith('R_'):
            # 不能修改超级管理员的信息
            if target_role_code == 'R_SUPER':
                return False, "无权修改超级管理员信息"
            return True, ""

        return False, "权限不足"

    def check_super_admin_protection(self, target_user, data):
        """检查超级管理员保护机制"""
        target_role_code = self.get_user_role_code(target_user)

        # 如果目标用户是超级管理员，且要修改部门或职务
        if target_role_code == 'R_SUPER' and ('department' in data or 'position' in data):
            # 统计系统中超级管理员的数量
            super_admin_role = Role.objects.filter(role_code='R_SUPER').first()
            if super_admin_role:
                super_admin_count = User.objects.filter(position=super_admin_role.id).count()
                if super_admin_count <= 1:
                    # 只阻止部门和职务的修改，允许其他信息修改
                    # 从data中移除department和position字段
                    if 'department' in data:
                        del data['department']
                    if 'position' in data:
                        del data['position']
                    # 返回警告信息但允许继续执行
                    return True, "系统中只有一个超级管理员，已跳过部门和职务的变更"

        return True, ""

    def post(self, request):
        try:
            # 验证用户身份
            current_user = get_user_from_token(request)
            if not current_user:
                return JsonResponse({
                    'code': 401,
                    'msg': '未授权访问，请重新登录',
                    'data': None
                })

            # 解析请求数据
            try:
                data = json.loads(request.body)
            except json.JSONDecodeError:
                return JsonResponse({
                    'code': 400,
                    'msg': '请求数据格式错误',
                    'data': None
                })

            # 获取要更新的用户ID
            user_id = data.get('userId')
            if not user_id:
                return JsonResponse({
                    'code': 400,
                    'msg': '用户ID不能为空',
                    'data': None
                })

            # 查找要更新的用户
            try:
                target_user = User.objects.get(id=user_id)
            except User.DoesNotExist:
                return JsonResponse({
                    'code': 404,
                    'msg': '用户不存在',
                    'data': None
                })

            # 权限检查：基于角色的权限控制
            has_permission, permission_msg = self.check_update_permission(current_user, target_user)
            if not has_permission:
                return JsonResponse({
                    'code': 403,
                    'msg': permission_msg,
                    'data': None
                })

            # 超级管理员保护检查
            can_modify, protection_msg = self.check_super_admin_protection(target_user, data)
            if not can_modify:
                return JsonResponse({
                    'code': 403,
                    'msg': protection_msg,
                    'data': None
                })

            if 'username' in data:
                target_user.username = data['username']
            if 'phone' in data:
                target_user.mobile = data['phone']
            if 'email' in data:
                target_user.email = data['email']
            if 'avatar' in data:
                target_user.avatar = data['avatar']
            if 'gender' in data:
                # 处理性别：'男' -> 1, '女' -> 0
                if data['gender'] == '男':
                    target_user.gender = 1
                elif data['gender'] == '女':
                    target_user.gender = 0
                else:
                    target_user.gender = int(data['gender']) if str(data['gender']).isdigit() else 1
            if 'status' in data:
                target_user.status = int(data['status'])

            # 处理部门和职务更新
            if 'department' in data and 'position' in data:
                department_name = data['department']
                position_name = data['position']

                if department_name and position_name:
                    try:
                        # 查找对应的角色
                        role = Role.objects.select_related('department').filter(
                            department__department_name=department_name,
                            role_name=position_name
                        ).first()

                        if role:
                            target_user.position = role.id
                        else:
                            return JsonResponse({
                                'code': 400,
                                'msg': f'未找到部门 "{department_name}" 下的职务 "{position_name}"',
                                'data': None
                            })
                    except Exception as e:
                        return JsonResponse({
                            'code': 400,
                            'msg': f'部门或职务信息错误: {str(e)}',
                            'data': None
                        })

            # 保存更新
            target_user.save()

            # 返回更新后的用户信息
            department_name = ''
            position_name = ''
            if target_user.position:
                try:
                    role = Role.objects.select_related('department').get(id=target_user.position)
                    position_name = role.role_name
                    department_name = role.department.department_name
                except Role.DoesNotExist:
                    pass

            updated_user_data = {
                'userId': target_user.id,
                'gender': target_user.gender or 1,
                'userName': target_user.username,
                'jobNumber': target_user.job_number or '',
                'position': position_name,
                'department': department_name,
                'avatar': target_user.avatar or '',
                'email': target_user.email or '',
                'phone': target_user.mobile or '',
                'status': str(target_user.status or 1)
            }

            return JsonResponse({
                'code': 200,
                'msg': '用户信息更新成功',
                'data': updated_user_data
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'服务器错误: {str(e)}',
                'data': None
            })


@csrf_exempt
@require_http_methods(["POST"])
def user_update_view(request):
    """
    函数式用户更新视图（备用）
    """
    view = UserUpdateView()
    return view.post(request)
