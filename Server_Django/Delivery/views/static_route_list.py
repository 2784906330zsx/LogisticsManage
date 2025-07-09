from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.core.paginator import Paginator
from Core.models import StaticRoute
from User.views.user_info import get_user_from_token
import json


class StaticRouteListView(View):
    """
    获取固定线路列表视图
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
            departure = request.GET.get('departure', '').strip()
            destination = request.GET.get('destination', '').strip()
            is_active = request.GET.get('isActive', '').strip()

            # 构建查询条件
            queryset = StaticRoute.objects.all()

            if departure:
                queryset = queryset.filter(departure__icontains=departure)
            if destination:
                queryset = queryset.filter(destination__icontains=destination)
            if is_active:
                queryset = queryset.filter(is_active=is_active == 'true')

            # 按创建时间倒序排列
            queryset = queryset.order_by('-create_time')

            # 分页处理
            paginator = Paginator(queryset, page_size)
            page_obj = paginator.get_page(page)

            # 构建返回数据
            route_list = []
            for route in page_obj:
                route_data = {
                    'id': route.id,
                    'departure': route.departure,
                    'destination': route.destination,
                    'totalDistance': float(route.total_distance),
                    'estimatedTime': float(route.estimated_time),
                    'scheduleInfo': route.schedule_info,
                    'isActive': route.is_active,
                    'createTime': route.create_time.strftime('%Y-%m-%d %H:%M:%S')
                }
                route_list.append(route_data)

            return JsonResponse({
                'code': 200,
                'message': '获取固定线路列表成功',
                'data': {
                    'list': route_list,
                    'total': paginator.count,
                    'page': page,
                    'pageSize': page_size,
                    'totalPages': paginator.num_pages
                }
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'message': f'获取固定线路列表失败: {str(e)}',
                'data': None
            }, status=500)


@csrf_exempt
@require_http_methods(["GET"])
def static_route_list_view(request):
    """
    函数式固定线路列表视图（备用）
    """
    view = StaticRouteListView()
    return view.get(request)
