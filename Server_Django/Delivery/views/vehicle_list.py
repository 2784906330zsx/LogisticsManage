import json
from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.core.paginator import Paginator
from Core.models import Vehicle
from User.views.user_info import get_user_from_token


class VehicleListView(View):
    """
    车辆列表视图
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def get(self, request):
        """
        获取车辆列表
        """
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
            plate_number = request.GET.get('plateNumber', '').strip()
            vehicle_type = request.GET.get('vehicleType', '').strip()
            health_status = request.GET.get('healthStatus', '').strip()
            storage_status = request.GET.get('storageStatus', '').strip()
            is_enabled = request.GET.get('isEnabled', '').strip()

            # 构建查询条件
            queryset = Vehicle.objects.all()

            if plate_number:
                queryset = queryset.filter(plate_number__icontains=plate_number)
            if vehicle_type:
                queryset = queryset.filter(vehicle_type=vehicle_type)
            if health_status:
                queryset = queryset.filter(health_status=health_status)
            if storage_status:
                queryset = queryset.filter(storage_status=storage_status)
            if is_enabled:
                queryset = queryset.filter(is_enabled=is_enabled == 'true')

            # 按购入时间倒序排列
            queryset = queryset.order_by('-purchase_time')

            # 分页处理
            paginator = Paginator(queryset, size)
            page_obj = paginator.get_page(current)

            # 构建返回数据
            vehicle_list = []
            for vehicle in page_obj:
                vehicle_data = {
                    'id': vehicle.id,
                    'vehicleType': vehicle.vehicle_type,
                    'plateNumber': vehicle.plate_number,
                    'currentLoad': vehicle.current_load,
                    'maxLoad': vehicle.max_load,
                    'healthStatus': vehicle.health_status,
                    'storageStatus': vehicle.storage_status,
                    'currentRoute': vehicle.current_route,
                    'driverJobNumber': vehicle.driver_job_number,
                    'purchaseTime': vehicle.purchase_time.strftime('%Y-%m-%d %H:%M:%S'),
                    'isEnabled': vehicle.is_enabled,
                    'loadRate': round((vehicle.current_load / vehicle.max_load) * 100, 2) if vehicle.max_load > 0 else 0
                }
                vehicle_list.append(vehicle_data)

            return JsonResponse({
                'code': 200,
                'msg': '获取车辆列表成功',
                'data': {
                    'list': vehicle_list,
                    'total': paginator.count,
                    'current': current,
                    'size': size,
                    'totalPages': paginator.num_pages
                }
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'获取车辆列表失败: {str(e)}',
                'data': None
            }, status=500)
