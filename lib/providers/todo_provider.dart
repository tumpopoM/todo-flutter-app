import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo_model.dart';
import 'package:uuid/uuid.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]);

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
      filtered.sort((a, b) => a.status.compareTo(b.status.toString()));
    }

    state = filtered;
  }

  void addTodo(String title, String description) {
    final todo = Todo(
      id: uuid.v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      image: null,
    );

    _allTodos = [..._allTodos, todo];
    _applyFilters();
  }

  void updateTodo(String id, String title, String description) {
    _allTodos = _allTodos.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(title: title, description: description);
      }
      return todo;
    }).toList();
    _applyFilters();
  }

  void removeTodo(String id) {
    _allTodos.removeWhere((todo) => todo.id == id);
    _applyFilters();
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
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});
