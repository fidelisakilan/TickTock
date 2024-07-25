import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/app/models/extensions.dart';

import '../bloc/create_task_cubit.dart';

class DefaultPresetWidget extends StatelessWidget {
  const DefaultPresetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTaskCubit, CreateTaskState>(
      builder: (context, state) {
        return Column(
          children: [
            const RepeatEveryWidget(),
            const Divider(),
            if (state.taskDetails.repeatFrequency == RepeatFrequency.weeks) ...[
              WeekDaySelectionWidget(
                  selectedDays: state.taskDetails.repeats.weekdays),
              const Divider(),
            ],
            const RepeatEndWidget(),
            const Divider(),
          ],
        );
      },
    );
  }
}

class RepeatEndWidget extends StatefulWidget {
  const RepeatEndWidget({super.key});

  @override
  State<RepeatEndWidget> createState() => _RepeatEndWidgetState();
}

class _RepeatEndWidgetState extends State<RepeatEndWidget> {
  late DateTime endingDate;

  CreateTaskCubit get cubit => context.read<CreateTaskCubit>();

  @override
  void initState() {
    super.initState();
    endingDate = cubit.state.taskDetails.repeats.endDate ?? DateTime.now();
  }

  void _datePicker(BuildContext context) async {
    final date = await showDialog(
      context: context,
      builder: (context) {
        return DatePickerDialog(
          firstDate: DateTime.now(),
          currentDate: endingDate,
          lastDate: DateTime.now().copyWith(year: DateTime.now().year + 100),
        );
      },
    );
    if (mounted && date is DateTime) {
      context.read<CreateTaskCubit>().setEndingDate(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTaskCubit, CreateTaskState>(
      builder: (context, state) {
        final hasEnding = state.taskDetails.repeats.endDate != null;
        return Padding(
          padding: Dimens.horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ends',
                style: context.textTheme.labelLarge!.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              ListTile(
                title: Text(
                  'Never',
                  style: context.textTheme.labelLarge!
                      .copyWith(color: context.colorScheme.onSurface),
                ),
                leading: Radio<bool>(
                  value: false,
                  groupValue: hasEnding,
                  onChanged: (bool? value) {
                    context.read<CreateTaskCubit>().setEndingDate();
                  },
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Text(
                      'On',
                      style: context.textTheme.labelLarge!
                          .copyWith(color: context.colorScheme.onSurface),
                    ),
                    const GapBox(gap: Gap.xxs),
                    IntrinsicWidth(
                      child: TextField(
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        style: context.textTheme.labelLarge!
                            .copyWith(color: context.colorScheme.onSurface),
                        controller: TextEditingController(
                            text: endingDate.formattedText1),
                        readOnly: true,
                        onTap: () => _datePicker(context),
                      ),
                    ),
                  ],
                ),
                leading: Radio<bool>(
                  value: true,
                  groupValue: hasEnding,
                  onChanged: (bool? value) {
                    context.read<CreateTaskCubit>().setEndingDate(endingDate);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class WeekDaySelectionWidget extends StatelessWidget {
  const WeekDaySelectionWidget({super.key, required this.selectedDays});

  final List<WeekDay> selectedDays;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.horizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Repeats on',
            style: context.textTheme.labelMedium!.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const GapBox(gap: Gap.xxs),
          SegmentedButton<WeekDay>(
            segments: WeekDay.values
                .map((e) => ButtonSegment<WeekDay>(
                    value: e, label: Text(e.name[0].toUpperCase())))
                .toList(),
            selected: selectedDays.toSet(),
            showSelectedIcon: false,
            multiSelectionEnabled: true,
            emptySelectionAllowed: true,
            onSelectionChanged: (Set<WeekDay> newSelection) {
              context
                  .read<CreateTaskCubit>()
                  .setWeekDays(newSelection.toList());
            },
          ),
        ],
      ),
    );
  }
}

class RepeatEveryWidget extends StatefulWidget {
  const RepeatEveryWidget({super.key});

  @override
  State<RepeatEveryWidget> createState() => _RepeatEveryWidgetState();
}

class _RepeatEveryWidgetState extends State<RepeatEveryWidget> {
  final textController = TextEditingController();
  final optionController = TextEditingController();

  CreateTaskCubit get cubit => context.read<CreateTaskCubit>();

  @override
  void initState() {
    super.initState();
    textController.value = TextEditingValue(
        text: cubit.state.taskDetails.repeats.interval.toString());
  }

  final List<RepeatFrequency> options = [
    RepeatFrequency.days,
    RepeatFrequency.weeks,
    RepeatFrequency.months,
    RepeatFrequency.years,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.horizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Repeats every',
            style: context.textTheme.labelMedium!.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const GapBox(gap: Gap.xxs),
          Row(
            children: [
              Flexible(
                child: SizedBox(
                  width: 80,
                  child: TextField(
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    controller: textController,
                    keyboardType: TextInputType.number,
                    style: context.textTheme.labelLarge!
                        .copyWith(color: context.colorScheme.onSurface),
                    onChanged: (value) {
                      if (value.trim().isNotEmpty) {
                        cubit.setRepeatInterval(int.parse(value));
                      }
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ], // Onl
                  ),
                ),
              ),
              const GapBox(gap: Gap.xxs),
              IntrinsicWidth(
                child: DropdownMenu<RepeatFrequency>(
                  initialSelection: options.first,
                  controller: optionController,
                  textStyle: context.textTheme.labelLarge!
                      .copyWith(color: context.colorScheme.onSurface),
                  expandedInsets: EdgeInsets.zero,
                  dropdownMenuEntries:
                      options.map<DropdownMenuEntry<RepeatFrequency>>(
                    (value) {
                      return DropdownMenuEntry<RepeatFrequency>(
                        value: value,
                        label: value.dropdownTitle,
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
