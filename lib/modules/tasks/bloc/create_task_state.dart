part of 'create_task_cubit.dart';

@freezed
sealed class CreateTaskState with _$CreateTaskState {
  const CreateTaskState._();

  const factory CreateTaskState.progress({required TaskDetails taskDetails}) =
      CreateTaskProgress;

  const factory CreateTaskState.complete({required TaskDetails taskDetails}) =
      CreateTaskComplete;
}