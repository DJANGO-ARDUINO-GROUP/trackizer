from django.contrib import admin
from .models import Category
from .models import Account
from .models import Expense

admin.site.register(Category)
admin.site.register(Account)
admin.site.register(Expense)