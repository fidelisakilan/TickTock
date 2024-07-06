import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/tasks/bloc/create_task_cubit.dart';

class RepeatOptionsWidget extends StatelessWidget {
  final String currentMode;
  final List<String> options;

  const RepeatOptionsWidget({
    super.key,
    required this.currentMode,
    required this.options,
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
                child: RadioListTile<String>(
                  title: Text(item),
                  value: item,
                  onChanged: (String? value) {
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
