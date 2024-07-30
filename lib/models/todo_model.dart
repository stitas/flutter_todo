class TodoModel {
  int? id;
  String title;
  String description;
  String creationDate;
  int isCompleted;

  TodoModel(
      {this.id,
      required this.title,
      required this.description,
      required this.creationDate,
      required this.isCompleted});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'creationDate': creationDate,
      'isCompleted': isCompleted
    };
  }

  static TodoModel fromMap(Map<String, dynamic> map) {
    return TodoModel(
        id: map['id']?.toInt() ?? 0,
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        creationDate: map['creationDate'] ?? '9999-99-99',
        isCompleted: map['isCompleted'] ?? false);
  }
}
