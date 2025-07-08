from django.urls import path
from .views.order_review import OrderReviewView
from .views.expenditure_record import ExpenditureRecordView
from Finance.views.income_record import IncomeRecordView

urlpatterns = [
    path('order/review/', OrderReviewView.as_view(), name='order_review'),
    path('expenditure/record/', ExpenditureRecordView.as_view(), name='expenditure_record'),
    path('income/record/', IncomeRecordView.as_view(), name='income_record'),
]
