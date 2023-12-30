
import 'package:flutter/material.dart';

class incomeExpDet extends StatelessWidget {
  const incomeExpDet({
    super.key,
    required this.title,
    required this.amount,
    required this.amountColor,
  });
  final String title;
  final String amount;
  final Color amountColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 22,
            color: amountColor,
          ),
        ),
      ],
    );
  }
}