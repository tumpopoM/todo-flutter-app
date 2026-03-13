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
      filtered.sort(
        (a, b) => a.isDone.toString().compareTo(b.isDone.toString()),
      );
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

  void removeTodo(int index) {
    _allTodos.removeAt(index);
    _applyFilters();
  }

  void toggleTodo(int index) {
    final todo = _allTodos[index];

    final updatedTodo = todo.copyWith(isDone: !todo.isDone);

    _allTodos[index] = updatedTodo;

    _applyFilters();
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});
