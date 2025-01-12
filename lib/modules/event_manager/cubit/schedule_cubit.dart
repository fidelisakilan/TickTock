import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/schedule_event_service.dart';
import '../repository/db_provider.dart';
import '../models/models.dart';

class ScheduleCubit extends Cubit<List<EventModel>> {
  final dbProvider = DbProvider();
  final scheduleService = ScheduleEventService();

  ScheduleCubit() : super([]) {
    scheduleService.initialize(
      (int id) {
        final event = state.firstWhereOrNull((element) => element.nId == id);
        if (event != null) updateCompletion(event, true);
      },
    );
    _loadFromDb();
  }

  void _loadFromDb() async {
    final eventList = await dbProvider.fetch();
    emit(eventList);
  }

  void updateCompletion(EventModel event, bool isCompleted) async {
    removeEvent(event);
    final updatedEvent = event.copyWith(isCompleted: isCompleted);
    addEvent(updatedEvent);
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
}
