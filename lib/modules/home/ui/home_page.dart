import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/home/ui/event_entry_sheet.dart';
import 'package:tick_tock/modules/home/bloc/notification_manager.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void onTap() async {
    final model = await showAppBottomSheet(context, const EventEntrySheet());
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

