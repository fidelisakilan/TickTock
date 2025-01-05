import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/app/config.dart';
import '../bloc/create_task_cubit.dart';
import 'custom_reminder_list_widget.dart';
import 'default_preset_widget.dart';

class CustomRepeatScreen extends StatefulWidget {
  const CustomRepeatScreen({super.key});

  @override
  State<CustomRepeatScreen> createState() => _CustomRepeatScreenState();
}

class _CustomRepeatScreenState extends State<CustomRepeatScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  CreateTaskCubit get cubit => context.read<CreateTaskCubit>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    switch (cubit.state.taskDetails.repeatFrequency) {
      case RepeatFrequency.none:
        cubit.setRepeatMode(RepeatFrequency.days);
        break;
      case RepeatFrequency.custom:
        _tabController.animateTo(1, duration: Duration.zero);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Custom...'),
        actions: [
          TextButton(
            child: Text(
              'Done',
              style: context.textTheme.labelLarge!.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              if (_tabController.index == 1) {
                cubit.setRepeatMode(RepeatFrequency.custom);
              }
              context.pop(true);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Simple'),
              Tab(text: 'Custom'),
            ],
          ),
          const GapBox(gap: Gap.xxs),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                DefaultPresetWidget(),
                CustomTimeListWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
