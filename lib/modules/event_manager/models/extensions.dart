import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get formattedText => DateFormat('MMM d, yyyy').format(this);

  DateTime get clearedTime => DateTime(year, month, day);
}
