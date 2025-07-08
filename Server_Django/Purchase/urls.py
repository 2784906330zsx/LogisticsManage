from django.urls import path
from .views.supplier_list import SupplierListView
from .views.supplier_manage import SupplierManageView
from .views.purchase_order_list import PurchaseOrderListView
from .views.purchase_order_manage import PurchaseOrderManageView

urlpatterns = [
    path('supplier/list/', SupplierListView.as_view(), name='supplier_list'),
    path('supplier/manage/', SupplierManageView.as_view(), name='supplier_manage'),
    path('order/list/', PurchaseOrderListView.as_view(), name='purchase_order_list'),
    path('order/manage/', PurchaseOrderManageView.as_view(), name='purchase_order_manage'),
]
