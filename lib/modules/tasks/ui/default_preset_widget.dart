import 'package:flutter/services.dart';
import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/tasks/models/extensions.dart';

import '../bloc/create_task_cubit.dart';

class DefaultPresetWidget extends StatelessWidget {
  const DefaultPresetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        RepeatEveryWidget(),
        Divider(),
        WeekDaySelectionWidget(),
        Divider(),
        RepeatEndWidget(),
        Divider(),
      ],
    );
  }
}

class RepeatEndWidget extends StatefulWidget {
  const RepeatEndWidget({super.key});

  @override
  State<RepeatEndWidget> createState() => _RepeatEndWidgetState();
}

class _RepeatEndWidgetState extends State<RepeatEndWidget> {
  bool hasEndingDate = false;
  DateTime endingDate = DateTime.now();

  void _datePicker() async {
    final date = await showDialog(
      context: context,
      builder: (context) {
        return DatePickerDialog(
          firstDate: DateTime.now(),
          currentDate: DateTime.now(),
          lastDate: DateTime.now().copyWith(year: DateTime.now().year + 100),
        );
      },
    );
    if (date is DateTime) {
      setState(() {
        endingDate = date;
        hasEndingDate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              groupValue: hasEndingDate,
              onChanged: (bool? value) {
                if (value != null) setState(() => hasEndingDate = value);
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
                    controller:
                        TextEditingController(text: endingDate.formattedText),
                    readOnly: true,
                    onTap: _datePicker,
                  ),
                ),
              ],
            ),
            leading: Radio<bool>(
              value: true,
              groupValue: hasEndingDate,
              onChanged: (bool? value) {
                if (value != null) setState(() => hasEndingDate = value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WeekDaySelectionWidget extends StatefulWidget {
  const WeekDaySelectionWidget({super.key});

  @override
  State<WeekDaySelectionWidget> createState() => _WeekDaySelectionWidgetState();
}

class _WeekDaySelectionWidgetState extends State<WeekDaySelectionWidget> {
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
            selected: const <WeekDay>{WeekDay.friday},
            showSelectedIcon: false,
            multiSelectionEnabled: true,
            emptySelectionAllowed: true,
            onSelectionChanged: (Set<WeekDay> newSelection) {},
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
              SizedBox(
                width: 80,
                child: TextField(
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  controller: textController,
                  keyboardType: TextInputType.number,
                  style: context.textTheme.labelLarge!
                      .copyWith(color: context.colorScheme.onSurface),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ], // Onl
                ),
              ),
              const GapBox(gap: Gap.xxs),
              IntrinsicWidth(
                child: DropdownMenu<RepeatFrequency>(
                  initialSelection: options.first,
                  controller: optionController,
                  requestFocusOnTap: false,
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
