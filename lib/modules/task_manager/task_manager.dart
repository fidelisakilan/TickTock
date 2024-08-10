import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tick_tock/app/models/task_details_model.dart';
import 'package:timezone/timezone.dart' as tz;

class TaskManager {
  final plugin = FlutterLocalNotificationsPlugin();

  void initialize() async {
    plugin.initialize(
      const InitializationSettings(),
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  void scheduleNotification(TaskDetails model) async {
    try {
      final List<TimeStamp> reminderList = [];
      reminderList.add(model.startDate);
      if (model.repeatFrequency == RepeatFrequency.custom) {
        reminderList.addAll(model.reminders);
      } else if (model.repeatFrequency != RepeatFrequency.none) {
        if (model.repeats.endDate != null) {
          TimeStamp nextReminder = model.startDate;
          while (nextReminder.date.isBefore(model.repeats.endDate!)) {}
        } else {
          return _schedulePeriodically(model);
        }
      }
      for (var element in reminderList) {
        _schedule(model: model, timeStamp: element, allDay: model.allDay);
      }
    } catch (e, stack) {
      log('error', error: e, stackTrace: stack);
    }
  }

  Future<void> _schedule({
    required TaskDetails model,
    required TimeStamp timeStamp,
    required bool allDay,
  }) async {
    final dateTime = DateTime(
      timeStamp.date.year,
      timeStamp.date.month,
      timeStamp.date.day,
      !allDay ? timeStamp.time.hour : 0,
      !allDay ? timeStamp.time.minute : 0,
    );

    await plugin.zonedSchedule(
      model.id,
      model.title,
      model.description,
      tz.TZDateTime.from(dateTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  Future<void> _schedulePeriodically(TaskDetails model) async {
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.periodicallyShow(
      model.id,
      model.title,
      model.description,
      model.repeatFrequency.interval,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  NotificationDetails get notificationDetails => NotificationDetails(
        android: AndroidNotificationDetails(
          'global_reminders',
          'Global Reminders',
          icon: 'ic_notification',
          importance: Importance.max,
          priority: Priority.high,
          actions: TaskNotificationAction.values
              .map((e) => AndroidNotificationAction(e.id, e.label))
              .toList(),
          enableVibration: true,
        ),
      );
}

extension _RepeatFrequencyExtension on RepeatFrequency {
  RepeatInterval get interval {
    switch (this) {
      case RepeatFrequency.days:
        return RepeatInterval.daily;
      case RepeatFrequency.weeks:
        return RepeatInterval.weekly;
      case RepeatFrequency.months:
        throw ComingSoonException();
      case RepeatFrequency.years:
        throw ComingSoonException();
      default:
        throw Exception();
    }
  }

  TimeStamp getNextReminder(TimeStamp stamp) {
    switch (this) {
      case RepeatFrequency.days:
        return stamp.copyWith(date: stamp.date.add(const Duration(days: 1)));
      case RepeatFrequency.weeks:
        return stamp.copyWith(date: stamp.date.add(const Duration(days: 1)));
      case RepeatFrequency.months:
        return stamp.copyWith(
            date: DateTime(stamp.date.year, stamp.date.month, stamp.date.year,
                stamp.date.day));
      case RepeatFrequency.years:
        return stamp.copyWith(
            date: DateTime(stamp.date.year + 1, stamp.date.month,
                stamp.date.year, stamp.date.day));
      default:
        throw Exception();
    }
  }
}

class ComingSoonException implements Exception {}

enum TaskNotificationAction {
  complete('complete', 'Complete'),
  snooze('snooze', 'Snooze');

  final String id;
  final String label;

  const TaskNotificationAction(this.id, this.label);
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  log("notificationTapBackground ${notificationResponse.id} ${notificationResponse.actionId}");
}
