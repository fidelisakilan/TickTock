import 'package:logger/logger.dart';

var _logger = Logger();

void logger({
  String? label,
  Object? error,
  StackTrace? stack,
}) {
  _logger.d(
    label ?? 'Error',
    error: error,
    stackTrace: stack,
  );
}
