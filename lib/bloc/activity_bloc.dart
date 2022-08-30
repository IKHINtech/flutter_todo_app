import 'package:rxdart/rxdart.dart';
import 'package:todo_app/model/activity_model.dart';
import 'package:todo_app/services/activity_service.dart';

class ActivityBloc {
  final _listActivityFetcher = PublishSubject<ActivityModel>();
  final ActivityService _activityService = ActivityService();
  late String activityIdentityId;
  ActivityModel? activityModel;

  Stream<ActivityModel> get streamActivity => _listActivityFetcher.stream;

  dispose() {
    if (_listActivityFetcher.isClosed == false) _listActivityFetcher.close();
  }

  fetchActivity() async {
    try {
      final String identityId =
          DateTime.now().millisecondsSinceEpoch.toString();
      activityIdentityId = identityId;
      _listActivityFetcher.sink.addError('LOADING');
      activityModel = await _activityService.fetchActivity();
      if (activityIdentityId == identityId) {
        _listActivityFetcher.sink.add(activityModel!);
      }
    } catch (e) {
      _listActivityFetcher.sink.addError(e.toString());
    }
  }
}
