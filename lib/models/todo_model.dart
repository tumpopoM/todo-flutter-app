class Todo {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final String image;
  final String status;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.image,
    required this.status,
  });
}

enum TodoStatus { inProgress, completed }
