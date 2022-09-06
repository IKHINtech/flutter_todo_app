import 'dart:convert';
import 'package:flutter/cupertino.dart';
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

  Future<CreateTodo> saveTodo({required CreateTodo todo}) async {
    try {
      var url = Uri.https('todo.api.devcode.gethired.id', '/todo-items');
      final data = jsonEncode(todo.toJsonSave());
      final response = await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: data,
      );

      final responseDecode = json.decode(response.body);
      return CreateTodo.fromJson(responseDecode);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> deleteTodo(int id) async {
    try {
      var url = Uri.encodeFull(
          'https://todo.api.devcode.gethired.id/todo-items/${id}');
      await client.delete(Uri.parse(url));
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future updateTodo({required Todo todo, required int id}) async {
    try {
      var url = Uri.encodeFull(
          'https://todo.api.devcode.gethired.id/todo-items/${id}');
      final data = jsonEncode(todo.toUpdate());

      final res = await client.patch(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: data,
      );
      final decodeRes = json.decode(res.body);
      return Todo.fromJson(decodeRes);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
