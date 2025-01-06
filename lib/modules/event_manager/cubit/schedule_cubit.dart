import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit() : super(ScheduleInitial());
}
