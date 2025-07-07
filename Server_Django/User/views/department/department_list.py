from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.core.paginator import Paginator
from Core.models import Department
from ..user_info import get_user_from_token
import json
from django.utils import timezone


class DepartmentListView(View):
    """
    获取部门列表视图
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
            department_name = request.GET.get('departmentName', '')
            enable = request.GET.get('enable', '')

            # 构建查询条件
            queryset = Department.objects.all()

            if department_name:
                queryset = queryset.filter(department_name__icontains=department_name)
            if enable:
                queryset = queryset.filter(is_enabled=bool(int(enable)))

            # 排序
            queryset = queryset.order_by('-create_time')

            # 分页
            paginator = Paginator(queryset, page_size)
            page_obj = paginator.get_page(current_page)

            # 构建返回数据
            records = []
            for department in page_obj:
                department_data = {
                    'id': department.id,
                    'departmentName': department.department_name,
                    'departmentCode': str(department.id),  # 使用ID作为编码
                    'des': department.description,
                    'enable': department.is_enabled,
                    'date': department.create_time.strftime('%Y-%m-%d %H:%M:%S')
                }
                records.append(department_data)

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


class DepartmentManageView(View):
    """
    部门管理视图：新增、修改、删除
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def post(self, request):
        """新增部门"""
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
            department_name = data.get('departmentName', '').strip()
            description = data.get('des', '').strip()
            is_enabled = data.get('enable', True)

            # 验证必填字段
            if not department_name:
                return JsonResponse({
                    'code': 400,
                    'msg': '部门名称不能为空',
                    'data': None
                })

            # 检查部门名称是否已存在
            if Department.objects.filter(department_name=department_name).exists():
                return JsonResponse({
                    'code': 400,
                    'msg': '部门名称已存在',
                    'data': None
                })

            # 创建部门
            department = Department.objects.create(
                department_name=department_name,
                description=description,
                is_enabled=is_enabled,
                create_time=timezone.now()
            )

            return JsonResponse({
                'code': 200,
                'msg': '新增部门成功',
                'data': {
                    'id': department.id,
                    'departmentName': department.department_name,
                    'departmentCode': str(department.id),
                    'des': department.description,
                    'enable': department.is_enabled,
                    'date': department.create_time.strftime('%Y-%m-%d %H:%M:%S')
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
        """修改部门"""
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
            department_id = data.get('id')
            department_name = data.get('departmentName', '').strip()
            description = data.get('des', '').strip()
            is_enabled = data.get('enable', True)

            # 验证必填字段
            if not department_id:
                return JsonResponse({
                    'code': 400,
                    'msg': '部门ID不能为空',
                    'data': None
                })

            if not department_name:
                return JsonResponse({
                    'code': 400,
                    'msg': '部门名称不能为空',
                    'data': None
                })

            # 查找部门
            try:
                department = Department.objects.get(id=department_id)
            except Department.DoesNotExist:
                return JsonResponse({
                    'code': 404,
                    'msg': '部门不存在',
                    'data': None
                })

            # 检查部门名称是否已存在（排除当前部门）
            if Department.objects.filter(department_name=department_name).exclude(id=department_id).exists():
                return JsonResponse({
                    'code': 400,
                    'msg': '部门名称已存在',
                    'data': None
                })

            # 更新部门信息
            department.department_name = department_name
            department.description = description
            department.is_enabled = is_enabled
            department.save()

            return JsonResponse({
                'code': 200,
                'msg': '修改部门成功',
                'data': {
                    'id': department.id,
                    'departmentName': department.department_name,
                    'departmentCode': str(department.id),
                    'des': department.description,
                    'enable': department.is_enabled,
                    'date': department.create_time.strftime('%Y-%m-%d %H:%M:%S')
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
        """删除部门"""
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
            department_id = data.get('id')

            # 验证必填字段
            if not department_id:
                return JsonResponse({
                    'code': 400,
                    'msg': '部门ID不能为空',
                    'data': None
                })

            # 查找部门
            try:
                department = Department.objects.get(id=department_id)
            except Department.DoesNotExist:
                return JsonResponse({
                    'code': 404,
                    'msg': '部门不存在',
                    'data': None
                })

            # 检查是否有关联的角色
            if hasattr(department, 'role_set') and department.role_set.exists():
                return JsonResponse({
                    'code': 400,
                    'msg': '该部门下还有角色，无法删除',
                    'data': None
                })

            # 删除部门
            department.delete()

            return JsonResponse({
                'code': 200,
                'msg': '删除部门成功',
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


@csrf_exempt
@require_http_methods(["GET"])
def department_list_view(request):
    """
    函数式部门列表视图（备用）
    """
    view = DepartmentListView()
    return view.get(request)


@csrf_exempt
@require_http_methods(["POST", "PUT", "DELETE"])
def department_manage_view(request):
    """
    函数式部门管理视图（备用）
    """
    view = DepartmentManageView()
    if request.method == 'POST':
        return view.post(request)
    elif request.method == 'PUT':
        return view.put(request)
    elif request.method == 'DELETE':
        return view.delete(request)
