import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get formattedText => DateFormat('EEE, MMM d, yyyy').format(this);
}
