import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/tasks/bloc/create_task_cubit.dart';
import 'package:tick_tock/modules/tasks/models/extensions.dart';
import 'package:tick_tock/modules/tasks/ui/custom_repeat_screen.dart';
import 'package:tick_tock/modules/tasks/ui/repeat_options_widget.dart';

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
                  child: BlocBuilder<CreateTaskCubit, TaskDetails>(
                    builder: (context, state) {
                      return FilledButton(
                        onPressed: state.title != null ? _onSave : null,
                        child: const Text('Save'),
                      );
                    },
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
          final trimmed = content.trim().isNotEmpty ? content.trim() : null;
          context.read<CreateTaskCubit>().setTitle(trimmed);
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
                final trimmed =
                    content.trim().isNotEmpty ? content.trim() : null;
                context.read<CreateTaskCubit>().setDescription(trimmed);
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
    FocusManager.instance.primaryFocus?.unfocus();

    final date = context.read<CreateTaskCubit>().state.startDate.date;
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
    FocusManager.instance.primaryFocus?.unfocus();

    final time = context.read<CreateTaskCubit>().state.startDate.time;
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
    RepeatFrequency currentMode =
        switch (context.read<CreateTaskCubit>().state) {
      CustomTaskDetails() => RepeatFrequency.custom,
      DefaultTaskDetails(:final repeats) =>
        repeats?.frequency ?? RepeatFrequency.none,
    };

    final result = await showDialog(
      context: context,
      builder: (_) => RepeatOptionsWidget(
        currentMode: currentMode,
      ),
    );

    if (!mounted) return;

    if (result == RepeatFrequency.custom) {
      context.push(const CustomRepeatScreen());
      return;
    }

    if (result is RepeatFrequency && mounted) {
      context.read<CreateTaskCubit>().setRepeatMode(result);
    }
  }

  String _tileName(TaskDetails details) {
    return switch (details) {
      DefaultTaskDetails(:final repeats) =>
        repeats?.frequency.label ?? RepeatFrequency.values.first.label,
      CustomTaskDetails() => RepeatFrequency.values.last.label,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTaskCubit, TaskDetails>(
      builder: (context, state) {
        return Padding(
          padding: Dimens.horizontalPadding,
          child: Column(
            children: [
              switch (state) {
                DefaultTaskDetails(:final allDay) => Row(
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
                            Switch(
                              value: allDay,
                              onChanged: (value) {
                                context
                                    .read<CreateTaskCubit>()
                                    .setAllDay(value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                CustomTaskDetails() => const SizedBox(),
              },
              const GapBox(gap: Gap.xs),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Colors.transparent,
                  ),
                  const GapBox(gap: Gap.xxs),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _datePicker,
                          child: Text(
                            state.startDate.date.formattedText,
                            style: context.textTheme.bodyLarge!.copyWith(
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        switch (state) {
                          CustomTaskDetails() => const SizedBox(),
                          DefaultTaskDetails() => GestureDetector(
                              onTap: _timePicker,
                              child: Text(
                                state.startDate.time.format(context),
                                style: context.textTheme.bodyLarge!.copyWith(
                                  color: context.colorScheme.onSurface,
                                ),
                              ),
                            ),
                        },
                      ],
                    ),
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
                      _tileName(state),
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
      },
    );
  }
}
