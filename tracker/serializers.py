from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Category, Account, Expense

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'password']

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'

class AccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields = '__all__'

class ExpenseSerializer(serializers.ModelSerializer):
    user = serializers.HiddenField(default=serializers.CurrentUserDefault())
    account_id = serializers.PrimaryKeyRelatedField(queryset=Account.objects.all(), source='account', write_only=True)

    class Meta:
        model = Expense
        fields = ['id', 'user', 'title', 'amount', 'date', 'category', 'account_id']

    def create(self, validated_data):
        account = validated_data.pop('account', None)  # Remove 'account' from validated_data
        expense = super().create(validated_data)

        # If an account is provided in the request data, associate the expense with that account
        if account:
            expense.account = account
            expense.save()

        return expense


# from rest_framework import serializers
# from django.contrib.auth.models import User
# from .models import Category, Account, Expense

# class CategorySerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Category
#         fields = '__all__'

# class AccountSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Account
#         fields = '__all__'

# class ExpenseSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Expense
#         fields = '__all__'

# class UserSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = User
#         fields = ['username', 'password']
#         extra_kwargs = {'password': {'write_only': True}}

#     def create(self, validated_data):
#         user = User(username=validated_data['username'])
#         user.set_password(validated_data['password'])
#         user.save()
#         return user