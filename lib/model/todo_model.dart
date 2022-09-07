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

class Todo implements Comparable<Todo> {
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

  @override
  int compareTo(Todo other) {
    if (title != other.title) {
      return -1;
    }
    return title!.compareTo(other.title!);
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        id: json['id'],
        title: json['title'],
        activityGroupId: json['activity_group_id'],
        isActive: json['is_active'],
        priority: json['priority']);
  }

  Map<String, dynamic> toJsonSave() => {
        "activity_group_id": activityGroupId,
        "title": title,
        'priority': priority
      };

  Map<String, dynamic> toUpdate() => {
        "title": title,
        'priority': priority,
        'is_active': isActive,
      };

  bool get status {
    if (isActive == 1) {
      return false;
    } else {
      return true;
    }
  }
}

class CreateTodo {
  int? id;
  String? title;
  int? activityGroupId;
  bool? isActive;
  String? priority;

  CreateTodo(
      {this.id,
      this.title,
      this.activityGroupId,
      this.isActive,
      this.priority});

  factory CreateTodo.fromJson(Map<String, dynamic> json) {
    return CreateTodo(
        id: json['id'],
        title: json['title'],
        activityGroupId: json['activity_group_id'],
        isActive: json['is_active'],
        priority: json['priority']);
  }

  Map<String, dynamic> toJsonSave() => {
        "activity_group_id": activityGroupId,
        "title": title,
        'priority': priority
      };
}
