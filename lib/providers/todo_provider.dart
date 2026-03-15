import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo_model.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]) {
    loadTodos();
  }

  final uuid = const Uuid();
  String _searchQuery = "";
  String _sortType = "date";
  List<Todo> _allTodos = [];

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void setSortType(String type) {
    _sortType = type;
    _applyFilters();
  }

  void _applyFilters() {
    final filtered = _allTodos.where((todo) {
      return todo.title.toLowerCase().contains(_searchQuery) ||
          todo.description.toLowerCase().contains(_searchQuery);
    }).toList();

    if (_sortType == "title") {
      filtered.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sortType == "date") {
      filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } else if (_sortType == "status") {
      filtered.sort((a, b) {
        if (a.status == b.status) return 0;

        if (a.status == "IN_PROGRESS") {
          return -1;
        } else {
          return 1;
        }
      });
    }

    state = filtered;
  }

  void addTodo(
    String title,
    String description,
    DateTime createdAt,
    String? image,
  ) {
    final todo = Todo(
      id: uuid.v4(),
      title: title,
      description: description,
      createdAt: createdAt,
      image: image,
    );

    _allTodos = [..._allTodos, todo];
    _applyFilters();
    saveTodos();
  }

  void updateTodo(
    String id,
    String title,
    String description,
    DateTime createdAt,
    String? image,
    String status,
  ) {
    _allTodos = _allTodos.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(
          title: title,
          description: description,
          createdAt: createdAt,
          image: image,
          status: status,
        );
      }
      return todo;
    }).toList();
    _applyFilters();
    saveTodos();
  }

  void removeTodo(String id) {
    _allTodos.removeWhere((todo) => todo.id == id);
    _applyFilters();
    saveTodos();
  }

  void toggleTodo(String id) {
    _allTodos = _allTodos.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(
          status: todo.status == "IN_PROGRESS" ? "COMPLETED" : "IN_PROGRESS",
        );
      }
      return todo;
    }).toList();
    _applyFilters();
    saveTodos();
  }

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _allTodos
        .map((todo) => jsonEncode(todo.toJson()))
        .toList();
    await prefs.setStringList('todos', jsonList);
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('todos') ?? [];
    _allTodos = jsonList
        .map((jsonStr) => Todo.fromJson(jsonDecode(jsonStr)))
        .toList();
    _applyFilters();
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});
