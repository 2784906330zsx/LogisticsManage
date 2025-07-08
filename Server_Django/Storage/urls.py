from django.urls import path
from .views.commodity_list import CommodityListView
from .views.commodity_manage import CommodityManageView
from .views.inventory_list import InventoryListView
from .views.inventory_adjust import InventoryAdjustView

app_name = 'storage'

urlpatterns = [
    # 商品管理
    path('commodity/list', CommodityListView.as_view(), name='commodity_list'),
    path('commodity/manage', CommodityManageView.as_view(), name='commodity_manage'),
    
    # 库存管理
    path('inventory/list', InventoryListView.as_view(), name='inventory_list'),
    path('inventory/adjust/', InventoryAdjustView.as_view(), name='inventory_adjust'),
]