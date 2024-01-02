from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Category, UserProfile, Expense

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'password']

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['id', 'name']

class UserProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer()

    class Meta:
        model = UserProfile
        fields = ['user', 'name', 'balance']

    def create(self, validated_data):
        user_data = validated_data.pop('user')
        user = User.objects.create(**user_data)
        profile = UserProfile.objects.create(user=user, **validated_data)
        return profile

class ExpenseSerializer(serializers.ModelSerializer):
    user = serializers.HiddenField(default=serializers.CurrentUserDefault())
    category_name = serializers.SerializerMethodField()
    class Meta:
        model = Expense
        fields = '__all__'

    def validate_amount(self, value):
        if value < 0:
            raise serializers.ValidationError("Amount must be non-negative.")
        return value
    
    def get_category_name(self, obj):
        return obj.category.name
