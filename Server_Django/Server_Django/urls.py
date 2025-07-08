from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/auth/', include('Auth.urls')),
    path('api/', include('User.urls')),
    path('api/', include('Storage.urls')),
    path('api/', include('Purchase.urls')),
]
