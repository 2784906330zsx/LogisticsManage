from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.db.models import Sum
from datetime import datetime, date
import json

from Core.models import Finance, IncomeRecord, ExpenditureRecord
from User.views.user_info import get_user_from_token


class FinanceStatisticsView(View):
    """
    财务统计视图
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def get(self, request):
        """
        获取财务统计数据
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

            # 获取今日日期
            today = date.today()
            
            # 计算今日收入
            today_income = IncomeRecord.objects.filter(
                income_time__date=today
            ).aggregate(total=Sum('amount'))['total'] or 0
            
            # 计算今日支出
            today_expenditure = ExpenditureRecord.objects.filter(
                expenditure_time__date=today
            ).aggregate(total=Sum('amount'))['total'] or 0

            # 构建返回数据
            statistics_data = {
                'balance': float(finance.balance),
                'todayIncome': float(today_income),
                'todayExpenditure': float(today_expenditure),
                'totalIncome': float(finance.income),
                'totalExpenditure': float(finance.expenditure),
                'netProfit': float(finance.net_profit)
            }

            return JsonResponse({
                'code': 200,
                'message': '获取成功',
                'data': statistics_data
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'message': f'服务器内部错误: {str(e)}',
                'data': None
            }, status=500)