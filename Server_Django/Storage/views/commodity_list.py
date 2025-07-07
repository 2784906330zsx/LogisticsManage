from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.core.paginator import Paginator
from Core.models import Commodity
from User.views.user_info import get_user_from_token
import json


class CommodityListView(View):
    """
    获取商品列表视图
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
            brand = request.GET.get('brand', '').strip()
            status = request.GET.get('status', '').strip()

            # 构建查询条件
            queryset = Commodity.objects.all()

            if name:
                queryset = queryset.filter(name__icontains=name)
            if brand:
                queryset = queryset.filter(brand__icontains=brand)
            if status:
                queryset = queryset.filter(status=status)

            # 按创建时间倒序排列
            queryset = queryset.order_by('-create_time')

            # 分页处理
            paginator = Paginator(queryset, page_size)
            page_obj = paginator.get_page(page)

            # 构建返回数据
            commodity_list = []
            for commodity in page_obj:
                commodity_data = {
                    'id': commodity.id,
                    'name': commodity.name,
                    'image': commodity.image,
                    'brand': commodity.brand,
                    'description': commodity.description,
                    'status': commodity.status,
                    'price': float(commodity.price),
                    'stock': commodity.stock,
                    'totalInbound': commodity.total_inbound,
                    'totalOutbound': commodity.total_outbound,
                    'supplier': commodity.supplier,
                    'createTime': commodity.create_time.strftime('%Y-%m-%d %H:%M:%S'),
                    'lastUpdateTime': commodity.last_update_time.strftime('%Y-%m-%d %H:%M:%S'),
                    'storageArea': commodity.storage_area
                }
                commodity_list.append(commodity_data)

            return JsonResponse({
                'code': 200,
                'message': '获取商品列表成功',
                'data': {
                    'list': commodity_list,
                    'total': paginator.count,
                    'page': page,
                    'pageSize': page_size,
                    'totalPages': paginator.num_pages
                }
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'message': f'获取商品列表失败: {str(e)}',
                'data': None
            }, status=500)


@csrf_exempt
@require_http_methods(["GET"])
def commodity_list_view(request):
    """
    函数式商品列表视图（备用）
    """
    view = CommodityListView()
    return view.get(request)