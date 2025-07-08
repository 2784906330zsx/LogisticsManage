"""
Django settings for Server_Django project.

使用 Django 5.2.3 版本通过 'django-admin startproject' 命令生成。

关于此文件的更多信息，请参见
https://docs.djangoproject.com/en/5.2/topics/settings/

有关所有设置及其值的完整列表，请参见
https://docs.djangoproject.com/en/5.2/ref/settings/
"""

import os # 导入必要的模块
from dotenv import load_dotenv # 加载环境变量
from pathlib import Path # 处理文件路径
import dj_database_url # 解析数据库URL

load_dotenv() # 加载.env文件中的环境变量

# 构建项目内部路径，例如：BASE_DIR / 'subdir'
# __file__表示当前文件路径，resolve()获取绝对路径，parent.parent返回上两级目录（项目根目录）
BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = "django-insecure--42@i@dd_qfgy%hpip7bitehzg=!8rk+av&m+q#$s*9ybs_y+#"

DEBUG = True

ALLOWED_HOSTS = []

# 应用定义

INSTALLED_APPS = [
    # Django内置应用
    "django.contrib.admin",          # 管理后台
    "django.contrib.auth",           # 认证系统
    "django.contrib.contenttypes",   # 内容类型框架
    "django.contrib.sessions",       # 会话管理
    "django.contrib.messages",       # 消息框架
    "django.contrib.staticfiles",    # 静态文件管理
    # 第三方应用
    "corsheaders",                   # 跨域资源共享支持
    # 自定义应用
    "Auth.apps.AuthConfig",          # 认证相关功能
    "Core.apps.CoreConfig",          # 核心功能模块
    "Delivery.apps.DeliveryConfig",  # 物流配送模块
    "Finance.apps.FinanceConfig",    # 财务管理模块
    "Order.apps.OrderConfig",        # 订单管理模块
    "Purchase.apps.PurchaseConfig",  # 采购管理模块
    "Storage.apps.StorageConfig",    # 库存管理模块
    "User.apps.UserConfig",          # 用户管理模块
]

MIDDLEWARE = [
    "corsheaders.middleware.CorsMiddleware",  # CORS中间件，处理跨域请求
    "django.middleware.security.SecurityMiddleware",  # 安全相关中间件
    "django.contrib.sessions.middleware.SessionMiddleware",  # 会话管理中间件
    "django.middleware.common.CommonMiddleware",  # 通用中间件
    "django.middleware.csrf.CsrfViewMiddleware",  # CSRF保护中间件
    "django.contrib.auth.middleware.AuthenticationMiddleware",  # 认证中间件
    "django.contrib.messages.middleware.MessageMiddleware",  # 消息中间件
    "django.middleware.clickjacking.XFrameOptionsMiddleware",  # 点击劫持保护中间件
]

# CORS配置
CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
    "http://localhost:3006",  # 添加这一行
    "http://127.0.0.1:3006",  # 添加这一行
    "http://localhost:5173",
    "http://127.0.0.1:5173",
]

CORS_ALLOW_CREDENTIALS = True

ROOT_URLCONF = "Server_Django.urls"
# 主URL配置模块
TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",  # 模板引擎后端
        "DIRS": [],  # 模板文件目录（留空则使用应用内的templates目录）
        "APP_DIRS": True,  # 是否在应用目录中查找模板
        "OPTIONS": {
            "context_processors": [  # 上下文处理器
                "django.template.context_processors.request",  # 请求上下文
                "django.contrib.auth.context_processors.auth",  # 认证上下文
                "django.contrib.messages.context_processors.messages",  # 消息上下文
            ],
        },
    },
]
# WSGI应用程序入口
WSGI_APPLICATION = "Server_Django.wsgi.application"


# Database
# https://docs.djangoproject.com/en/5.2/ref/settings/#databases

# 从环境变量获取数据库URL
database_url = os.environ.get("DATABASE_URL")
# 解析数据库URL并配置数据库连接
DATABASES = {"default": dj_database_url.parse(database_url)}


# Password validation
# https://docs.djangoproject.com/en/5.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        # 检查密码与用户属性的相似度
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {
        # 检查密码最小长度
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
    },
    {
        # 检查密码是否为常见密码
        "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
    },
    {
        # 检查密码是否全为数字
        "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
    },
]

LANGUAGE_CODE = "zh-hans"  # 设置语言为简体中文

TIME_ZONE = "Asia/Shanghai"  # 设置时区为亚洲/上海

USE_I18N = True  # 启用国际化

USE_TZ = False   # 不使用时区感知 datetime

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/5.2/howto/static-files/

STATIC_URL = "static/"

# Default primary key field type
# https://docs.djangoproject.com/en/5.2/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

# 自定义用户模型
AUTH_USER_MODEL = 'Core.User'
