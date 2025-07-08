from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.core.paginator import Paginator
from Core.models import PurchaseOrder, Commodity, Supplier
from User.views.user_info import get_user_from_token
import json


class PurchaseOrderListView(View):
    """
    获取采购订单列表视图
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
            order_number = request.GET.get('orderNumber', '').strip()
            commodity_name = request.GET.get('commodityName', '').strip()
            supplier_name = request.GET.get('supplierName', '').strip()
            status = request.GET.get('status', '').strip()
            purchaser_name = request.GET.get('purchaserName', '').strip()

            # 构建查询条件
            queryset = PurchaseOrder.objects.select_related('commodity', 'supplier').all()

            if order_number:
                queryset = queryset.filter(order_number__icontains=order_number)
            if commodity_name:
                queryset = queryset.filter(commodity__name__icontains=commodity_name)
            if supplier_name:
                queryset = queryset.filter(supplier__name__icontains=supplier_name)
            if status:
                queryset = queryset.filter(status=status)
            if purchaser_name:
                queryset = queryset.filter(purchase_name__icontains=purchaser_name)

            # 按下单时间倒序排列
            queryset = queryset.order_by('-order_time')

            # 分页处理
            paginator = Paginator(queryset, page_size)
            page_obj = paginator.get_page(page)

            # 构建返回数据
            order_list = []
            for order in page_obj:
                # 状态映射
                status_map = {
                    '1': '财务审核中',
                    '2': '审核未通过',
                    '3': '待入库',
                    '4': '已入库',
                    '5': '已取消'
                }

                order_data = {
                    'id': order.id,
                    'orderNumber': order.order_number,
                    'commodityId': order.commodity.id,
                    'commodityName': order.commodity.name,
                    'commodityImage': order.commodity.image,
                    'supplierId': order.supplier.id,
                    'supplierName': order.supplier.name,
                    'unitPrice': float(order.unit_price),
                    'quantity': order.quantity,
                    'totalAmount': float(order.total_amount),
                    'status': order.status,
                    'statusText': status_map.get(order.status, order.status),
                    'purchaserName': order.purchase_name,
                    'purchaserJobNumber': order.purchase_job_number,
                    'orderTime': order.order_time.strftime('%Y-%m-%d %H:%M:%S'),
                    'checkName': order.check_name,
                    'checkJobNumber': order.check_job_number,
                    'checkTime': order.check_time.strftime('%Y-%m-%d %H:%M:%S') if order.check_time else None,
                    'checkReason': order.check_reason,
                    'inboundName': order.inbound_name,
                    'inboundJobNumber': order.inbound_job_number,
                    'inboundTime': order.inbound_time.strftime('%Y-%m-%d %H:%M:%S') if order.inbound_time else None,
                    'warehouseKeeperName': order.inbound_name,
                    'warehouseKeeperJobNumber': order.inbound_job_number
                }
                order_list.append(order_data)

            return JsonResponse({
                'code': 200,
                'message': '获取采购订单列表成功',
                'data': {
                    'list': order_list,
                    'total': paginator.count,
                    'page': page,
                    'pageSize': page_size,
                    'totalPages': paginator.num_pages
                }
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'message': f'获取采购订单列表失败: {str(e)}',
                'data': None
            }, status=500)


@csrf_exempt
@require_http_methods(["GET"])
def purchase_order_list_view(request):
    """
    函数式采购订单列表视图（备用）
    """
    view = PurchaseOrderListView()
    return view.get(request)