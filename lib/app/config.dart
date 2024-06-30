import 'package:flutter/material.dart';
export 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  void pop([dynamic result]) => Navigator.of(this).pop(result);

  Future push(Widget widget) {
    return Navigator.of(this).push(MaterialPageRoute(builder: (_) => widget));
  }

}
