import 'package:sembast/sembast.dart';
import 'package:tick_tock/shared/core/database/database.dart';
import '../models/models.dart';

class DbProvider {
  Future<Database> get _db => AppDatabase.instance.database;

  final _taskListStore = intMapStoreFactory.store('task_list');

  Future<List<EventModel>> fetch() async {
    final records = await _taskListStore.find(await _db);
    final List<EventModel> taskList = [];
    for (var e in records) {
      taskList.add(EventModel.fromJson(e.value));
    }
    return taskList;
  }

  Future<void> store(EventModel event) async {
    await _taskListStore.record(event.nId).put(await _db, event.toJson());
  }

  Future<void> remove(EventModel event) async {
    await _taskListStore.record(event.nId).delete(await _db);
  }
}
