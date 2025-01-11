import 'dart:math';

import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static int get randomInt => Random().nextInt(2 ^ 32);

  static void showToast(String msg) => Fluttertoast.showToast(msg: msg);
}
