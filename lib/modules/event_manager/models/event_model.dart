import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'event_model.g.dart';

part 'event_model.freezed.dart';

@Freezed()
class EventModel with _$EventModel {
  const EventModel._();

  const factory EventModel({
    required int nId,
    required DateTime date,
    @TimeOfDayConverter() required TimeOfDay time,
    required String title,
    String? description,
    @Default({}) Map<String, bool> completedDates,
    RepeatSchedule? repeats,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  bool isCompleted(DateTime current) {
    return completedDates[current.toString()] ?? false;
  }
}

class TimeOfDayConverter
    implements JsonConverter<TimeOfDay, Map<String, dynamic>> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(Map<String, dynamic> json) {
    return TimeOfDay(
      hour: json['hour'],
      minute: json['minute'],
    );
  }

  @override
  Map<String, dynamic> toJson(TimeOfDay object) {
    return {'hour': object.hour, 'minute': object.minute};
  }
}

extension RepeatScheduleExtension on RepeatSchedule {
  String get label {
    switch (this) {
      case RepeatSchedule.none:
        return "No Repeats";
      case RepeatSchedule.time:
        return 'Every Day';
      case RepeatSchedule.dayOfWeekAndTime:
        return 'Every Week';
      case RepeatSchedule.dayOfMonthAndTime:
        return "Every Month";
      case RepeatSchedule.dateAndTime:
        return "Every Year";
    }
  }

  String scheduleName(DateTime current) {
    switch (this) {
      case RepeatSchedule.none:
        return "Do not repeat";
      case RepeatSchedule.time:
        return "Every Day ${DateFormat.jm().format(current)}";
      case RepeatSchedule.dayOfWeekAndTime:
        return "Every Week ${DateFormat.jm().format(current)}";
      case RepeatSchedule.dayOfMonthAndTime:
        return "Every Month on day ${current.day}, at ${DateFormat.jm().format(current)} ";
      case RepeatSchedule.dateAndTime:
        return "Every year ${DateFormat('MMM dd').format(current)}, at ${DateFormat.jm().format(current)}";
    }
  }
}

enum RepeatSchedule {
  none,
  time,
  dayOfWeekAndTime,
  dayOfMonthAndTime,
  dateAndTime,
}
