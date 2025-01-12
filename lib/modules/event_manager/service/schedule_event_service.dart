import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tick_tock/modules/event_manager/repository/db_provider.dart';
import 'package:tick_tock/shared/utils/utils.dart';
import '../models/models.dart';
import 'package:timezone/timezone.dart' as tz;

class ScheduleEventService {
  final plugin = FlutterLocalNotificationsPlugin();

  void initialize(Function(int) updateAppList) async {
    plugin.initialize(
      const InitializationSettings(
          android: AndroidInitializationSettings("ic_notification")),
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
      onDidReceiveNotificationResponse: (response) {
        if (response.actionId == "complete") {
          updateAppList(response.id!);
        }
      },
    );
  }

  void cancelNotification(EventModel model) {
    plugin.cancel(model.nId);
  }

  void scheduleNotification(EventModel model) async {
    cancelNotification(model);
    try {
      final dateTime = DateTime.now().add(const Duration(seconds: 5));
      // final dateTime = DateTime(
      //   model.date.year,
      //   model.date.month,
      //   model.date.day,
      //   model.time.hour,
      //   model.time.minute,
      // );
      await plugin.zonedSchedule(
        model.nId,
        model.title,
        model.description,
        tz.TZDateTime.from(dateTime, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
      );
    } catch (e, stack) {
      log('error', error: e, stackTrace: stack);
    }
  }

  NotificationDetails get notificationDetails => NotificationDetails(
        android: AndroidNotificationDetails(
          'event_manager',
          'Events',
          icon: 'ic_notification',
          importance: Importance.max,
          priority: Priority.high,
          actions: TaskNotificationAction.values.map((e) {
            return AndroidNotificationAction(
              e.id,
              e.label,
              showsUserInterface: true,
            );
          }).toList(),
          enableVibration: true,
        ),
      );
}

enum TaskNotificationAction {
  complete('complete', 'Complete'),
  snooze('dismiss', 'Dismiss');

  final String id;
  final String label;

  const TaskNotificationAction(this.id, this.label);
}

@pragma('vm:entry-point')
void onNotificationTap(NotificationResponse response) async {
  Utils.showToast("${response.id}_${response.actionId}");
  if (response.actionId == "complete") {
    final eventList = await DbProvider().fetch();
    final event =
        eventList.firstWhereOrNull((element) => element.nId == response.id);
    if (event != null) {
      DbProvider().store(event.copyWith(isCompleted: true));
    }
  }
}
