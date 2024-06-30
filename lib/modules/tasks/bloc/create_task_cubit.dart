import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/app/config.dart';
import '../models/task_model.dart';

part 'create_task_state.dart';

class CreateTaskCubit extends Cubit<CreateTaskState> {
  CreateTaskCubit() : super(CreateTaskInitial.create());

  void setTitle(String title) {
    emit(state.copyWith(title: title));
  }

  void setDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void setAllDay(bool value) {
    emit(state.copyWith(allDay: value));
  }

  void setStartDate(DateTime date) {
    emit(state.copyWith(startDate: date));
  }

  void setStartTime(TimeOfDay time) {
    emit(state.copyWith(startTime: time));
  }

  void setRepeatMode(RepeatMode mode) {
    emit(state.copyWith(repeatMode: mode));
  }

  void onSave() {}
}
