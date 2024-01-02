import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
        final user = User.fromJson(loginResponse);
        Get.offAll(() => const HomeScreen());
        print(user.name);
        return user;
        
      } else {
        Get.snackbar(
          "",
          "",
          titleText: const Text(
            "Error",
            style: TextStyle(color: Colors.white),
          ),
          messageText: const Text(
            "Error trying to login",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        "Error",
        "$e",
        titleText: Text(
          "$e",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );
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
      } else {
        Get.snackbar(
          "",
          "",
          titleText: const Text(
            "Error",
            style: TextStyle(color: Colors.white),
          ),
          messageText: const Text(
            "Error trying to register",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar(
        "Error",
        "$e",
        titleText: Text(
          "$e",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );
    }
  }

  Future updateBalance(int bal, String operation) async {
    final String token = await secureStorage.readSecureData("auth_token");

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update_balance/'),
        body: jsonEncode(
          {
            'amount': bal,
            'operation': operation,
          },
        ),
        headers: {
          'Accept': '*/*',
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        Get.snackbar(
          "",
          "",
          titleText: const Text(
            "Success!",
            style: TextStyle(color: Colors.white),
          ),
          messageText: const Text(
            "Balance updated successfully!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        );
      } else {
        Get.snackbar(
          "",
          "",
          titleText: const Text(
            "Error",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            "Failed to update balance. Status code: ${response.statusCode}",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "$e",
        titleText: Text(
          "$e",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );
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
        Get.snackbar(
          "",
          "",
          titleText: const Text(
            "Success!",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            "Created category: ${data['name']}",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        );
        return data;
      } else {
        Get.snackbar(
          "",
          "",
          titleText: const Text(
            "Error",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            "Try Again. Status code: ${response.statusCode}",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "$e",
        titleText: Text(
          "$e",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );
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

  Future addExpense(
      String title, String amount, int categoryid, String date) async {
    final String token = await secureStorage.readSecureData("auth_token");
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/expenses/'),
        body: jsonEncode(
          {
            'title': title,
            'amount': amount,
            'category': categoryid,
            'date': date,
          },
        ),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 201) {
        Get.snackbar(
          "",
          "",
          titleText: const Text(
            "Success!",
            style: TextStyle(color: Colors.white),
          ),
          messageText: const Text(
            "Expense Added Successfully",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        );
      } else {
        Get.snackbar(
          "",
          "",
          titleText: const Text(
            "Error",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            "Try Again. Status code: ${response.statusCode}",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "$e",
        titleText: Text(
          "$e",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );
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
