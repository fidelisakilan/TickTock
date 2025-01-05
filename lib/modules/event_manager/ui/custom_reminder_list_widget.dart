import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/app/config.dart';
import '../bloc/create_task_cubit.dart';
import '../../../app/models/extensions.dart';
import 'package:tick_tock/shared/widgets/wavy_divider.dart';

import '../models/extensions.dart';

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
            List.from(cubit.state.taskDetails.reminders, growable: true);
        newList.remove(timeStamp);
        newList.add(result);
        cubit.setCustomTimeList(newList);
      }
    }
  }

  void _removeTime(TimeStamp timeStamp) {
    final List<TimeStamp> newList =
        List.from(cubit.state.taskDetails.reminders, growable: true);
    newList.remove(timeStamp);
    cubit.setCustomTimeList(newList);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTaskCubit, CreateTaskState>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            ListView.separated(
              itemCount: state.taskDetails.reminders.length + 1,
              separatorBuilder: (context, index) => Visibility(
                visible: index != 0,
                child: Container(
                  color: context.colorScheme.surfaceContainerLowest,
                  child: const WavyDivider(),
                ),
              ),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: Dimens.horizontalPadding,
                        child: Text(
                          'Starting Reminder',
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
                              isStartTime: true,
                              timeStamp: state.taskDetails.startDate);
                        },
                        child: ReminderCardWidget(
                          item: state.taskDetails.startDate,
                          index: 0,
                          removeCallback: () {},
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
                      const GapBox(gap: Gap.xxs),
                    ],
                  );
                }
                final item = state.taskDetails.reminders[index - 1];
                return GestureDetector(
                  onTap: () => _addTime(timeStamp: item),
                  child: ReminderCardWidget(
                    dismissible: true,
                    item: item,
                    index: index,
                    removeCallback: () => _removeTime(item),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: FloatingActionButton.extended(
                    foregroundColor: context.colorScheme.onPrimaryContainer,
                    backgroundColor: context.colorScheme.primaryContainer,
                    onPressed: _addTime,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    label: Row(
                      children: [
                        const Icon(
                          Icons.add_alarm,
                          size: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Add Alarm',
                          style: context.textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
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
    this.dismissible = false,
    required this.removeCallback,
  });

  final TimeStamp item;
  final int index;
  final bool dismissible;
  final Function removeCallback;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        color: context.colorScheme.errorContainer,
      ),
      key: ValueKey<int>(index),
      direction:
          !dismissible ? DismissDirection.none : DismissDirection.endToStart,
      onDismissed: (direction) => removeCallback(),
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerLowest,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  '${index + 1}',
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ],
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
    timeStamp = widget.oldTimeStamp ?? Utils.startDate();
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
