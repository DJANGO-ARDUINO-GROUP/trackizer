import 'package:flutter/material.dart';
import 'package:trackizer/api_client.dart';

class ExpenseDet extends StatelessWidget {
  ExpenseDet({
    super.key,
    required this.title,
    required this.amount,
    required this.amountColor,
    this.future,
  });
  final String title;
  final String amount;
  final Color amountColor;
  final Future<dynamic>? future;
  final DjangoApiClient djangoApiClient = DjangoApiClient();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
               List<dynamic> expenses = snapshot.data!;

          double totalAmount = expenses
              .map((expense) => double.parse(expense['amount'].toString()))
              .fold(0, (prev, amount) => prev + amount);

                return Text(
                  "₦${totalAmount}0",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: amountColor,
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return Text(
                '₦0.00',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: amountColor,
                ),
              );
            }),
      ],
    );
  }
}
