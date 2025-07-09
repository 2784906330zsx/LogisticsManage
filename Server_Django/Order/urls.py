from django.urls import path
from .views.shipping_order import ShippingOrderView
from .views.commodity_info import CommodityInfoView
from .views.shipping_order_confirm import ShippingOrderConfirmView
from .views.shipping_order_return_review import ShippingOrderReturnReviewView

urlpatterns = [
    path('order/', ShippingOrderView.as_view(), name='shipping_order'),
    path('commodity/info/', CommodityInfoView.as_view(), name='commodity_info'),
    path('confirm/', ShippingOrderConfirmView.as_view(), name='shipping_order_confirm'),
    path('return-review/', ShippingOrderReturnReviewView.as_view(), name='shipping_order_return_review'),
]