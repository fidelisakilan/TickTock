import 'package:timezone/timezone.dart' as tz;

class EventModel {
  final String title;
  final String description;
  final tz.TZDateTime time;

  EventModel({
    required this.title,
    required this.description,
    required this.time,
  });
}
