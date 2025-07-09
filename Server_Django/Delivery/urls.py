from django.urls import path
from .views.static_route_list import StaticRouteListView
from .views.static_route_manage import StaticRouteManageView

urlpatterns = [
    path('static-routes/', StaticRouteListView.as_view(), name='static_route_list'),
    path('static-routes/manage/', StaticRouteManageView.as_view(), name='static_route_manage'),
]
