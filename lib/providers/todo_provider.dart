import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo_model.dart';
import 'package:uuid/uuid.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]);

  final uuid = const Uuid();

  void addTodo(String title, String description) {
    final todo = Todo(
      id: uuid.v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      image: "",
      status: "IN_PROGRESS",
    );

    state = [...state, todo];
  }

  void removeTodo(int index) {
    final newList = [...state];
    newList.removeAt(index);
    state = newList;
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});
