from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.generics import get_object_or_404
from rest_framework.authentication import SessionAuthentication, BasicAuthentication, TokenAuthentication
from django.contrib.auth.models import User
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.authtoken.models import Token
from django.contrib.auth import authenticate
from datetime import timedelta
from .models import Category, UserProfile, Expense
from .serializers import UserSerializer, CategorySerializer, UserProfileSerializer, ExpenseSerializer


@api_view(['POST', 'OPTIONS'])
@permission_classes([AllowAny])
def login(request):
    user = get_object_or_404(User, username=request.data['username'])
    if not user.check_password(request.data['password']):
        Response({'detail': 'Not found'}, status=status.HTTP_404_NOT_FOUND)
    token, created = Token.objects.get_or_create(user=user)
    serializer = UserSerializer(instance=user)
    return Response({"token": token.key, "user": serializer.data})


@api_view(['POST', 'OPTIONS'])
@permission_classes([AllowAny])
def register_user(request):
    """
    Register a new user and generate a token. Also, create an account for the user.
    """
    if request.method == 'POST':
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()

            # Create a UserProfile for the user
            UserProfile.objects.create(user=user, name=user.username, balance=0.0)

            # Generate token
            refresh = RefreshToken.for_user(user)
            access_token = str(refresh.access_token)

            data = {
                'access_token': access_token,
                'user_id': user.id,
                'username': user.username,
                'email': user.email,
                'first_name': user.first_name,
                'last_name': user.last_name,
                'password': user.password,
            }

            return Response(data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'POST'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def category_list_create(request):
    if request.method == 'GET':
        categories = Category.objects.filter(user=request.user)
        serializer = CategorySerializer(categories, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = CategorySerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['DELETE'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def delete_category(request, category_id):
    try:
        category = Category.objects.get(id=category_id, user=request.user)
    except Category.DoesNotExist:
        return Response({'detail': 'Category not found'}, status=status.HTTP_404_NOT_FOUND)

    category.delete()
    return Response({'detail': 'Category deleted successfully'}, status=status.HTTP_204_NO_CONTENT)


@api_view(['GET', 'POST'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def account_list_create(request):
    if request.method == 'GET':
        accounts = UserProfile.objects.filter(user=request.user)
        serializer = UserProfileSerializer(accounts, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        # Check if the user already has an account
        user_profile = UserProfile.objects.filter(user=request.user).first()

        if user_profile:
            serializer = UserProfileSerializer(user_profile)
            return Response(serializer.data, status=status.HTTP_200_OK)
        else:
            # Create an account for the user
            account_data = {'user': request.user, 'name': f"{request.user.username}'s Account", 'balance': 0.0}
            serializer = UserProfileSerializer(data=account_data)

            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)

            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'POST'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def expense_list_create(request):
    if request.method == 'GET':
        expenses = Expense.objects.filter(user=request.user)
        serializer = ExpenseSerializer(expenses, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        # Set 'account' to the current user profile's ID
        account_id = request.user.userprofile.id
        request_data = {**request.data, 'account': account_id}

        serializer = ExpenseSerializer(data=request_data, context={'request': request})
        if serializer.is_valid():
            serializer.save(user=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'PUT', 'DELETE'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def expense_retrieve_update_destroy(request, pk):
    expense = get_object_or_404(Expense, pk=pk)

    if request.method == 'GET':
        serializer = ExpenseSerializer(expense)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = ExpenseSerializer(expense, data=request.data)
        if serializer.is_valid():
            # Adjust the user profile balance by adding back the old amount and subtracting the new amount
            user_profile = UserProfile.objects.get(user=request.user)
            user_profile.balance += expense.amount
            user_profile.balance -= serializer.validated_data['amount']
            user_profile.save()
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        # Adjust the user profile balance by adding back the amount before deleting the expense
        user_profile = UserProfile.objects.get(user=request.user)
        user_profile.balance += expense.amount
        user_profile.save()
        expense.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


@api_view(['PUT'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def update_user_balance(request):
    user_profile = UserProfile.objects.get(user=request.user)

    if request.method == 'PUT':
        amount = request.data.get('amount', 0)
        # Determine whether to add or subtract based on the operation specified
        operation = request.data.get('operation')

        if operation == 'add':
            user_profile.balance += amount
        elif operation == 'subtract':
            user_profile.balance -= amount

        user_profile.save()
        return Response({'balance': user_profile.balance})
    return Response(status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
# @authentication_classes([SessionAuthentication, TokenAuthentication])
# @permission_classes([IsAuthenticated])
def get_all_users(request):
    users = UserProfile.objects.all()
    serializer = UserProfileSerializer(users, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)


@api_view(['GET'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_current_user_profile(request):
    user_profile = UserProfile.objects.get(user=request.user)
    serializer = UserProfileSerializer(user_profile)
    balance_as_decimal = Decimal(user_profile.balance)
    serialized_data = serializer.data
    serialized_data['balance'] = balance_as_decimal
    return Response(serializer.data, status=status.HTTP_200_OK)