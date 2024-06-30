part of 'create_task_cubit.dart';

@immutable
sealed class CreateTaskState {
  final String? title;
  final String? description;
  final bool allDay;
  final RepeatMode repeatMode;
  final List<DateTime> customList;
  final DateTime startDate;
  final TimeOfDay startTime;
  final DateTime? endDate;

  const CreateTaskState({
    this.title,
    this.description,
    required this.allDay,
    required this.repeatMode,
    required this.customList,
    required this.startDate,
    required this.startTime,
    this.endDate,
  });

  CreateTaskState copyWith({
    String? title,
    String? description,
    bool? allDay,
    RepeatMode? repeatMode,
    List<DateTime>? customList,
    DateTime? startDate,
    TimeOfDay? startTime,
    DateTime? endDate,
  });
}

final class CreateTaskInitial extends CreateTaskState {
  const CreateTaskInitial({
    super.title,
    super.description,
    required super.allDay,
    required super.repeatMode,
    required super.customList,
    required super.startDate,
    required super.startTime,
    super.endDate,
  });

  factory CreateTaskInitial.create() {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day, now.hour)
        .add(const Duration(hours: 1));
    return CreateTaskInitial(
      allDay: false,
      customList: const [],
      repeatMode: RepeatMode.none,
      startDate: startDate,
      startTime: TimeOfDay(hour: startDate.hour, minute: startDate.minute),
    );
  }

  @override
  CreateTaskState copyWith({
    String? title,
    String? description,
    bool? allDay,
    RepeatMode? repeatMode,
    List<DateTime>? customList,
    DateTime? startDate,
    TimeOfDay? startTime,
    DateTime? endDate,
  }) {
    return CreateTaskInitial(
      title: title ?? this.title,
      description: description ?? this.description,
      allDay: allDay ?? this.allDay,
      repeatMode: repeatMode ?? this.repeatMode,
      customList: customList ?? this.customList,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      endDate: endDate ?? this.endDate,
    );
  }
}