import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';
import 'dart:convert';
import '../utils/picker_utils.dart';
import '../widgets/app_text_field.dart';

class CreateTodoScreen extends ConsumerStatefulWidget {
  const CreateTodoScreen({super.key});

  @override
  ConsumerState<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends ConsumerState<CreateTodoScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String? _base64Image;
  DateTime selectedDate = DateTime.now();

  void createTodo() {
    final title = titleController.text;
    final description = descriptionController.text;

    if (title.isEmpty || title.length > 100) {
      return;
    }

    final now = DateTime.now();

    final dateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      now.hour,
      now.minute,
      now.second,
    );

    ref
        .read(todoProvider.notifier)
        .addTodo(title, description, dateTime, _base64Image);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Todo",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppTextField(
                controller: titleController,
                label: "Title",
                maxLength: 100,
              ),
              const SizedBox(height: 16.0),
              AppTextField(
                controller: descriptionController,
                label: "Description",
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Date: ${selectedDate.toLocal().toString().split(' ')[0]}",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  TextButton(
                    onPressed: () async {
                      final date = await pickDate(context, selectedDate);
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    },
                    child: const Text(
                      "Select Date",
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () async {
                  final imageBase64 = await pickImageBase64();
                  if (imageBase64 != null) {
                    setState(() {
                      _base64Image = imageBase64;
                    });
                  }
                },
                child: const Text(
                  "Select Image",
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ),
              const SizedBox(height: 16.0),
              if (_base64Image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(14.0),
                  child: Image.memory(
                    base64Decode(_base64Image!),
                    height: 120.0,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: createTodo,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
            ),
            child: const Text(
              "Create Todo",
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
