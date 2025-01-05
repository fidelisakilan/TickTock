import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/home/bloc/task_history_cubit.dart';
import 'package:tick_tock/shared/widgets/loading_widget.dart';

class TaskListWidget extends StatefulWidget {
  const TaskListWidget({super.key});

  @override
  State<TaskListWidget> createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  @override
  void initState() {
    super.initState();
    context.read<TaskHistoryCubit>().fetchFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskHistoryCubit, TaskHistoryState>(
      builder: (context, state) {
        return switch (state) {
          TasksLoading() => const LoadingWidget(),
          TasksLoaded(history: var history) => ListView.separated(
              itemCount: history.length,
              padding: const EdgeInsets.only(bottom: 150),
              itemBuilder: (context, index) {
                final element = history[index];
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  margin: Dimens.horizontalPadding,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: context.colorScheme.surfaceContainer,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              element.title,
                              style: context.textTheme.titleLarge,
                            ),
                            Text(
                              element.repeatDetailsText ??
                                  element.startDate.text,
                              style: context.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              context.colorScheme.tertiaryContainer),
                          foregroundColor: WidgetStateProperty.all(
                              context.colorScheme.tertiary),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const GapBox(gap: Gap.xxs),
            ),
        };
      },
    );
  }
}
