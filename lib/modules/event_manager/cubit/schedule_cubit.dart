import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/modules/event_manager/service/schedule_event_service.dart';
import '../repository/db_provider.dart';
import '../models/models.dart';

class ScheduleCubit extends Cubit<List<EventModel>> {
  final dbProvider = DbProvider();
  final scheduleServie = ScheduleEventService();
  

  ScheduleCubit() : super([]) {
    _loadFromDb();
  }

  void _loadFromDb() async {
    final eventList = await dbProvider.fetch();
    emit(eventList);
  }

  void addEvent(EventModel event) async {
    emit([...state, event]);
    dbProvider.store(event);
    scheduleServie.scheduleNotification(event);
  }
}
