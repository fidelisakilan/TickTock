import 'package:rxdart/subjects.dart';
import 'package:tick_tock/shared/core/bloc_interface.dart';

import '../models/task_model.dart';

class TaskListBloc implements BlocInterface {
  final BehaviorSubject<List<TaskModel>> _taskFetcher =
      BehaviorSubject<List<TaskModel>>();

  Stream<List<TaskModel>> get taskListStream => _taskFetcher.stream;

  @override
  void dispose() {
    _taskFetcher.close();
  }
}
