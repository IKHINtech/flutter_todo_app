import 'package:todo_app/model/activity_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ActivityService {
  final client = http.Client();

  Future<ActivityModel> fetchActivity() async {
    try {
      var url = Uri.https('todo.api.devcode.gethired.id', '/activity-groups',
          {'email': 'yoga+1@skyshi.io'});
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final responseDecode = json.decode(response.body);
        return ActivityModel.fromJson(responseDecode);
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future addActivity(CreateActivity activity) async {
    try {
      var url = Uri.https('todo.api.devcode.gethired.id', '/activity-groups');
      final data = jsonEncode(activity.toJsonSave());

      await client.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> deleteTodo(int id) async {
    try {
      var url = Uri.encodeFull(
          'https://todo.api.devcode.gethired.id/activity-groups/${id}');
      await client.delete(Uri.parse(url));
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
