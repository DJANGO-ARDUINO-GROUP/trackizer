import 'package:flutter/material.dart';

class ExpenseCustomTxtField extends StatelessWidget {
  const ExpenseCustomTxtField({
    super.key,
    required TextEditingController controller,
    this.keyboardType,
    this.labelText,
    this.txtcolor = Colors.white,
  }) : _controller = controller;

  final TextEditingController _controller;
  final TextInputType? keyboardType;
  final String? labelText;
  final Color? txtcolor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: _controller,
        style: TextStyle(color: txtcolor),
        decoration: InputDecoration(labelText: labelText),
      ),
    );
  }
}
