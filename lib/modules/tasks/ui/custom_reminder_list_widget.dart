import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/tasks/bloc/create_task_cubit.dart';
import 'package:tick_tock/modules/tasks/models/extensions.dart';

class CustomTimeListWidget extends StatefulWidget {
  const CustomTimeListWidget({super.key});

  @override
  State<CustomTimeListWidget> createState() => _CustomTimeListWidgetState();
}

class _CustomTimeListWidgetState extends State<CustomTimeListWidget> {
  CreateTaskCubit get cubit => context.read<CreateTaskCubit>();

  void _addTime({TimeStamp? timeStamp, bool isStartTime = false}) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) =>
          _AddReminderWidget(oldTimeStamp: timeStamp),
    );
    if (result is TimeStamp) {
      if (isStartTime) {
        cubit.setStartTimeStamp(result);
      } else {
        final List<TimeStamp> newList =
            List.from(cubit.state.reminders, growable: true);
        newList.remove(timeStamp);
        newList.add(result);
        cubit.setCustomTimeList(newList);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTaskCubit, TaskDetails>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            ListView.separated(
              itemCount: state.reminders.length + 1,
              separatorBuilder: (context, index) =>
                  const Divider(height: 0, indent: 60),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const GapBox(gap: Gap.xxs),
                      Padding(
                        padding: Dimens.horizontalPadding,
                        child: Text(
                          'Start Time',
                          style: context.textTheme.labelMedium!.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const GapBox(gap: Gap.xxs),
                      GestureDetector(
                        onTap: () {
                          _addTime(
                              isStartTime: true, timeStamp: state.startDate);
                        },
                        child: ReminderCardWidget(
                          item: state.startDate,
                          index: 0,
                          bgColor: context.colorScheme.surfaceContainerHighest,
                        ),
                      ),
                      const GapBox(gap: Gap.xxs),
                      Padding(
                        padding: Dimens.horizontalPadding,
                        child: Text(
                          'Next Reminders',
                          style: context.textTheme.labelMedium!.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],

                  );
                }
                final item = state.reminders[index - 1];
                return GestureDetector(
                  onTap: () => _addTime(timeStamp: item),
                  child: ReminderCardWidget(
                    item: item,
                    index: index + 1,
                  ),
                );
              },
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FloatingActionButton(
                  foregroundColor: context.colorScheme.onPrimaryContainer,
                  backgroundColor: context.colorScheme.primaryContainer,
                  onPressed: _addTime,
                  child: const Icon(Icons.add_alarm),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ReminderCardWidget extends StatelessWidget {
  const ReminderCardWidget({
    super.key,
    required this.item,
    required this.index,
    this.bgColor,
  });

  final TimeStamp item;
  final int index;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? context.colorScheme.surfaceContainer,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.colorScheme.primary),
            ),
            padding: const EdgeInsets.all(10),
            child: Text(
              '${index + 1}',
              style: context.textTheme.bodyLarge!
                  .copyWith(color: context.colorScheme.onSurface),
            ),
          ),
          const Spacer(),
          Text(
            'Date: ',
            style: context.textTheme.bodyLarge!
                .copyWith(color: context.colorScheme.onSurface),
          ),
          Container(
            decoration: BoxDecoration(
              color: context.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(5),
            child: Text(
              item.date.formattedText1,
              style: context.textTheme.bodyLarge!.copyWith(
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Time: ',
            style: context.textTheme.bodyLarge!
                .copyWith(color: context.colorScheme.onSurface),
          ),
          Container(
            decoration: BoxDecoration(
              color: context.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(5),
            child: Text(
              item.time.format(context),
              style: context.textTheme.bodyLarge!.copyWith(
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddReminderWidget extends StatefulWidget {
  final TimeStamp? oldTimeStamp;

  const _AddReminderWidget({this.oldTimeStamp});

  @override
  State<_AddReminderWidget> createState() => _AddReminderWidgetState();
}

class _AddReminderWidgetState extends State<_AddReminderWidget> {
  late TimeStamp timeStamp;

  @override
  void initState() {
    timeStamp = widget.oldTimeStamp ?? CreateTaskCubit.startDate();
    super.initState();
  }

  void _datePicker() async {
    final lastDate = timeStamp.date.copyWith(year: DateTime.now().year + 100);
    final newDate = await showDialog(
      context: context,
      builder: (context) {
        return DatePickerDialog(
          firstDate: DateTime.now(),
          currentDate: timeStamp.date,
          lastDate: lastDate,
        );
      },
    );
    if (newDate is DateTime) {
      setState(() => timeStamp = timeStamp.copyWith(date: newDate));
    }
  }

  void _timePicker() async {
    final time = await showDialog(
      context: context,
      builder: (context) => TimePickerDialog(initialTime: timeStamp.time),
    );
    if (time is TimeOfDay && mounted) {
      setState(() => timeStamp = timeStamp.copyWith(time: time));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Reminder'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Date',
            style: context.textTheme.labelMedium!.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const GapBox(gap: Gap.xxs),
          GestureDetector(
            onTap: _datePicker,
            child: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: Text(
                timeStamp.date.formattedText1,
                style: context.textTheme.bodyLarge!.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const GapBox(gap: Gap.xs),
          Text(
            'Time',
            style: context.textTheme.labelMedium!.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const GapBox(gap: Gap.xxs),
          GestureDetector(
            onTap: _timePicker,
            child: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: Text(
                timeStamp.time.format(context),
                style: context.textTheme.bodyLarge!.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => context.pop(timeStamp),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
