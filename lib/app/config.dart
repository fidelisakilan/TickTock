export 'package:flutter/material.dart';
export 'package:flutter/foundation.dart';
export 'package:tick_tock/shared/utils/constants.dart';
export 'env.dart';
export 'package:tick_tock/shared/widgets/widgets.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:tick_tock/shared/core/exceptions.dart';
export 'package:tick_tock/shared/utils/logger.dart';

import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  void showToast(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }

  void pop([dynamic result]) => Navigator.of(this).pop(result);

  Future push(Widget widget) {
    return Navigator.of(this).push(MaterialPageRoute(builder: (_) => widget));
  }

  Future pushReplacement(Widget widget) {
    return Navigator.of(this)
        .pushReplacement(MaterialPageRoute(builder: (_) => widget));
  }
}
