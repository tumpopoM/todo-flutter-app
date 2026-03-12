class Todo {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final String? image;
  final bool isDone;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.image,
    this.isDone = false,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    String? image,
    bool? isDone,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      image: image ?? this.image,
      isDone: isDone ?? this.isDone,
    );
  }
}
