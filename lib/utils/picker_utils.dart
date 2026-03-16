import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<DateTime?> pickDate(BuildContext context, DateTime initialDate) async {
  final date = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  return date;
}

Future<String?> pickImageBase64() async {
  final picker = ImagePicker();

  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    final bytes = await image.readAsBytes();
    return base64Encode(bytes);
  }

  return null;
}
