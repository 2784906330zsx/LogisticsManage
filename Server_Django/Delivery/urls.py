from django.urls import path
from .views.static_route_list import StaticRouteListView
from .views.static_route_manage import StaticRouteManageView
from .views.vehicle_list import VehicleListView
from .views.vehicle_manage import VehicleManageView
from .views.delivery_order_list import DeliveryOrderListView
from .views.shipping_order_assign import ShippingOrderAssignView

urlpatterns = [
    path('static-route/list/', StaticRouteListView.as_view(), name='static_route_list'),
    path('static-route/manage/', StaticRouteManageView.as_view(), name='static_route_manage'),
    path('vehicle/list/', VehicleListView.as_view(), name='vehicle_list'),
    path('vehicle/manage/', VehicleManageView.as_view(), name='vehicle_manage'),
    path('order/list/', DeliveryOrderListView.as_view(), name='delivery_order_list'),
    path('order/assign/', ShippingOrderAssignView.as_view(), name='shipping_order_assign'),
]
