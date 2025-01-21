import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/event_manager/event_manager.dart';
import 'package:path/path.dart' as path;
import 'package:tick_tock/modules/event_manager/models/models.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _onEventManager() {
    context.push(const SchedulePage());
  }

  void _onDailyJournal() {}

  void _exportData() async {
    final result = await context.read<ScheduleCubit>().exportData();
    if (!result && mounted) {
      showCustomToast(context, "You have no events to exports");
    }
  }

  void _importData() async {
    final result = await context.read<ScheduleCubit>().importData();
    if (!result && mounted) {
      showCustomToast(context, "Failed to import, Invalid File");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          Constants.appName,
          style: context.textTheme.headlineSmall!
              .copyWith(fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.small(
            onPressed: _exportData,
            child: const Icon(Icons.upload),
          ),
          const GapBox(gap: Gap.s),
          FloatingActionButton.small(
            onPressed: _importData,
            child: const Icon(Icons.download),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _onEventManager,
              child: const Text("Event Manager"),
            ),
            ElevatedButton(
              onPressed: _onDailyJournal,
              child: const Text("Daily Journal"),
            )
          ],
        ),
      ),
    );
  }
}
