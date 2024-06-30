part of 'task_model.dart';

enum RepeatMode {
  none,
  daily,
  weekly,
  monthly,
  yearly,
  custom,
}

extension RepeatModeExtension on RepeatMode {
  String get tileName {
    switch (this) {
      case RepeatMode.none:
        return 'Does not repeat';
      case RepeatMode.daily:
        return 'Every day';
      case RepeatMode.weekly:
        return 'Every week';
      case RepeatMode.monthly:
        return 'Every month';
      case RepeatMode.yearly:
        return 'Every year';
      case RepeatMode.custom:
        return 'Custom...';
    }
  }
}
