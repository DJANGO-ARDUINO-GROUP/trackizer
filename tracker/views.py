from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from rest_framework_simplejwt.tokens import RefreshToken 
from rest_framework.authentication import SessionAuthentication, BasicAuthentication, TokenAuthentication
from rest_framework.permissions import AllowAny
from rest_framework.permissions import IsAuthenticated
from rest_framework.generics import get_object_or_404
from django.shortcuts import get_object_or_404
from rest_framework.authtoken.models import Token
from django.contrib.auth import authenticate
from datetime import timedelta
from django.contrib.auth.models import User
from .models import Category, Account, Expense
from .serializers import CategorySerializer, AccountSerializer, ExpenseSerializer, UserSerializer


@api_view(['POST'])
def login(request):
    user = get_object_or_404(User, username=request.data['username'])
    if not user.check_password(request.data['password']):
        Response({'detail': 'Not found'}, status=status.HTTP_404_NOT_FOUND)
    token, created = Token.objects.get_or_create(user=user)
    serializer = UserSerializer(instance=user)
    return Response({"token": token.key, "user": serializer.data})

@api_view(['POST'])
@permission_classes([AllowAny])
def custom_token_obtain_pair(request):
    if request.method == 'POST':
        username = request.data.get('username')
        password = request.data.get('password')
        email = request.data.get('email')

        print(f"Attempting login for user: {username}")

        # Authenticate user
        user = authenticate(username=username, password=password)

        if user is not None:
            print(f"User {username} authenticated successfully")

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
            }

            print("Generated Token Data:", data)

            return Response(data, status=status.HTTP_200_OK)

        print(f"User {username} authentication failed")
        return Response({'detail': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)

@api_view(['POST'])
# def register_user(request):
    # """
    # Register a new user and generate a token.
    # """
    # if request.method == 'POST':
      
    #     serializer = UserSerializer(data=request.data)
    #     if serializer.is_valid():
          
    #         user = serializer.save()
           
    #         refresh = RefreshToken.for_user(user)
    #         access_token = str(refresh.access_token)
    #         data = {
    #             'access_token': access_token,
    #             'user_id': user.id,
    #             'username': user.username,
    #             'email': user.email,
    #             'first_name': user.first_name,
    #             'last_name': user.last_name,
    #         }
    #         return Response(data, status=status.HTTP_201_CREATED)
    #     return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
def register_user(request):
    """
    Register a new user and generate a token. Also, create an account for the user.
    """
    if request.method == 'POST':
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()

            # Create an account for the user
            account_data = {'user': user.id, 'name': f"{user.username}'s Account", 'balance': 0.0}
            account_serializer = AccountSerializer(data=account_data)
            
            if account_serializer.is_valid():
                account_serializer.save()

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
                }

                return Response(data, status=status.HTTP_201_CREATED)

            # If creating the account fails, delete the user
            user.delete()
            
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'POST'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def category_list_create(request):
    if request.method == 'GET':
        categories = Category.objects.all()
        serializer = CategorySerializer(categories, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = CategorySerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'POST'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def account_list_create(request):
    # if request.method == 'GET':
    #     accounts = Account.objects.all()
    #     serializer = AccountSerializer(accounts, many=True)
    #     return Response(serializer.data)

    # elif request.method == 'POST':
    #     serializer = AccountSerializer(data=request.data)
    #     if serializer.is_valid():
    #         serializer.save()
    #         return Response(serializer.data, status=status.HTTP_201_CREATED)
    #     return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    if request.method == 'GET':
        accounts = Account.objects.all()
        serializer = AccountSerializer(accounts, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        # Check if the user already has an account
        user_account = Account.objects.filter(user=request.user).first()

        if user_account:
            serializer = AccountSerializer(user_account)
            return Response(serializer.data, status=status.HTTP_200_OK)
        else:
            # Create an account for the user
            account_data = {'user': request.user.id, 'name': f"{request.user.username}'s Account", 'balance': 0.0}
            serializer = AccountSerializer(data=account_data)

            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)

            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
        

@api_view(['GET', 'POST'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def expense_list_create(request):
    # if request.method == 'GET':
    #     expenses = Expense.objects.all()
    #     serializer = ExpenseSerializer(expenses, many=True)
    #     return Response(serializer.data)

    # elif request.method == 'POST':
    #     serializer = ExpenseSerializer(data=request.data)
    #     if serializer.is_valid():
    #         expense = serializer.save()
    #         # Update the account balance
    #         expense.account.balance -= expense.amount
    #         expense.account.save()
    #         return Response(serializer.data, status=status.HTTP_201_CREATED)
    #     return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    if request.method == 'GET':
        expenses = Expense.objects.filter(user=request.user)
        serializer = ExpenseSerializer(expenses, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = ExpenseSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
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
            # Adjust the account balance by adding back the old amount and subtracting the new amount
            expense.account.balance += expense.amount
            expense.account.balance -= serializer.validated_data['amount']
            expense.account.save()
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        # Adjust the account balance by adding back the amount before deleting the expense
        expense.account.balance += expense.amount
        expense.account.save()
        expense.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


@api_view(['PUT'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def update_account_balance(request):
    # instead of using a static pk, we can use a dynamic pk that can be gotten from the currently authenticated user
    user = request.user
    account = get_object_or_404(Account, user=user)

    if request.method == 'PUT':
        amount = request.data.get('amount', 0)
        # Determine whether to add or subtract based on the operation specified
        operation = request.data.get('operation')

        if operation == 'add':
            account.balance += amount
        elif operation == 'subtract':
            account.balance -= amount

        account.save()
        return Response({'balance': account.balance})
    return Response(status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def get_all_users(request):
    """
    Get a list of all users in the database.
    """
    if request.method == 'GET':
        # Retrieve all users from the User model
        users = User.objects.all()

        # Serialize the users
        user_data = [{'id': user.id, 'username': user.username, 'email': user.email, 'password': user.password} for user in users]

        return Response(user_data, status=status.HTTP_200_OK)