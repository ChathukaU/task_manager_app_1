import 'dart:convert';

class Task {
  String name;
  String description;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.name,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });

  // Convert Task to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  // Create Task from JSON
  factory Task.fromJson(String json) {
    Map<String, dynamic> map = Map<String, dynamic>.from(jsonDecode(json));
    return Task(
      name: map['name'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'],
    );
  }
}
