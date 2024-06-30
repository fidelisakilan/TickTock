import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/tasks/bloc/create_task_cubit.dart';
import 'package:tick_tock/modules/tasks/models/task_model.dart';
import 'package:tick_tock/shared/components/dimensions.dart';

class TaskEntrySheet extends StatefulWidget {
  const TaskEntrySheet({super.key});

  @override
  State<TaskEntrySheet> createState() => _TaskEntrySheetState();
}

class _TaskEntrySheetState extends State<TaskEntrySheet> {
  void _onSave() {
    context.read<CreateTaskCubit>().onSave();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceDim,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            const GapBox(gap: Gap.xxs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: context.pop,
                  child: Padding(
                    padding: Dimens.horizontalPadding,
                    child: Icon(
                      Icons.close,
                      color: context.colorScheme.inverseSurface,
                    ),
                  ),
                ),
                Padding(
                  padding: Dimens.horizontalPadding,
                  child: FilledButton(
                    onPressed: _onSave,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
            const _TaskTitleWidget(),
            const Divider(),
            const _ReminderWidget(),
            const Divider(),
            const Expanded(child: _TaskDescriptionWidget()),
          ],
        ),
      ),
    );
  }
}

class _TaskTitleWidget extends StatefulWidget {
  const _TaskTitleWidget();

  @override
  State<_TaskTitleWidget> createState() => _TaskTitleWidgetState();
}

class _TaskTitleWidgetState extends State<_TaskTitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onChanged: (String content) {
          context.read<CreateTaskCubit>().setTitle(content.trim());
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Add Title',
          hintStyle: context.textTheme.titleLarge!.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
        style: context.textTheme.titleLarge!.copyWith(
          color: context.colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _TaskDescriptionWidget extends StatelessWidget {
  const _TaskDescriptionWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.horizontalPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Baseline(
            baseline: 32,
            baselineType: TextBaseline.alphabetic,
            child: Icon(
              Icons.subject,
              color: context.colorScheme.onSurface,
            ),
          ),
          const GapBox(gap: Gap.xxs),
          Expanded(
            child: TextField(
              expands: true,
              minLines: null,
              maxLines: null,
              onChanged: (String content) {
                context.read<CreateTaskCubit>().setDescription(content.trim());
              },
              scrollPadding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Add Details',
                hintStyle: context.textTheme.bodyLarge!.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              style: context.textTheme.bodyLarge!
                  .copyWith(color: context.colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderWidget extends StatefulWidget {
  const _ReminderWidget();

  @override
  State<_ReminderWidget> createState() => _ReminderWidgetState();
}

class _ReminderWidgetState extends State<_ReminderWidget> {
  void _datePicker() async {
    final date = context.read<CreateTaskCubit>().state.startDate;
    final newDate = await showDialog(
      context: context,
      builder: (context) {
        return DatePickerDialog(
          firstDate: DateTime.now(),
          currentDate: date,
          lastDate: DateTime.now().copyWith(year: DateTime.now().year + 100),
        );
      },
    );
    if (newDate is DateTime && mounted) {
      context.read<CreateTaskCubit>().setStartDate(newDate);
    }
  }

  void _timePicker() async {
    final time = context.read<CreateTaskCubit>().state.startTime;
    final newTime = await showDialog(
      context: context,
      builder: (context) {
        return TimePickerDialog(
          initialTime: TimeOfDay(hour: time.hour, minute: time.minute),
        );
      },
    );
    if (newTime is TimeOfDay && mounted) {
      context.read<CreateTaskCubit>().setStartTime(newTime);
    }
  }

  void _repeatMode() async {
    final repeatMode = context.read<CreateTaskCubit>().state.repeatMode;

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Padding(
            padding: Dimens.horizontalPadding,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: RepeatMode.values.length,
                itemBuilder: (context, index) {
                  final item = RepeatMode.values[index];
                  return Material(
                    color: context.colorScheme.surfaceContainerHighest,
                    child: RadioListTile<RepeatMode>(
                      title: Text(item.name),
                      value: item,
                      onChanged: (value) {},
                      groupValue: repeatMode,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.horizontalPadding,
      child: Column(
        children: [
          Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time,
                color: context.colorScheme.onSurface,
              ),
              const GapBox(gap: Gap.xxs),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All-day',
                      style: context.textTheme.bodyLarge!.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    BlocBuilder<CreateTaskCubit, CreateTaskState>(
                      buildWhen: (previous, current) =>
                          previous.allDay != current.allDay,
                      builder: (context, state) {
                        return Switch(
                          value: state.allDay,
                          onChanged: (value) {
                            context.read<CreateTaskCubit>().setAllDay(value);
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
          const GapBox(gap: Gap.xs),
          Row(
            children: [
              const Icon(
                Icons.access_time,
                color: Colors.transparent,
              ),
              const GapBox(gap: Gap.xxs),
              BlocBuilder<CreateTaskCubit, CreateTaskState>(
                builder: (context, state) {
                  return Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _datePicker,
                          child: Text(
                            DateFormat('EEE, MMM d, yyyy')
                                .format(state.startDate),
                            style: context.textTheme.bodyLarge!.copyWith(
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !state.allDay,
                          child: GestureDetector(
                            onTap: _timePicker,
                            child: Text(
                              state.startTime.format(context),
                              style: context.textTheme.bodyLarge!.copyWith(
                                color: context.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const GapBox(gap: Gap.xs),
          GestureDetector(
            onTap: _repeatMode,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.replay,
                  color: context.colorScheme.onSurface,
                ),
                const GapBox(gap: Gap.xxs),
                Text(
                  'Does not repeat',
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const GapBox(gap: Gap.xxs),
        ],
      ),
    );
  }
}
