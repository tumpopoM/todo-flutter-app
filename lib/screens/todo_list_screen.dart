import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_app/screens/create_todo_creen.dart';
import '../providers/todo_provider.dart';

class TodoListScreen extends ConsumerStatefulWidget {
  const TodoListScreen({super.key});

  @override
  ConsumerState<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends ConsumerState<TodoListScreen> {
  String _selectedSort = "date";

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                ref.read(todoProvider.notifier).setSearchQuery(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButton<String>(
              value: _selectedSort,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: "date", child: Text("Sort by Date")),
                DropdownMenuItem(value: "title", child: Text("Sort by Title")),
                DropdownMenuItem(
                  value: "status",
                  child: Text("Sort by Status"),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedSort = value;
                  });
                  ref.read(todoProvider.notifier).setSortType(value);
                }
              },
            ),
          ),

          Expanded(
            child: todos.isEmpty
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
                            ref.read(todoProvider.notifier).toggleTodo(todo.id);
                          },
                        ),
                        title: Text(todo.title),
                        subtitle: Text(todo.description),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            ref.read(todoProvider.notifier).removeTodo(todo.id);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
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
