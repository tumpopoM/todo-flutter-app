import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/todo_model.dart';
import '../providers/todo_provider.dart';

class EditTodoScreen extends ConsumerStatefulWidget {
  final Todo todo;

  const EditTodoScreen({super.key, required this.todo});

  @override
  ConsumerState<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends ConsumerState<EditTodoScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  String? _base64Image;
  late DateTime selectedDate;
  late String status;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.todo.title);

    descriptionController = TextEditingController(
      text: widget.todo.description,
    );

    selectedDate = widget.todo.createdAt;

    _base64Image = widget.todo.image;

    status = widget.todo.status;
  }

  void updateTodo() {
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
        .updateTodo(
          widget.todo.id,
          title,
          description,
          dateTime,
          _base64Image,
          status,
        );

    Navigator.pop(context);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();

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
      appBar: AppBar(title: const Text("Edit Todo")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date : ${selectedDate.toLocal().toString().split(' ')[0]}",
                ),
                TextButton(
                  onPressed: pickDate,
                  child: const Text("Change Date"),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: status,
              decoration: const InputDecoration(labelText: "Status"),
              items: const [
                DropdownMenuItem(
                  value: "IN_PROGRESS",
                  child: Text("IN_PROGRESS"),
                ),
                DropdownMenuItem(value: "COMPLETED", child: Text("COMPLETED")),
              ],
              onChanged: (value) {
                setState(() {
                  status = value!;
                });
              },
            ),

            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Change Image"),
            ),
            const SizedBox(height: 12),
            if (_base64Image != null)
              Image.memory(base64Decode(_base64Image!), height: 120),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: updateTodo, child: const Text("Update")),
          ],
        ),
      ),
    );
  }
}
