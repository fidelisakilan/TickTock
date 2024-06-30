import 'package:dynamic_color/dynamic_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tick_tock/modules/tasks/ui/home_page.dart';
import 'config.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final themeData = ThemeData(
          scaffoldBackgroundColor: context.colorScheme.surface,
          textTheme: GoogleFonts.interTextTheme(),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: context.colorScheme.surfaceContainerHighest,
          ),
          filledButtonTheme: FilledButtonThemeData(
              style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.zero))),
        );
        return MaterialApp(
          themeMode: ThemeMode.system,
          theme: themeData.copyWith(colorScheme: lightDynamic),
          darkTheme: themeData.copyWith(colorScheme: darkDynamic),
          home: const HomePage(),
        );
      },
    );
  }
}
