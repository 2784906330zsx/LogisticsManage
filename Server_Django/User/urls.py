from django.urls import path
from .views.user_list import UserListView
from .views.user_info import UserInfoView


app_name = 'user'

urlpatterns = [
    path('user/list', UserListView.as_view(), name='user_list'),
    path('user/info', UserInfoView.as_view(), name='user_info'),
]
