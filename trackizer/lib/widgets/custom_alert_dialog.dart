import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final TextEditingController? controller;
  final void Function() onSave;
  final void Function() onCancel;
  final String? hintText;
  const CustomAlertDialog(
      {super.key,
      this.controller,
      required this.onSave,
      required this.onCancel,
      this.hintText = "Add value"});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      content: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey)),
      ),
      actions: [
        MaterialButton(
          color: Colors.grey[700],
          onPressed: onSave,
          child: const Text(
            "Save",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        MaterialButton(
          color: Colors.grey[700],
          onPressed: onCancel,
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
