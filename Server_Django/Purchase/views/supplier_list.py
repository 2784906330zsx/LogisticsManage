from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.core.paginator import Paginator
from Core.models import Supplier
from User.views.user_info import get_user_from_token
import json


class SupplierListView(View):
    """
    获取供应商列表视图
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def get(self, request):
        try:
            # 验证用户身份
            user = get_user_from_token(request)
            if not user:
                return JsonResponse({
                    'code': 401,
                    'message': '未授权访问',
                    'data': None
                }, status=401)

            # 获取查询参数
            page = int(request.GET.get('page', 1))
            page_size = int(request.GET.get('pageSize', 10))
            name = request.GET.get('name', '').strip()
            supplier_type = request.GET.get('type', '').strip()
            contact_person = request.GET.get('contactPerson', '').strip()
            status = request.GET.get('status', '').strip()

            # 构建查询条件
            queryset = Supplier.objects.all()

            if name:
                queryset = queryset.filter(name__icontains=name)
            if supplier_type:
                queryset = queryset.filter(supplier_type=supplier_type)
            if contact_person:
                queryset = queryset.filter(contact_person__icontains=contact_person)
            if status:
                queryset = queryset.filter(status=status)

            # 按创建时间倒序排列
            queryset = queryset.order_by('-create_time')

            # 分页处理
            paginator = Paginator(queryset, page_size)
            page_obj = paginator.get_page(page)

            # 构建返回数据
            supplier_list = []
            for supplier in page_obj:
                # 状态映射
                status_map = {
                    '1': '正常',
                    '2': '暂停合作',
                    '3': '黑名单'
                }

                supplier_data = {
                    'id': supplier.id,
                    'name': supplier.name,
                    'type': supplier.supplier_type,
                    'address': supplier.address,
                    'contactPerson': supplier.contact_person,
                    'contactPhone': supplier.contact_phone,
                    'contactEmail': supplier.contact_email,
                    'status': status_map.get(supplier.status, supplier.status),  # 转换状态显示
                    'createTime': supplier.create_time.strftime('%Y-%m-%d %H:%M:%S')
                }
                supplier_list.append(supplier_data)

            return JsonResponse({
                'code': 200,
                'message': '获取供应商列表成功',
                'data': {
                    'list': supplier_list,
                    'total': paginator.count,
                    'page': page,
                    'pageSize': page_size,
                    'totalPages': paginator.num_pages
                }
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'message': f'获取供应商列表失败: {str(e)}',
                'data': None
            }, status=500)


@csrf_exempt
@require_http_methods(["GET"])
def supplier_list_view(request):
    """
    函数式供应商列表视图（备用）
    """
    view = SupplierListView()
    return view.get(request)
