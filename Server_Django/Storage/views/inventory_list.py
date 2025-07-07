from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.core.paginator import Paginator
from Core.models import Commodity
from User.views.user_info import get_user_from_token


class InventoryListView(View):
    """
    获取库存列表视图
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
                    'msg': '未授权访问',
                    'data': None
                }, status=401)

            # 获取查询参数
            current = int(request.GET.get('current', 1))
            size = int(request.GET.get('size', 20))
            name = request.GET.get('name', '').strip()
            brand = request.GET.get('brand', '').strip()
            supplier = request.GET.get('supplier', '').strip()
            storage_area = request.GET.get('storageArea', '').strip()

            # 构建查询条件
            queryset = Commodity.objects.all()

            if name:
                queryset = queryset.filter(name__icontains=name)
            if brand:
                queryset = queryset.filter(brand__icontains=brand)
            if supplier:
                queryset = queryset.filter(supplier__icontains=supplier)
            if storage_area:
                queryset = queryset.filter(storage_area__icontains=storage_area)

            # 按最近更新时间倒序排列
            queryset = queryset.order_by('-last_update_time')

            # 分页处理
            paginator = Paginator(queryset, size)
            page_obj = paginator.get_page(current)

            # 构建返回数据
            inventory_list = []
            for commodity in page_obj:
                inventory_data = {
                    'id': commodity.id,
                    'name': commodity.name,
                    'image': commodity.image,
                    'brand': commodity.brand,
                    'description': commodity.description,
                    'price': float(commodity.price),
                    'stock': commodity.stock,
                    'totalInbound': commodity.total_inbound,
                    'totalOutbound': commodity.total_outbound,
                    'supplier': commodity.supplier,
                    'storageArea': commodity.storage_area,
                    'createTime': commodity.create_time.strftime('%Y-%m-%d %H:%M:%S'),
                    'lastUpdateTime': commodity.last_update_time.strftime('%Y-%m-%d %H:%M:%S')
                }
                inventory_list.append(inventory_data)

            return JsonResponse({
                'code': 200,
                'msg': '获取库存列表成功',
                'data': {
                    'list': inventory_list,
                    'total': paginator.count,
                    'current': current,
                    'size': size,
                    'totalPages': paginator.num_pages
                }
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'获取库存列表失败: {str(e)}',
                'data': None
            }, status=500)