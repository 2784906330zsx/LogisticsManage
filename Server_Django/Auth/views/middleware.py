import jwt
from django.conf import settings
from django.http import JsonResponse
from django.utils.deprecation import MiddlewareMixin
from Core.models import User


class JWTAuthenticationMiddleware(MiddlewareMixin):
    """
    JWT认证中间件
    """

    def process_request(self, request):
        # 不需要认证的路径
        exempt_paths = [
            '/api/auth/login',
            '/admin/',
            '/api/auth/register',
            '/api/auth/forget-password'
        ]

        # 检查是否为免认证路径
        if any(request.path.startswith(path) for path in exempt_paths):
            return None

        # 检查是否为API路径
        if not request.path.startswith('/api/'):
            return None

        # 获取Authorization头
        auth_header = request.META.get('HTTP_AUTHORIZATION')
        if not auth_header or not auth_header.startswith('Bearer '):
            return JsonResponse({
                'code': 401,
                'msg': '缺少认证token',
                'data': None
            }, status=401)

        # 解析token
        token = auth_header.split(' ')[1]
        try:
            payload = jwt.decode(token, settings.SECRET_KEY, algorithms=['HS256'])
            user_id = payload.get('user_id')
            user = User.objects.get(id=user_id)

            # 将用户信息添加到request中
            request.user = user
            return None

        except jwt.ExpiredSignatureError:
            return JsonResponse({
                'code': 401,
                'msg': 'Token已过期，请重新登录',
                'data': None
            }, status=401)
        except jwt.InvalidTokenError:
            return JsonResponse({
                'code': 401,
                'msg': '无效的token',
                'data': None
            }, status=401)
        except User.DoesNotExist:
            return JsonResponse({
                'code': 401,
                'msg': '用户不存在',
                'data': None
            }, status=401)
        except Exception as e:
            return JsonResponse({
                'code': 500,
                'msg': f'认证失败: {str(e)}',
                'data': None
            }, status=500)
