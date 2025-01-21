import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/event_manager/models/extensions.dart';
import 'package:tick_tock/shared/utils/utils.dart';

import '../models/models.dart';
import 'widgets.dart';

class CreateEventWidget extends StatefulWidget {
  const CreateEventWidget({super.key});

  @override
  State<CreateEventWidget> createState() => _CreateEventWidgetState();
}

class _CreateEventWidgetState extends State<CreateEventWidget> {
  late DateTime _currentDate;
  late TimeOfDay _currentTime;
  String? _title;
  String? _description;
  RepeatSchedule _repeatType = RepeatSchedule.none;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now().add(const Duration(hours: 1));

    _currentDate = DateTime(now.year, now.month, now.day);
    _currentTime = TimeOfDay(hour: now.hour, minute: 0);
  }

  void _datePicker() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final newDate = await showDialog(
      context: context,
      builder: (context) {
        return DatePickerDialog(
          firstDate: DateTime.now(),
          currentDate: _currentDate,
          lastDate: DateTime.now().copyWith(year: DateTime.now().year + 100),
        );
      },
    );
    if (newDate is DateTime && mounted) {
      setState(() => _currentDate = newDate);
    }
  }

  void _timePicker() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final newTime = await showDialog(
      context: context,
      builder: (context) {
        return TimePickerDialog(
          initialTime: TimeOfDay(
            hour: _currentTime.hour,
            minute: _currentTime.minute,
          ),
        );
      },
    );
    if (newTime is TimeOfDay && mounted) {
      setState(() => _currentTime = newTime);
    }
  }

  void _repeatSchedule() async {
    final result = await showDialog(
      context: context,
      builder: (_) => RepeatOptionsWidget(
        options: RepeatSchedule.values,
        date: _currentDate.copyWith(
            hour: _currentTime.hour, minute: _currentTime.minute),
        currentMode: _repeatType,
      ),
    );
    setState(() {
      _repeatType =
          RepeatSchedule.values.firstWhere((element) => element == result);
    });
  }

  void _onCreate() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_title != null) {
      context.pop(EventModel(
        nId: Utils.randomInt,
        title: _title!,
        description: _description,
        date: _currentDate,
        time: _currentTime,
        repeats: _repeatType,
      ));
    } else {
      showCustomToast(context, "Give it a great title");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.colorScheme.surface,
      child: Material(
        child: SafeArea(
          child: Padding(
            padding: Dimens.horizontalPadding
                .copyWith(bottom: context.mediaQuery.viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (String content) {
                    if (content.trim().isEmpty) {
                      _title = null;
                    } else {
                      _title = content;
                    }
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add Title',
                    hintStyle: context.textTheme.titleMedium!
                        .copyWith(color: context.colorScheme.outline),
                  ),
                  style: context.textTheme.titleMedium!.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                ),
                TextField(
                  minLines: 4,
                  maxLines: 4,
                  onChanged: (String content) {
                    if (content.trim().isEmpty) {
                      _description = null;
                    } else {
                      _description = content;
                    }
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add Details',
                    hintStyle: context.textTheme.bodyMedium!
                        .copyWith(color: context.colorScheme.outline),
                  ),
                  style: context.textTheme.bodyMedium!
                      .copyWith(color: context.colorScheme.onSurface),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const GapBox(gap: Gap.xxs),
                    OutlinedButton(
                      onPressed: _datePicker,
                      child: Text(_currentDate.formattedText),
                    ),
                    const GapBox(gap: Gap.xxs),
                    OutlinedButton(
                      onPressed: _timePicker,
                      child: Text(_currentTime.format(context)),
                    ),
                  ],
                ),
                const GapBox(gap: Gap.xxs),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: _repeatSchedule,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.repeat, size: 16),
                        const GapBox(gap: Gap.xxxs),
                        Text(
                          _repeatType.label,
                          style: context.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const GapBox(gap: Gap.xxs),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _onCreate,
                    child: const Text("Create"),
                  ),
                ),
                const GapBox(gap: Gap.xxs),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
