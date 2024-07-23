
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/home/repository/task_db_provider.dart';
export '../../../app/models/task_details_model.dart';
import '../../../app/models/task_details_model.dart';

part 'create_task_state.dart';

part 'create_task_cubit.freezed.dart';

class CreateTaskCubit extends Cubit<CreateTaskState> {
  CreateTaskCubit()
      : super(CreateTaskProgress(
            taskDetails:
                TaskDetails(startDate: startDate(), allDay: false, title: '')));

  static TimeStamp startDate() {
    final date = DateTime.now().add(const Duration(hours: 1));
    return TimeStamp(
      date: DateTime(date.year, date.month, date.day),
      time: TimeOfDay(hour: date.hour, minute: 0),
    );
  }

  void setTitle(String? title) {
    emit(state.copyWith.taskDetails(title: title ?? ''));
  }

  void setDescription(String? description) {
    emit(state.copyWith.taskDetails(description: description));
  }

  void setAllDay(bool value) {
    emit(state.copyWith.taskDetails(allDay: value));
  }

  void setStartTimeStamp(TimeStamp timeStamp) {
    emit(state.copyWith.taskDetails(startDate: timeStamp));
  }

  void setStartDate(DateTime date) {
    emit(state.copyWith.taskDetails.startDate(date: date));
  }

  void setStartTime(TimeOfDay time) {
    emit(state.copyWith.taskDetails.startDate(time: time));
  }

  void setRepeatMode(RepeatFrequency frequency) {
    emit(state.copyWith.taskDetails(repeatFrequency: frequency));
  }

  void setRepeatInterval(int value) {
    emit(state.copyWith.taskDetails.repeats(interval: value));
  }

  void setWeekDays(List<WeekDay> weekdays) {
    emit(state.copyWith.taskDetails.repeats(weekdays: weekdays));
  }

  void updateDetails(TaskDetails details) {
    emit(CreateTaskProgress(taskDetails: details));
  }

  void setEndingDate([DateTime? value]) {
    emit(state.copyWith.taskDetails.repeats(endDate: value));
  }

  void setCustomTimeList(List<TimeStamp> value) {
    emit(state.copyWith.taskDetails(reminders: value));
  }

  void onSave() async {
    await TaskDbProvider().storeTaskData(state.taskDetails);
    emit(CreateTaskComplete(taskDetails: state.taskDetails));
  }
}
