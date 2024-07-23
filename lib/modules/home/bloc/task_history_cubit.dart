import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/app/models/task_details_model.dart';
import 'package:tick_tock/modules/home/repository/task_db_provider.dart';

import '../../../app/config.dart';

part 'task_history_state.dart';

class TaskHistoryCubit extends Cubit<TaskHistoryState> {
  TaskHistoryCubit() : super(TasksLoading());

  void fetchFromDb() async {
    emit(TasksLoading());
    final history = await TaskDbProvider().fetchTaskList();
    emit(TasksLoaded(history: history));
  }

}
