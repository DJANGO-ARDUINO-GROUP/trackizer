# from django.contrib.auth.models import User
# from django.db import models

# class Category(models.Model):
#     name = models.CharField(max_length=255)

#     def __str__(self):
#         return self.name

# def get_default_user():
#     return User.objects.get(username='your_default_username')

# class Account(models.Model):
#     user = models.OneToOneField(User, on_delete=models.CASCADE, null=True)
#     name = models.CharField(max_length=255)
#     balance = models.DecimalField(max_digits=10, decimal_places=2)
   

#     def __str__(self):
#         return self.name

# class Expense(models.Model):
#     user = models.ForeignKey(User, on_delete=models.CASCADE)
#     title = models.CharField(max_length=255)
#     amount = models.DecimalField(max_digits=10, decimal_places=2)
#     date = models.DateField()
#     category = models.ForeignKey(Category, on_delete=models.CASCADE)
#     account = models.ForeignKey(Account, on_delete=models.CASCADE)

#     def __str__(self):
#         return self.title
from django.contrib.auth.models import User
from django.db import models

class Category(models.Model):
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.name

class Account(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, null=True)
    name = models.CharField(max_length=255)
    balance = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return self.name

class Expense(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    title = models.CharField(max_length=255)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    date = models.DateField()
    category = models.ForeignKey(Category, on_delete=models.CASCADE)
    account = models.ForeignKey(Account, on_delete=models.CASCADE)

    def __str__(self):
        return self.title
