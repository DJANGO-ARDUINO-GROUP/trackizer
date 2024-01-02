import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:trackizer/models/user.dart';
import 'package:trackizer/screens/home_screen.dart';
import 'package:trackizer/screens/login_screen.dart';
import 'package:trackizer/secure_storage.dart';
import 'package:get/get.dart';

class DjangoApiClient {
  final String baseUrl = 'https://group-api.onrender.com/api';
  final SecureStorage secureStorage = SecureStorage();

  Future logOut() async {
    await secureStorage.deleteSecureData("auth_token");
    Get.offAll(() => const LoginScreen());
  }

  Future loginUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
        },
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final loginResponse = jsonDecode(response.body);
        print(loginResponse);
        await secureStorage.writeSecureData(
            "auth_token", loginResponse['token']);
        final user = User.fromJson(loginResponse['user']);
        Get.offAll(() => const HomeScreen());
        return user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future registerUser(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201) {
        if (kDebugMode) {
          print(jsonDecode(response.body));
        }
        final user = userFromJson(response.body);
        Get.offAll(() => const LoginScreen());
        return user;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future getCategoryList() async {
    final token = await secureStorage.readSecureData("auth_token");
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories/'),
        headers: {'Authorization': 'Token $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        return data;
      } else {
        throw Exception('Failed to fetch categories');
      }
    } catch (e) {
      print(e);
    }
  }

  Future createCategory(String categoryData) async {
    final token = await secureStorage.readSecureData("auth_token");
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/categories/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
          {
            'name': categoryData,
          },
        ),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print(data);
        return data;
      }
    } catch (e) {
      print(e);
    }
  }

  Future deleteCategory(int categoryId) async {
    final token = await secureStorage.readSecureData("auth_token");
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/categories/$categoryId/'),
        headers: {'Authorization': 'Token $token'},
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete category');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> getAccountList() async {
    final token = secureStorage.readSecureData("auth_token");
    final response = await http.get(
      Uri.parse('$baseUrl/accounts/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch accounts');
    }
  }

  Future getCurrentUser() async {
    final token = await secureStorage.readSecureData("auth_token");
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_current_user_profile/'),
        headers: {
          'Accept': '*/*',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final dynamic decodedData = jsonDecode(response.body);
        // print('Decoded Data: $decodedData');
        return decodedData;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }

    return null;
  }

  Future addExpense(String title, String amount, String categoryid) async {
    final String token = await secureStorage.readSecureData("auth_token");
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/expenses/'),
        body: {
          'title': title,
          'amount': amount,
          // Assuming you have a default category and account, you may need to modify this part
          'category': categoryid, // Replace with the actual category ID
          // 'account': '1', // Replace with the actual account ID
        },
        headers: {
          'Accept': '*/*',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 201) {
        if (kDebugMode) {
          print('Expense added successfully!');
        }
      } else {
        if (kDebugMode) {
          print('Failed to add expense. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future getExpenses() async {
    final String token = await secureStorage.readSecureData("auth_token");
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/expenses/'),
        headers: {
          'Accept': '*/*',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Handle the fetched data as needed
        if (kDebugMode) {
          print(data.runtimeType);
        }
        return data;
      } else {
        if (kDebugMode) {
          print(
              'Failed to fetch expenses. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future updateExpense(int expenseId) async {
    final String token = await secureStorage.readSecureData("auth_token");
    final response = await http.put(
      Uri.parse('$baseUrl/expenses/$expenseId/'),
      body: {
        'title': 'Updated Title',
        'amount': '50.0', // Replace with the new amount
      },
      headers: {
        'Accept': '*/*',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Expense updated successfully!');
      }
    } else {
      if (kDebugMode) {
        print('Failed to update expense. Status code: ${response.statusCode}');
      }
    }
  }

  Future deleteExpense(int expenseId) async {
    final String token = await secureStorage.readSecureData("auth_token");
    final response = await http.delete(
      Uri.parse('$baseUrl/expenses/$expenseId/'),
      headers: {
        'Accept': '*/*',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 204) {
      if (kDebugMode) {
        print('Expense deleted successfully!');
      }
    } else {
      if (kDebugMode) {
        print('Failed to delete expense. Status code: ${response.statusCode}');
      }
    }
  }
}
