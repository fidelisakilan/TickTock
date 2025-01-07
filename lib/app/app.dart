import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_tock/modules/event_manager/cubit/schedule_cubit.dart';
import 'package:tick_tock/modules/home/home.dart';
import 'package:tick_tock/shared/core/theme/theme.dart';
import 'config.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Inter Tight", "Inter");
    MaterialTheme theme = MaterialTheme(textTheme: textTheme);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ScheduleCubit(),
        )
      ],
      child: MaterialApp(
        themeMode: ThemeMode.system,
        darkTheme: theme.dark(),
        theme: theme.light(),
        home: const HomePage(),
      ),
    );
  }
}
