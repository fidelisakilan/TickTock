import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/event_manager/event_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _onEventManager() {
    context.push(BlocProvider(
      create: (context) => ScheduleCubit(),
      child: const SchedulePage(),
    ));
  }

  void _onDailyJournal() {}

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
