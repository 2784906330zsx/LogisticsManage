import json
from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.db import transaction
from django.utils import timezone
from Core.models import Commodity, InboundRecord, OutboundRecord
from User.views.user_info import get_user_from_token


class InventoryAdjustView(View):
    """
    库存调整视图：调整库存并自动创建入库或出库记录
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def post(self, request):
        """
        调整库存
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
            required_fields = ['commodityId', 'adjustType', 'quantity', 'reason']
            for field in required_fields:
                if not data.get(field):
                    return JsonResponse({
                        'code': 400,
                        'message': f'缺少必填字段: {field}',
                        'data': None
                    }, status=400)

            commodity_id = data.get('commodityId')
            adjust_type = data.get('adjustType')  # '入库' 或 '出库'
            quantity = int(data.get('quantity'))
            reason = data.get('reason')
            related_order = data.get('relatedOrder', '')

            # 验证调整类型
            if adjust_type not in ['入库', '出库']:
                return JsonResponse({
                    'code': 400,
                    'message': '调整类型必须是"入库"或"出库"',
                    'data': None
                }, status=400)

            # 验证数量
            if quantity <= 0:
                return JsonResponse({
                    'code': 400,
                    'message': '调整数量必须大于0',
                    'data': None
                }, status=400)

            # 获取商品
            try:
                commodity = Commodity.objects.get(id=commodity_id)
            except Commodity.DoesNotExist:
                return JsonResponse({
                    'code': 404,
                    'message': '商品不存在',
                    'data': None
                }, status=404)

            # 检查出库时库存是否足够
            if adjust_type == '出库' and commodity.stock < quantity:
                return JsonResponse({
                    'code': 400,
                    'message': f'库存不足，当前库存：{commodity.stock}，出库数量：{quantity}',
                    'data': None
                }, status=400)

            # 使用事务确保数据一致性
            with transaction.atomic():
                # 更新商品库存
                if adjust_type == '入库':
                    commodity.stock += quantity
                    commodity.total_inbound = (commodity.total_inbound or 0) + quantity
                    
                    # 创建入库记录
                    InboundRecord.objects.create(
                        commodity=commodity,
                        quantity=quantity,
                        reason=reason,
                        related_order=related_order,
                        inbound_name=user.username,
                        inbound_job_number=user.job_number
                    )
                else:  # 出库
                    commodity.stock -= quantity
                    commodity.total_outbound = (commodity.total_outbound or 0) + quantity
                    
                    # 创建出库记录
                    OutboundRecord.objects.create(
                        commodity=commodity,
                        quantity=quantity,
                        reason=reason,
                        related_order=related_order,
                        outbound_name=user.username,
                        outbound_job_number=user.job_number
                    )

                # 更新商品的最后更新时间
                commodity.update_time = timezone.now()
                commodity.save()

            return JsonResponse({
                'code': 200,
                'message': f'库存调整成功，{adjust_type}{quantity}件',
                'data': {
                    'commodityId': commodity.id,
                    'newStock': commodity.stock,
                    'adjustType': adjust_type,
                    'quantity': quantity
                }
            })

        except json.JSONDecodeError:
            return JsonResponse({
                'code': 400,
                'message': '请求数据格式错误',
                'data': None
            }, status=400)
        except ValueError as e:
            return JsonResponse({
                'code': 400,
                'message': f'数据类型错误: {str(e)}',
                'data': None
            }, status=400)
        except Exception as e:
            return JsonResponse({
                'code': 500,
                'message': f'服务器内部错误: {str(e)}',
                'data': None
            }, status=500)