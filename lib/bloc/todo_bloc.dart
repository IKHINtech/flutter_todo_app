import 'package:rxdart/rxdart.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/services/todo_service.dart';

class TodoBloc {
  final _listTodoFetcher = PublishSubject<TodoModel>();
  final TodoService _todoService = TodoService();
  late String todoIdentityId;
  TodoModel? todoModel;

  Stream<TodoModel> get streamTodo => _listTodoFetcher.stream;

  dispose() {
    if (_listTodoFetcher.isClosed == false) _listTodoFetcher.close();
  }

  fetchTodo(int id) async {
    try {
      final String identityId =
          DateTime.now().millisecondsSinceEpoch.toString();
      todoIdentityId = identityId;
      _listTodoFetcher.sink.addError('LOADING');
      todoModel = await _todoService.fetchTodo(id);
      if (todoIdentityId == identityId) {
        _listTodoFetcher.sink.add(todoModel!);
      }
    } catch (e) {
      _listTodoFetcher.sink.addError(e.toString());
    }
  }
}
