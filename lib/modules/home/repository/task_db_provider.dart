
import 'package:sembast/sembast.dart';
import 'package:tick_tock/modules/create_task/bloc/create_task_cubit.dart';
import 'package:tick_tock/shared/core/database/database.dart';

class TaskDbProvider {
  Future<Database> get _db => AppDatabase.instance.database;

  final _taskListStore = stringMapStoreFactory.store('task_list');

  Future<List<TaskDetails>> fetchTaskList() async {
    final records = await _taskListStore.find(await _db);
    final List<TaskDetails> taskList = [];
    for (var e in records) {
      taskList.add(TaskDetails.fromJson(e.value));
    }
    return taskList;
  }

  Future<void> storeTaskData(TaskDetails details) async {
    await _taskListStore.add(await _db, details.toJson());
  }
}
