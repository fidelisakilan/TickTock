import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/app/config.dart';
import 'package:tick_tock/modules/home/bloc/task_history_cubit.dart';
import 'package:tick_tock/shared/widgets/loading_widget.dart';
import 'package:tick_tock/shared/widgets/wavy_divider.dart';

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
              itemBuilder: (context, index) {
                final element = history[index];
                return Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: context.colorScheme.surfaceContainerHigh,
                  ),
                  child: Text(element.title),
                );
              },
              separatorBuilder: (context, index) =>
                  const WavyDivider(verticalPadding: 15),
            ),
        };
      },
    );
  }
}
