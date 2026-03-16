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
        elevation: 0,
        title: const Text(
          'Todo List',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                ref.read(todoProvider.notifier).setSearchQuery(value);
              },
              cursorColor: Colors.black,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Sort by",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
            const SizedBox(height: 10),
            Expanded(
              child: todos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.check_circle_outline,
                            size: 80,
                            color: Colors.grey,
                          ),

                          SizedBox(height: 16),

                          Text(
                            "No Todo Yet",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            "Tap + to create your first task",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: todos.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        final todo = todos[index];

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(14),

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
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),

                            child: Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              child: ListTile(
                                tileColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),

                                leading: GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(todoProvider.notifier)
                                        .toggleTodo(todo.id);
                                  },

                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: todo.status == "COMPLETED"
                                          ? AppTheme.primaryColor
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: todo.status == "COMPLETED"
                                            ? AppTheme.primaryColor
                                            : Colors.grey,
                                        width: 2,
                                      ),
                                    ),
                                    child: todo.status == "COMPLETED"
                                        ? const Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),

                                title: Text(
                                  todo.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    decoration: todo.status == "COMPLETED"
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color: todo.status == "COMPLETED"
                                        ? Colors.grey.shade500
                                        : Colors.black,
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
