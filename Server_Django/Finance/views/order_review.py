from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.db import transaction
import json
from datetime import datetime

from Core.models import PurchaseOrder, ExpenditureRecord, Finance
from User.views.user_info import get_user_from_token


class OrderReviewView(View):
    """
    财务审核采购订单视图
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def get(self, request):
        """
        获取待审核的采购订单列表（status=1）
        """
        try:
            # 验证用户身份
            user = get_user_from_token(request)
            if not user:
                return JsonResponse({
                    'code': 401,
                    'message': '用户未登录或token无效',
                    'data': None
                }, status=401)

            # 获取查询参数 - 修改参数名称
            current = int(request.GET.get('current', 1))
            size = int(request.GET.get('size', 20))
            order_number = request.GET.get('orderNumber', '').strip()
            commodity_name = request.GET.get('commodityName', '').strip()
            supplier_name = request.GET.get('supplierName', '').strip()
            purchaser_name = request.GET.get('purchaserName', '').strip()

            # 构建查询条件 - 只查询状态为'1'（财务审核中）的订单
            queryset = PurchaseOrder.objects.filter(status='1').select_related(
                'commodity', 'supplier'
            )

            # 应用搜索过滤
            if order_number:
                queryset = queryset.filter(order_number__icontains=order_number)
            if commodity_name:
                queryset = queryset.filter(commodity__name__icontains=commodity_name)
            if supplier_name:
                queryset = queryset.filter(supplier__name__icontains=supplier_name)
            if purchaser_name:
                queryset = queryset.filter(purchase_name__icontains=purchaser_name)

            # 按下单时间倒序排列
            queryset = queryset.order_by('-order_time')

            # 分页
            total = queryset.count()
            start = (current - 1) * size
            end = start + size
            orders = queryset[start:end]

            # 构建返回数据
            order_list = []
            for order in orders:
                order_data = {
                    'id': order.id,
                    'orderNumber': order.order_number,
                    'commodityId': order.commodity.id,
                    'commodityName': order.commodity.name,
                    'commodityImage': getattr(order.commodity, 'image', ''),
                    'supplierId': order.supplier.id,
                    'supplierName': order.supplier.name,
                    'unitPrice': float(order.unit_price),
                    'quantity': order.quantity,
                    'totalAmount': float(order.total_amount),
                    'orderTime': order.order_time.strftime('%Y-%m-%d %H:%M:%S'),
                    'status': order.status,
                    'purchaserName': order.purchase_name,
                    'purchaserJobNumber': order.purchase_job_number,
                }
                order_list.append(order_data)

            return JsonResponse({
                'code': 200,
                'message': '获取成功',
                'data': {
                    'list': order_list,
                    'total': total,
                    'current': current,    # 改为 current
                    'size': size          # 改为 size
                }
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'message': f'服务器内部错误: {str(e)}',
                'data': None
            }, status=500)

    def post(self, request):
        """
        审核采购订单（通过或不通过）
        """
        try:
            # 验证用户身份
            user = get_user_from_token(request)
            if not user:
                return JsonResponse({
                    'code': 401,
                    'message': '用户未登录或token无效',
                    'data': None
                }, status=401)

            # 解析请求数据
            try:
                data = json.loads(request.body)
            except json.JSONDecodeError:
                return JsonResponse({
                    'code': 400,
                    'message': '请求数据格式错误',
                    'data': None
                }, status=400)

            # 获取必要参数
            order_id = data.get('orderId')
            action = data.get('action')  # 'approve' 或 'reject'
            review_comment = data.get('reviewComment', '').strip()

            # 参数验证
            if not order_id:
                return JsonResponse({
                    'code': 400,
                    'message': '订单ID不能为空',
                    'data': None
                }, status=400)

            if action not in ['approve', 'reject']:
                return JsonResponse({
                    'code': 400,
                    'message': '审核操作类型无效',
                    'data': None
                }, status=400)

            if action == 'reject' and not review_comment:
                return JsonResponse({
                    'code': 400,
                    'message': '审核不通过时必须填写原因',
                    'data': None
                }, status=400)

            # 查找订单
            try:
                order = PurchaseOrder.objects.select_related('commodity', 'supplier').get(id=order_id)
            except PurchaseOrder.DoesNotExist:
                return JsonResponse({
                    'code': 404,
                    'message': '订单不存在',
                    'data': None
                }, status=404)

            # 检查订单状态
            if order.status != '1':
                return JsonResponse({
                    'code': 400,
                    'message': '只能审核状态为"财务审核中"的订单',
                    'data': None
                }, status=400)

            # 原子操作更新订单状态并创建支出记录
            with transaction.atomic():
                if action == 'approve':
                    # 获取或创建财务记录
                    finance, created = Finance.objects.get_or_create(
                        id=1,
                        defaults={
                            'balance': 0,
                            'income': 0,
                            'expenditure': 0,
                            'net_profit': 0
                        }
                    )

                    # 检查余额是否足够
                    if finance.balance < order.total_amount:
                        return JsonResponse({
                            'code': 400,
                            'message': f'账户余额不足，无法审核通过。当前余额：{finance.balance}，订单金额：{order.total_amount}',
                            'data': None
                        }, status=400)

                    # 更新订单状态
                    order.status = '3'  # 待入库
                    order.finance_reviewer = user
                    order.finance_review_time = datetime.now()
                    order.finance_review_comment = review_comment
                    order.save()

                    # 自动创建支出记录
                    expenditure_record = ExpenditureRecord.objects.create(
                        amount=order.total_amount,
                        reason='采购支出',
                        related_order=order.order_number,
                        operator_name=user.username,
                        operator_job_number=user.job_number,
                        remark=f'采购订单审核通过自动创建 - 商品：{order.commodity.name}，供应商：{order.supplier.name}'
                    )

                    # 更新财务数据
                    finance.balance -= order.total_amount
                    finance.expenditure += order.total_amount
                    finance.net_profit = finance.income - finance.expenditure
                    finance.save()

                    message = '审核通过'

                else:  # reject
                    order.status = '2'  # 审核未通过
                    order.finance_reviewer = user
                    order.finance_review_time = datetime.now()
                    order.finance_review_comment = review_comment
                    order.save()
                    message = '审核不通过'

            return JsonResponse({
                'code': 200,
                'message': message,
                'data': None
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'message': f'服务器内部错误: {str(e)}',
                'data': None
            }, status=500)
