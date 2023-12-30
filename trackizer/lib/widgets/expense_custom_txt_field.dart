import 'package:flutter/material.dart';

class ExpenseCustomTxtField extends StatelessWidget {
  const ExpenseCustomTxtField({
    super.key,
    required TextEditingController controller,
    this.keyboardType,
    this.labelText,
  }) : _controller = controller;

  final TextEditingController _controller;
  final TextInputType? keyboardType;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(labelText: labelText),
      ),
    );
  }
}
