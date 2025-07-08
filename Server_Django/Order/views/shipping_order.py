import json
from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.utils import timezone
from django.db import transaction
from Core.models import ShippingOrder, Commodity
from User.views.user_info import get_user_from_token


class ShippingOrderView(View):
    """
    运单管理视图：创建、查询运单
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def post(self, request):
        """
        创建运单
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
            required_fields = ['commodityId', 'quantity', 'receiverName', 'receiverPhone', 'receiverAddress']
            for field in required_fields:
                if not data.get(field):
                    return JsonResponse({
                        'code': 400,
                        'msg': f'缺少必填字段: {field}',
                        'data': None
                    }, status=400)

            commodity_id = data.get('commodityId')
            quantity = int(data.get('quantity'))
            receiver_name = data.get('receiverName')
            receiver_phone = data.get('receiverPhone')
            receiver_address = data.get('receiverAddress')

            # 验证商品是否存在
            try:
                commodity = Commodity.objects.get(id=commodity_id)
            except Commodity.DoesNotExist:
                return JsonResponse({
                    'code': 404,
                    'msg': '商品不存在',
                    'data': None
                }, status=404)

            # 验证库存是否充足
            if commodity.stock < quantity:
                return JsonResponse({
                    'code': 400,
                    'msg': f'库存不足，当前库存：{commodity.stock}，需要数量：{quantity}',
                    'data': None
                }, status=400)

            # 生成运单号
            order_number = self.generate_order_number()

            # 使用事务确保数据一致性
            with transaction.atomic():
                # 创建运单
                shipping_order = ShippingOrder.objects.create(
                    order_number=order_number,
                    commodity=commodity,
                    quantity=quantity,
                    receiver_name=receiver_name,
                    receiver_phone=receiver_phone,
                    receiver_address=receiver_address,
                    creator_name=user.username,
                    creator_job_number=user.job_number,
                    status='1'  # 待审核
                )

                # 减少商品库存
                commodity.stock -= quantity
                commodity.total_outbound = (commodity.total_outbound or 0) + quantity
                commodity.save()

            return JsonResponse({
                'code': 200,
                'msg': '运单创建成功',
                'data': {
                    'orderNumber': order_number,
                    'orderId': shipping_order.id
                }
            })

        except json.JSONDecodeError:
            return JsonResponse({
                'code': 400,
                'msg': '请求数据格式错误',
                'data': None
            }, status=400)
        except ValueError as e:
            return JsonResponse({
                'code': 400,
                'msg': f'数据类型错误: {str(e)}',
                'data': None
            }, status=400)
        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'服务器内部错误: {str(e)}',
                'data': None
            }, status=500)

    def get(self, request):
        """
        获取运单列表
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

            # 构建查询条件
            queryset = ShippingOrder.objects.select_related('commodity').all()

            if order_number:
                queryset = queryset.filter(order_number__icontains=order_number)
            if status:
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
                    'createTime': order.create_time.strftime('%Y-%m-%d %H:%M:%S')
                }
                order_list.append(order_data)

            return JsonResponse({
                'code': 200,
                'msg': '获取运单列表成功',
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
                'msg': f'获取运单列表失败: {str(e)}',
                'data': None
            }, status=500)

    def generate_order_number(self):
        """
        生成运单号：D+yyyy-mm-dd+四位订单顺序
        例如：D2025-07-09-0001
        """
        import datetime
        from django.db.models import Q

        now = datetime.datetime.now()
        date_str = now.strftime('%Y%m%d')

        # 获取今天的日期范围
        today_start = datetime.datetime.combine(now.date(), datetime.time.min)
        today_end = datetime.datetime.combine(now.date(), datetime.time.max)

        # 查询今天已创建的运单数量
        today_count = ShippingOrder.objects.filter(
            create_time__range=(today_start, today_end)
        ).count()

        # 生成四位顺序号（从0001开始）
        sequence_number = str(today_count + 1).zfill(4)

        return f'D{date_str}{sequence_number}'
