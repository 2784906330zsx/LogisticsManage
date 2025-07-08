from django.urls import path
from .views.shipping_order import ShippingOrderView
from .views.commodity_info import CommodityInfoView

urlpatterns = [
    path('order/', ShippingOrderView.as_view(), name='shipping_order'),
    path('commodity/info/', CommodityInfoView.as_view(), name='commodity_info'),
]