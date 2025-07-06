import jwt
import json
from django.conf import settings
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.utils.decorators import method_decorator
from django.views import View
from Core.models import User, Role, Department


def get_user_from_token(request):
    """
    从请求头中获取token并解析用户信息
    """
    auth_header = request.META.get('HTTP_AUTHORIZATION')
    if not auth_header or not auth_header.startswith('Bearer '):
        return None

    token = auth_header.split(' ')[1]
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=['HS256'])
        user_id = payload.get('user_id')
        user = User.objects.get(id=user_id)
        return user
    except (jwt.ExpiredSignatureError, jwt.InvalidTokenError, User.DoesNotExist):
        return None


class UserInfoView(View):
    """
    获取用户信息视图
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def get(self, request):
        try:
            # 从token获取用户信息
            user = get_user_from_token(request)
            if not user:
                return JsonResponse({
                    'code': 401,
                    'msg': '未授权访问，请重新登录',
                    'data': None
                }, status=401)

            # 获取用户职务和部门信息
            position_name = ''
            department_name = ''
            if user.position:
                try:
                    role = Role.objects.select_related('department').get(id=user.position)
                    position_name = role.role_name
                    department_name = role.department.department_name
                except Role.DoesNotExist:
                    pass

            # 构造用户信息响应
            user_info = {
                'userId': user.id,
                'gender': user.gender or 1,  # 默认为1（男）
                'userName': user.username,
                'jobNumber': user.job_number or '',
                'position': position_name,
                'department': department_name,
                'roles': ['R_USER'],  # 默认角色，可根据实际业务调整
                'buttons': [],  # 按钮权限，可根据实际业务调整
                'avatar': user.avatar or '',
                'email': user.email or '',
                'phone': user.mobile or ''
            }

            # 根据用户状态设置角色
            if user.is_superuser:
                user_info['roles'] = ['R_SUPER']
                user_info['buttons'] = ['add', 'edit', 'delete', 'view']
            elif user.is_staff:
                user_info['roles'] = ['R_ADMIN']
                user_info['buttons'] = ['add', 'edit', 'view']
            else:
                user_info['roles'] = ['R_USER']
                user_info['buttons'] = ['view']

            return JsonResponse({
                'code': 200,
                'msg': '获取用户信息成功',
                'data': user_info
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'服务器内部错误: {str(e)}',
                'data': None
            }, status=500)


@csrf_exempt
@require_http_methods(["GET"])
def user_info_view(request):
    """
    函数式用户信息视图（备用）
    """
    view = UserInfoView()
    return view.get(request)
