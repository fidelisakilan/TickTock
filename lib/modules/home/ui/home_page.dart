import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/shared/utils/constants.dart';

import '../../event_manager/bloc/create_task_cubit.dart';
import '../../event_manager/ui/create_task_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _onEventManager() async {
    context.push(BlocProvider(
      create: (context) => CreateTaskCubit(null),
      child: const TaskEntrySheet(),
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
      body: Column(
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
    );
  }
}
