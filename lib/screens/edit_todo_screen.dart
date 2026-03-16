import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo_model.dart';
import '../providers/todo_provider.dart';
import '../utils/picker_utils.dart';
import '../widgets/app_text_field.dart';

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
  Uint8List? imageBytes;

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

    if (_base64Image != null) {
      imageBytes = base64Decode(_base64Image!);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Todo")),

      body: Padding(
        padding: const EdgeInsets.all(16),

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
                    "Change Date",
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Status:", style: TextStyle(fontSize: 16.0)),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: status,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "IN_PROGRESS",
                        child: Text("In Progress"),
                      ),
                      DropdownMenuItem(
                        value: "COMPLETED",
                        child: Text("Completed"),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          status = value;
                        });
                      }
                    },
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
                    imageBytes = base64Decode(imageBase64);
                  });
                }
              },
              child: const Text(
                "Change Image",
                style: TextStyle(fontSize: 16.0, color: Colors.black),
              ),
            ),
            const SizedBox(height: 16.0),
            if (imageBytes != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(14.0),
                child: Image.memory(
                  imageBytes!,
                  height: 120.0,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: updateTodo,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
            ),
            child: const Text(
              "Update Todo",
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
