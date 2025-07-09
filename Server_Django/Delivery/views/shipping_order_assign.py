import json
from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.utils import timezone
from django.db import transaction
from Core.models import ShippingOrder, Vehicle, User
from User.views.user_info import get_user_from_token


class ShippingOrderAssignView(View):
    """
    运单分配视图：分配配送车辆和路线，更新运单状态
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def post(self, request):
        """
        分配运单给配送车辆
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

            # 解析请求数据
            data = json.loads(request.body)

            # 验证必填字段
            order_id = data.get('orderId')
            vehicle_id = data.get('vehicleId')
            route_info = data.get('routeInfo')  # 路线信息对象

            if not order_id:
                return JsonResponse({
                    'code': 400,
                    'msg': '缺少运单ID',
                    'data': None
                }, status=400)

            if not vehicle_id:
                return JsonResponse({
                    'code': 400,
                    'msg': '缺少车辆ID',
                    'data': None
                }, status=400)

            # 使用事务确保数据一致性
            with transaction.atomic():
                # 查找运单
                try:
                    shipping_order = ShippingOrder.objects.get(id=order_id)
                except ShippingOrder.DoesNotExist:
                    return JsonResponse({
                        'code': 404,
                        'msg': '运单不存在',
                        'data': None
                    }, status=404)

                # 检查运单状态是否为待配送
                if shipping_order.status != '3':
                    return JsonResponse({
                        'code': 400,
                        'msg': '运单状态不是待配送，无法分配',
                        'data': None
                    }, status=400)

                # 查找车辆
                try:
                    vehicle = Vehicle.objects.get(id=vehicle_id)
                except Vehicle.DoesNotExist:
                    return JsonResponse({
                        'code': 404,
                        'msg': '车辆不存在',
                        'data': None
                    }, status=404)

                # 检查车辆状态
                if not vehicle.is_enabled:
                    return JsonResponse({
                        'code': 400,
                        'msg': '车辆未启用，无法分配',
                        'data': None
                    }, status=400)

                if vehicle.storage_status not in ['在库待命', '正在装货']:
                    return JsonResponse({
                        'code': 400,
                        'msg': '车辆状态不可用，无法分配',
                        'data': None
                    }, status=400)

                # 更新运单信息
                shipping_order.status = '4'  # 配送中
                shipping_order.delivery_time = timezone.now()
                shipping_order.delivery_car_number = vehicle.plate_number

                # 根据车辆的司机工号获取司机信息
                try:
                    driver = User.objects.get(job_number=vehicle.driver_job_number)
                    shipping_order.delivery_job_number = driver.job_number
                    shipping_order.delivery_person_name = driver.username
                    shipping_order.delivery_person_phone = driver.mobile
                except User.DoesNotExist:
                    # 如果找不到司机信息，记录警告但不阻止分配
                    shipping_order.delivery_person_name = '未知司机'
                    shipping_order.delivery_person_phone = ''

                shipping_order.save()

                # 更新车辆状态
                if vehicle.storage_status == '在库待命':
                    vehicle.storage_status = '正在装货'
                    if route_info:
                        vehicle.current_route = f"{route_info.get('departure', '')} → {route_info.get('destination', '')}"
                    vehicle.save()

                return JsonResponse({
                    'code': 200,
                    'msg': '运单分配成功',
                    'data': {
                        'orderId': shipping_order.id,
                        'orderNumber': shipping_order.order_number,
                        'vehicleId': vehicle.id,
                        'plateNumber': vehicle.plate_number,
                        'status': shipping_order.status,
                        'deliveryTime': shipping_order.delivery_time.strftime('%Y-%m-%d %H:%M:%S')
                    }
                })

        except json.JSONDecodeError:
            return JsonResponse({
                'code': 400,
                'msg': '请求数据格式错误',
                'data': None
            }, status=400)
        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'分配运单失败: {str(e)}',
                'data': None
            }, status=500)
