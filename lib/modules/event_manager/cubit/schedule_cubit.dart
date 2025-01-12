import 'dart:isolate';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      if (event != null) updateCompletion(event, true);
    });
  }

  void _loadFromDb() async {
    final eventList = await dbProvider.fetch();
    emit(eventList);
  }

  void receiveNotificationAction(int id) {
    final event = state.firstWhereOrNull((element) => id == element.nId);
    if (event != null) {
      state.remove(event);
      emit([...state, event.copyWith(isCompleted: true)]);
    }
  }

  void updateCompletion(EventModel oldEvent, bool isCompleted) async {
    final updatedEvent = oldEvent.copyWith(isCompleted: isCompleted);
    state.remove(oldEvent);
    emit([...state, updatedEvent]);
    dbProvider.store(updatedEvent);
    if (!updatedEvent.isCompleted) {
      scheduleService.scheduleNotification(updatedEvent);
    } else {
      scheduleService.cancelNotification(updatedEvent);
    }
  }

  void addEvent(EventModel event) async {
    emit([...state, event]);
    dbProvider.store(event);
    if (!event.isCompleted) {
      scheduleService.scheduleNotification(event);
    }
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
