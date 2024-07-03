import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/app/config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_task_state.dart';

part 'create_task_cubit.freezed.dart';

part 'create_task_cubit.g.dart';

class CreateTaskCubit extends Cubit<TaskDetails> {
  CreateTaskCubit()
      : super(TaskDetails.defaults(startDate: _startDate(), allDay: false));

  static TimeStamp _startDate() {
    final date = DateTime.now().add(const Duration(hours: 1));
    return TimeStamp(
      date: DateTime(date.year, date.month, date.day),
      time: TimeOfDay(hour: date.hour, minute: 0),
    );
  }

  void setTitle(String? title) {
    emit(state.copyWith(title: title));
  }

  void setDescription(String? description) {
    emit(state.copyWith(description: description));
  }

  void setAllDay(bool value) {
    switch (state) {
      case DefaultTaskDetails():
        emit((state as DefaultTaskDetails).copyWith(allDay: value));
        break;
      default:
        break;
    }
  }

  void setStartDate(DateTime date) {
    emit(state.copyWith.startDate(date: date));
  }

  void setStartTime(TimeOfDay time) {
    emit(state.copyWith.startDate(time: time));
  }

  void setRepeatMode(RepeatFrequency frequency) {
    switch (state) {
      case DefaultTaskDetails():
        emit((state as DefaultTaskDetails).copyWith(
          repeats: RepeatDetails(interval: 1, frequency: frequency),
        ));
        break;
      default:
        break;
    }
  }

  void onSave() {}
}
