import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:tick_tock/modules/create_task/models/extensions.dart';
import 'extensions.dart';
import '../config.dart';

part 'task_details_model.freezed.dart';

part 'task_details_model.g.dart';

@freezed
sealed class TaskDetails with _$TaskDetails {
  const TaskDetails._();

  const factory TaskDetails({
    required int id,
    required String title,
    String? description,
    @TimeStampConverter() required TimeStamp startDate,
    @Default(RepeatFrequency.none) RepeatFrequency repeatFrequency,
    @Default(false) bool allDay,
    @Default(RepeatDetails(interval: 1, days: [])) RepeatDetails repeats,
    @TimeStampConverter() @Default([]) List<TimeStamp> reminders,
    @TimeStampConverter() @Default([]) List<TimeStamp> completedDates,
  }) = _TaskDetails;

  const factory TaskDetails.done({
    required int id,
    required String title,
    String? description,
    @TimeStampConverter() required TimeStamp startDate,
    @Default(RepeatFrequency.none) RepeatFrequency repeatFrequency,
    @Default(false) bool allDay,
    @Default(RepeatDetails(interval: 1, days: [])) RepeatDetails repeats,
    @Default([]) List<TimeStamp> reminders,
    @Default([]) List<TimeStamp> completedDates,
  }) = TaskDetailsDone;

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
      String? label;
      if (repeatFrequency == RepeatFrequency.weeks) {
        const weekEnds = [WeekDay.saturday, WeekDay.sunday];
        const weekDays = [
          WeekDay.monday,
          WeekDay.tuesday,
          WeekDay.wednesday,
          WeekDay.thursday,
          WeekDay.friday
        ];
        final List<WeekDay> currentDays = List.from(repeats.days);
        if (const ListEquality().equals(currentDays, weekDays)) {
          label = 'Every ${repeats.interval} weekday${repeats.interval > 1 ? 's' : ''}';
        } else if (const ListEquality().equals(currentDays, weekEnds)) {
          label = 'Every ${repeats.interval} weekend${repeats.interval > 1 ? 's' : ''}';
        } else if (currentDays.length > 1) {
          label =
              'Every ${repeats.interval} ${repeatFrequency.dropdownTitle}${repeats.interval > 1 ? 's' : ''} on ${currentDays.length} days';
        }
      }

      label ??=
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
  const RepeatDetails._();

  const factory RepeatDetails({
    required int interval,
    @Default([]) List<WeekDay> days,
    @DateTimeConverter() DateTime? endDate,
  }) = _RepeatDetails;

  factory RepeatDetails.fromJson(Map<String, dynamic> json) =>
      _$RepeatDetailsFromJson(json);
}

@freezed
class TimeStamp with _$TimeStamp {
  const TimeStamp._();

  const factory TimeStamp({
    required int id,
    @DateTimeConverter() required DateTime date,
    @TimeOfDayConverter() required TimeOfDay time,
  }) = _TimeStamp;

  factory TimeStamp.fromJson(Map<String, dynamic> json) =>
      _$TimeStampFromJson(json);

  DateTime get combined =>
      DateTime(date.year, date.month, date.day, time.hour, time.minute);

  String get text => DateFormat.yMMMd('en_US').add_jm().format(combined);
}

class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String content) => DateTime.parse(content);

  @override
  String toJson(DateTime object) => object.toIso8601String();
}

class TimeOfDayConverter implements JsonConverter<TimeOfDay, String> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(String time) {
    return TimeOfDay(
      hour: int.parse(time.split(':').first),
      minute: int.parse(time.split(':').last),
    );
  }

  @override
  String toJson(TimeOfDay object) => '${object.hour}:${object.minute}';
}

class TimeStampConverter
    implements JsonConverter<TimeStamp, Map<String, dynamic>> {
  const TimeStampConverter();

  @override
  TimeStamp fromJson(Map<String, dynamic> json) {
    return TimeStamp(
      id: json['id'] ?? Utils.randomInt,
      date: DateTime.parse((json['date'] as String)),
      time: TimeOfDay(
        hour: int.parse(json['time'].split(':').first),
        minute: int.parse(json['time'].split(':').last),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson(TimeStamp object) {
    return {
      'id': object.id,
      'date': object.date.toIso8601String(),
      'time': '${object.time.hour}:${object.time.minute}',
    };
  }
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

enum WeekDay {
  monday(label: 'Monday'),
  tuesday(label: 'Tuesday'),
  wednesday(label: 'Wednesday'),
  thursday(label: 'Thursday'),
  friday(label: 'Friday'),
  saturday(label: 'Saturday'),
  sunday(label: 'Sunday');

  final String label;

  const WeekDay({required this.label});
}
