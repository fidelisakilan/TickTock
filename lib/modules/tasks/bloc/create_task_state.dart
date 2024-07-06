part of 'create_task_cubit.dart';

@freezed
sealed class TaskDetails with _$TaskDetails {
  const TaskDetails._();

  const factory TaskDetails({
    String? title,
    String? description,
    required TimeStamp startDate,
    @Default(RepeatFrequency.none) RepeatFrequency repeatFrequency,
    @Default(false) bool allDay,
    @Default(RepeatDetails(interval: 1, weekdays: [])) RepeatDetails repeats,
    @Default([]) List<TimeStamp> reminders,
  }) = _TaskDetails;

  factory TaskDetails.fromJson(Map<String, dynamic> json) =>
      _$TaskDetailsFromJson(json);

  String? get repeatDetailsText {
    switch (repeatFrequency) {
      case RepeatFrequency.none:
      case RepeatFrequency.custom:
        return null;
      default:
        break;
    }
    if (repeats.interval == 1 && repeats.endDate == null) {
      return repeatFrequency.label;
    } else {
      String label =
          'Every ${repeats.interval} ${repeatFrequency.dropdownTitle}${repeats.interval > 1 ? 's' : ''}';
      if (repeats.endDate != null) {
        label = '$label; Ends: ${repeats.endDate!.formattedText1}';
      }
      return label;
    }
  }
}

@freezed
class RepeatDetails with _$RepeatDetails {
  const factory RepeatDetails({
    required int interval,
    required List<WeekDay> weekdays,
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
  none(label: 'Does not repeat', dropdownTitle: 'None'),
  days(label: 'Every day', dropdownTitle: 'Day'),
  weeks(label: 'Every week', dropdownTitle: 'Week'),
  months(label: 'Every month', dropdownTitle: 'Month'),
  years(label: 'Every year', dropdownTitle: 'Year'),
  custom(label: 'Custom...', dropdownTitle: 'Custom');

  final String label;
  final String dropdownTitle;

  const RepeatFrequency({required this.label, required this.dropdownTitle});
}

enum WeekDay { sunday, monday, tuesday, wednesday, thursday, friday, saturday }
