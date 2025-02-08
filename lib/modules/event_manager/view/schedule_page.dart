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
        heroTag: 'create_event',
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
    return Dismissible(
      onDismissed: (direction) {
        context.read<ScheduleCubit>().removeEvent(event);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        color: context.colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Text(
          "Delete",
          style: context.textTheme.titleMedium!.copyWith(
            color: context.colorScheme.onError,
          ),
        ),
      ),
      key: Key(event.nId.toString()),
      child: ListTile(
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
        onTap: () {},
        subtitle: event.isRepeated
            ? Row(
                children: [
                  Text(
                    event.repeats.label,
                    style: context.textTheme.labelSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (event.isRepeated && event.completedCounts > 0) ...[
              Text(
                "🔥${event.completedCounts}",
                style: context.textTheme.bodySmall,
              ),
            ],
            const GapBox(gap: Gap.xs),
            Text(
              event.time.format(context),
              style: context.textTheme.bodySmall,
            ),
          ],
        ),
        title: Text(
          event.title,
          style: context.textTheme.titleSmall,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
