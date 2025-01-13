import 'package:flutter/scheduler.dart';
import 'package:grouped_list/grouped_list.dart';
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
  final DateTime _currentDate = DateTime.now().clearedTime;

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
                return GroupedListView<EventModel, DateTime>(
                  elements: state,
                  groupBy: (element) => element.date,
                  itemComparator: (item1, item2) {
                    int comp = item1.time.compareTo(item2.time);
                    if (comp != 0) {
                      return comp;
                    }
                    comp = item1.title.compareTo(item2.title);
                    if (comp != 0) {
                      return comp;
                    }
                    return item1.nId.compareTo(item2.nId);
                  },
                  groupSeparatorBuilder: (DateTime groupByValue) {
                    return Padding(
                      padding: Dimens.horizontalPadding,
                      child: Text(
                        groupByValue.formattedText,
                        style: context.textTheme.bodySmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                  itemBuilder: (context, item) {
                    return EventTileWidget(
                      event: item,
                      currentDate: _currentDate,
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
  const EventTileWidget({
    super.key,
    required this.event,
    required this.currentDate,
  });

  final EventModel event;
  final DateTime currentDate;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: Key(event.nId.toString()),
      shape: const Border(),
      enableFeedback: true,
      leading: Checkbox(
        value: event.isCompleted(currentDate),
        onChanged: (value) {
          context.read<ScheduleCubit>().updateCompletion(
                oldEvent: event,
                isCompleted: value!,
                date: currentDate,
              );
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              event.title,
              style: context.textTheme.titleSmall,
            ),
          ),
          Text(
            event.time.format(context),
            style: context.textTheme.bodySmall,
          ),
        ],
      ),
      backgroundColor: context.colorScheme.surfaceContainerHighest,
      collapsedBackgroundColor: context.colorScheme.surface,
      expansionAnimationStyle: AnimationStyle(
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
      ),
      children: [
        Padding(
          padding: Dimens.horizontalPadding,
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => context.read<ScheduleCubit>().removeEvent(event),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.delete,
                    size: 20,
                  ),
                  const GapBox(gap: Gap.xxxs),
                  Text(
                    "Remove",
                    style: context.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
