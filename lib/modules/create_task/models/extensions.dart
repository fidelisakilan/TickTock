import 'package:tick_tock/app/config.dart';
import '../bloc/create_task_cubit.dart';

class Utils {
  static TimeStamp startDate() {
    final date = DateTime.now().add(const Duration(hours: 1));
    return TimeStamp(
      date: DateTime(date.year, date.month, date.day),
      time: TimeOfDay(hour: date.hour, minute: 0),
    );
  }
}
