from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.db import transaction
import json
from datetime import datetime

from Core.models import ExpenditureRecord, Finance
from User.views.user_info import get_user_from_token


class ExpenditureRecordView(View):
    """
    财务支出记录视图
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def get(self, request):
        """
        获取支出记录列表
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

            # 获取查询参数
            current = int(request.GET.get('current', 1))
            size = int(request.GET.get('size', 20))
            reason = request.GET.get('reason', '').strip()
            related_order = request.GET.get('relatedOrder', '').strip()
            operator_name = request.GET.get('operatorName', '').strip()

            # 构建查询条件
            queryset = ExpenditureRecord.objects.all()

            # 应用搜索过滤
            if reason:
                queryset = queryset.filter(reason=reason)
            if related_order:
                queryset = queryset.filter(related_order__icontains=related_order)
            if operator_name:
                queryset = queryset.filter(operator_name__icontains=operator_name)

            # 按支出时间倒序排列
            queryset = queryset.order_by('-expenditure_time')

            # 分页
            total = queryset.count()
            start = (current - 1) * size
            end = start + size
            records = queryset[start:end]

            # 构建返回数据
            record_list = []
            for record in records:
                record_data = {
                    'id': record.id,
                    'amount': float(record.amount),
                    'reason': record.reason,
                    'relatedOrder': record.related_order,
                    'expenditureTime': record.expenditure_time.strftime('%Y-%m-%d %H:%M:%S'),
                    'operatorName': record.operator_name,
                    'operatorJobNumber': record.operator_job_number,
                    'remark': record.remark,
                    'createTime': record.create_time.strftime('%Y-%m-%d %H:%M:%S')
                }
                record_list.append(record_data)

            return JsonResponse({
                'code': 200,
                'message': '获取成功',
                'data': {
                    'list': record_list,
                    'total': total,
                    'current': current,
                    'size': size
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
        创建支出记录
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
            amount = data.get('amount')
            reason = data.get('reason')
            related_order = data.get('relatedOrder', '')
            remark = data.get('remark', '')

            # 参数验证
            if not amount or amount <= 0:
                return JsonResponse({
                    'code': 400,
                    'message': '支出金额必须大于0',
                    'data': None
                }, status=400)

            if not reason:
                return JsonResponse({
                    'code': 400,
                    'message': '支出原因不能为空',
                    'data': None
                }, status=400)

            # 创建支出记录并更新财务余额
            with transaction.atomic():
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
                if finance.balance < amount:
                    return JsonResponse({
                        'code': 400,
                        'message': f'余额不足，当前余额：{finance.balance}，需要支出：{amount}',
                        'data': None
                    }, status=400)
                
                # 创建支出记录
                record = ExpenditureRecord.objects.create(
                    amount=amount,
                    reason=reason,
                    related_order=related_order,
                    operator_name=user.username,
                    operator_job_number=user.job_number,
                    remark=remark
                )
                
                # 更新财务数据
                finance.balance -= amount
                finance.expenditure += amount
                finance.net_profit = finance.income - finance.expenditure
                finance.save()

            return JsonResponse({
                'code': 200,
                'message': '创建成功',
                'data': {
                    'id': record.id
                }
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'message': f'服务器内部错误: {str(e)}',
                'data': None
            }, status=500)

    def delete(self, request):
        """
        删除支出记录
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

            # 获取记录ID
            record_id = request.GET.get('id')
            if not record_id:
                return JsonResponse({
                    'code': 400,
                    'message': '记录ID不能为空',
                    'data': None
                }, status=400)

            # 查找并删除记录，同时恢复财务余额
            with transaction.atomic():
                try:
                    record = ExpenditureRecord.objects.get(id=record_id)
                    
                    # 获取财务记录
                    finance = Finance.objects.get(id=1)
                    
                    # 恢复财务数据
                    finance.balance += record.amount
                    finance.expenditure -= record.amount
                    finance.net_profit = finance.income - finance.expenditure
                    finance.save()
                    
                    # 删除支出记录
                    record.delete()
                    
                except ExpenditureRecord.DoesNotExist:
                    return JsonResponse({
                        'code': 404,
                        'message': '记录不存在',
                        'data': None
                    }, status=404)
                except Finance.DoesNotExist:
                    return JsonResponse({
                        'code': 500,
                        'message': '财务记录不存在',
                        'data': None
                    }, status=500)

            return JsonResponse({
                'code': 200,
                'message': '删除成功',
                'data': None
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'message': f'服务器内部错误: {str(e)}',
                'data': None
            }, status=500)