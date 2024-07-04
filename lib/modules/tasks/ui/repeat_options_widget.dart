import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/tasks/bloc/create_task_cubit.dart';

class RepeatOptionsWidget extends StatelessWidget {
  final RepeatFrequency currentMode;

  const RepeatOptionsWidget({super.key, required this.currentMode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: Dimens.horizontalPadding,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: RepeatFrequency.values.length,
            itemBuilder: (context, index) {
              final item = RepeatFrequency.values[index];
              return Material(
                color: context.colorScheme.surfaceContainerHighest,
                child: RadioListTile<RepeatFrequency>(
                  title: Text(item.label),
                  value: item,
                  onChanged: (RepeatFrequency? value) {
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
