from django.urls import path
from .views.static_route_list import StaticRouteListView
from .views.static_route_manage import StaticRouteManageView
from .views.vehicle_list import VehicleListView
from .views.vehicle_manage import VehicleManageView

urlpatterns = [
    path('static-routes/', StaticRouteListView.as_view(), name='static_route_list'),
    path('static-routes/manage/', StaticRouteManageView.as_view(), name='static_route_manage'),
    path('vehicles/', VehicleListView.as_view(), name='vehicle_list'),
    path('vehicles/manage/', VehicleManageView.as_view(), name='vehicle_manage'),
]
