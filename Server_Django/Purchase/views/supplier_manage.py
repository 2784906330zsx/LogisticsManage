import json
from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.utils import timezone
from Core.models import Supplier
from User.views.user_info import get_user_from_token


class SupplierManageView(View):
    """
    供应商管理视图：新增、修改、删除
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def post(self, request):
        """
        新增供应商
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
            required_fields = ['name', 'type', 'address', 'contactPerson', 'contactPhone', 'contactEmail']
            for field in required_fields:
                if field not in data or not data[field]:
                    return JsonResponse({
                        'code': 400,
                        'msg': f'缺少必填字段: {field}',
                        'data': None
                    }, status=400)

            # 状态映射（前端传中文，后端存数字）
            status_reverse_map = {
                '正常': '1',
                '暂停合作': '2',
                '黑名单': '3'
            }

            # 创建供应商
            supplier = Supplier.objects.create(
                name=data['name'],
                supplier_type=data['type'],
                address=data['address'],
                contact_person=data['contactPerson'],
                contact_phone=data['contactPhone'],
                contact_email=data['contactEmail'],
                status=status_reverse_map.get(data.get('status', '正常'), '1')
            )

            return JsonResponse({
                'code': 200,
                'msg': '供应商创建成功',
                'data': {
                    'id': supplier.id,
                    'name': supplier.name
                }
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'创建供应商失败: {str(e)}',
                'data': None
            }, status=500)

    def put(self, request):
        """
        修改供应商
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

            # 验证供应商ID
            supplier_id = data.get('id')
            if not supplier_id:
                return JsonResponse({
                    'code': 400,
                    'msg': '缺少供应商ID',
                    'data': None
                }, status=400)

            # 查找供应商
            try:
                supplier = Supplier.objects.get(id=supplier_id)
            except Supplier.DoesNotExist:
                return JsonResponse({
                    'code': 404,
                    'msg': '供应商不存在',
                    'data': None
                }, status=404)

            # 状态映射（前端传中文，后端存数字）
            status_reverse_map = {
                '正常': '1',
                '暂停合作': '2',
                '黑名单': '3'
            }

            # 更新供应商信息
            if 'name' in data:
                supplier.name = data['name']
            if 'type' in data:
                supplier.supplier_type = data['type']
            if 'address' in data:
                supplier.address = data['address']
            if 'contactPerson' in data:
                supplier.contact_person = data['contactPerson']
            if 'contactPhone' in data:
                supplier.contact_phone = data['contactPhone']
            if 'contactEmail' in data:
                supplier.contact_email = data['contactEmail']
            if 'status' in data:
                supplier.status = status_reverse_map.get(data['status'], supplier.status)

            supplier.save()

            return JsonResponse({
                'code': 200,
                'msg': '供应商更新成功',
                'data': {
                    'id': supplier.id,
                    'name': supplier.name
                }
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'更新供应商失败: {str(e)}',
                'data': None
            }, status=500)

    def delete(self, request):
        """
        删除供应商
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

            # 验证供应商ID
            supplier_id = data.get('id')
            if not supplier_id:
                return JsonResponse({
                    'code': 400,
                    'msg': '缺少供应商ID',
                    'data': None
                }, status=400)

            # 查找并删除供应商
            try:
                supplier = Supplier.objects.get(id=supplier_id)
                supplier_name = supplier.name
                supplier.delete()

                return JsonResponse({
                    'code': 200,
                    'msg': f'供应商 "{supplier_name}" 删除成功',
                    'data': None
                })
            except Supplier.DoesNotExist:
                return JsonResponse({
                    'code': 404,
                    'msg': '供应商不存在',
                    'data': None
                }, status=404)

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'删除供应商失败: {str(e)}',
                'data': None
            }, status=500)


@csrf_exempt
@require_http_methods(["POST", "PUT", "DELETE"])
def supplier_manage_view(request):
    """
    函数式供应商管理视图（备用）
    """
    view = SupplierManageView()
    if request.method == 'POST':
        return view.post(request)
    elif request.method == 'PUT':
        return view.put(request)
    elif request.method == 'DELETE':
        return view.delete(request)