import json
from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from Core.models import User, Role
from .user_info import get_user_from_token


class UserDeleteView(View):
    """
    用户删除视图
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def delete(self, request):
        try:
            # 验证用户身份
            current_user = get_user_from_token(request)
            if not current_user:
                return JsonResponse({
                    'code': 401,
                    'msg': '未授权访问，请重新登录',
                    'data': None
                })

            # 权限检查：通过position查找role_code判断是否为管理员
            if not current_user.position:
                return JsonResponse({
                    'code': 403,
                    'msg': '用户未分配职务，无权限删除用户',
                    'data': None
                })

            try:
                current_role = Role.objects.get(id=current_user.position)
                # 只有R开头的角色（管理员）才能删除用户，R_SUPER为超级管理员
                if not current_role.role_code.startswith('R_'):
                    return JsonResponse({
                        'code': 403,
                        'msg': '只有管理员才能删除用户',
                        'data': None
                    })
            except Role.DoesNotExist:
                return JsonResponse({
                    'code': 403,
                    'msg': '用户职务信息异常，无权限删除用户',
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

            # 获取要删除的用户ID
            user_id = data.get('userId')
            if not user_id:
                return JsonResponse({
                    'code': 400,
                    'msg': '用户ID不能为空',
                    'data': None
                })

            # 查找要删除的用户
            try:
                user_to_delete = User.objects.get(id=user_id)
            except User.DoesNotExist:
                return JsonResponse({
                    'code': 404,
                    'msg': '用户不存在',
                    'data': None
                })

            # 检查要删除的用户是否为超级管理员
            if user_to_delete.position:
                try:
                    target_role = Role.objects.get(id=user_to_delete.position)
                    if target_role.role_code == 'R_SUPER':
                        return JsonResponse({
                            'code': 403,
                            'msg': '不能删除总经理账户',
                            'data': None
                        })
                except Role.DoesNotExist:
                    pass

            # 防止删除自己
            if current_user.id == user_to_delete.id:
                return JsonResponse({
                    'code': 403,
                    'msg': '不能删除自己的账户',
                    'data': None
                })

            # 执行硬删除
            deleted_user_info = {
                'userId': user_to_delete.id,
                'userName': user_to_delete.username,
                'jobNumber': user_to_delete.job_number
            }
            
            user_to_delete.delete()

            return JsonResponse({
                'code': 200,
                'msg': '用户删除成功',
                'data': deleted_user_info
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'服务器错误: {str(e)}',
                'data': None
            })


@csrf_exempt
@require_http_methods(["DELETE"])
def user_delete_view(request):
    """
    函数式用户删除视图（备用）
    """
    view = UserDeleteView()
    return view.delete(request)