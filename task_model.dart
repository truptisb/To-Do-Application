// lib/dashboard/task_model.dart
class Task {
  final String id;
  final String title;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isCompleted: json['is_completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'is_completed': isCompleted,
    };
  }
}
