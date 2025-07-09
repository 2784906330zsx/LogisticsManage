from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from Core.models import ShippingOrder, Vehicle  # 添加Vehicle导入
from Auth.utils import get_user_from_token
import json


class DeliveryOrderListView(View):
    """
    配送运单列表视图：获取不同状态的配送运单
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def get(self, request):
        """
        获取配送运单列表
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
            order_number = request.GET.get('orderNumber', '').strip()
            status = request.GET.get('status', '').strip()
            delivery_status = request.GET.get('deliveryStatus', '').strip()  # 配送状态筛选

            # 构建查询条件
            queryset = ShippingOrder.objects.select_related('commodity').all()

            if order_number:
                queryset = queryset.filter(order_number__icontains=order_number)

            # 如果指定了配送状态，则按配送状态筛选
            if delivery_status:
                queryset = queryset.filter(status=delivery_status)
            elif status:
                queryset = queryset.filter(status=status)

            # 按创建时间倒序排列
            queryset = queryset.order_by('-create_time')

            # 分页处理
            from django.core.paginator import Paginator
            paginator = Paginator(queryset, size)
            page_obj = paginator.get_page(current)

            # 构建返回数据
            order_list = []
            for order in page_obj:
                # 获取配送车辆的线路信息
                delivery_route = None
                if order.delivery_car_number:
                    try:
                        vehicle = Vehicle.objects.get(plate_number=order.delivery_car_number)
                        delivery_route = vehicle.current_route
                    except Vehicle.DoesNotExist:
                        delivery_route = 'None'

                order_data = {
                    'id': order.id,
                    'orderNumber': order.order_number,
                    'commodityName': order.commodity.name,
                    'commodityId': order.commodity.id,
                    'commodityImage': order.commodity.image,
                    'quantity': order.quantity,
                    'receiverName': order.receiver_name,
                    'receiverPhone': order.receiver_phone,
                    'receiverAddress': order.receiver_address,
                    'status': order.status,
                    'statusText': dict(ShippingOrder.STATUS_CHOICES)[order.status],
                    'creatorName': order.creator_name,
                    'creatorJobNumber': order.creator_job_number,
                    'createTime': order.create_time.strftime('%Y-%m-%d %H:%M:%S'),
                    'completeTime': order.complete_time.strftime('%Y-%m-%d %H:%M:%S') if order.complete_time else None,
                    'deliveryPersonName': order.delivery_person_name,
                    'deliveryPersonPhone': order.delivery_person_phone,
                    'deliveryCarNumber': order.delivery_car_number,
                    'deliveryRoute': delivery_route,
                    'deliveryTime': order.delivery_time.strftime('%Y-%m-%d %H:%M:%S') if order.delivery_time else None
                }
                order_list.append(order_data)

            return JsonResponse({
                'code': 200,
                'msg': '获取配送运单列表成功',
                'data': {
                    'list': order_list,
                    'total': paginator.count,
                    'current': current,
                    'size': size,
                    'totalPages': paginator.num_pages
                }
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'获取配送运单列表失败: {str(e)}',
                'data': None
            }, status=500)
