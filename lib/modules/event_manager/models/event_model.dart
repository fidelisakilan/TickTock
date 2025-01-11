import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'event_model.g.dart';
part 'event_model.freezed.dart';

@Freezed()
class EventModel with _$EventModel {
  const factory EventModel({
    required int nId,
    required DateTime date,
    @TimeOfDayConverter() required TimeOfDay time,
    required String title,
    String? description,
    @Default(false) bool isCompleted,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
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
