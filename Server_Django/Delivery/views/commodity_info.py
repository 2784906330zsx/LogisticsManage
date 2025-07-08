import json
from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from Core.models import Commodity
from User.views.user_info import get_user_from_token


class CommodityInfoView(View):
    """
    商品信息视图：获取单个商品详情
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def get(self, request):
        """
        根据商品ID获取商品详情
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

            commodity_id = request.GET.get('commodityId')
            if not commodity_id:
                return JsonResponse({
                    'code': 400,
                    'msg': '缺少商品ID参数',
                    'data': None
                }, status=400)

            try:
                commodity = Commodity.objects.get(id=commodity_id)
            except Commodity.DoesNotExist:
                return JsonResponse({
                    'code': 404,
                    'msg': '商品不存在',
                    'data': None
                }, status=404)

            commodity_data = {
                'id': commodity.id,
                'name': commodity.name,
                'image': commodity.image,
                'brand': commodity.brand,
                'description': commodity.description,
                'price': float(commodity.price),
                'stock': commodity.stock,
                'supplier': commodity.supplier,
                'storageArea': commodity.storage_area,
                'status': commodity.status
            }

            return JsonResponse({
                'code': 200,
                'msg': '获取商品信息成功',
                'data': commodity_data
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'获取商品信息失败: {str(e)}',
                'data': None
            }, status=500)