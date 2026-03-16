import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int? maxLength;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.maxLength,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: const TextStyle(fontSize: 16, color: Colors.black),
        hintStyle: const TextStyle(fontSize: 16, color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
