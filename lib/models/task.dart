class Task {
  final String id;
    String title;
    String? description;
  bool isCompleted;
  DateTime? dateTime;
  int? hours;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.dateTime,
    this.hours = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dateTime': dateTime?.toIso8601String(),
      'hours': hours,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? "",
      isCompleted: json['isCompleted'] ?? false,
      dateTime: json['dateTime'] != null ? DateTime.parse(json['dateTime']) : null,
      hours: json['hours'] ?? 0,
    );
  }
}