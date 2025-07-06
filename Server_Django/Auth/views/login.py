import jwt
import json
from datetime import datetime, timedelta
from django.conf import settings
from django.contrib.auth import authenticate
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.utils.decorators import method_decorator
from django.views import View
from Core.models import User


class LoginView(View):
    """
    用户登录视图
    """

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super().dispatch(request, *args, **kwargs)

    def post(self, request):
        try:
            # 解析请求数据
            data = json.loads(request.body)
            username = data.get('userName')
            password = data.get('password')

            # 参数验证
            if not username or not password:
                return JsonResponse({
                    'code': 400,
                    'msg': '用户名和密码不能为空',
                    'data': None
                }, status=400)

            # 用户认证
            user = authenticate(request, username=username, password=password)
            if not user:
                return JsonResponse({
                    'code': 401,
                    'msg': '用户名或密码错误',
                    'data': None
                }, status=401)

            # 生成JWT token
            token_payload = {
                'user_id': user.id,
                'username': user.username,
                'exp': datetime.utcnow() + timedelta(hours=24),  # 24小时过期
                'iat': datetime.utcnow()
            }

            refresh_payload = {
                'user_id': user.id,
                'username': user.username,
                'exp': datetime.utcnow() + timedelta(days=7),  # 7天过期
                'iat': datetime.utcnow(),
                'type': 'refresh'
            }

            # 使用Django的SECRET_KEY作为JWT密钥
            secret_key = settings.SECRET_KEY
            token = jwt.encode(token_payload, secret_key, algorithm='HS256')
            refresh_token = jwt.encode(refresh_payload, secret_key, algorithm='HS256')

            return JsonResponse({
                'code': 200,
                'msg': '登录成功',
                'data': {
                    'token': token,
                    'refreshToken': refresh_token
                }
            })

        except json.JSONDecodeError:
            return JsonResponse({
                'code': 400,
                'msg': '请求数据格式错误',
                'data': None
            }, status=400)
        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'服务器内部错误: {str(e)}',
                'data': None
            }, status=500)


@csrf_exempt
@require_http_methods(["POST"])
def login_view(request):
    """
    函数式登录视图（备用）
    """
    view = LoginView()
    return view.post(request)
