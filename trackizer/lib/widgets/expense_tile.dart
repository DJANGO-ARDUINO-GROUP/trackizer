import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    super.key,
    required this.title,
    required this.amount, required this.category,
  });
  final String title;
  final String category;
  final String amount;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      decoration: BoxDecoration(
          color: Colors.grey.shade800, borderRadius: BorderRadius.circular(4)),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "($category)",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "₦$amount",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.red,
            width: 5,
          )
        ],
      ),
    );
  }
}
