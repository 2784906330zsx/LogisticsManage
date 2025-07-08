from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.core.paginator import Paginator
from Core.models import OutboundRecord
from User.views.user_info import get_user_from_token


class OutboundRecordListView(View):
    """
    获取出库记录列表视图
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
            current = int(request.GET.get('current', 1))
            size = int(request.GET.get('size', 20))
            commodity_name = request.GET.get('commodityName', '').strip()
            reason = request.GET.get('reason', '').strip()
            related_order = request.GET.get('relatedOrder', '').strip()

            # 构建查询条件
            queryset = OutboundRecord.objects.select_related('commodity').all()

            if commodity_name:
                queryset = queryset.filter(commodity__name__icontains=commodity_name)
            if reason:
                queryset = queryset.filter(reason__icontains=reason)
            if related_order:
                queryset = queryset.filter(related_order__icontains=related_order)

            # 按出库时间倒序排列
            queryset = queryset.order_by('-outbound_time')

            # 分页处理
            paginator = Paginator(queryset, size)
            page_obj = paginator.get_page(current)

            # 构建返回数据
            record_list = []
            for record in page_obj:
                record_data = {
                    'id': record.id,
                    'commodityId': record.commodity.id,
                    'commodityName': record.commodity.name,
                    'commodityImage': record.commodity.image,
                    'quantity': record.quantity,
                    'reason': record.reason,
                    'relatedOrder': record.related_order,
                    'outboundName': record.outbound_name,
                    'outboundJobNumber': record.outbound_job_number,
                    'outboundTime': record.outbound_time.strftime('%Y-%m-%d %H:%M:%S')
                }
                record_list.append(record_data)

            return JsonResponse({
                'code': 200,
                'message': '获取出库记录列表成功',
                'data': {
                    'list': record_list,
                    'total': paginator.count,
                    'current': current,
                    'size': size,
                    'totalPages': paginator.num_pages
                }
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'message': f'获取出库记录列表失败: {str(e)}',
                'data': None
            }, status=500)