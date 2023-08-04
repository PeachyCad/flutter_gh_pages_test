class Task {
  String name;
  String description;
  bool isCompleted;

  Task({
    required this.name,
    required this.description,
    this.isCompleted = false,
  });
}
