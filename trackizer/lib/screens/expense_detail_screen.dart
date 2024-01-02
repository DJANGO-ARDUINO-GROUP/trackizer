import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackizer/api_client.dart';

class ExpenseDetailScreen extends StatefulWidget {
  const ExpenseDetailScreen({
    super.key,
    required this.expId,
  });
  final int expId;

  @override
  State<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  final DjangoApiClient djangoApiClient = DjangoApiClient();
  late Future _expDetFuture;

  @override
  void initState() {
    super.initState();
    _expDetFuture = djangoApiClient.getExpenseDetail(widget.expId);
  }

  Future _refresh() async {
    // Make a new request when the refresh is triggered
    setState(() {
      _expDetFuture = djangoApiClient.getExpenseDetail(widget.expId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          iconSize: 20,
          onPressed: () {
            Get.back();
          },
          color: Colors.white,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          'Expense Details',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: _expDetFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              if (kDebugMode) {
                print(data);
              }
              if (data.isEmpty) {
                return const Text(
                  "No expenses",
                  style: TextStyle(color: Colors.white),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //title
                  const Text(
                    "Title",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    data['title'],
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  //amount
                  const Text(
                    "Amount",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "₦${data['amount']}",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  //category
                  const Text(
                    "Category",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    data['category_name'],
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  //date
                  const Text(
                    "Date/Time",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    data['date'],
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async{
                       djangoApiClient.deleteExpense(widget.expId);
                      Get.back(
                        result: [
                          djangoApiClient.getExpenses(),
                          djangoApiClient.getCurrentUser()
                        ],
                      );
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
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
      ),
    );
  }
}
