import json
from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.contrib.auth.hashers import make_password
from Core.models import User, Role, Department
from .user_info import get_user_from_token


class UserCreateView(View):
    """
    用户新增视图
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

            # 权限检查：只有管理员可以新增用户
            if not current_user.is_staff:
                # 检查用户角色是否为管理员
                if current_user.position:
                    try:
                        role = Role.objects.get(id=current_user.position)
                        if not role.role_code.startswith('R'):
                            return JsonResponse({
                                'code': 403,
                                'msg': '没有权限新增用户，只有管理员可以执行此操作',
                                'data': None
                            })
                    except Role.DoesNotExist:
                        return JsonResponse({
                            'code': 403,
                            'msg': '没有权限新增用户',
                            'data': None
                        })
                else:
                    return JsonResponse({
                        'code': 403,
                        'msg': '没有权限新增用户',
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

            # 验证必填字段
            required_fields = ['username', 'jobNumber', 'phone', 'email', 'password']
            for field in required_fields:
                if not data.get(field):
                    return JsonResponse({
                        'code': 400,
                        'msg': f'{field} 不能为空',
                        'data': None
                    })

            # 检查用户名是否已存在
            if User.objects.filter(username=data['username']).exists():
                return JsonResponse({
                    'code': 400,
                    'msg': '用户名已存在',
                    'data': None
                })

            # 检查工号是否已存在
            if User.objects.filter(job_number=data['jobNumber']).exists():
                return JsonResponse({
                    'code': 400,
                    'msg': '工号已存在',
                    'data': None
                })

            # 检查邮箱是否已存在
            if User.objects.filter(email=data['email']).exists():
                return JsonResponse({
                    'code': 400,
                    'msg': '邮箱已存在',
                    'data': None
                })

            # 处理部门和职务
            role_id = None
            if data.get('department') and data.get('position'):
                department_name = data['department']
                position_name = data['position']
                
                try:
                    # 查找对应的角色
                    role = Role.objects.select_related('department').filter(
                        department__department_name=department_name,
                        role_name=position_name
                    ).first()
                    
                    if role:
                        role_id = role.id
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

            # 创建新用户
            user = User(
                username=data['username'],
                job_number=data['jobNumber'],
                mobile=data['phone'],
                email=data['email'],
                password=make_password(data['password']),  # 加密密码
                gender=1 if data.get('gender') == '男' else 0,
                position=role_id,
                status=int(data.get('status', 1)),
                avatar=data.get('avatar', ''),
                is_active=True
            )
            
            user.save()

            # 返回新创建的用户信息
            department_name = ''
            position_name = ''
            if user.position:
                try:
                    role = Role.objects.select_related('department').get(id=user.position)
                    position_name = role.role_name
                    department_name = role.department.department_name
                except Role.DoesNotExist:
                    pass

            new_user_data = {
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
                'msg': '用户创建成功',
                'data': new_user_data
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'服务器错误: {str(e)}',
                'data': None
            })


@csrf_exempt
@require_http_methods(["POST"])
def user_create_view(request):
    """
    函数式用户创建视图（备用）
    """
    view = UserCreateView()
    return view.post(request)