from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.db import transaction
from Core.models import PurchaseOrder, Commodity, Supplier
from User.views.user_info import get_user_from_token
from datetime import datetime
import json


class PurchaseOrderManageView(View):
    """
    采购订单管理视图
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def post(self, request):
        """
        新增采购订单
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
            commodity_id = data.get('commodityId')
            supplier_id = data.get('supplierId')
            unit_price = data.get('unitPrice')
            quantity = data.get('quantity')

            # 验证必填字段
            if not all([commodity_id, supplier_id, unit_price, quantity]):
                return JsonResponse({
                    'code': 400,
                    'message': '请填写完整的订单信息',
                    'data': None
                }, status=400)

            # 验证商品和供应商是否存在
            try:
                commodity = Commodity.objects.get(id=commodity_id)
                supplier = Supplier.objects.get(id=supplier_id)
            except (Commodity.DoesNotExist, Supplier.DoesNotExist):
                return JsonResponse({
                    'code': 400,
                    'message': '商品或供应商不存在',
                    'data': None
                }, status=400)

            # 计算总金额
            total_amount = float(unit_price) * int(quantity)

            # 生成订单编号
            order_number = self.generate_order_number()

            # 创建采购订单
            with transaction.atomic():
                purchase_order = PurchaseOrder.objects.create(
                    order_number=order_number,
                    commodity=commodity,
                    supplier=supplier,
                    unit_price=unit_price,
                    quantity=quantity,
                    total_amount=total_amount,
                    status='1',  # 财务审核中
                    purchase_name=user.username,
                    purchase_job_number=user.job_number,
                    order_time=datetime.now()
                )

            return JsonResponse({
                'code': 200,
                'message': '采购订单创建成功',
                'data': {
                    'id': purchase_order.id,
                    'orderNumber': purchase_order.order_number
                }
            })

        except json.JSONDecodeError:
            print('请求数据格式错误')
            return JsonResponse({
                'code': 400,
                'message': '请求数据格式错误',
                'data': None
            }, status=400)
        except Exception as e:
            print(f'创建采购订单失败: {str(e)}')
            return JsonResponse({
                'code': 500,
                'message': f'创建采购订单失败: {str(e)}',
                'data': None
            }, status=500)

    def generate_order_number(self):
        """
        生成订单编号：P+yyyymmdd+四位计数
        """
        today = datetime.now().strftime('%Y%m%d')
        prefix = f'P{today}'

        # 查询今天已有的订单数量
        today_orders = PurchaseOrder.objects.filter(
            order_number__startswith=prefix
        ).count()

        # 生成四位计数
        count = str(today_orders + 1).zfill(4)

        return f'{prefix}{count}'

    def get(self, request):
        """
        获取商品信息（用于自动填充）
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

            commodity_id = request.GET.get('commodityId')
            if not commodity_id:
                return JsonResponse({
                    'code': 400,
                    'message': '请提供商品ID',
                    'data': None
                }, status=400)

            try:
                commodity = Commodity.objects.get(id=commodity_id)

                # 获取商品的供应商信息
                supplier = None
                if commodity.supplier:
                    try:
                        supplier = Supplier.objects.get(name=commodity.supplier)
                    except Supplier.DoesNotExist:
                        pass

                return JsonResponse({
                    'code': 200,
                    'message': '获取商品信息成功',
                    'data': {
                        'id': commodity.id,
                        'name': commodity.name,
                        'price': float(commodity.price),
                        'supplier': {
                            'id': supplier.id if supplier else None,
                            'name': supplier.name if supplier else commodity.supplier
                        } if commodity.supplier else None
                    }
                })
            except Commodity.DoesNotExist:
                return JsonResponse({
                    'code': 404,
                    'message': '商品不存在',
                    'data': None
                }, status=404)

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'message': f'获取商品信息失败: {str(e)}',
                'data': None
            }, status=500)

    def delete(self, request):
        """
        删除采购订单
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
            order_id = data.get('id')

            if not order_id:
                return JsonResponse({
                    'code': 400,
                    'message': '请提供订单ID',
                    'data': None
                }, status=400)

            # 查找并删除采购订单
            try:
                purchase_order = PurchaseOrder.objects.get(id=order_id)

                # 检查订单状态，只有特定状态的订单才能删除
                if purchase_order.status in ['3', '4']:  # 待入库、已入库状态不能删除
                    return JsonResponse({
                        'code': 400,
                        'message': '该状态的订单不能删除',
                        'data': None
                    }, status=400)

                # 执行删除
                with transaction.atomic():
                    purchase_order.delete()

                return JsonResponse({
                    'code': 200,
                    'message': '采购订单删除成功',
                    'data': None
                })

            except PurchaseOrder.DoesNotExist:
                return JsonResponse({
                    'code': 404,
                    'message': '采购订单不存在',
                    'data': None
                }, status=404)

        except json.JSONDecodeError:
            return JsonResponse({
                'code': 400,
                'message': '请求数据格式错误',
                'data': None
            }, status=400)
        except Exception as e:
            return JsonResponse({
                'code': 500,
                'message': f'删除采购订单失败: {str(e)}',
                'data': None
            }, status=500)
