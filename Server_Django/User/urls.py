from django.urls import path
from .views.user_list import UserListView
from .views.user_info import UserInfoView
from .views.user_update import UserUpdateView
from .views.user_delete import UserDeleteView
from .views.user_create import UserCreateView
from .views.role.role_list import RoleListView, RoleManageView
from .views.department.department_list import DepartmentListView
from .views.department.department_list import DepartmentManageView


app_name = 'user'

urlpatterns = [
    path('user/list', UserListView.as_view(), name='user_list'),
    path('user/info', UserInfoView.as_view(), name='user_info'),
    path('user/update', UserUpdateView.as_view(), name='user_update'),
    path('user/delete', UserDeleteView.as_view(), name='user_delete'),
    path('user/create', UserCreateView.as_view(), name='user_create'),
    path('role/list', RoleListView.as_view(), name='role_list'),
    path('role/manage', RoleManageView.as_view(), name='role_manage'),
    path('department/list', DepartmentListView.as_view(), name='department_list'),
    path('department/manage', DepartmentManageView.as_view(), name='department_manage'),
]
