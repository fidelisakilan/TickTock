import 'package:tick_tock/app/config.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Schedule List"),
      ),
      body: ListView.separated(
        itemCount: 10,
        separatorBuilder: (context, index) => const GapBox(gap: Gap.s),
        itemBuilder: (context, index) {
          return Container(
            color: context.colorScheme.error,
          );
        },
      ),
    );
  }
}
