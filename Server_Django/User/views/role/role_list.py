from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.core.paginator import Paginator
from django.utils import timezone
from Core.models import Role, Department, User
from ..user_info import get_user_from_token
import json


class RoleListView(View):
    """
    获取角色列表视图
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def get(self, request):
        try:
            # 验证用户身份
            current_user = get_user_from_token(request)
            if not current_user:
                return JsonResponse({
                    'code': 401,
                    'msg': '未授权访问，请重新登录',
                    'data': None
                })

            # 获取分页参数
            current_page = int(request.GET.get('current', 1))
            page_size = int(request.GET.get('size', 20))

            # 获取搜索参数
            role_name = request.GET.get('roleName', '')
            role_code = request.GET.get('roleCode', '')
            department_name = request.GET.get('departmentName', '')
            enable = request.GET.get('enable', '')

            # 构建查询条件
            queryset = Role.objects.select_related('department').all()

            if role_name:
                queryset = queryset.filter(role_name__icontains=role_name)
            if role_code:
                queryset = queryset.filter(role_code__icontains=role_code)
            if enable:
                queryset = queryset.filter(is_enabled=bool(int(enable)))

            # 根据部门名称筛选
            if department_name:
                queryset = queryset.filter(department__department_name__icontains=department_name)

            # 排序
            queryset = queryset.order_by('-create_time')

            # 分页
            paginator = Paginator(queryset, page_size)
            page_obj = paginator.get_page(current_page)

            # 构建返回数据
            records = []
            for role in page_obj:
                role_data = {
                    'id': role.id,
                    'roleName': role.role_name,
                    'roleCode': role.role_code,
                    'des': role.description,
                    'departmentCode': role.department.id if role.department else '',
                    'departmentName': role.department.department_name if role.department else '未知部门',
                    'enable': role.is_enabled,
                    'date': role.create_time.strftime('%Y-%m-%d %H:%M:%S')
                }
                records.append(role_data)

            return JsonResponse({
                'code': 200,
                'msg': '获取成功',
                'data': {
                    'records': records,
                    'current': current_page,
                    'size': page_size,
                    'total': paginator.count
                }
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'服务器错误: {str(e)}',
                'data': None
            })


@csrf_exempt
@require_http_methods(["GET"])
def role_list_view(request):
    """
    函数式角色列表视图（备用）
    """
    view = RoleListView()
    return view.get(request)


class RoleManageView(View):
    """
    角色管理视图 - 增删改
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def post(self, request):
        """新增角色"""
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
            data = json.loads(request.body)
            role_name = data.get('roleName', '').strip()
            role_code = data.get('roleCode', '').strip()
            description = data.get('des', '').strip()
            department_id = data.get('departmentCode')
            is_enabled = data.get('enable', True)

            # 数据验证
            if not role_name:
                return JsonResponse({
                    'code': 400,
                    'msg': '角色名称不能为空',
                    'data': None
                })

            if not role_code:
                return JsonResponse({
                    'code': 400,
                    'msg': '角色编码不能为空',
                    'data': None
                })

            if not department_id:
                return JsonResponse({
                    'code': 400,
                    'msg': '请选择所属部门',
                    'data': None
                })

            # 检查角色名称是否已存在
            if Role.objects.filter(role_name=role_name).exists():
                return JsonResponse({
                    'code': 400,
                    'msg': '角色名称已存在',
                    'data': None
                })

            # 检查角色编码是否已存在
            if Role.objects.filter(role_code=role_code).exists():
                return JsonResponse({
                    'code': 400,
                    'msg': '角色编码已存在',
                    'data': None
                })

            # 检查部门是否存在
            try:
                department = Department.objects.get(id=department_id)
            except Department.DoesNotExist:
                return JsonResponse({
                    'code': 400,
                    'msg': '所选部门不存在',
                    'data': None
                })

            # 创建角色
            role = Role.objects.create(
                role_name=role_name,
                role_code=role_code,
                description=description,
                department=department,
                is_enabled=is_enabled,
                create_time=timezone.now()
            )

            return JsonResponse({
                'code': 200,
                'msg': '角色创建成功',
                'data': {
                    'id': role.id,
                    'roleName': role.role_name,
                    'roleCode': role.role_code,
                    'des': role.description,
                    'departmentCode': role.department.id,
                    'departmentName': role.department.department_name,
                    'enable': role.is_enabled,
                    'date': role.create_time.strftime('%Y-%m-%d %H:%M:%S')
                }
            })

        except json.JSONDecodeError:
            return JsonResponse({
                'code': 400,
                'msg': '请求数据格式错误',
                'data': None
            })
        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'服务器错误: {str(e)}',
                'data': None
            })

    def put(self, request):
        """修改角色"""
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
            data = json.loads(request.body)
            role_id = data.get('id')
            role_name = data.get('roleName', '').strip()
            role_code = data.get('roleCode', '').strip()
            description = data.get('des', '').strip()
            department_id = data.get('departmentCode')
            is_enabled = data.get('enable', True)

            # 数据验证
            if not role_id:
                return JsonResponse({
                    'code': 400,
                    'msg': '角色ID不能为空',
                    'data': None
                })

            if not role_name:
                return JsonResponse({
                    'code': 400,
                    'msg': '角色名称不能为空',
                    'data': None
                })

            if not role_code:
                return JsonResponse({
                    'code': 400,
                    'msg': '角色编码不能为空',
                    'data': None
                })

            if not department_id:
                return JsonResponse({
                    'code': 400,
                    'msg': '请选择所属部门',
                    'data': None
                })

            # 检查角色是否存在
            try:
                role = Role.objects.get(id=role_id)
            except Role.DoesNotExist:
                return JsonResponse({
                    'code': 400,
                    'msg': '角色不存在',
                    'data': None
                })

            # 检查角色名称是否已被其他角色使用
            if Role.objects.filter(role_name=role_name).exclude(id=role_id).exists():
                return JsonResponse({
                    'code': 400,
                    'msg': '角色名称已存在',
                    'data': None
                })

            # 检查角色编码是否已被其他角色使用
            if Role.objects.filter(role_code=role_code).exclude(id=role_id).exists():
                return JsonResponse({
                    'code': 400,
                    'msg': '角色编码已存在',
                    'data': None
                })

            # 检查部门是否存在
            try:
                department = Department.objects.get(id=department_id)
            except Department.DoesNotExist:
                return JsonResponse({
                    'code': 400,
                    'msg': '所选部门不存在',
                    'data': None
                })

            # 更新角色信息
            role.role_name = role_name
            role.role_code = role_code
            role.description = description
            role.department = department
            role.is_enabled = is_enabled
            role.save()

            return JsonResponse({
                'code': 200,
                'msg': '角色修改成功',
                'data': {
                    'id': role.id,
                    'roleName': role.role_name,
                    'roleCode': role.role_code,
                    'des': role.description,
                    'departmentCode': role.department.id,
                    'departmentName': role.department.department_name,
                    'enable': role.is_enabled,
                    'date': role.create_time.strftime('%Y-%m-%d %H:%M:%S')
                }
            })

        except json.JSONDecodeError:
            return JsonResponse({
                'code': 400,
                'msg': '请求数据格式错误',
                'data': None
            })
        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'服务器错误: {str(e)}',
                'data': None
            })

    def delete(self, request):
        """删除角色"""
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
            data = json.loads(request.body)
            role_id = data.get('id')

            # 数据验证
            if not role_id:
                return JsonResponse({
                    'code': 400,
                    'msg': '角色ID不能为空',
                    'data': None
                })

            # 检查角色是否存在
            try:
                role = Role.objects.get(id=role_id)
            except Role.DoesNotExist:
                return JsonResponse({
                    'code': 400,
                    'msg': '角色不存在',
                    'data': None
                })

            # 检查是否有用户关联此角色 - 修复这里的字段名
            if User.objects.filter(position=role.id).exists():
                return JsonResponse({
                    'code': 400,
                    'msg': '该角色下还有用户，无法删除',
                    'data': None
                })

            # 删除角色
            role.delete()

            return JsonResponse({
                'code': 200,
                'msg': '角色删除成功',
                'data': None
            })

        except json.JSONDecodeError:
            return JsonResponse({
                'code': 400,
                'msg': '请求数据格式错误',
                'data': None
            })
        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'服务器错误: {str(e)}',
                'data': None
            })
