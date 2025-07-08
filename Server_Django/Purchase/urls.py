from django.urls import path
from .views.supplier_list import SupplierListView
from .views.supplier_manage import SupplierManageView

urlpatterns = [
    path('supplier/list/', SupplierListView.as_view(), name='supplier_list'),
    path('supplier/manage/', SupplierManageView.as_view(), name='supplier_manage'),
]
