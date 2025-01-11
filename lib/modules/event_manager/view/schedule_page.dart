import 'package:flutter/scheduler.dart';
import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/event_manager/cubit/schedule_cubit.dart';
import 'package:tick_tock/modules/event_manager/models/event_model.dart';
import 'package:tick_tock/modules/event_manager/models/extensions.dart';
import 'package:tick_tock/shared/utils/permission_handler.dart';
import '../widgets/widgets.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  void _createEvent() async {
    final result =
        await showCustomBottomSheet(context, const CreateEventWidget());
    if (result is EventModel && mounted) {
      context.read<ScheduleCubit>().addEvent(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Schedule List"),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: _createEvent,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const NotificationEnableWidget(),
          Expanded(
            child: BlocBuilder<ScheduleCubit, List<EventModel>>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.length,
                  itemBuilder: (context, index) {
                    return EventTileWidget(
                      event: state.elementAt(index),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationEnableWidget extends StatefulWidget {
  const NotificationEnableWidget({super.key});

  @override
  State<NotificationEnableWidget> createState() =>
      _NotificationEnableWidgetState();
}

class _NotificationEnableWidgetState extends State<NotificationEnableWidget> {
  bool showNotificationBanner = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      showNotificationBanner =
          await PermissionHandler().notificationPermNeeded();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!showNotificationBanner) return const SizedBox();
    return ListTile(
      onTap: () async {
        showNotificationBanner =
            !(await PermissionHandler().requestNotification());
        setState(() {});
      },
      title: const Text("Tap to enable notifications"),
      trailing: const Icon(Icons.notifications_on),
    );
  }
}

class EventTileWidget extends StatelessWidget {
  const EventTileWidget({super.key, required this.event});
  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: Text(event.title, style: context.textTheme.titleSmall),
      trailing: Text(
          "${event.date.formattedText} ${event.time.format(context)}",
          style: context.textTheme.bodySmall),
    );
  }
}
