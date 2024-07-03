part of 'create_task_cubit.dart';

@freezed
sealed class TaskDetails with _$TaskDetails {
  const factory TaskDetails.custom({
    String? title,
    String? description,
    required TimeStamp startDate,
    required List<TimeStamp> reminders,
  }) = CustomTaskDetails;

  const factory TaskDetails.defaults({
    String? title,
    String? description,
    required TimeStamp startDate,
    required bool allDay,
    RepeatDetails? repeats,
  }) = DefaultTaskDetails;

  factory TaskDetails.fromJson(Map<String, dynamic> json) =>
      _$TaskDetailsFromJson(json);
}

@freezed
class RepeatDetails with _$RepeatDetails {
  const factory RepeatDetails({
    required int interval,
    required RepeatFrequency frequency,
    List<WeekDay>? weekdays,
    DateTime? endDate,
  }) = _RepeatDetails;

  factory RepeatDetails.fromJson(Map<String, dynamic> json) =>
      _$RepeatDetailsFromJson(json);
}

@freezed
class TimeStamp with _$TimeStamp {
  const factory TimeStamp({
    required DateTime date,
    @TimeOfDayConverter() required TimeOfDay time,
  }) = _TimeStamp;

  factory TimeStamp.fromJson(Map<String, dynamic> json) =>
      _$TimeStampFromJson(json);
}

class TimeOfDayConverter
    implements JsonConverter<TimeOfDay, Map<String, dynamic>> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(Map<String, dynamic> json) {
    return TimeOfDay(hour: json['hour'], minute: json['minute']);
  }

  @override
  Map<String, dynamic> toJson(TimeOfDay object) =>
      {'hour': object.hour, 'minute': object.minute};
}

enum RepeatFrequency {
  none(label: 'Does not repeat'),
  days(label: 'Every day'),
  weeks(label: 'Every week'),
  months(label: 'Every month'),
  years(label: 'Every year'),
  custom(label: 'Custom...');

  final String label;

  const RepeatFrequency({required this.label});
}

enum WeekDay { sunday, monday, tuesday, wednesday, thursday, friday, saturday }
