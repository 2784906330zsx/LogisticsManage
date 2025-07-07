from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.core.paginator import Paginator
from Core.models import User, Role, Department
from .user_info import get_user_from_token
import json


class UserListView(View):
    """
    获取用户列表视图
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
            name = request.GET.get('name', '')
            phone = request.GET.get('phone', '')
            email = request.GET.get('email', '')
            gender = request.GET.get('gender', '')
            department = request.GET.get('department', '')
            position = request.GET.get('position', '')
            status = request.GET.get('status', '')

            # 构建查询条件
            queryset = User.objects.all()

            if name:
                queryset = queryset.filter(username__icontains=name)
            if phone:
                queryset = queryset.filter(mobile__icontains=phone)
            if email:
                queryset = queryset.filter(email__icontains=email)
            if gender:
                queryset = queryset.filter(gender=int(gender))
            if status:
                queryset = queryset.filter(status=int(status))

            # 根据部门和职务筛选
            if department or position:
                role_filters = {}
                if department:
                    role_filters['department__department_name__icontains'] = department
                if position:
                    role_filters['role_name__icontains'] = position

                if role_filters:
                    role_ids = Role.objects.filter(**role_filters).values_list('id', flat=True)
                    queryset = queryset.filter(position__in=role_ids)

            # 排序
            queryset = queryset.order_by('-date_joined')

            # 分页
            paginator = Paginator(queryset, page_size)
            page_obj = paginator.get_page(current_page)

            # 构建返回数据
            records = []
            for user in page_obj:
                # 获取用户的职务和部门信息
                department_name = ''
                position_name = ''
                if user.position:
                    try:
                        role = Role.objects.select_related('department').get(id=user.position)
                        position_name = role.role_name
                        department_name = role.department.department_name
                    except Role.DoesNotExist:
                        pass

                user_data = {
                    'userId': user.id,
                    'gender': user.gender,
                    'userName': user.username,
                    'jobNumber': user.job_number or '',
                    'position': position_name,
                    'department': department_name,
                    'roles': ['user'],
                    'buttons': [],
                    'avatar': user.avatar or '',
                    'email': user.email or '',
                    'phone': user.mobile or '',
                    'registerTime': user.date_joined.strftime('%Y-%m-%d %H:%M:%S') if user.date_joined else '',
                    'dep': department_name,
                    'status': str(user.status or 1)
                }
                records.append(user_data)

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
def user_list_view(request):
    """
    函数式用户列表视图（备用）
    """
    view = UserListView()
    return view.get(request)
