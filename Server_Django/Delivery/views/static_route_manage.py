import json
from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.utils import timezone
from Core.models import StaticRoute
from User.views.user_info import get_user_from_token
from decimal import Decimal


class StaticRouteManageView(View):
    """
    固定线路管理视图：新增、修改、删除
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def post(self, request):
        """
        新增固定线路
        """
        try:
            # 验证用户身份
            user = get_user_from_token(request)
            if not user:
                return JsonResponse({
                    'code': 401,
                    'message': '未授权访问',
                    'data': None
                }, status=401)

            # 解析请求数据
            data = json.loads(request.body)

            # 验证必填字段
            required_fields = ['departure', 'destination', 'totalDistance', 'estimatedTime', 'scheduleInfo']
            for field in required_fields:
                if field not in data or not data[field]:
                    return JsonResponse({
                        'code': 400,
                        'message': f'缺少必填字段: {field}',
                        'data': None
                    }, status=400)

            # 创建固定线路
            static_route = StaticRoute.objects.create(
                departure=data['departure'],
                destination=data['destination'],
                total_distance=Decimal(str(data['totalDistance'])),
                estimated_time=Decimal(str(data['estimatedTime'])),
                schedule_info=data['scheduleInfo'],
                is_active=data.get('isActive', True),
                create_time=timezone.now()
            )

            return JsonResponse({
                'code': 200,
                'message': '固定线路创建成功',
                'data': {
                    'id': static_route.id,
                    'departure': static_route.departure,
                    'destination': static_route.destination
                }
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'message': f'创建固定线路失败: {str(e)}',
                'data': None
            }, status=500)

    def put(self, request):
        """
        修改固定线路
        """
        try:
            # 验证用户身份
            user = get_user_from_token(request)
            if not user:
                return JsonResponse({
                    'code': 401,
                    'message': '未授权访问',
                    'data': None
                }, status=401)

            # 解析请求数据
            data = json.loads(request.body)

            # 验证线路ID
            route_id = data.get('id')
            if not route_id:
                return JsonResponse({
                    'code': 400,
                    'message': '缺少线路ID',
                    'data': None
                }, status=400)

            # 查找线路
            try:
                static_route = StaticRoute.objects.get(id=route_id)
            except StaticRoute.DoesNotExist:
                return JsonResponse({
                    'code': 404,
                    'message': '固定线路不存在',
                    'data': None
                }, status=404)

            # 更新线路信息
            if 'departure' in data:
                static_route.departure = data['departure']
            if 'destination' in data:
                static_route.destination = data['destination']
            if 'totalDistance' in data:
                static_route.total_distance = Decimal(str(data['totalDistance']))
            if 'estimatedTime' in data:
                static_route.estimated_time = Decimal(str(data['estimatedTime']))
            if 'scheduleInfo' in data:
                static_route.schedule_info = data['scheduleInfo']
            if 'isActive' in data:
                static_route.is_active = data['isActive']

            static_route.save()

            return JsonResponse({
                'code': 200,
                'message': '固定线路更新成功',
                'data': {
                    'id': static_route.id,
                    'departure': static_route.departure,
                    'destination': static_route.destination
                }
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'message': f'更新固定线路失败: {str(e)}',
                'data': None
            }, status=500)

    def delete(self, request):
        """
        删除固定线路
        """
        try:
            # 验证用户身份
            user = get_user_from_token(request)
            if not user:
                return JsonResponse({
                    'code': 401,
                    'message': '未授权访问',
                    'data': None
                }, status=401)

            # 解析请求数据
            data = json.loads(request.body)

            # 验证线路ID
            route_id = data.get('id')
            if not route_id:
                return JsonResponse({
                    'code': 400,
                    'message': '缺少线路ID',
                    'data': None
                }, status=400)

            # 查找并删除线路
            try:
                static_route = StaticRoute.objects.get(id=route_id)
                route_name = f"{static_route.departure} -> {static_route.destination}"
                static_route.delete()

                return JsonResponse({
                    'code': 200,
                    'message': f'固定线路 "{route_name}" 删除成功',
                    'data': None
                })
            except StaticRoute.DoesNotExist:
                return JsonResponse({
                    'code': 404,
                    'message': '固定线路不存在',
                    'data': None
                }, status=404)

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'message': f'删除固定线路失败: {str(e)}',
                'data': None
            }, status=500)


@csrf_exempt
@require_http_methods(["POST", "PUT", "DELETE"])
def static_route_manage_view(request):
    """
    函数式固定线路管理视图（备用）
    """
    view = StaticRouteManageView()
    if request.method == 'POST':
        return view.post(request)
    elif request.method == 'PUT':
        return view.put(request)
    elif request.method == 'DELETE':
        return view.delete(request)