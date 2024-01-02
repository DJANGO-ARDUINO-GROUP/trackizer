import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackizer/api_client.dart';
import 'package:trackizer/controllers/dropdown_controller.dart';
import 'package:trackizer/models/user.dart';
import 'package:trackizer/secure_storage.dart';
import 'package:trackizer/widgets/custom_alert_dialog.dart';
import 'package:trackizer/widgets/category_bottom_sheet.dart';
import 'package:trackizer/widgets/expense_custom_txt_field.dart';
import 'package:trackizer/widgets/expense_detail.dart';
import 'package:trackizer/widgets/expense_tile.dart';
import 'package:trackizer/widgets/balance_detail.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _balController = TextEditingController();
  final DropdownController controller = Get.put(DropdownController());
  final DjangoApiClient djangoApiClient = DjangoApiClient();
  final SecureStorage secureStorage = SecureStorage();
  final User user = User();

  late Future _balfuture;
  late Future _expfuture;
  @override
  void initState() {
    super.initState();
    _balfuture = djangoApiClient.getCurrentUser();
    _expfuture = djangoApiClient.getExpenses();
  }

  Future _refresh() async {
    // Make a new request when the refresh is triggered
    setState(() {
      _balfuture = djangoApiClient.getCurrentUser();
      _expfuture = djangoApiClient.getExpenses();
    });
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate;
  }

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
              FutureBuilder(
                  future: secureStorage.readSecureData("username"),
                  builder: (context, snapshot) {
                    return Text(
                      "Hello ${snapshot.data} 👋",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    );
                  }),
              const SizedBox(height: 10),
              const Text(
                'Your Balance',
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder(
                      future: _balfuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            "₦${snapshot.data['balance'].toString()}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        return const Text(
                          '₦000',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white),
                        );
                      }),
                  //add balance
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomAlertDialog(
                            hintText: "Enter new balance",
                            controller: _balController,
                            onSave: () {
                              djangoApiClient.updateBalance(
                                  int.parse(_balController.text), "add");
                              _balController.clear();
                              Navigator.of(context).pop();
                              _refresh();
                            },
                            onCancel: Navigator.of(context).pop,
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                    BalanceDet(
                      title: 'BALANCE',
                      amount: "₦0.00",
                      future: _balfuture,
                      amountColor: Colors.green,
                    ),
                    ExpenseDet(
                      title: 'EXPENSES',
                      amount: "₦0.00",
                      future: _expfuture,
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
                future: _expfuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> data = snapshot.data;
                    if (kDebugMode) {
                      print(data);
                    }
                    if (data.isEmpty) {
                      return const Text(
                        "No expenses",
                        style: TextStyle(color: Colors.white),
                      );
                    }
                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ExpenseTile(
                            title: snapshot.data[index]['title'],
                            category:
                                snapshot.data[index]['category'].toString(),
                            amount: snapshot.data[index]['amount'],
                          );
                        },
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return const Text(
                    'Probably check internet',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white),
                  );
                },
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
              ),
              const SizedBox(height: 20),
              //category
              const Text(
                'Category',
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder(
                      future: djangoApiClient.getCategoryList(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<dynamic> data = snapshot.data;
                          if (data.isEmpty) {
                            return const Center(
                              child: Text(
                                "You have Categories. Please create one 🙏",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                        }
                        return Obx(
                          () => Text(
                            'Category: ${controller.selectedValue.value ?? "None"}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                        // Initial Selected Value
                      }),
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        CategoryBottomSheet(),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Text(
                          'Select Category',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              GestureDetector(
                onTap: () {
                  String currentDate = getCurrentDate();
                  djangoApiClient.addExpense(
                    _titleController.text,
                    _amountController.text,
                    controller.selectedId.value!,
                    currentDate,
                  );
                  _titleController.clear();
                  _amountController.clear();
                  _refresh();
                },
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
            ],
          ),
        ),
      ),
    );
  }
}
