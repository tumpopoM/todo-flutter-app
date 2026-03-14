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

  void createTodo() {
    final title = titleController.text;
    final description = descriptionController.text;

    if (title.isEmpty) return;

    ref.read(todoProvider.notifier).addTodo(title, description, _base64Image);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Todo")),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Select Image"),
            ),
            const SizedBox(height: 20),
            if (_base64Image != null)
              Image.memory(
                base64Decode(_base64Image!),
                height: 120,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: createTodo, child: const Text("Create")),
          ],
        ),
      ),
    );
  }
}
