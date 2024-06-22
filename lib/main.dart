import 'package:flutter/material.dart';
import 'package:tick_tock/event_entry_sheet.dart';
import 'package:tick_tock/notification_manager.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void onTap() async {
    final model = await showAppBottomSheet(context, const EventEntrySheet());
    final model = EventModel();

    NotificationManager().schedule(model);
    DateTime.now().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: onTap),
    );
  }
}

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
