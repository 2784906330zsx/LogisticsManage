import json
from django.http import JsonResponse
from django.views import View
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.utils import timezone
from django.db import transaction
from Core.models import Vehicle
from User.views.user_info import get_user_from_token
from datetime import datetime


class VehicleManageView(View):
    """
    车辆管理视图：新增、修改、删除
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def post(self, request):
        """
        新增车辆
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
            required_fields = ['vehicleType', 'plateNumber', 'maxLoad', 'driverJobNumber', 'purchaseTime']
            for field in required_fields:
                if not data.get(field):
                    return JsonResponse({
                        'code': 400,
                        'msg': f'缺少必填字段: {field}',
                        'data': None
                    }, status=400)

            # 验证车牌号是否已存在
            if Vehicle.objects.filter(plate_number=data['plateNumber']).exists():
                return JsonResponse({
                    'code': 400,
                    'msg': '车牌号已存在',
                    'data': None
                }, status=400)

            # 解析购入时间
            purchase_time = datetime.strptime(data['purchaseTime'], '%Y-%m-%d %H:%M:%S')

            # 创建车辆
            vehicle = Vehicle.objects.create(
                vehicle_type=data['vehicleType'],
                plate_number=data['plateNumber'],
                current_load=data.get('currentLoad', 0),
                max_load=int(data['maxLoad']),
                health_status=data.get('healthStatus', '正常'),
                storage_status=data.get('storageStatus', '在库待命'),
                current_route=data.get('currentRoute', ''),
                driver_job_number=data['driverJobNumber'],
                purchase_time=purchase_time,
                is_enabled=data.get('isEnabled', True)
            )

            return JsonResponse({
                'code': 200,
                'msg': '车辆创建成功',
                'data': {
                    'id': vehicle.id,
                    'plateNumber': vehicle.plate_number
                }
            })

        except json.JSONDecodeError:
            return JsonResponse({
                'code': 400,
                'msg': '请求数据格式错误',
                'data': None
            }, status=400)
        except ValueError as e:
            return JsonResponse({
                'code': 400,
                'msg': f'数据格式错误: {str(e)}',
                'data': None
            }, status=400)
        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'创建车辆失败: {str(e)}',
                'data': None
            }, status=500)

    def put(self, request):
        """
        修改车辆信息
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

            # 验证车辆ID
            vehicle_id = data.get('id')
            if not vehicle_id:
                return JsonResponse({
                    'code': 400,
                    'msg': '缺少车辆ID',
                    'data': None
                }, status=400)

            # 查找车辆
            try:
                vehicle = Vehicle.objects.get(id=vehicle_id)
            except Vehicle.DoesNotExist:
                return JsonResponse({
                    'code': 404,
                    'msg': '车辆不存在',
                    'data': None
                }, status=404)

            # 验证车牌号唯一性（如果修改了车牌号）
            if 'plateNumber' in data and data['plateNumber'] != vehicle.plate_number:
                if Vehicle.objects.filter(plate_number=data['plateNumber']).exists():
                    return JsonResponse({
                        'code': 400,
                        'msg': '车牌号已存在',
                        'data': None
                    }, status=400)

            # 更新车辆信息
            if 'vehicleType' in data:
                vehicle.vehicle_type = data['vehicleType']
            if 'plateNumber' in data:
                vehicle.plate_number = data['plateNumber']
            if 'currentLoad' in data:
                vehicle.current_load = int(data['currentLoad'])
            if 'maxLoad' in data:
                vehicle.max_load = int(data['maxLoad'])
            if 'healthStatus' in data:
                vehicle.health_status = data['healthStatus']
            if 'storageStatus' in data:
                vehicle.storage_status = data['storageStatus']
            if 'currentRoute' in data:
                vehicle.current_route = data['currentRoute']
            if 'driverJobNumber' in data:
                vehicle.driver_job_number = data['driverJobNumber']
            if 'purchaseTime' in data:
                vehicle.purchase_time = datetime.strptime(data['purchaseTime'], '%Y-%m-%d %H:%M:%S')
            if 'isEnabled' in data:
                vehicle.is_enabled = data['isEnabled']

            vehicle.save()

            return JsonResponse({
                'code': 200,
                'msg': '车辆信息更新成功',
                'data': {
                    'id': vehicle.id,
                    'plateNumber': vehicle.plate_number
                }
            })

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'更新车辆信息失败: {str(e)}',
                'data': None
            }, status=500)

    def delete(self, request):
        """
        删除车辆
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

            # 验证车辆ID
            vehicle_id = data.get('id')
            if not vehicle_id:
                return JsonResponse({
                    'code': 400,
                    'msg': '缺少车辆ID',
                    'data': None
                }, status=400)

            # 查找并删除车辆
            try:
                vehicle = Vehicle.objects.get(id=vehicle_id)
                plate_number = vehicle.plate_number
                vehicle.delete()

                return JsonResponse({
                    'code': 200,
                    'msg': f'车辆 "{plate_number}" 删除成功',
                    'data': None
                })
            except Vehicle.DoesNotExist:
                return JsonResponse({
                    'code': 404,
                    'msg': '车辆不存在',
                    'data': None
                }, status=404)

        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'删除车辆失败: {str(e)}',
                'data': None
            }, status=500)
