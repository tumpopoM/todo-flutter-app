import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await File(image.path).readAsBytes();

      setState(() {
        _base64Image = base64Encode(bytes);
      });
    }
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
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
              TextField(
                controller: titleController,
                maxLength: 100,
                decoration: InputDecoration(
                  labelText: "Title",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  labelStyle: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintStyle: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    borderSide: BorderSide.none,
                  ),
                ),
                cursorColor: Colors.black,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  filled: true,
                  labelStyle: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintStyle: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    borderSide: BorderSide.none,
                  ),
                ),
                cursorColor: Colors.black,
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
                    onPressed: pickDate,
                    child: const Text(
                      "Select Date",
                      style: TextStyle(fontSize: 16.0, color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: _pickImage,
                child: const Text(
                  "Select Image",
                  style: TextStyle(fontSize: 16.0, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 16.0),
              if (_base64Image != null)
                Image.memory(
                  base64Decode(_base64Image!),
                  height: 120.0,
                  fit: BoxFit.cover,
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
