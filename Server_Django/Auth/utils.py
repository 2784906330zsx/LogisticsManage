import jwt
from django.conf import settings
from Core.models import User


def get_user_from_token(request):
    """
    从请求中提取JWT token并返回用户对象

    Args:
        request: Django请求对象

    Returns:
        User: 用户对象，如果token无效则返回None
    """
    try:
        # 获取Authorization头
        auth_header = request.META.get('HTTP_AUTHORIZATION')
        if not auth_header or not auth_header.startswith('Bearer '):
            return None

        # 解析token
        token = auth_header.split(' ')[1]
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=['HS256'])
        user_id = payload.get('user_id')

        # 获取用户对象
        user = User.objects.get(id=user_id)
        return user

    except (jwt.ExpiredSignatureError, jwt.InvalidTokenError, User.DoesNotExist, Exception):
        return None
