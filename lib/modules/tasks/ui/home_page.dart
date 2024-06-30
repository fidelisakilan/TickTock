import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/app/config.dart';
import '../bloc/create_task_cubit.dart';
import 'task_entry_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void onTap() async {
    context.push(BlocProvider(
      create: (context) => CreateTaskCubit(),
      child: const TaskEntrySheet(),
    ));
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
      backgroundColor: context.colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: onTap,
        child: const Icon(Icons.add),
      ),
    );
  }
}
