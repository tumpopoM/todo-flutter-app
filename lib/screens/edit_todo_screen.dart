import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.todo.title);

    descriptionController = TextEditingController(
      text: widget.todo.description,
    );
  }

  void updateTodo() {
    final title = titleController.text;
    final description = descriptionController.text;

    if (title.isEmpty) return;

    ref
        .read(todoProvider.notifier)
        .updateTodo(widget.todo.id, title, description);

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

            ElevatedButton(onPressed: updateTodo, child: const Text("Update")),
          ],
        ),
      ),
    );
  }
}
