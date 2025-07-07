import json
from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.utils import timezone
from Core.models import Commodity
from User.views.user_info import get_user_from_token
from decimal import Decimal


class CommodityManageView(View):
    """
    商品管理视图：新增、修改、删除
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def post(self, request):
        """
        新增商品
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
            required_fields = ['name', 'image', 'brand', 'description', 'price', 'stock', 'supplier', 'storageArea']
            for field in required_fields:
                if field not in data or not data[field]:
                    return JsonResponse({
                        'code': 400,
                        'message': f'缺少必填字段: {field}',
                        'data': None
                    }, status=400)

            # 创建商品
            commodity = Commodity.objects.create(
                name=data['name'],
                image=data['image'],
                brand=data['brand'],
                description=data['description'],
                status=data.get('status', '1'),
                price=Decimal(str(data['price'])),
                stock=int(data['stock']),
                total_inbound=int(data.get('totalInbound', 0)),
                total_outbound=int(data.get('totalOutbound', 0)),
                supplier=data['supplier'],
                storage_area=data['storageArea'],
                create_time=timezone.now(),
                last_update_time=timezone.now()
            )

            return JsonResponse({
                'code': 200,
                'message': '商品创建成功',
                'data': {
                    'id': commodity.id,
                    'name': commodity.name
                }
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'message': f'创建商品失败: {str(e)}',
                'data': None
            }, status=500)

    def put(self, request):
        """
        修改商品
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
            
            # 验证商品ID
            commodity_id = data.get('id')
            if not commodity_id:
                return JsonResponse({
                    'code': 400,
                    'message': '缺少商品ID',
                    'data': None
                }, status=400)

            # 查找商品
            try:
                commodity = Commodity.objects.get(id=commodity_id)
            except Commodity.DoesNotExist:
                return JsonResponse({
                    'code': 404,
                    'message': '商品不存在',
                    'data': None
                }, status=404)

            # 更新商品信息
            if 'name' in data:
                commodity.name = data['name']
            if 'image' in data:
                commodity.image = data['image']
            if 'brand' in data:
                commodity.brand = data['brand']
            if 'description' in data:
                commodity.description = data['description']
            if 'status' in data:
                commodity.status = data['status']
            if 'price' in data:
                commodity.price = Decimal(str(data['price']))
            if 'stock' in data:
                commodity.stock = int(data['stock'])
            if 'supplier' in data:
                commodity.supplier = data['supplier']
            if 'storageArea' in data:
                commodity.storage_area = data['storageArea']
            
            commodity.last_update_time = timezone.now()
            commodity.save()

            return JsonResponse({
                'code': 200,
                'message': '商品更新成功',
                'data': {
                    'id': commodity.id,
                    'name': commodity.name
                }
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'message': f'更新商品失败: {str(e)}',
                'data': None
            }, status=500)

    def delete(self, request):
        """
        删除商品
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
            
            # 验证商品ID
            commodity_id = data.get('id')
            if not commodity_id:
                return JsonResponse({
                    'code': 400,
                    'message': '缺少商品ID',
                    'data': None
                }, status=400)

            # 查找并删除商品
            try:
                commodity = Commodity.objects.get(id=commodity_id)
                commodity_name = commodity.name
                commodity.delete()
                
                return JsonResponse({
                    'code': 200,
                    'message': f'商品 "{commodity_name}" 删除成功',
                    'data': None
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
                'message': f'删除商品失败: {str(e)}',
                'data': None
            }, status=500)


@csrf_exempt
@require_http_methods(["POST", "PUT", "DELETE"])
def commodity_manage_view(request):
    """
    函数式商品管理视图（备用）
    """
    view = CommodityManageView()
    if request.method == 'POST':
        return view.post(request)
    elif request.method == 'PUT':
        return view.put(request)
    elif request.method == 'DELETE':
        return view.delete(request)