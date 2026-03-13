import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_app/screens/create_todo_creen.dart';
import '../providers/todo_provider.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: todos.isEmpty
          ? const Center(
              child: Text(
                "No Todo yet.\nTap + to create one",
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];

                return ListTile(
                  leading: Checkbox(
                    value: todo.isDone,
                    onChanged: (_) {
                      ref.read(todoProvider.notifier).toggleTodo(index);
                    },
                  ),
                  title: Text(todo.title),
                  subtitle: Text(todo.description),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref.read(todoProvider.notifier).removeTodo(index);
                    },
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTodoScreen()),
          );
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}
