import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3,
            offset: Offset(-0.5, 1.5),
            spreadRadius: 0.5,
          ),
        ],
        borderRadius: BorderRadius.circular(4)
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("hello"),
                  Text("\$000"),
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
