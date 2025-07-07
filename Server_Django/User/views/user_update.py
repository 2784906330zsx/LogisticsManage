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
                user = User.objects.get(id=user_id)
            except User.DoesNotExist:
                return JsonResponse({
                    'code': 404,
                    'msg': '用户不存在',
                    'data': None
                })

            # 权限检查：只有管理员或用户本人可以更新信息
            if not (current_user.is_staff or current_user.id == user.id):
                return JsonResponse({
                    'code': 403,
                    'msg': '没有权限更新此用户信息',
                    'data': None
                })

            # 更新用户基本信息
            if 'username' in data:
                user.username = data['username']
            if 'jobNumber' in data:
                user.job_number = data['jobNumber']
            if 'phone' in data:
                user.mobile = data['phone']
            if 'email' in data:
                user.email = data['email']
            if 'gender' in data:
                # 处理性别：'男' -> 1, '女' -> 0
                if data['gender'] == '男':
                    user.gender = 1
                elif data['gender'] == '女':
                    user.gender = 0
                else:
                    user.gender = int(data['gender']) if str(data['gender']).isdigit() else 1
            if 'status' in data:
                user.status = int(data['status'])

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
                            user.position = role.id
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
            user.save()

            # 返回更新后的用户信息
            department_name = ''
            position_name = ''
            if user.position:
                try:
                    role = Role.objects.select_related('department').get(id=user.position)
                    position_name = role.role_name
                    department_name = role.department.department_name
                except Role.DoesNotExist:
                    pass

            updated_user_data = {
                'userId': user.id,
                'gender': user.gender or 1,
                'userName': user.username,
                'jobNumber': user.job_number or '',
                'position': position_name,
                'department': department_name,
                'avatar': user.avatar or '',
                'email': user.email or '',
                'phone': user.mobile or '',
                'status': str(user.status or 1)
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