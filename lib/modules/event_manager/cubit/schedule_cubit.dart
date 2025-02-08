import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:collection/collection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/event_manager/models/extensions.dart';
import '../service/schedule_service.dart';
import '../repository/db_provider.dart';
import '../models/models.dart';

class ScheduleCubit extends Cubit<List<EventModel>> {
  final dbProvider = DbProvider();
  final scheduleService = ScheduleService();
  final receivePort = ReceivePort();

  ScheduleCubit() : super([]) {
    scheduleService.initialize();
    dbProvider.fetch().then((value) {
      emit(value);
    });
    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, 'calendar_completion_bus');
    receivePort.listen((message) {
      final event = state.firstWhereOrNull((element) => message == element.nId);
      if (event != null) {
        updateCompletion(
          oldEvent: event,
          isCompleted: true,
          date: DateTime.now().clearedTime,
        );
      }
    });
  }

  Future<bool> exportData() async {
    final eventList = await dbProvider.createBackup();
    if (eventList.isNotEmpty) {
      Directory appDir = await getTemporaryDirectory();
      String filePath = path.joinAll([appDir.path, "ticktock-bak.txt"]);
      File tempFile = File(filePath);
      tempFile.writeAsStringSync(json.encode(eventList));
      Share.shareXFiles([XFile(tempFile.path)]);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> importData() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      try {
        final backupFile = File(result.files.single.path!);
        final output = backupFile.readAsStringSync();
        final records = await dbProvider.restoreBackup(json.decode(output));
        //TODO: Add implementation to schedule events when backup is restored

        // for (EventModel rec in records) {
        //   if (rec.isCompleted(current)) {
        //     scheduleService.cancelNotification(updatedEvent);
        //   } else {
        //     scheduleService.scheduleNotification(
        //         updatedEvent, date, updatedEvent.time);
        //   }
        // }
        emit(records);
        return true;
      } catch (e, stack) {
        logger(error: e, stack: stack);
      }
    }
    throw UserCancelledException();
  }

  void updateCompletion({
    required EventModel oldEvent,
    required DateTime date,
    required bool isCompleted,
  }) async {
    final newDates = Map<String, bool>.from(oldEvent.completionList);
    newDates[date.toString()] = isCompleted;
    final updatedEvent = oldEvent.copyWith(completionList: newDates);
    state.remove(oldEvent);
    emit([...state, updatedEvent]);
    dbProvider.store(updatedEvent);

    if (updatedEvent.isRepeated) {
      if (isCompleted) {
        scheduleService.cancelNotification(updatedEvent);
      } else {
        scheduleService.scheduleNotification(
            updatedEvent, date, updatedEvent.time);
      }
    } else {
      if (isCompleted) {
        scheduleService.cancelNotification(updatedEvent);
      }
    }
  }

  void addEvent(EventModel event) async {
    emit([...state, event]);
    dbProvider.store(event);
    scheduleService.scheduleNotification(event, event.date, event.time);
  }

  void removeEvent(EventModel event) async {
    emit(List.of(state..remove(event)));
    dbProvider.remove(event);
    scheduleService.cancelNotification(event);
  }

  @override
  Future<void> close() {
    receivePort.close();
    return super.close();
  }
}
