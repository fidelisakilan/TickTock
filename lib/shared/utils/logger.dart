import 'dart:developer';

void logger({
  String? label,
  Object? error,
  StackTrace? stack,
}) {
  log(
    label ?? 'Error',
    error: error,
    stackTrace: stack,
  );
}
