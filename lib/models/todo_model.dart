enum TodoStatus { IN_PROGRESS, COMPLETED }

class Todo {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final String? image;
  final TodoStatus status;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.image,
    this.status = TodoStatus.IN_PROGRESS,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    String? image,
    TodoStatus? status,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      image: image ?? this.image,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "createdAt": createdAt.toUtc().toIso8601String(),
      "image": image,
      "status": status.name,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      createdAt: DateTime.parse(json["createdAt"]),
      image: json["image"],
      status: TodoStatus.values.byName(json["status"]),
    );
  }
}
