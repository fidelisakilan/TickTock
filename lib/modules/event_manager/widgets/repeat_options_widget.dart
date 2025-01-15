import 'package:tick_tock/app/config.dart';

import '../models/event_model.dart';

class RepeatOptionsWidget extends StatelessWidget {
  final RepeatSchedule? currentMode;
  final List<RepeatSchedule> options;
  final DateTime date;

  const RepeatOptionsWidget({
    super.key,
    required this.currentMode,
    required this.options,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: Dimens.horizontalPadding,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final item = options[index];
              return Material(
                color: context.colorScheme.surfaceContainerHighest,
                child: RadioListTile<RepeatSchedule>(
                  title: Text(item.scheduleName(date)),
                  value: item,
                  onChanged: (RepeatSchedule? value) {
                    if (value != null) {
                      context.pop(value);
                    }
                  },
                  groupValue: currentMode,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
