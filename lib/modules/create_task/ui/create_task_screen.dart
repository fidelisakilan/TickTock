import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/home/bloc/task_history_cubit.dart';
import 'package:tick_tock/modules/create_task/bloc/create_task_cubit.dart';
import 'package:tick_tock/app/models/extensions.dart';
import 'package:tick_tock/modules/create_task/ui/custom_repeat_screen.dart';
import 'package:tick_tock/modules/create_task/ui/repeat_options_widget.dart';

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
    return BlocListener<CreateTaskCubit, CreateTaskState>(
      listener: (_, state) {
        switch (state) {
          case CreateTaskComplete():
            context.read<TaskHistoryCubit>().fetchFromDb();
            context.pop();
          default:
            break;
        }
      },
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
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
                    child: BlocBuilder<CreateTaskCubit, CreateTaskState>(
                      builder: (context, state) {
                        return FilledButton(
                          onPressed: state.taskDetails.title.trim().isNotEmpty
                              ? _onSave
                              : null,
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
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.value = TextEditingValue(
        text: context.read<CreateTaskCubit>().state.taskDetails.title);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onChanged: (String content) {
          final trimmed = content.trim().isNotEmpty ? content.trim() : null;
          context.read<CreateTaskCubit>().setTitle(trimmed);
        },
        controller: controller,
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

class _TaskDescriptionWidget extends StatefulWidget {
  const _TaskDescriptionWidget();

  @override
  State<_TaskDescriptionWidget> createState() => _TaskDescriptionWidgetState();
}

class _TaskDescriptionWidgetState extends State<_TaskDescriptionWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final description =
        context.read<CreateTaskCubit>().state.taskDetails.description;
    if (description != null) {
      controller.value = TextEditingValue(text: description);
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

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
              controller: controller,
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

    final date =
        context.read<CreateTaskCubit>().state.taskDetails.startDate.date;
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

    final time =
        context.read<CreateTaskCubit>().state.taskDetails.startDate.time;
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
    final state = context.read<CreateTaskCubit>().state;

    String currentMode = state.taskDetails.repeatDetailsText ??
        state.taskDetails.repeatFrequency.label;

    List<String> options = List.of([
      ...RepeatFrequency.values.map((e) => e.label),
      if (currentMode != state.taskDetails.repeatFrequency.label) currentMode,
    ]);

    final result = await showDialog(
      context: context,
      builder: (_) => RepeatOptionsWidget(
        options: options,
        currentMode: currentMode,
      ),
    );

    if (!mounted) return;

    if (result is String) {
      RepeatFrequency? selectedFrequency =
          RepeatFrequency.values.firstWhereOrNull((e) => e.label == result);
      if (selectedFrequency == RepeatFrequency.custom) {
        final result = await context.push(BlocProvider.value(
          value: context.read<CreateTaskCubit>(),
          child: const CustomRepeatScreen(),
        ));
        if (result is! bool && mounted) {
          context.read<CreateTaskCubit>().updateDetails(state.taskDetails);
        }
      } else if (mounted && selectedFrequency != null) {
        context.read<CreateTaskCubit>().setRepeatMode(selectedFrequency);
      }
    }
  }

  String _tileName(TaskDetails details) =>
      details.repeatDetailsText ?? details.repeatFrequency.label;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTaskCubit, CreateTaskState>(
      builder: (context, state) {
        return Padding(
          padding: Dimens.horizontalPadding,
          child: Column(
            children: [
              Visibility(
                visible:
                    state.taskDetails.repeatFrequency != RepeatFrequency.custom,
                child: Row(
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
                            value: state.taskDetails.allDay,
                            onChanged: (value) {
                              context.read<CreateTaskCubit>().setAllDay(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                            state.taskDetails.startDate.date.formattedText,
                            style: context.textTheme.bodyLarge!.copyWith(
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !state.taskDetails.allDay,
                          child: GestureDetector(
                            onTap: _timePicker,
                            child: Text(
                              state.taskDetails.startDate.time.format(context),
                              style: context.textTheme.bodyLarge!.copyWith(
                                color: context.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
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
                    Expanded(
                      child: Text(
                        _tileName(state.taskDetails),
                        style: context.textTheme.bodyLarge!.copyWith(
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
