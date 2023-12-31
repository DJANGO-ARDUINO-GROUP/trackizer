import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trackizer/login_screen.dart';
import 'package:trackizer/main.dart';
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
        // print(jsonDecode(response.body));
        // final loginResponse = jsonDecode(response.body);
        // await secureStorage.writeSecureData("auth_token", loginResponse['token']);
        Get.offAll(() => const MyHomePage());
        // print(loginResponse['token']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register_user/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<List<Map<String, dynamic>>> getCategoryList() async {
    final token = secureStorage.readSecureData("auth_token");
    final response = await http.get(
      Uri.parse('$baseUrl/category_list_create/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  Future<Map<String, dynamic>> createCategory(
      Map<String, dynamic> categoryData) async {
    final token = secureStorage.readSecureData("auth_token");
    final response = await http.post(
      Uri.parse('$baseUrl/category_list_create/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(categoryData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create category');
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    final token = secureStorage.readSecureData("auth_token");
    final response = await http.delete(
      Uri.parse('$baseUrl/categories/$categoryId/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete category');
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

  Future<List<Map<String, dynamic>>> getCurrentUser() async {
    final token = await secureStorage.readSecureData("auth_token");
    final response = await http.get(
      Uri.parse('$baseUrl/get_current_user_profile/'),
      headers: {
        'Accept': '*/*',
        'Authorization': 'Token 7252953d02bfe26a81500fd43a6703858c30d1ec',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch accounts');
    }
  }

  // Future<void> _addExpense(String title, String amount) async {
  //   final response = await http.post(
  //     Uri.parse('http://127.0.0.1:8000/api/expenses/'),
  //     body: {
  //       'title': title,
  //       'amount': amount,
  //       // Assuming you have a default category and account, you may need to modify this part
  //       'category': '1', // Replace with the actual category ID
  //       'account': '1', // Replace with the actual account ID
  //     },
  //   );

  //   if (response.statusCode == 201) {
  //     if (kDebugMode) {
  //       print('Expense added successfully!');
  //     }
  //   } else {
  //     if (kDebugMode) {
  //       print('Failed to add expense. Status code: ${response.statusCode}');
  //     }
  //   }
  // }

  // Future<void> _getExpenses() async {
  //   final response =
  //       await http.get(Uri.parse('http://127.0.0.1:8000/api/expenses/'));

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = jsonDecode(response.body);
  //     // Handle the fetched data as needed
  //     if (kDebugMode) {
  //       print(data);
  //     }
  //   } else {
  //     if (kDebugMode) {
  //       print('Failed to fetch expenses. Status code: ${response.statusCode}');
  //     }
  //   }
  // }

  // Future<void> _updateExpense(int expenseId) async {
  //   final response = await http.put(
  //     Uri.parse('http://127.0.0.1:8000/api/expenses/$expenseId/'),
  //     body: {
  //       'title': 'Updated Title',
  //       'amount': '50.0', // Replace with the new amount
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     if (kDebugMode) {
  //       print('Expense updated successfully!');
  //     }
  //   } else {
  //     if (kDebugMode) {
  //       print('Failed to update expense. Status code: ${response.statusCode}');
  //     }
  //   }
  // }

  // Future<void> _deleteExpense(int expenseId) async {
  //   final response = await http
  //       .delete(Uri.parse('http://127.0.0.1:8000/api/expenses/$expenseId/'));

  //   if (response.statusCode == 204) {
  //     if (kDebugMode) {
  //       print('Expense deleted successfully!');
  //     }
  //   } else {
  //     if (kDebugMode) {
  //       print('Failed to delete expense. Status code: ${response.statusCode}');
  //     }
  //   }
  // }
}
