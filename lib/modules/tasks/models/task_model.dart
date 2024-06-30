import 'package:tick_tock/main.dart';
import 'package:timezone/timezone.dart';

part 'repeat_mode.dart';

class TaskModel {
  final String title;
  final String description;
  final bool allDay;
  final RepeatMode repeatMode;
  final List<TZDateTime> customList;
  final TZDateTime startDate;
  final TZDateTime? endDate;

  TaskModel({
    required this.title,
    required this.description,
    required this.allDay,
    required this.repeatMode,
    required this.customList,
    required this.startDate,
    this.endDate,
  });

  TaskModel copyWith({
    String? title,
    String? description,
    bool? allDay,
    RepeatMode? repeatMode,
    List<TZDateTime>? customList,
    TZDateTime? startDate,
    TZDateTime? endDate,
  }) {
    return TaskModel(
      title: title ?? this.title,
      description: description ?? this.description,
      allDay: allDay ?? this.allDay,
      repeatMode: repeatMode ?? this.repeatMode,
      customList: customList ?? this.customList,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'allDay': allDay,
      'repeatMode': repeatMode.name,
      'startDate': startDate.toString(),
      'endDate': endDate.toString(),
      'customList': customList.map((e) => e.toString()).toList(),
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    final List<TZDateTime> customList = [];
    for (var element in (map['customList'] as List<String>)) {
      customList.add(TZDateTime.parse(currentLocation, element));
    }
    return TaskModel(
      title: map['title'] as String,
      description: map['description'] as String,
      startDate: TZDateTime.parse(currentLocation, map['startDate']),
      endDate: map.containsKey('endDate')
          ? TZDateTime.parse(currentLocation, map['endDate'])
          : null,
      allDay: map['allDay'] as bool,
      repeatMode:
          RepeatMode.values.firstWhere((e) => e.name == map['repeatMode']),
      customList: customList,
    );
  }
}

