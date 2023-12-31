import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackizer/api_client.dart';
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
    return const GetMaterialApp(
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
  final DjangoApiClient djangoApiClient = DjangoApiClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              djangoApiClient.logOut();
            },
            child: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          )
        ],
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
              FutureBuilder(
                  future: djangoApiClient.getCurrentUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData == true) {
                      return const Text(
                        'There is Balance',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return const Text(
                      '',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    );
                  }),
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
                onTap: () {},
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