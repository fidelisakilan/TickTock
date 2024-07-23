import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/modules/home/bloc/task_history_cubit.dart';
import 'package:tick_tock/modules/home/ui/home_page.dart';
import 'package:tick_tock/shared/core/theme/theme.dart';
import 'package:tick_tock/shared/core/theme/util.dart';
import 'config.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      TextTheme textTheme = createTextTheme(context, "Inter Tight", "Inter");
      MaterialTheme theme = MaterialTheme(textTheme: textTheme);

      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => TaskHistoryCubit()),
        ],
        child: MaterialApp(
          themeMode: ThemeMode.system,
          darkTheme: theme.dark(),
          theme: theme.light(),
          home: const HomePage(),
        ),
      );
    });
  }
}
