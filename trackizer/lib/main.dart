import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trackizer/widgets/expense_custom_txt_field.dart';
import 'package:trackizer/widgets/expense_tile.dart';
import 'package:trackizer/widgets/income_exp_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  Future<void> _addExpense() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/expenses/'),
      body: {
        'title': _titleController.text,
        'amount': _amountController.text,
        // Assuming you have a default category and account, you may need to modify this part
        'category': '1', // Replace with the actual category ID
        'account': '1', // Replace with the actual account ID
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
  }

  Future<void> _getExpenses() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/expenses/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // Handle the fetched data as needed
      if (kDebugMode) {
        print(data);
      }
    } else {
      if (kDebugMode) {
        print('Failed to fetch expenses. Status code: ${response.statusCode}');
      }
    }
  }

  Future<void> _updateExpense(int expenseId) async {
    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/expenses/$expenseId/'),
      body: {
        'title': 'Updated Title',
        'amount': '50.0', // Replace with the new amount
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

  Future<void> _deleteExpense(int expenseId) async {
    final response = await http
        .delete(Uri.parse('http://127.0.0.1:8000/api/expenses/$expenseId/'));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Balance',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const Text(
                'Balance',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white, boxShadow: [BoxShadow()]),
                height: 100,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    incomeExpDet(
                      title: 'BALANCE',
                      amount: "\$000",
                      amountColor: Colors.green,
                    ),
                    incomeExpDet(
                      title: 'EXPENSES',
                      amount: "\$000",
                      amountColor: Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'History',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return const ExpenseTile();
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Add New Expense',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const Divider(),
              const SizedBox(height: 20),
              const Text(
                'Title',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              ExpenseCustomTxtField(
                controller: _titleController,
                labelText: 'Expense Title',
              ),
              const SizedBox(height: 20),
              const Text(
                'Amount',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              ExpenseCustomTxtField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                labelText: 'Expense Amount',
              ),
              const SizedBox(height: 20),
              const Text(
                'Category',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              ExpenseCustomTxtField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                labelText: 'Expense Category',
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _addExpense,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: Text(
                      'Add Expense',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: _getExpenses,
              //   child: const Text('Get Expenses'),
              // ),
              // const SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: () =>
              //       _updateExpense(1), // Replace with the actual expense ID
              //   child: const Text('Update Expense'),
              // ),
              // const SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: () =>
              //       _deleteExpense(1), // Replace with the actual expense ID
              //   child: const Text('Delete Expense'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}




// {
//   "title":"titleController.text",
//   "amount":2000,
//   "date":"2023-12-04",
//   "category":1,
//   "account":1
// }