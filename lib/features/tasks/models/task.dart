class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final int durationSeconds;
  final bool isRunning;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.durationSeconds = 0,
    this.isRunning = false,
  });

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    int? durationSeconds,
    bool? isRunning,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      isRunning: isRunning ?? this.isRunning,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'durationSeconds': durationSeconds,
      'isRunning': isRunning,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      durationSeconds: json['durationSeconds'],
      isRunning: json['isRunning'] ?? false,
    );
  }
}
