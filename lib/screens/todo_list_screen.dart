import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_app/screens/create_todo_creen.dart';
import 'package:todo_flutter_app/theme/app_theme.dart';
import '../providers/todo_provider.dart';
import 'edit_todo_screen.dart';

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
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          'Todo List',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14.0)),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                ref.read(todoProvider.notifier).setSearchQuery(value);
              },
              cursorColor: Colors.black,
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Sort by",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
                ),
                DropdownButton(
                  value: _selectedSort,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: "date", child: Text("Date")),
                    DropdownMenuItem(value: "title", child: Text("Title")),
                    DropdownMenuItem(value: "status", child: Text("Status")),
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
              ],
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: todos.isEmpty
                  ? const Center(
                      child: Text(
                        "No Todo yet.\nTap + to create one",
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      itemCount: todos.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10.0);
                      },
                      itemBuilder: (context, index) {
                        final todo = todos[index];

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(14.0),

                          child: Dismissible(
                            key: Key(todo.id),
                            direction: DismissDirection.endToStart,

                            onDismissed: (_) {
                              ref
                                  .read(todoProvider.notifier)
                                  .removeTodo(todo.id);
                            },

                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20.0),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),

                            child: Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.0),
                              child: ListTile(
                                tileColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                ),

                                leading: GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(todoProvider.notifier)
                                        .toggleTodo(todo.id);
                                  },

                                  child: Container(
                                    width: 24.0,
                                    height: 24.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: todo.status == "COMPLETED"
                                          ? AppTheme.primaryColor
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: todo.status == "COMPLETED"
                                            ? AppTheme.primaryColor
                                            : Colors.grey,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: todo.status == "COMPLETED"
                                        ? const Icon(
                                            Icons.check,
                                            size: 16.0,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),

                                title: Text(
                                  todo.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),

                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EditTodoScreen(todo: todo),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTodoScreen()),
          );
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
