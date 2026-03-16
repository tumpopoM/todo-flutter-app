import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_app/screens/todo_list_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: TodoApp()));
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const TodoListScreen(),
    );
  }
}
