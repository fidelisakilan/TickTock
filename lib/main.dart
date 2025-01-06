import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/bloc_observer.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  tz.initializeTimeZones();
  Bloc.observer = MyBlocObserver();
  runApp(const App());
}