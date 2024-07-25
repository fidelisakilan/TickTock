import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/home/ui/task_list_widget.dart';
import 'package:tick_tock/shared/utils/constants.dart';

import '../../create_task/bloc/create_task_cubit.dart';
import '../../create_task/ui/create_task_screen.dart';

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
      floatingActionButton: FloatingActionButton.large(
        onPressed: onTap,
        child: const ImageIcon(
          AssetImage('assets/images/ic_gemini_icon.png'),
        ),
      ),
      body: const TaskListWidget(),
    );
  }
}
