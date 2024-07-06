import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/app/config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tick_tock/modules/tasks/models/extensions.dart';

part 'create_task_state.dart';

part 'create_task_cubit.freezed.dart';

part 'create_task_cubit.g.dart';

class CreateTaskCubit extends Cubit<TaskDetails> {
  CreateTaskCubit() : super(TaskDetails(startDate: startDate(), allDay: false));

  static TimeStamp startDate() {
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
    emit(state.copyWith(allDay: value));
  }

  void setStartTimeStamp(TimeStamp timeStamp) {
    emit(state.copyWith(startDate: timeStamp));
  }

  void setStartDate(DateTime date) {
    emit(state.copyWith.startDate(date: date));
  }

  void setStartTime(TimeOfDay time) {
    emit(state.copyWith.startDate(time: time));
  }

  void setRepeatMode(RepeatFrequency frequency) {
    emit(state.copyWith(repeatFrequency: frequency));
  }

  void setRepeatInterval(int value) {
    emit(state.copyWith.repeats(interval: value));
  }

  void setWeekDays(List<WeekDay> weekdays) {
    emit(state.copyWith.repeats(weekdays: weekdays));
  }

  void updateDetails(TaskDetails details) {
    emit(details);
  }

  void setEndingDate([DateTime? value]) {
    emit(state.copyWith.repeats(endDate: value));
  }

  void setCustomTimeList(List<TimeStamp> value) {
    emit(state.copyWith(reminders: value));
  }

  void onSave() {
    log(state.toString());
  }
}
