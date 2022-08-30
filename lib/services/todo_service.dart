import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/model/todo_model.dart';

class TodoService {
  final client = http.Client();

  Future<TodoModel> fetchTodo(int activityId) async {
    try {
      var url = Uri.https('todo.api.devcode.gethired.id', '/todo-items',
          {'activity_group_id': activityId.toString()});
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final responseDecode = json.decode(response.body);
        return TodoModel.fromJson(responseDecode);
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
