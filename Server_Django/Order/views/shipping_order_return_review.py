import json
from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.utils import timezone
from Core.models import ShippingOrder
from User.views.user_info import get_user_from_token


class ShippingOrderReturnReviewView(View):
    """
    退货运单审核视图：审核退货申请
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def post(self, request):
        """
        审核退货运单
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
            action = data.get('action')  # 'approve' 或 'reject'
            review_comment = data.get('reviewComment', '')

            if not order_id:
                return JsonResponse({
                    'code': 400,
                    'msg': '缺少运单ID',
                    'data': None
                }, status=400)

            if action not in ['approve', 'reject']:
                return JsonResponse({
                    'code': 400,
                    'msg': '无效的操作类型',
                    'data': None
                }, status=400)

            # 查找运单
            try:
                shipping_order = ShippingOrder.objects.get(id=order_id)
            except ShippingOrder.DoesNotExist:
                return JsonResponse({
                    'code': 404,
                    'msg': '运单不存在',
                    'data': None
                }, status=404)

            # 检查运单状态
            if shipping_order.status != '7':
                return JsonResponse({
                    'code': 400,
                    'msg': '运单状态不是待退货审核，无法进行审核操作',
                    'data': None
                }, status=400)

            # 获取当前时间
            current_time = timezone.now()

            # 根据操作类型更新状态
            if action == 'approve':
                new_status = '9'  # 已退货
                msg = '退货审核通过'
                # 退货审核通过时设置运单完成时间，表示运单流程终止
                shipping_order.complete_time = current_time
            else:
                new_status = '8'  # 审核未通过
                msg = '退货审核不通过'
                # 审核不通过时不设置完成时间，运单可能继续其他流程

            # 更新运单信息
            shipping_order.status = new_status
            shipping_order.check_name = user.username
            shipping_order.check_job_number = user.job_number
            shipping_order.check_time = current_time
            shipping_order.check_reason = review_comment
            shipping_order.save()

            return JsonResponse({
                'code': 200,
                'msg': msg,
                'data': {
                    'orderId': order_id,
                    'newStatus': new_status,
                    'statusText': dict(ShippingOrder.STATUS_CHOICES)[new_status]
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
                'msg': f'服务器内部错误: {str(e)}',
                'data': None
            }, status=500)
