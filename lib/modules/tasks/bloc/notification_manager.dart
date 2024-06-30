import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/task_model.dart';

class NotificationManager {
  void schedule(TaskModel model) async {
    try {
      final permission1 = await Permission.notification.request();
      final permission2 = await Permission.scheduleExactAlarm.request();
      if (!permission1.isGranted || !permission2.isGranted) return;

      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestExactAlarmsPermission();
      await flutterLocalNotificationsPlugin.zonedSchedule(
        104,
        model.title,
        model.description,
        tz.TZDateTime.from(model.startDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminders',
            'Reminders',
            channelDescription: 'All Reminders',
            icon: "ic_notification",
            importance: Importance.max,
            priority: Priority.high,
            actions: [
              AndroidNotificationAction('complete', 'Complete'),
              AndroidNotificationAction('snooze', 'Snooze'),
            ],
            enableVibration: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      // final List<PendingNotificationRequest> pendingNotificationRequests =
      //     await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      // for (var element in pendingNotificationRequests) {
      //   print('element ${element.id} ${element.title}');
      // }
    } catch (e, stack) {
      log('error', error: e, stackTrace: stack);
    }
  }
}
