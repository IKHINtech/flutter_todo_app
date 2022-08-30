class TodoModel {
  int? total;
  int? limit;
  List<Todo>? data;

  TodoModel({this.total, this.data, this.limit});

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    List tmp = json['data'];
    return TodoModel(
        total: json['total'],
        limit: json['limit'],
        data: tmp.map((e) => Todo.fromJson(e)).toList());
  }
}

class Todo {
  int? id;
  String? title;
  int? activityGroupId;
  int? isActive;
  String? priority;

  Todo(
      {this.id,
      this.title,
      this.activityGroupId,
      this.isActive,
      this.priority});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        id: json['id'],
        title: json['title'],
        activityGroupId: json['activity_group_id'],
        isActive: json['is_active'],
        priority: json['priority']);
  }
}
