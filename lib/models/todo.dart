class Todo {
  int? id;
  int? plantId;
  String task;
  bool isCompleted;

  Todo({
    this.id,
    this.plantId,
    required this.task,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plantId': plantId,
      'task': task,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      plantId: map['plantId'],
      task: map['task'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
