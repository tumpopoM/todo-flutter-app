import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo_model.dart';
import 'package:uuid/uuid.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]);

  final uuid = const Uuid();
  String _searchQuery = "";

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void _applyFilters() {
    final filtered = state.where((todo) {
      return todo.title.toLowerCase().contains(_searchQuery) ||
          todo.description.toLowerCase().contains(_searchQuery);
    }).toList();
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

    state = [...state, todo];
  }

  void removeTodo(int index) {
    final newList = [...state];
    newList.removeAt(index);
    state = newList;
  }

  void toggleTodo(int index) {
    final todo = state[index];

    final updatedTodo = todo.copyWith(isDone: !todo.isDone);

    final newList = [...state];
    newList[index] = updatedTodo;

    state = newList;
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});
