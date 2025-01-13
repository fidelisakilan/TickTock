import 'dart:isolate';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    _loadFromDb();
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

  void _loadFromDb() async {
    final eventList = await dbProvider.fetch();
    emit(eventList);
  }

  void updateCompletion({
    required EventModel oldEvent,
    required DateTime date,
    required bool isCompleted,
  }) async {
    final newDates = Map<String, bool>.from(oldEvent.completedDates);
    newDates[date.toString()] = isCompleted;
    final updatedEvent = oldEvent.copyWith(completedDates: newDates);
    state.remove(oldEvent);
    emit([...state, updatedEvent]);
    dbProvider.store(updatedEvent);
    //TODO:
    // if (!updatedEvent.isCompleted) {
    //   scheduleService.scheduleNotification(updatedEvent);
    // } else {
    //   scheduleService.cancelNotification(updatedEvent);
    // }
  }

  void addEvent(EventModel event) async {
    emit([...state, event]);
    dbProvider.store(event);
    scheduleService.scheduleNotification(event);
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
