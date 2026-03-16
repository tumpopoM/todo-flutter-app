import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_flutter_app/providers/todo_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  test('addTodo should add new todo', () {
    final notifier = TodoNotifier();

    notifier.addTodo("Test title", "Test description", DateTime.now(), null);

    expect(notifier.state.length, 1);
    expect(notifier.state.first.title, "Test title");
  });

  test('removeTodo should delete todo', () {
    final notifier = TodoNotifier();

    notifier.addTodo("Test", "Test desc", DateTime.now(), null);

    final id = notifier.state.first.id;

    notifier.removeTodo(id);

    expect(notifier.state.isEmpty, true);
  });

  test('updateTodo should update todo fields', () {
    final notifier = TodoNotifier();

    notifier.addTodo("Old title", "Old desc", DateTime.now(), null);

    final todo = notifier.state.first;

    notifier.updateTodo(
      todo.id,
      "New title",
      "New desc",
      DateTime.now(),
      null,
      "IN_PROGRESS",
    );

    expect(notifier.state.first.title, "New title");
  });

  test('toggleTodo should change status', () {
    final notifier = TodoNotifier();

    notifier.addTodo("Test", "Test desc", DateTime.now(), null);

    final id = notifier.state.first.id;

    notifier.toggleTodo(id);

    expect(notifier.state.first.status, "COMPLETED");
  });
}
