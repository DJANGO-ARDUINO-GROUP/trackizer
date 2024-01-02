from django.urls import path
from django.urls import path
from rest_framework.routers import DefaultRouter
from rest_framework.urlpatterns import format_suffix_patterns
from .views import (
    register_user,
    category_list_create,
    account_list_create,
    expense_list_create,
    expense_retrieve_update_destroy,
    update_user_balance,
    get_all_users,
    login,
    get_current_user_profile,
    delete_category,
    get_overall_expense,
)

urlpatterns = [
    path('api/get_current_user_profile/', get_current_user_profile, name='get_current_user_profile'),
    path('api/login/', login, name='login'),
    path('api/register/', register_user, name='register_user'),
    path('api/categories/', category_list_create, name='category_list_create'),
    path('api/categories/<int:category_id>/', delete_category, name='delete_category'),
    path('api/accounts/', account_list_create, name='account_list_create'),
    path('api/expenses/', expense_list_create, name='expense_list_create'),
    path('api/expenses/<int:pk>/', expense_retrieve_update_destroy, name='expense_retrieve_update_destroy'),
    path('api/update_balance/', update_user_balance, name='update_user_balance'),
    path('api/get_all_users/', get_all_users, name='get_all_users'),
    path('api/get_overall_expense/', get_overall_expense, name='get_overall_expense'),
]


urlpatterns = format_suffix_patterns(urlpatterns)