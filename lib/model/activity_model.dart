class ActivityModel {
  int? total;
  int? limit;
  List<Activity>? data;

  ActivityModel({this.total, this.data, this.limit});

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    List tmp = json['data'];
    return ActivityModel(
        total: json['total'],
        limit: json['limit'],
        data: tmp.map((e) => Activity.fromJson(e)).toList());
  }
}

class Activity {
  int? id;
  String? title;
  String? createdAt;

  Activity({this.id, this.title, this.createdAt});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
        id: json['id'], title: json['title'], createdAt: json['created_at']);
  }
}

class CreateActivity {
  String? title;
  String? email;

  CreateActivity({this.email, this.title});

  Map<String, dynamic> toJsonSave() => {"title": title, 'email': email};
}
