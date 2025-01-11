import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tick_tock/shared/utils/utils.dart';
import '../models/models.dart';
import 'package:timezone/timezone.dart' as tz;

class ScheduleEventService {
  final plugin = FlutterLocalNotificationsPlugin();

  void initialize() async {
    plugin.initialize(
      const InitializationSettings(),
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
      onDidReceiveNotificationResponse: onNotificationTap,
    );
  }

  void scheduleNotification(EventModel model) async {
    try {
      final dateTime = DateTime(
        model.date.year,
        model.date.month,
        model.date.day,
        model.time.hour,
        model.time.minute,
      );

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
  snooze('snooze', 'Snooze');

  final String id;
  final String label;

  const TaskNotificationAction(this.id, this.label);
}

@pragma('vm:entry-point')
void onNotificationTap(NotificationResponse notificationResponse) {
  print("Notification TAPPED");
  Utils.showToast(notificationResponse.toString());
  print(
      "notificationTapBackground ${notificationResponse.id} ${notificationResponse.actionId}");
}
