"""tracker URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from rest_framework.routers import DefaultRouter
from rest_framework.urlpatterns import format_suffix_patterns
from .views import custom_token_obtain_pair, TokenRefreshView, category_list_create, account_list_create, expense_list_create, expense_retrieve_update_destroy, update_account_balance, register_user, get_all_users, login

urlpatterns = [
    path('api/login/', login, name='login'),
    path('api/get_all_users/', get_all_users, name='get_all_users'),
    path('api/token/', custom_token_obtain_pair, name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('api/register/', register_user, name='register_user'),
    path('api/category/', category_list_create, name='category-list-create'),
    path('api/account/', account_list_create, name='account-list-create'),
    path('api/expense/', expense_list_create, name='expense-list-create'),
    path('api/expense/<int:pk>/', expense_retrieve_update_destroy, name='expense-retrieve-update-destroy'),
    path('api/update_balance/', update_account_balance, name='update-account-balance'),
]

urlpatterns = format_suffix_patterns(urlpatterns)
