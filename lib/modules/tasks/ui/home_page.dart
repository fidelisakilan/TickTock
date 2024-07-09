import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/tasks/ui/prompt_entry_screen.dart';
import 'package:tick_tock/shared/utils/constants.dart';
import '../bloc/create_task_cubit.dart';
import 'create_task_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void onTap() async {
    context.push(const PromptEntryScreen());
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
        backgroundColor: context.colorScheme.surfaceContainer,
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
    );
  }
}
