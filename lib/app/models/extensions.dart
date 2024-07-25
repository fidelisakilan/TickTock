import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {

  String get formattedText => DateFormat('EEE, MMM d, yyyy')
      .format(this);

  String get formattedText1 => DateFormat('MMM d, yyyy')
      .format(this);
}


