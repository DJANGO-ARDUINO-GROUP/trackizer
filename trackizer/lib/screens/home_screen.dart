import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/api_client.dart';
import 'package:trackizer/widgets/custom_alert_dialog.dart';
import 'package:trackizer/widgets/expense_custom_txt_field.dart';
import 'package:trackizer/widgets/expense_tile.dart';
import 'package:trackizer/widgets/income_exp_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _catNameController = TextEditingController();
  final DjangoApiClient djangoApiClient = DjangoApiClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () {
              djangoApiClient.logOut();
            },
            child: const Text(
              'Logout',
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            ),
          )
        ],
        title: const Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
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
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              ),
              FutureBuilder(
                  future: djangoApiClient.getCurrentUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data['balance'].toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return const Text(
                      '\$000',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white),
                    );
                  }),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    incomeExpDet(
                      title: 'BALANCE',
                      amount: "\$000",
                      future: djangoApiClient.getCurrentUser(),
                      amountColor: Colors.green,
                    ),
                    incomeExpDet(
                      title: 'EXPENSES',
                      amount: "\$000",
                      future: djangoApiClient.getCurrentUser(),
                      amountColor: Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'History',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const Divider(),
              FutureBuilder(
                future: djangoApiClient.getExpenses(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> data = snapshot.data;
                    if (kDebugMode) {
                      print(data);
                    }
                    if (data.isEmpty) {
                      return const Text("No expenses");
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return const ExpenseTile();
                      },
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return const Text(
                    'Error',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white),
                  );
                },
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              hintText: "+ Add Category",
                              controller: _catNameController,
                              onSave: () {
                                djangoApiClient.createCategory(
                                  _catNameController.text,
                                );
                                _catNameController.clear();
                                Navigator.of(context).pop();
                              },
                              onCancel: Navigator.of(context).pop,
                            );
                          });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Text(
                          'Add Category',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              hintText: "+ Add Category",
                              controller: _catNameController,
                              onSave: () {
                                djangoApiClient.createCategory(
                                  _catNameController.text,
                                );
                                _catNameController.clear();
                                Navigator.of(context).pop();
                              },
                              onCancel: Navigator.of(context).pop,
                            );
                          });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Text(
                          '- Delete Category',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Text(
                'Add New Expense',
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              ),
              const Divider(),
              const SizedBox(height: 20),
              const Text(
                'Title',
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              ),
              ExpenseCustomTxtField(
                controller: _titleController,
                labelText: 'Expense Title',
              ),
              const SizedBox(height: 20),
              const Text(
                'Amount',
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              ),
              ExpenseCustomTxtField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                labelText: 'Expense Amount',
              ),
              const SizedBox(height: 20),
              const Text(
                'Category',
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
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


// () => CustomAlertDialog(
//                           controller: val,
//                           onSave: () {
//                              djangoApiClient.createCategory(
                  //   {
                  //     "name": _catNameController.text,
                  //   },
                  // );
//                           },
//                           onCancel: Navigator.of(context).pop,
//                         ),
