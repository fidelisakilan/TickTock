import 'dart:developer';
import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tick_tock/modules/event_manager/models/extensions.dart';
import '../models/models.dart';
import 'package:timezone/timezone.dart' as tz;
import '../repository/db_provider.dart';

class ScheduleService {
  final plugin = FlutterLocalNotificationsPlugin();

  void initialize() async {
    plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      ),
      onDidReceiveBackgroundNotificationResponse: _onCompleteAction,
    );
  }

  void cancelNotification(EventModel model) {
    plugin.cancel(model.nId);
  }

  void scheduleNotification(EventModel model) async {
    cancelNotification(model);
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
          importance: Importance.max,
          priority: Priority.high,
          actions: TaskNotificationAction.values.map((e) {
            return AndroidNotificationAction(
              e.id,
              e.label,
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
void _onCompleteAction(NotificationResponse response) async {
  if (response.actionId == "complete") {
    final eventList = await DbProvider().fetch();
    final event =
        eventList.firstWhereOrNull((element) => element.nId == response.id);
    if (event != null) {
      final newDates = Map<String, bool>.from(event.completedDates);
      newDates[DateTime.now().clearedTime.toString()] = true;
      final updatedEvent = event.copyWith(completedDates: newDates);
      DbProvider().store(updatedEvent);
    }
    IsolateNameServer.lookupPortByName('calendar_completion_bus')
        ?.send(response.id!);
  }
}
