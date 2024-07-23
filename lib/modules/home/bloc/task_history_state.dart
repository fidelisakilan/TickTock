part of 'task_history_cubit.dart';

@immutable
sealed class TaskHistoryState {}

final class TasksLoading extends TaskHistoryState {}

final class TasksLoaded extends TaskHistoryState {
  final List<TaskDetails> history;

  TasksLoaded({required this.history});
}
