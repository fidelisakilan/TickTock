import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/tasks/models/task_model.dart';

class RepeatOptionsDialog extends StatelessWidget {
  final RepeatMode currentRepeatMode;

  const RepeatOptionsDialog({super.key, required this.currentRepeatMode});

  @override
  Widget build(BuildContext context) {
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
                  title: Text(item.tileName),
                  value: item,
                  onChanged: (RepeatMode? value) {
                    if (value != null) {
                      context.pop(value);
                    }
                  },
                  groupValue: currentRepeatMode,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
