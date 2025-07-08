from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/auth/', include('Auth.urls')),
    path('api/', include('User.urls')),
    path('api/storage/', include('Storage.urls')),
    path('api/purchase/', include('Purchase.urls')),
    path('api/finance/', include('Finance.urls')),
    path('api/delivery/', include('Delivery.urls')),
    path('api/order/', include('Order.urls'))
]
